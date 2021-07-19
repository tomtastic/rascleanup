#!/usr/bin/env bash
# Attempt to remove all traces of RemoteAccess

declare -a RAS_ELEMENTS
RAS_ELEMENTS=(
  # Root elements
    "/Applications/Citrix Workspace.app"
    "/Library/Application Support/Citrix"
    "/Library/Application Support/Citrix Receiver"
    "/Library/Application Support/Oracle"
    "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin"
    "/Library/Java/JavaVirtualMachines/jdk*"
    "/Library/Java/JavaVirtualMachines/jre*"
    "/Library/LaunchAgents/com.citrix.ServiceRecords.plist"
    "/Library/LaunchAgents/com.citrix.AuthManager_Mac.plist"
    "/Library/LaunchAgents/com.citrix.ReceiverHelper.plist"
    "/Library/LaunchDaemons/com.citrix.ctxusbd.plist"
    "/Library/LaunchAgents/com.oracle.java.Java-Updater.plist"
    "/Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist"
    "/Library/Logs/DiagnosticReports/Citrix Viewer*"
    "/Library/Preferences/com.oracle.java.Java-Updater.plist"
    "/Library/Preferences/com.oracle.java.Helper-Tool.plist"
    "/Library/PreferencePanes/Citrix HDX RealTime Media Engine.prefPane"
    "/Library/PreferencePanes/JavaControlPanel.prefPane"
    "/Users/Shared/Citrix"
    "/Users/Shared/Citrix Receiver"
    "/private/var/root/Library/Application Support/Citrix Receiver"
    "/usr/local/libexec/AuthManager_Mac.app"
    "/usr/local/libexec/ServiceRecords.app"
    "/usr/local/libexec/ReceiverHelper.app"
  # User elements
    "~/Library/Application Support/Citrix"
    "~/Library/Application Support/Citrix Receiver"
    "~/Library/Application Support/com.citrix.CitrixReceiverLauncher"
    "~/Library/Application Support/com.citrix.RTMediaEngineSRV"
    "~/Library/Application Support/com.citrix.ReceiverHelper"
    "~/Library/Application Support/com.citrix.XenAppViewer"
    "~/Library/Application Support/com.citrix.receiver.nomas"
    "~/Library/Application Support/Java"
    "~/Library/Application Support/Juniper Networks"
    "~/Library/Application Support/Oracle"
    "~/Library/Application Support/Pulse Secure"
    "~/Library/Caches/com.oracle.java.*"
    "~/Library/Caches/net.pulsesecure.PulseApplicationLauncher"
    "~/Library/LaunchAgents/net.pulsesecure.SetupClient.plist"
    "~/Library/Logs/Citrix"
    "~/Library/Logs/Citrix Workspace"
    "~/Library/Logs/Pulse Secure"
    "~/Library/Logs/PulseSecureAppLauncher.log"
    "~/Library/Preferences/com.citrix.AuthManager.plist"
    "~/Library/Preferences/com.citrix.CitrixReceiverLauncher.plist"
    "~/Library/Preferences/com.citrix.RTMediaEngineSRV.plist"
    "~/Library/Preferences/com.citrix.ReceiverHelper.plist"
    "~/Library/Preferences/com.citrix.XenAppViewer.plist"
    "~/Library/Preferences/com.citrix.receiver.nomas.plist"
    "~/Library/Preferences/com.oracle.java.JavaAppletPlugin.plist"
    "~/Library/Preferences/com.oracle.javadeployment.plist"
    "~/Library/Receipts/net.pulsesecure.*"
    "~/Library/Saved Application State/com.oracle.java.*"
    "~/Library/WebKit/com.citrix.receiver.nomas"
)

declare -a RAS_RECEIPTS
i=0
while read -r; do
    RAS_RECEIPTS[i]="$REPLY"
    ((++i))
done <<< "$(pkgutil --packages | grep -Ei 'citrix|pulse|oracle.jdk|oracle.jre')"

function cleanup_leftovers() {
    for e in "${RAS_ELEMENTS[@]}"; do
        # Expand any tilda, etc
        e="${e/#\~/$HOME}"
        expanded="$(echo $e)"
        for i in "${expanded[@]}"; do
            if [[ -d "$i" ]]; then
                echo "[-] Removing directory : $i"
                sudo rm -r "$i"
            elif [[ -f "$i" ]]; then
                echo "[-] Removing file : $i"
                sudo rm "$i"
            elif [[ -h "$i" ]]; then
                echo "[-] Removing symlink : $i"
                sudo rm "$i"
            fi
        done
    done
}

function cleanup_receipts() {
    for r in "${RAS_RECEIPTS[@]}"; do
        if [[ -n "$r" ]]; then
            echo "[-] Removing package receipts for : $r"
            sudo pkgutil --forget "$r"
        fi
    done
}


# Get privs
sudo -l >/dev/null 2>&1
cleanup_leftovers
cleanup_receipts

[[ "$1" =~ "h" ]] || exit 0
echo "Recommended RAS apps for re-install:"
echo "  - MacOS 10.13 (High Sierra) to 10.15 (Catalina)"
echo "    Citrix Workspace 2008 – https://www.citrix.com/downloads/workspace-app/legacy-receiver-for-mac/workspace-app-for-mac-2008.html"
echo "    Citrix RTX engine - https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29300.html"
echo "    Oracle JDK 8u291 - https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html"
echo "  - MacOS 11 (Big Sur) onwards"
echo "    Citrix Workspace – https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html"
echo "    Citrix RTX engine - https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29300.html"
echo "    Oracle JDK 8u291 - https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html"
echo "Ensure Safari (13+) is setup:"
echo "  - Safari > Preferences > Websites > General > Content Blockers > (DOMAIN) > Off."
echo "  - Safari > Preferences > Websites > General > Pop-up Windows > (DOMAIN) > Allow."
echo "Ensure MacOS Security & Privacy is setup:"
echo "  - ALL"
echo "    System Preferences > Security & Privacy > Firewall > Firewall Options > Uncheck : Automatically allow downloaded signed software to receive incoming connections"
echo "    System Preferences > Security & Privacy > General > Allow apps downloaded from > Check : Open anyway"
echo "  - MacOS 11 (Big Sur) onwards"
echo "    System Preferences > Security & Privacy > Privacy > Full Disk Access > Check : PulseApplicationLauncher"
echo "    System Preferences > Security & Privacy > Privacy > Full Disk Access > Check : Citrix Viewer"
