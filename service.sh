MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# 1. WAIT UNTIL BOOT IS FULLY COMPLETED (FBE Decrypted & UI Rendered)
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 3
done

# Extra wait to let SystemUI, Keyguard, and Launcher completely settle
sleep 8

# var
API=$(getprop ro.build.version.sdk)
if [ ! -d "$MODPATH/vendor" ] || [ -L "$MODPATH/vendor" ]; then
  MODSYSTEM=/system
fi
MOD=/data/adb/modules/nomount
NM=$MOD/bin/nm
NOMOUNT=false
[ ! -f "$MOD/disable" ] && [ -x "$NM" ] && $NM v >/dev/null 2>&1 && NOMOUNT=true
AML=/data/adb/modules/aml
AUD=$(cat "$MODPATH/audio.txt" 2>/dev/null)

# Auto-install Dolby APKs as user apps if PackageManager didn't register them as priv-apps
if ! pm list packages | grep -q "com.dolby.daxappui2"; then
  if [ -f "$MODPATH/system/priv-app/DolbySound/DolbySound.apk" ]; then
    pm install -r --bypass-low-target-sdk-block "$MODPATH/system/priv-app/DolbySound/DolbySound.apk" 2>/dev/null || pm install -r "$MODPATH/system/priv-app/DolbySound/DolbySound.apk" 2>/dev/null || true
  fi
fi
if ! pm list packages | grep -q "com.dolby.daxservice"; then
  if [ -f "$MODPATH/system/priv-app/daxService/daxService.apk" ]; then
    pm install -r --bypass-low-target-sdk-block "$MODPATH/system/priv-app/daxService/daxService.apk" 2>/dev/null || pm install -r "$MODPATH/system/priv-app/daxService/daxService.apk" 2>/dev/null || true
  fi
fi

# NoMount
if $NOMOUNT; then
  DES=/system/etc/vintf/manifest.xml
  FILE=$MODPATH$DES
  if [ -f "$FILE" ] && [ -f "$DES" ]; then
    $NM del "$DES" 2>/dev/null || true
    $NM add "$DES" "$FILE"
  fi
  if [ ! -d "$AML" ] || [ -f "$AML/disable" ]; then
    FILES=$(find "$MODPATH/system" "$MODPATH/vendor" -type f -name "$AUD" 2>/dev/null)
    for FILE in $FILES; do
      DES=$(echo "$FILE" | sed -e "s|$MODPATH||g" -e 's|/system/odm|/odm|g' -e 's|/system/my_product|/my_product|g')
      RDES=$(realpath "$DES" 2>/dev/null)
      if [ -f "$RDES" ]; then
        $NM del "$RDES" 2>/dev/null || true
        $NM add "$RDES" "$FILE"
      fi
    done
  fi
fi

# property
resetprop -n ro.audio.ignore_effects false
resetprop -n ro.vendor.dolby.dax.version DAX3_3.7.0.8_r1
resetprop -n ro.dolby.mod_uuid false
resetprop -n ro.dolby.music_stream false
resetprop -n vendor.audio.dolby.ds2.enabled false
resetprop -n vendor.audio.dolby.ds2.hardbypass false

# Restart hwservicemanager safely now that the device is fully booted
killall -9 hwservicemanager 2>/dev/null || true
sleep 1

# restart audio services
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall -9 $SERVER android.hardware.audio@4.0-service-mediatek android.hardware.audio.service 2>/dev/null || true

# stop old hal instances
NAMES="dms-hal-1-0 dms-hal-2-0 dms-v36-hal-2-0 dms-sp-hal-2-0"
for NAME in $NAMES; do
  if [ "$(getprop init.svc.$NAME)" = "running" ] || [ "$(getprop init.svc.$NAME)" = "restarting" ]; then
    stop "$NAME"
  fi
done

# mount
DIR=/odm/bin/hw
FILES="$DIR/vendor.dolby.hardware.dms@1.0-service
       $DIR/vendor.dolby.hardware.dms@2.0-service
       $DIR/vendor.dolby_sp.hardware.dmssp@2.0-service
       $DIR/vendor.dolby_v3_6.hardware.dms360@2.0-service"
if [ "$(realpath $DIR 2>/dev/null)" = "$DIR" ]; then
  for FILE in $FILES; do
    MODFILE=$MODPATH$MODSYSTEM/vendor$FILE
    if [ -f "$FILE" ]; then
      if $NOMOUNT; then
        $NM del "$FILE" 2>/dev/null || true
        $NM add "$FILE" "$MODFILE"
      else
        umount "$FILE" 2>/dev/null || true
        mount -o bind "$MODFILE" "$FILE"
      fi
    fi
  done
fi

# permission
chmod 0755 $MODPATH$MODSYSTEM/vendor/bin/hw/* 2>/dev/null || true
chown 0.2000 $MODPATH$MODSYSTEM/vendor/bin/hw/* 2>/dev/null || true

# run dolby dms service
SERVICES=$(realpath /vendor 2>/dev/null)/bin/hw/vendor.dolby.hardware.dms@2.0-service
for SERVICE in $SERVICES; do
  killall "$SERVICE" 2>/dev/null || true
  $SERVICE &
done

# list
PKGS=$(cat "$MODPATH/package.txt" 2>/dev/null)
for PKG in $PKGS; do
  magisk --denylist rm "$PKG" 2>/dev/null
  magisk --sulist add "$PKG" 2>/dev/null
done
if magisk magiskhide sulist 2>/dev/null; then
  for PKG in $PKGS; do
    magisk magiskhide add "$PKG" 2>/dev/null
  done
else
  for PKG in $PKGS; do
    magisk magiskhide rm "$PKG" 2>/dev/null
  done
fi

# allow appops
PKG=com.dolby.daxappui2
if appops get $PKG >/dev/null 2>&1; then
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore 2>/dev/null
  fi
  if [ "$API" -ge 33 ]; then
    appops set $PKG ACCESS_RESTRICTED_SETTINGS allow 2>/dev/null
  fi
fi

PKG=com.dolby.daxservice
if appops get $PKG >/dev/null 2>&1; then
  pm grant --all-permissions $PKG 2>/dev/null || true
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore 2>/dev/null
  fi
  if [ "$API" -ge 33 ]; then
    appops set $PKG ACCESS_RESTRICTED_SETTINGS allow 2>/dev/null
  fi
fi

# check and keep alive
for SERVICE in $SERVICES; do
  if ! pidof "$SERVICE" >/dev/null 2>&1; then
    $SERVICE &
  fi
done