### Xcode extension that creates init method by selected properties.

## Install :fire:

1. Check that Xcode version greater or equal than 8.0.
2. If you are using OS X 10.11, running `sudo /usr/libexec/xpccachectl` and rebooting are required for using Xcode Extension.
3. Clone this repository.
4. Open `Shared.xcodeproj` via Xcode.
5. Configure signing with your own developer ID. 
6. Quit Xcode.
7. Open a terminal, change to the directory where you cloned and run `xcodebuild -scheme XShared install DSTROOT=~` to compile the extension.
8. Run `~/Applications/Shared.app` and quit.
9. Go to ***System Preferences -> Extensions -> Xcode Source Editor*** and enable the extension.
10. Done.
