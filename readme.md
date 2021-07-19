```
$ ./clean.sh
Password:
[-] Removing file : /Library/LaunchAgents/com.citrix.ServiceRecords.plist
[-] Removing file : /Library/LaunchAgents/com.citrix.AuthManager_Mac.plist
[-] Removing directory : /Library/PreferencePanes/Citrix HDX RealTime Media Engine.prefPane
[-] Removing directory : /Library/Java/JavaVirtualMachines/jdk1.8.0_291.jdk
... etc ...
```

Or, more recklessly :
```
$ curl -s "https://raw.githubusercontent.com/tomtastic/rascleanup/main/clean.sh" | bash
```
