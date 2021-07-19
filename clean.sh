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
    "/Library/LaunchAgents/com.citrix.AuthManager_Mac.plist"
    "/Library/LaunchAgents/com.citrix.ReceiverHelper.plist"
    "/Library/LaunchAgents/com.citrix.ServiceRecords.plist"
    "/Library/LaunchAgents/com.oracle.java.Java-Updater.plist"
    "/Library/LaunchDaemons/com.citrix.ctxusbd.plist"
    "/Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist"
    "/Library/Logs/DiagnosticReports/Citrix Viewer*"
    "/Library/PreferencePanes/Citrix HDX RealTime Media Engine.prefPane"
    "/Library/PreferencePanes/JavaControlPanel.prefPane"
    "/Library/Preferences/com.oracle.java.Helper-Tool.plist"
    "/Library/Preferences/com.oracle.java.Java-Updater.plist"
    "/Users/Shared/Citrix"
    "/Users/Shared/Citrix Receiver"
    "/private/var/root/Library/Application Support/Citrix Receiver"
    "/usr/local/libexec/AuthManager_Mac.app"
    "/usr/local/libexec/ReceiverHelper.app"
    "/usr/local/libexec/ServiceRecords.app"
  # User elements
    "~/Library/Application Support/Citrix"
    "~/Library/Application Support/Citrix Receiver"
    "~/Library/Application Support/CrashReporter/HostChecker*"
    "~/Library/Application Support/Java"
    "~/Library/Application Support/Juniper Networks"
    "~/Library/Application Support/Oracle"
    "~/Library/Application Support/Pulse Secure"
    "~/Library/Application Support/com.citrix.CitrixReceiverLauncher"
    "~/Library/Application Support/com.citrix.RTMediaEngineSRV"
    "~/Library/Application Support/com.citrix.ReceiverHelper"
    "~/Library/Application Support/com.citrix.XenAppViewer"
    "~/Library/Application Support/com.citrix.receiver.nomas"
    "~/Library/Caches/com.oracle.java.*"
    "~/Library/Caches/net.pulsesecure.PulseApplicationLauncher"
    "~/Library/LaunchAgents/net.pulsesecure.SetupClient.plist"
    "~/Library/Logs/Citrix"
    "~/Library/Logs/Citrix Workspace"
    "~/Library/Logs/DiagnosticReports/HostChecker*"
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
    enabled="$1"
    for e in "${RAS_ELEMENTS[@]}"; do
        # Expand any tilda, etc
        e="${e/#\~/$HOME}"
        declare -a expanded
        expanded=($(echo $e))
        for i in "${expanded[@]}"; do
            if [[ -d "$i" ]]; then
                echo "[-] Removing directory : $i"
                [[ -n "$enabled" ]] && sudo rm -r "$i"
            elif [[ -f "$i" ]]; then
                echo "[-] Removing file : $i"
                [[ -n "$enabled" ]] && sudo rm "$i"
            elif [[ -h "$i" ]]; then
                echo "[-] Removing symlink : $i"
                [[ -n "$enabled" ]] && sudo rm "$i"
            fi
        done
    done
}

function cleanup_receipts() {
    enabled=$1
    for r in "${RAS_RECEIPTS[@]}"; do
        if [[ -n "$r" ]]; then
            echo "[-] Removing package receipts for : $r"
            [[ -n "$enabled" ]] && sudo pkgutil --forget "$r"
        fi
    done
}

if [[ "$1" =~ "-f" ]]; then
    # Get privs
    sudo -l >/dev/null 2>&1
    cleanup_leftovers
    cleanup_receipts
    echo "[+] Done"
else
    echo "[!] Check-only mode, use $0 --force to remove files"
    cleanup_leftovers
    cleanup_receipts
    echo "[!] Check-only mode, use $0 --force to remove files"
fi
