<div align="center">
  <img src="preview/Banner.jpeg" alt="Dolby Atmos Banner" width="100%" />

  <h1>Dolby Atmos — Sony Xperia 5 V Port</h1>
  <p><b>System-Wide Spatial Audio & Graphic Equalizer for Modern Android (Official Magisk & Read-Only ROMs)</b></p>

  <p>
    <a href="https://github.com/venky6158/DolbyAtmos-SonyXperia5V-Releases/releases/latest">
      <img src="https://img.shields.io/github/v/release/venky6158/DolbyAtmos-SonyXperia5V-Releases?style=for-the-badge&logo=github&color=2b7de9&label=Release" alt="Latest Release" />
    </a>
    <a href="https://github.com/venky6158/DolbyAtmos-SonyXperia5V-Releases/releases">
      <img src="https://img.shields.io/github/downloads/venky6158/DolbyAtmos-SonyXperia5V-Releases/total?style=for-the-badge&logo=android&color=2ea44f&label=Downloads" alt="Downloads" />
    </a>
    <img src="https://img.shields.io/badge/Android-11%20to%2017%2B-3ddc84?style=for-the-badge&logo=android&logoColor=white" alt="Android Versions" />
    <img src="https://img.shields.io/badge/Root-Official%20Magisk%20%7C%20KSU%20%7C%20APatch-ff6f00?style=for-the-badge" alt="Root Support" />
  </p>

  <p>
    <a href="https://t.me/venky6158">
      <img src="https://img.shields.io/badge/Telegram-@venky6158-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" />
    </a>
    <a href="https://instagram.com/venky6158">
      <img src="https://img.shields.io/badge/Instagram-@venky6158-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram" />
    </a>
    <a href="https://www.linkedin.com/in/venkateshotturi/">
      <img src="https://img.shields.io/badge/LinkedIn-Venkatesh%20Otturi-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" />
    </a>
  </p>
</div>

---

### ✨ Overview

A modernized, split-architecture port of the **Sony Xperia 5 V (`pdx237`) Dolby Atmos** sound engine, engineered to run smoothly on **Official Magisk**, **KernelSU**, and **APatch**—including strict **Read-Only (`EROFS` / `EXT4`)** stock and custom ROMs without bootloops.

This release requires **two components** working together:
1. **Sony Dolby Atmos Magisk Module (Drivers & Services)** — Installs the systemless audio libraries, `daxService`, and native DMS hardware daemon.
2. **Sony Dolby Atmos Standalone APK (UI App)** — Provides the Sony Xperia equalizer and spatial audio control interface.

---

### 📱 Screenshots

<div align="center">
  <img src="preview/Screenshots/Screenshot_20261112-181940.png" alt="Dolby Atmos Xperia 5 V UI Preview 1" width="30%" />
  <img src="preview/Screenshots/Screenshot_20261112-181943.png" alt="Dolby Atmos Xperia 5 V UI Preview 2" width="30%" />
  <img src="preview/Screenshots/Screenshot_20261112-181949.png" alt="Dolby Atmos Xperia 5 V UI Preview 3" width="30%" />
  <br><br>
  <img src="preview/Screenshots/Screenshot_20261112-181953.png" alt="Dolby Atmos Xperia 5 V UI Preview 4" width="30%" />
  <img src="preview/Screenshots/Screenshot_20261112-181956.png" alt="Dolby Atmos Xperia 5 V UI Preview 5" width="30%" />
  <img src="preview/Screenshots/Screenshot_20261112-181959.png" alt="Dolby Atmos Xperia 5 V UI Preview 6" width="30%" />
  <br><br>
  <img src="preview/Screenshots/Screenshot_20261112-182022.png" alt="Dolby Atmos Xperia 5 V UI Preview 7" width="30%" />
</div>



---

### 🚀 Key Improvements & Fixes

- **Persistent System-Wide Processing (Session 0):** Keeps `com.dolby.daxservice` active in the background and exempt from Doze/AppOps throttling so Dolby effects stay active across Spotify, YouTube, Poweramp, and games—not just inside the Dolby UI.
- **Real-Time UI State Synchronization:** Fixed the `MusicSubFragment` `NullPointerException` crash-relaunch loop (`mMusicOffHeadImage`) so preset toggles, EQ bands, and virtualizer buttons update instantaneously on tap.
- **Modern SDK & Hidden API Compatibility:** Automatically applies hidden API policy exemptions so the standalone user-space APK links cleanly to Android's `AudioEffect` framework on Android 14–17+.
- **Read-Only ROM & Official Magisk Safe:** Cleanly initializes `vendor.dolby.hardware.dms@2.0-service` and merges audio configs without requiring Magisk Delta/Kitsune early-init workarounds.
- **Multi-Mod Friendly:** Compatible alongside other audio mods when paired with **Audio Modification Library (AML)**.

---

### 📥 How to Install

> [!IMPORTANT]
> **Both files are required.** You must flash the **Sony Dolby Atmos Magisk Module** and reboot **before** installing the **Sony Dolby Atmos Standalone APK**.

1. **Download Both Files** from [**Releases**](https://github.com/venky6158/DolbyAtmos-SonyXperia5V-Releases/releases/latest):
   - `DolbyAtmos-SonyXperia5V-Driver-Only.zip` *(Magisk Driver Module)*
   - `DolbyAtmos-SonyXperia5V-Standalone.apk` *(Sony Dolby Atmos UI App)*
2. **Flash the Magisk Module:**
   - Open **Official Magisk** (or KernelSU / APatch) → **Modules** → **Install from storage**.
   - Select `DolbyAtmos-SonyXperia5V-Driver-Only.zip` and wait for installation to complete.
3. **Reboot Your Device:**
   - Restart your phone so the native `dms@2.0-service` daemon and `daxService` initialize properly.
4. **Install the Standalone APK:**
   - After rebooting, install `DolbyAtmos-SonyXperia5V-Standalone.apk` like a normal Android app and launch it.
5. *(Optional)* If you use additional audio mods simultaneously, flash [**Audio Modification Library (AML)**](https://github.com/Magisk-Modules-Repo/aml) so all effects chain cleanly on Session 0.

> [!NOTE]
> - **Custom EQ Sliders:** Switch from **Dynamic** to **Custom** profile inside the app to unlock the 10-band Graphic Equalizer, Surround Virtualizer, and Dialogue Enhancer.
> - **Independent Device Profiles:** Dolby maintains separate sound profiles for **Phone Speaker**, **Wired Headphones**, and **Bluetooth** devices.

---

### 🙏 Credits & Developer

- **Dolby Laboratories & Sony Mobile** — Original Xperia 5 V (`pdx237`) audio binaries and DSP tuning.
- **[Rei Ryuki](https://github.com/reiryuki)** — Foundational [Dolby Atmos Sony Xperia 5 V Magisk Module](https://github.com/reiryuki/Dolby-Atmos-Sony-Xperia-5-V-Magisk-Module) and reverse-engineering research.
- **Venkatesh Otturi** — Modern Android / Official Magisk & Read-Only ROM port, background persistence fixes, and standalone APK patches.
  - **GitHub:** [@venky6158](https://github.com/venky6158)
  - **Telegram:** [@venky6158](https://t.me/venky6158)
  - **Instagram:** [@venky6158](https://instagram.com/venky6158)
  - **LinkedIn:** [linkedin.com/in/venkateshotturi](https://www.linkedin.com/in/venkateshotturi/)
