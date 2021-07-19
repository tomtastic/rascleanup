### usage
```
$ ./clean.sh
Password:
[-] Removing file : /Library/LaunchAgents/com.citrix.ServiceRecords.plist
[-] Removing file : /Library/LaunchAgents/com.citrix.AuthManager_Mac.plist
[-] Removing directory : /Library/PreferencePanes/Citrix HDX RealTime Media Engine.prefPane
[-] Removing directory : /Library/Java/JavaVirtualMachines/jdk1.8.0_291.jdk
... etc ...
[+] Done
```

### ras (re)install tips
#### all macos versions
 - [Install Oracle JDK 8u291](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
 - Ensure Safari (13+) is setup
    - Safari > Preferences > Websites > General > Content Blockers > `(DOMAIN)` > **Off**
    - Safari > Preferences > Websites > General > Pop-up Windows > `(DOMAIN)` > **Allow**
 - Ensure MacOS Security & Privacy is setup
    - System Preferences > Security & Privacy > Firewall > Firewall Options > **Uncheck** : `Automatically allow downloaded signed software to receive incoming connections`
    - System Preferences > Security & Privacy > General > Allow apps downloaded from > **Check** : `Open anyway`
#### (only) macos 11 (big sur) onwards
 - Install [Citrix Workspace (latest)](https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html)
 - Install [Citrix HDX Realtime Media Engine](https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29300.html)
 - System Preferences > Security & Privacy > Privacy > Full Disk Access > **Check** : `PulseApplicationLauncher`
 - System Preferences > Security & Privacy > Privacy > Full Disk Access > **Check** :` Citrix Viewer`
#### (only) macos 10.13 (high sierra) to 10.15 (catalina)
 - Install [Citrix Workspace (v2008)](https://www.citrix.com/downloads/workspace-app/legacy-receiver-for-mac/workspace-app-for-mac-2008.html)
 - Install [Citrix HDX Realtime Media Engine](https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29300.html)
