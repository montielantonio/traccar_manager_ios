# GPSLink Manger - Mac Mini Setup Guide

## Prerequisites
- Mac Mini access (SSH or VNC)
- Apple Developer Account credentials
- Xcode installed on the Mac

---

## Step 1: Connect to Mac Mini

### Option A: SSH (Command Line)
```bash
ssh administrator@162.221.89.35
```
Password: `Ahmaich9`

### Option B: VNC (Screen Sharing)
On your Mac/Windows, connect to:
```
vnc://162.221.89.35
```
Or use a VNC client (RealVNC, TightVNC) with:
- Host: `162.221.89.35`
- Username: `administrator`
- Password: `Ahmaich9`

---

## Step 2: Check Xcode Installation

Once connected via SSH, run:
```bash
xcode-select -p
```

If Xcode is installed, you'll see something like:
```
/Applications/Xcode.app/Contents/Developer
```

If not installed, you'll need to install it via VNC (App Store) or:
```bash
xcode-select --install
```

Check Xcode version:
```bash
xcodebuild -version
```

---

## Step 3: Create Project Directory

```bash
mkdir -p ~/Projects
cd ~/Projects
```

---

## Step 4: Transfer Project Files

### Option A: If you have Git repository
```bash
cd ~/Projects
git clone <YOUR_REPO_URL> GPSLinkManger
cd GPSLinkManger
```

### Option B: Transfer via SCP (from your Windows machine)
On your Windows machine (PowerShell), run:
```powershell
scp -r "C:\path\to\traccar_manager_ios" administrator@162.221.89.35:~/Projects/GPSLinkManger
```

### Option C: Create files manually (if no Git/SCP)
See "Manual File Creation" section at the end.

---

## Step 5: Verify Project Structure

```bash
cd ~/Projects/GPSLinkManger
ls -la
```

You should see:
```
TraccarManager/
TraccarManager.xcodeproj/
README.md
LICENSE.txt
```

---

## Step 6: Open Project in Xcode (via VNC)

Connect via VNC, then open Terminal and run:
```bash
cd ~/Projects/GPSLinkManger
open TraccarManager.xcodeproj
```

---

## Step 7: Configure Signing in Xcode

1. In Xcode, click on **TraccarManager** in the Project Navigator (left sidebar)
2. Select **TraccarManager** target
3. Go to **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team** (Apple Developer Account)
6. Bundle Identifier should be: `com.quisqueyaride`

---

## Step 8: Build the Project

### Via Xcode GUI:
1. Select a simulator (e.g., iPhone 15 Pro)
2. Press **⌘ + B** to build
3. Check for any errors in the Issue Navigator

### Via Command Line:
```bash
cd ~/Projects/GPSLinkManger
xcodebuild -project TraccarManager.xcodeproj -scheme TraccarManager -sdk iphonesimulator -configuration Debug build
```

---

## Step 9: Run on Simulator

### Via Xcode GUI:
1. Select simulator from the device dropdown
2. Press **⌘ + R** to run

### Via Command Line:
```bash
# List available simulators
xcrun simctl list devices

# Boot a simulator (example: iPhone 15 Pro)
xcrun simctl boot "iPhone 15 Pro"

# Open Simulator app
open -a Simulator
```

---

## Step 10: Archive for App Store (When Ready)

### Via Xcode GUI:
1. Select **Any iOS Device (arm64)** as destination
2. Go to **Product → Archive**
3. Wait for archive to complete
4. In Organizer, click **Distribute App**
5. Select **App Store Connect**
6. Follow the wizard

### Via Command Line:
```bash
cd ~/Projects/GPSLinkManger

# Create archive
xcodebuild -project TraccarManager.xcodeproj \
  -scheme TraccarManager \
  -sdk iphoneos \
  -configuration Release \
  -archivePath ~/Desktop/GPSLinkManger.xcarchive \
  archive

# Export for App Store
xcodebuild -exportArchive \
  -archivePath ~/Desktop/GPSLinkManger.xcarchive \
  -exportPath ~/Desktop/GPSLinkManger_Export \
  -exportOptionsPlist ExportOptions.plist
```

---

## Troubleshooting

### "No signing certificate" error
1. Open Xcode → Preferences → Accounts
2. Add your Apple ID
3. Click "Download Manual Profiles" or let Xcode manage automatically

### "Bundle identifier already in use"
The bundle ID `com.quisqueyaride` must match what's registered in App Store Connect.

### Build fails with Swift version error
```bash
# Check Swift version
swift --version

# Should be Swift 5.0+
```

### Xcode command line tools not found
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

---

## Quick Reference

| Item | Value |
|------|-------|
| App Name | GPSLink Manger |
| Bundle ID | com.quisqueyaride |
| Server URL | https://track.gpslinkusa.com/ |
| Min iOS | 12.0 |
| Swift Version | 5.0 |

---

## Contact
For issues, contact YNVERT LLC development team.
