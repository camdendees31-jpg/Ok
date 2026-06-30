# Roblox iOS Update Bypass Tweak

This Theos tweak bypasses the forced "App Update is Required" prompt in the Roblox mobile app on iOS.

## Features
- Auto-dismisses UIAlertController popups matching update-related titles/messages.
- Spoofs CFBundle version strings to a high number (prevents some local version checks).
- Blocks automatic redirects to the App Store for update links.

## How to Build
1. Set up Theos on macOS (recommended) or Linux: https://theos.dev/install
2. Export THEOS path if needed: `export THEOS=/opt/theos`
3. Place the three files (Makefile, control, Tweak.xm) in a folder.
4. Run: `make clean package`
5. The .deb will be generated in the `packages/` folder (or `.theos`).

## Installation
- Jailbroken device: Install .deb via Sileo, Zebra, or dpkg -i
- After install, respring or reboot.
- For TrollStore / non-jail: Use appropriate injection method for the dylib inside the package.

## Usage
- Launch Roblox. The update prompt should be automatically dismissed.
- If it still appears, update the version numbers in Tweak.xm (CFBundleShortVersionString and CFBundleVersion) to exceed the current Roblox version.
- Rebuild and reinstall.

## Customization / Advanced
If the prompt is not caught (Roblox may use custom views in newer versions):
- Use Frida to trace the app: `frida-trace -U -f com.roblox.robloxmobile -m "*[UIAlert* *]"` or search for "update" strings.
- Find the exact method showing the update screen and add a %hook for it.
- For server-side version enforcement, a MITM proxy (like Fiddler on PC with iOS VPN) or deeper hooking on network responses may be needed.

Update the version spoof values in Tweak.xm to the latest available Roblox version before building.

Tested conceptually for standard UIAlert flow. Adjust as needed for current app versions.

[made by seraph]
