# Windows 11 Tweaks

![LOGO](README_media/LOGO.png)

[![Contributor Covenant](https://img.shields.io/badge/contributor%20covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md) &nbsp; [![GitHub](https://img.shields.io/github/license/kyaulabs/win11tweak)](LICENSE) &nbsp; [![Gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue)](https://github.com/zricethezav/gitleaks) &nbsp; [![CI](https://img.shields.io/github/actions/workflow/status/kyaulabs/win11tweak/psscriptanalyzer.yml)](https://github.com/kyaulabs/win11tweak/actions)\
[![Semantic Versioning](https://img.shields.io/github/v/release/kyaulabs/win11tweak?include_prereleases&logo=semver&sort=semver)](https://semver.org) &nbsp; [![Discord](https://img.shields.io/discord/88713030895943680?logo=discord&color=blue&logoColor=white)](https://discord.gg/DSvUNYm)

## Disclaimer

Let's be honest, Windows has become a mammoth of an OS that is generically geared toward everyone. My goal with this set of scripts is to put the User back in control of the OS. That said, these scripts have been heavily customized to my own personal needs, it is highly recommended that if you are to use them you review them in their entirety first.

```text
🚧 WARNING
This repository is provided for archival/educational purposes, I am not responsible for any data loss or
damage that may ensue.
```

* [Introduction](#introduction)
* [Features](#features)
* [Windows 11 Tweaks Guide](#windows-11-tweaks-guide)
  * [Installation](#installation)
  * [Windows Update](#windows-update)
  * [Windows Defender (optional)](#windows-defender-optional)
  * [Download Win11Tweaks](#download-win11tweaks)
  * [Win11Tweaks Configuration](#win11tweaks-configuration)
  * [Anti-Virus Install (optional)](#anti-virus-note-optional)
  * [Running Win11Tweaks](#running-win11tweaks)
  * [Microsoft Edge Removal (optional)](#microsoft-edge-removal-optional)
  * [Configuring Windows](#configuring-windows)
  * [OpenShell](#openshell)
  * [UniGetUI](#unigetui)
  * [Brave](#brave)
  * [Firewall](#firewall)
  * [Everything](#everything)
  * [CCleaner](#ccleaner)
  * [MSEdgeRedirect](#msedgeredirect)
* [Further Setup](#further-setup)
* [Customization](#customization)
  * [Winget App Customization](#winget-app-customization)
* [Attribution](#attribution)

## Introduction

This script is meant to be utilized immediately after a fresh installation of Windows 11. Before the script can be run, Windows itself needs to be installed properly. The following will walk you through setting up Windows 11 with a local user account.

## Features

This set of scripts attempts to maintain a vanilla appearance while gutting most of the unneeded and/or unwanted items from the operating system. Privacy is another focus and as such any call home or telemetry functions have been disabled or out-right removed.

* Microsoft Bloat Removed

* Microsoft Copilot/Recall Removed

* Microsoft Telemetry/Tracking Stripped

* *Optional* Microsoft Edge Removal &mdash; **Not Recommended**

* *Optional* Windows Defender Removal &mdash; **Not Recommended**

* MSYS2 is used for a Linux terminal (Git for Windows integrated) [^1]

* Winget / UniGetUI Package Manger, manage packages like a Linux system

* YubiKey Ready! [^2]

* *Optional* GPG and SSH key forwarding over SSH

* Many Visual Changes!
  
  * Start Menu shifted back to the left
  
  * Original Windows right-click menu restored
  
  * OpenShell is used for a customizable start menu experience

  * Many more!

[^1]: Install Git for Windows inside MSYS2 proper [git-for-windows/git](https://gitforwindows.org/Install-inside-MSYS2-proper)
[^2]: This assumes you followed [drduh's YubiKey Guide](https://github.com/drduh/YubiKey-Guide) in order to setup your YubiKey

## Windows 11 Tweaks Guide

### Installation

While this can be used with any version of Windows 11, this guide revolves around Windows 11 Pro N. In order to bypass the Microsoft Account requirements it is advised that you pull your network cable until Windows 11 is fully installed.

```text
❗ DO NOT SKIP ❗
If you do not plan on pulling your network cable you will be forced into logging in with a Microsoft
Account.
```

On the third screen of the initial setup there will be an option you can select to return to the previous version of Setup. Select it.

![PreInstall_03](README_media/PreInstall_01.png)

Then go through Setup normally.

![Install_01](README_media/Install_01.png)

After installing Windows to the selected hard drive you will be prompted to reboot the computer. Upon completion, press `SHIFT+F10` to bring up a command prompt window.

![Install_02](README_media/Install_02b.png)

Run `oobe\bypassnro` in the command prompt window, this will reboot the machine automatically and then return you to the region selection window.

![Install_02](README_media/Install_02a.png)

Begin by selecting a region and keyboard (and a secondary keyboard layout if necessary).

![Install_03](README_media/Install_03.png)

Windows will now prompt you about having no internet connection, select `I don't have internet`.

![Install_05](README_media/Install_04.png)

Set your desired username.

![Install_08](README_media/Install_08.png)

Set and confirm your password.

![Install_09](README_media/Install_09.png)

Fill in the three security questions.

![Install_10](README_media/Install_10.png)

Finally on the privacy settings screen, make sure you de-select every single option (scroll down for more options). Only after you have turned off all of Microsoft's tracking should you select `Accept` to complete the Windows 11 configuration.

![Install_11](README_media/Install_11.png)

### Windows Update

Eventually you will be able to login and will then be presented with the desktop.

```text
📌NOTE
Now would be an acceptable time to plug your network cable back in.
```

Right-click on the Start Menu icon (bottom center of screen, left most icon). From here you will want to select `Settings`.

![Windows_01](README_media/Windows_01.png)

Navigate to `Windows Update`.

![Windows_02](README_media/Windows_02.png)

From here update Windows, you need to continue to check for updates after every update until Windows tells you that `You're up to date`.

![Windows_03](README_media/Windows_03.png)

Don't forget to also install optional updates as these tend to contain drivers, these have been moved inside Advanced options.

![Windows_04](README_media/Windows_04.png)

This will most likely require a reboot or a few. Once complete open the Windows Store from the taskbar (the briefcase with the Windows logo on it). Open the `Library` from the bottom left of the app.

![Windows_05](README_media/Windows_05.png)

Select `Get updates` in the upper right corner of the window.

![Windows_06](README_media/Windows_06.png)

Verify that you have performed all updates by the store telling you `You're good to go`.

![Windows_07](README_media/Windows_07.png)

At this point (if it has not been done already) activate Windows.

With the computer updated and activated it is now time to download the script. Download the latest version of Win11Tweaks. Extract the contents of the ZIP file to the Desktop, this should place a folder `win11tweak` on the Desktop.

### Windows Defender (optional)

```text
📌 NOTE
If you choose to keep Windows Defender installed, the script used to remove it 'defender.ps1' will get
flagged by Defender itself, this is normal behavior.
```

```text
🚧 WARNING
Removal of Windows Defender WILL break the ability to use Windows Update!
```

Before the main script can be run Windows Defender needs to be disabled along with tamper protection.

Select the Security Center icon in the system tray and navigate to the security dashboard.

![Defender_01](README_media/Defender_01.png)

Navigate to `Virus & threat protection` and select `Manage settings`.

![Defender_02](README_media/Defender_02.png)

Turn off `Real-time protection`,  `Cloud-delivered protection`, `Automatic sample submission` and `Tamper Protection` inside of Virus & threat protection settings.

![Defender_03](README_media/Defender_03.png)

### Download Win11Tweaks

Right-click on the Start Menu icon and select `Terminal (Admin)`. Run the following command in PowerShell.

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/kyaulabs/win11tweak/raw/master/Modules/download.ps1'))
```

![Win11Tweaks_01](README_media/Win11Tweaks_01.png)

This will download a copy of Win11Tweaks and place it on your desktop. You can then close out of Windows Terminal.

### Win11Tweaks Configuration

While not required, in order to personalize your installation, it is recommended to edit `user_settings.ps1` in the `win11tweak` folder on the Desktop.  Use any text editor or regular old Notepad to edit the file.

```text
📌 NOTE
By default this file contains all of my own personal settings. At the very least you should change the Git
Email, GPG Public Key and then review over the list of software that Chocolatey is going to be installing.
```

![Win11Tweaks_02](README_media/Win11Tweaks_02.png)

### Anti-Virus Install (Optional)

If you want to completely remove Windows Defender, you must first install a third-party anti-virus product that Windows 11 recognizes as active protection. This can be installed temporarily so Defender can be fully disabled/removed during this process, then uninstalled again after you finish the guide.

### Running Win11Tweaks

Assuming the scripts have been extracted to your Desktop... Open the start menu and search for `cmd`, this should bring up the listing for Command Prompt. Make sure you choose the option on the right `Run as administrator`.

```text
🚧 WARNING
Do not simply run the script from Windows Explorer, this will fail and/or produce unintentional results.
```

![Win11Tweaks_03](README_media/Win11Tweaks_03.png)

Change directory into the extracted folder `cd %UserProfile%\Desktop\win11tweak`.

Finally run the script using `main.cmd`.

![Win11Tweaks_04](README_media/Win11Tweaks_04.png)

The script will take quite a while to finish. When finished press `ENTER` and/or `RETURN` to reboot.

![Win11Tweaks_05](README_media/Win11Tweaks_05.png)

After the reboot the last part of the script will run automatically after login and then remove itself (via scheduled task). This will utilize UAC for Administrative permission to continue. Click `Yes` on the UAC dialog.

![Win11Tweaks_06](README_media/Win11Tweaks_06.png)

Wait for the post-reboot portion of the script to complete. When finished press `ENTER` and/or `RETURN` to reboot.

![Win11Tweaks_07](README_media/Win11Tweaks_07.png)

### Microsoft Edge Removal (optional)

If chosen, at some point it during the first part of the Win11Tweaks installation it will ask you to uninstall the two Microsoft Edge components. If this happens you will be presented with the following screen, make sure to select `Uninstall` for both.

![Script_01](README_media/Script_01.png)

```text
❗ DO NOT SKIP ❗
It is possible that the second of which, uninstalling MSEdge itself, will popup two Internet Explorer
errors in the background. These errors will need to be cleared by ALT+TABing and selecting 'OK' before
the script can continue.
```

### Configuring Windows

Right-click on the desktop and choose `Personalize`. Navigate to `Themes` and set the mouse cursor theme to `Snow Leopard`.

![Config_01](README_media/Config_01.png)

Click `Color`, change `Choose your color` to `Custom` and then the default Windows mode to `Dark` and the default App mode to `Light`.

![Config_02](README_media/Config_02.png)

Set the accent color to `Manual` then click `View colors`. Selecting `More` will allow you to set a hex color code. Change it to `#131313` (Black) and enable accent color on `Start, taskbar, and action center` and `Title bars and window borders`.

![Config_03](README_media/Config_03.png)

### OpenShell

OpenShell, which is the continuation of ClassicShell, should be installed by default with a settings XML file ready for import on the Desktop.

```text
📌 NOTE
After OpenShell is installed you will find example shortcuts for SSH and RDP in the Start Menu under the
KYAU Labs section (feel free to rename to the name of your network).
```

Press the Windows key on your keyboard in order to open the settings dialog for Open-Shell. Click `Backup` and then `Load from an XML file...` choosing the provided XML file on the desktop.

![OpenShell_01](README_media/OpenShell_01.png)

If you need to make changes to the Start Menu, enable `Show all settings` and then navigate to the `Customize Start Menu` tab.

When finished, select `OK` in the bottom right to save the changes. It will prompt you to Exit and reload OpenShell.

Shift + Right-click on the Start Menu and select `Exit`.

![OpenShell_02](README_media/OpenShell_02.png)

Then click the Start Menu and re-launch `Open-Shell Menu Settings`. Finally, selecting `OK` to close settings.

### UniGetUI

UniGetUI will usually popup a notification about updates found, select `Open UniGETUI`. If not navigate to it from Start Menu > Utilities > UniGetUI.

![UniGet_01](README_media/UniGet_01.png)

Once open you should see a callout about anonymous usage data at the top, select `Settings`.

![UniGet_02](README_media/UniGet_02.png)

Decline sharing usage data.

![UniGet_03](README_media/UniGet_03.png)

Select the gear icon to open Settings.

![UniGet_04](README_media/UniGet_04.png)

Navigate to `Administrator rights and other dangerous settings` and enable `Ask for administrator privileges once for each batch of operations` if you want to make multiple updates easier on yourself.

![UniGet_05](README_media/UniGet_05.png)

Finally, navigate to `Software Updates` and select `Update selection`.

![UniGet_06](README_media/UniGet_06.png)

### Brave

```text
🚧 WARNING
Naturally this can be replaced with a browser of your choosing, I would recommend you at least give Brave
a try if you have never used it.
```

The Brave web browser is installed by default unless you modified this.  Mavigate to `Start > Apps > Brave`.

Once open, click `Set Brave as default browser`, which should open the following dialog.

![Brave_01](README_media/Brave_01.png)

While there, might as well set some other sane defaults. When finished close the window.

![Brave_02](README_media/Brave_02.png)

`Skip` importing settings from other browsers as none exist.

![Brave_03](README_media/Brave_03.png)

Next select `Maybe later` for Search Telemetry.

![Brave_04](README_media/Brave_04.png)

Finally, un-check both telemetry options on the final screen and select `Finish`.

![Brave_05](README_media/Brave_05.png)

Next scroll down a little to bring up the Brave News banner and select `No thanks`.

![Brave_06](README_media/Brave_06.png)

Then click on the gear icon in the upper-right corner of the New Tab window.

![Brave_07](README_media/Brave_07.png)

De-select `Show new tab page ads`.

![Brave_08](README_media/Brave_08.png)

Navigate to `Search` and choose your Search Engine of choice.

![Brave_09](README_media/Brave_09.png)

Navigate to `Top Sites` and change it to `Favorites`.

![Brave_10](README_media/Brave_10.png)

Navigate to `Clock` and select `Show clock`.

![Brave_11](README_media/Brave_11.png)

Finally, navigate to `Cards` and de-select all of them except `Brave Stats`.

Then close out of `Customize New Tab Page` with the `X` in the upper right corner of the dialog.

![Brave_12](README_media/Brave_12.png)

Navigate to the hamburger menu in the upper-right and select `Extensions > Visit Web Store` to continue, this should launch in the current tab.

Extensions typical revolve heavily around personal choice, however there are a few extensions that deal with privacy/security that I would recommend to everyone.

* [Cookie AutoDelete](https://chrome.google.com/webstore/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh)
* [Decentraleyes](https://chrome.google.com/webstore/detail/decentraleyes/ldpochfccmkkmhdbclfhpagapcfdljkj)
* [Privacy Badger](https://chrome.google.com/webstore/detail/privacy-badger/pkehgijcmpdhfbdbbnkijodmdjhbjlgp)

Other extensions that I also use:

* [Don't F*** With Paste](https://chromewebstore.google.com/detail/dont-f-with-paste/efaagigdgamehbpimpiagfpoihlkgamh)
* [Enhancer for Youtube](https://chromewebstore.google.com/detail/enhancer-for-youtube/ponfpcnoihfmfllpaingbgckeeldkhle)
* [KeePassXC-Browser](https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk)
* [Stylebot](https://chromewebstore.google.com/detail/stylebot/oiaejidbmkiecgbjeifoejpgmdaleoha)
* [uBlacklist](https://chromewebstore.google.com/detail/ublacklist/pncfbmialoiaghdehhbnbhkkgmjanfhe)

Navigate to the hamburger menu again and select Settings. Under `Appearance` set `Show bookmarks bar` to `Always`.

![Brave_13](README_media/Brave_13.png)

Scroll down and de-select `Leo AI Assistant` under `Show autocomplete suggestions in address bar`. Also and select `Always show full URLs` to enable it.

![Brave_14](README_media/Brave_14.png)

Under `Shields` change `Trackers & ad blocking` to `Aggressive`. Also de-select `Store contact information for future broken site reports`.

![Brave_15](README_media/Brave_15.png)

Scroll to the bottom of the `Shields` section to find `Social media blocking`, de-select all platforms that you do not use.

![Brave_16](README_media/Brave_16.png)

Under `Privacy and security` de-select everything in the `Data collection` section.

![Brave_17](README_media/Brave_17.png)

Under `Search engine` swap the `Search engine used in the address bar` for `Normal Window` and `Private Window` to the one of your choice, I use `DuckDuckGo` personally. Also de-select `Improve search suggestions` as this is also telemtry related.

![Brave_18](README_media/Brave_18.png)

Under `Extensions` select `Widevine` if you plan on using streaming services with this browser.

```text
📌 NOTE
Enabling Widevine DRM will require a restart of Brave, you will be returned to where you left off in
Settings after the restart.
```

![Brave_06](README_media/Brave_19.png)

Under `Autofill and passwords` > `Password Manager` then open the Hamburger menu in the upper left and select `Settings`. De-select `Offer to save passwords` and `Sign in automatically`. Finally, close the `Password Manager` tab to return to `Settings`.

![Brave_20](README_media/Brave_20.png)

Under `Autofill and passwords` > `Payment methods` de-select `Save and fill payment methods` and `Allow sites to check if you have payment methods saved`.

![Brave_21](README_media/Brave_21.png)

Under `Autofill and passwords` > `Addresses and more` de-select `Save and fill addresses`.

![Brave_22](README_media/Brave_22.png)

Brave can be closed for now as configuration is complete.

### Firewall

In the Utilities section of the Start Menu is simplewall, launch it and allow it to update if needed.

![Simplewall_01](README_media/Simplewall_01.png)

In the `Settings` menu enable `Load on system startup`,  `Start minimized`, and `Skip "User Account Control" prompt warning`.

Optionally, also enable `Check apps for sha-256 hash` and `Monitor apps changing`.

![Simplewall_02](README_media/Simplewall_02.png)

In the `Blocklist` menu enable `Microsoft update` by selecting `Allow` in the sub-menu.

![Simplewall_03](README_media/Simplewall_03.png)

Click `Enable filters` in the toolbar, making sure to uncheck `Disable Windows Firewall` if you do not want to overwrite the Windows Firewall. Then clicking `Enable filters` in the popup dialog in order to permanently activate simplewall.

![Simplewall_04](README_media/Simplewall_04.png)

```text
📌 NOTE
simplewall can fully replace Windows Firewall however in Windows 11 this will trip the firewall
failure inside of Windows Security (what use to be called Security Center).
```

Applications will popup asking for internet access, stuff that is required for Windows to function are as follows (it is safe to allow everything in this list):

* `dashost.exe`: wired/wireless device pairing
* `explorer.exe`: typically for SMB of NFS access (network drives)
* `Microsoft Content`: part of search
* `Microsoft Store`: the store uwp app
* `mousocoreworker.exe`: Windows update client
* `microsoftedgeupdate.exe`: Microsoft Web Browser Update
* `mpdefendercoreservice.exe`: Windows Defender
* `msedge.exe`: Microsoft Web Browser (if you are using a different one feel free to block this and the update above)
* `msedgewebview2.exe`: Application level embedded web content
* `msmpeng.exe`: Windows Defender
* `mstsc.exe`: remote desktop connection
* `pwsh.exe`: PowerShell v7.x
* `sihclient.exe`: Windows update background installer
* `simplewall.exe`: 3rd party firewall
* `spoolsv.exe`: network printing
* `sppextcomobj.exe`: KMS connection broker
* `svchost.exe`: Windows service host process
* `System`: Windows NT kernel
* `systemsettings.exe`: Windows update related
* `taskhostw.exe`: scheduled tasks are needed for windows update
* `usocoreworker.exe`: Windows update client
* `windowspackagemangerserver.exe`: Microsoft Windows Store

NVIDIA Graphics Cards Allow List:

* `nvcontainer.exe`: NVIDIA display driver
* `nvidia app.exe`: NVIDIA App
* `nvidia overlay.exe`: NVIDIA Overlay

Default Application Allow List:

* `autoruns.exe`: Autoruns VirusTotal scanning capability
* `brave.exe`: Web browser
* `braveupdate.exe`: Web browser auto-updater
* `ccenhancer.exe`: CCEnhancer downloader
* `cleaner_service.exe`: CCleaner
* `ccleaner64.exe`: Utilities > CCleaner
* `heidisql.exe`: SQL client
* `igcmd.exe`: ImageGlass image viewer update checker
* `sharex.exe`: ShareX screenshot auto uploading
* `sublime_text.exe`: Sublime Text 4 package manager and update checker
* `unigetui.exe`: UniGetUI is the interface for the package manager

Things to block:

* `ccupdate`: CCleaner update checker
* `devicecensus.exe`: Microsoft telemetry
* `dxdiag.exe`: DirectX diagnostic
* `keepassxc.exe`: KeePassXC update checker
* `msiexec.exe`: Microsoft Installer (system32 and syswow64)
* `onedrivesetup.exe`: if you are not using OneDrive
* `wermgr.exe`: Windows error reporting manager (telemetry)
* `Windows Feature Experience Pack`: Windows Start Menu ads and telemetry

Past this, things to allow are at your discretion. Generally I won't allow any installers access to the internet unless they need to download the installation material, and then I give them timed access (only 10 minutes for example). Some things will be easy to choose to allow; like a web browser or email client.

When in doubt, choose the `X` instead of block and if the program fails to work, re-launch the program and you will be asked again and can this time select allow.

### Everything

Everything is a modern replacement for Windows Search with extended functionality. However, always running this in the background is a waste of resources. Open it via the Start Menu, navigate to `Apps > Everything`. Then choose `Options`  from the `Tools` menu.

![Everything_01](README_media/Everything_01.png)

Disable the setting `Everything Service` while enabling `Run as administrator` and then select `OK` at the bottom of the window. Select `Yes` for the UAC popup(s).

![Everything_02](README_media/Everything_02.png)

Finally select `Exit` from the `File` menu.

### CCleaner

Open `CCEnhancer` under `Utilities` in the Start Menu. Select `Yes` for the UAC popup, and `Allow` for the simplewall popup.

Select `Settings` at the bottom of the window.

![CCleaner_01](README_media/CCleaner_01.png)

Enable the setting `Trim definition file to improve performance` and then select `Save and Close`.

![CCleaner_02](README_media/CCleaner_02.png)

Select `Download Latest`, when asked to run CCleaner select `Yes`. If it does not open automatically, right-click the icon in the System Trayto open it.1

![CCleaner_03](README_media/CCleaner_03.png)

Since this is the first time CCleaner has run, select `Next`, then `Not Now` to require prompts. Finally choose `Let's start` with your desired theme selected.

Clicking on the gear icon will bring up `Settings`.

![CCleaner_04](README_media/CCleaner_04.png)

Under the `General` tab de-select both options under `Shortcuts` and `Show tray icon`.

![CCleaner_05](README_media/CCleaner_05.png)

Navigate to the `Scheduling` tab and select `Got it` after reading the help page. Then navigate to `Updates` and select `I'll update manually` since we have winget managing this.

![CCleaner_06](README_media/CCleaner_06.png)

Navigate to the `Privacy` tab and de-select all of the telemetry options.

![CCleaner_08](README_media/CCleaner_07.png)

Navigate to the `Custom Clean` and select `Scan now`. Upon completion of the analysis, select `Clean and fix`.

```text
📌 NOTE
You might receive a warning stating that Microsoft OneDrive or some other application needs to be closed in order for CCleaner to continue. Go ahead and select Yes to the popup.
```

![CCleaner_08](README_media/CCleaner_08.png)

Upon completion you should see `CYou freed up xxx.x MB`. Click `Done`.

Navigate to the `Registry` tab and select `Select all` at the top of the list to the left and then click `Scan now`. Once it has found all the issues, select `Clean and fix`. Confirm with `Continue` that you understand that the registry will be backed up. Select `Done` when finished.

![CCleaner_09](README_media/CCleaner_09.png)

CCleaner will ask if you want to make a back up of the registry before making changes, since we just installed a fresh copy of Windows this is not necessary, select `No`. Once the fix window comes up select `Fix All Selected Issues` and then `Close`.

Finally close out of CCleaner.

### MSEdgeRedirect

Open `MSEdgeRedirect` under `Utilities` in the Start Menu. Select `Allow` for the simplewall popup.

Change the settings `Bing Search`, `Bing Images` and `MSN News (ALPHA)` to the search engine and news provider of choice, I will be using `DuckDuckGo` for them all. Then change the `MSN Weather` setting to your weather provider of choice, I will be using `AccuWeather`.

Enable the `PDF Viewer` setting then pull down the drop-down and select `Custom`, this will open a file dialog box, navigate to `%ProgramFiles%\SumatraPDF\SumatraPDF.exe` and select `Open`.

Close the program by selecting `Save`.

![MSEdgeRedirect_01](README_media/MSEdgeRedirect_01.png)

### Widgets

Hover over the weather widget in the taskbar to open the News/Weather Widget window selecting the gear icon in the upper right.

![Widgets_01](README_media/Widgets_01.png)

Disable the setting `Open Widgets board on hover`, this will change the icon to require a click in order to show the widgets. Then select `Feed` under Personalize.

![Widgets_02](README_media/Widgets_02.png)

Navigate to the `Notifications` tab and de-select all of the notifications you do not want to recieve. I personally only leave weather notifications on.

![Widgets_03](README_media/Widgets_03.png)

Close out of all the widgets windows.

### PowerToys

Click on the PowerToys icon in the System Tray to open its quick launch menu. Then click on the gear icon to open the PowerToys Settings window.

![PowerToys_01](README_media/PowerToys_01.png)

Reboot the machine to continue.

## Further Setup

Additional setup and software configuration can be found on the [Wiki](https://github.com/kyaulabs/win11tweak/wiki).

## Customization

This section covers optional customization points for Win11Tweaks so you can tailor behavior to your own environment and workflow. More customization guides will be added here over time as additional script components become configurable.

### Winget App Customization

If you modify the default applications installed by `winget`, you must update more than one place in this project.

Customize Apps Checklist:

* [ ] Add/remove package IDs in `user_settings.ps1`.
* [ ] Add/remove matching `Add-Shortcut` entries in `Modules/startmenu.ps1` under `Creating Shortcuts`.
* [ ] Verify each shortcut target path exists after install.
* [ ] Run the script and confirm Open-Shell has no dead shortcuts.

#### Detailed Notes

1. Update the package list in `user_settings.ps1`.
   This is the source list consumed by the scripts for `winget` installs.
2. Update Open-Shell shortcuts in `Modules/startmenu.ps1` under the `Creating Shortcuts` section (starts around line 50).
   Each application you want visible in the Start Menu should have a matching `Add-Shortcut` entry.
3. Follow the shortcut syntax shown directly under that section header (line 51):

```powershell
# Add-Shortcut "SubMenu\Application OR Startup" "target.exe" "icon-name" "arguments" "working-directory"
Add-Shortcut "Apps\Example App" "${Env:ProgramFiles}\Vendor\Example\example.exe" "win11tweak-apps.dll,123"
```

If a package is removed from `user_settings.ps1`, also remove or adjust its corresponding `Add-Shortcut` entry so Open-Shell does not show dead shortcuts.

## Attribution

Without all of the following this guide/script would not have been possible.

* [Windows 10 Privacy Guide - 1903 Update](https://github.com/adolfintel/Windows10-Privacy)
* [tweaks & fixes for windows 10 - mostly powershell](https://github.com/equk/windows)
* [Win10 Initial Setup Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script)
* [Windows TenForums](https://www.tenforums.com/)
* [Summary of AV Test Results - July 2022](https://www.reddit.com/r/antivirus/comments/w1rcgi/summary_of_av_test_results_july_2022/)
* [Flat-Remix Icon Theme](https://github.com/daniruiz/flat-remix)
* [agave font](https://github.com/agarick/agave)
* [Mixed wallpaper](https://www.deviantart.com/i5yal/art/Mixed-wallpaper-744877376)
* [openssh-sk-winhello](https://github.com/tavrez/openssh-sk-winhello)
* [Git for Windows inside MSYS2 proper](https://gitforwindows.org/Install-inside-MSYS2-proper)
