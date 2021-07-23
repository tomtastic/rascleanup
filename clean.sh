#!/usr/bin/env bash
# Attempt to cleanup RemoteAccess components

# shellcheck disable=SC2088 # Because we prefer to use tilde than $HOME here
RAS_ELEMENTS_LIGHT=(
  # User elements
    "~/Library/Caches/com.oracle.java.*"
    "~/Library/Caches/net.pulsesecure.*"
    "~/Library/Application Support/Pulse Secure/applets"
)

# shellcheck disable=SC2088 # Because we prefer to use tilde than $HOME here
RAS_ELEMENTS_FULL=(
  # Root elements
    "/Applications/Citrix Workspace.app"
    "/Library/Application Support/Citrix"
    "/Library/Application Support/Citrix Receiver"
    "/Library/Application Support/Oracle/Java"
    "/Library/Application Support/Pulse Secure"
    "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin"
    "/Library/Java/Extensions"
    "/Library/Java/JavaVirtualMachines/jdk*"
    "/Library/Java/JavaVirtualMachines/jre*"
    "/Library/LaunchAgents/com.citrix.*"
    "/Library/LaunchAgents/com.oracle.java*"
    "/Library/LaunchDaemons/com.citrix.*"
    "/Library/LaunchDaemons/com.oracle.java*"
    "/Library/LaunchDaemons/com.oracle.Java*"
    "/Library/Logs/DiagnosticReports/Citrix Viewer*"
    "/Library/PreferencePanes/Citrix HDX RealTime Media Engine.prefPane"
    "/Library/PreferencePanes/JavaControlPanel.prefPane"
    "/Library/Preferences/com.oracle.java.*"
    "/Library/PrivilegedHelperTools/com.oracle.JavaInstallHelper"
    "/Library/PrivilegedHelperTools/com.oracle.java.JavaUpdateHelper"
    "/Users/Shared/Citrix"
    "/Users/Shared/Citrix Receiver"
    "/private/var/root/Library/Application Support/Citrix Receiver"
    "/usr/local/libexec/AuthManager_Mac.app"
    "/usr/local/libexec/ReceiverHelper.app"
    "/usr/local/libexec/ServiceRecords.app"
    "/var/db/receipts/com.oracle.jdk*"
    "/var/db/receipts/com.oracle.jre*"
    "/var/root/Library/Application Support/Oracle/Java"
    "/var/root/.oracle_jre_usage"
  # User elements
    "~/Library/Application Support/Citrix"
    "~/Library/Application Support/Citrix Receiver"
    "~/Library/Application Support/CrashReporter/HostChecker*"
    "~/Library/Application Support/Java"
    "~/Library/Application Support/Juniper Networks"
    "~/Library/Application Support/Oracle"
    "~/Library/Application Support/Pulse Secure"
    "~/Library/Application Support/com.citrix.*"
    "~/Library/Caches/com.oracle.java.*"
    "~/Library/Caches/net.pulsesecure.*"
    "~/Library/Java/Extensions"
    "~/Library/LaunchAgents/net.pulsesecure.*"
    "~/Library/Logs/Citrix"
    "~/Library/Logs/Citrix Workspace"
    "~/Library/Logs/DiagnosticReports/HostChecker*"
    "~/Library/Logs/Pulse Secure"
    "~/Library/Logs/PulseSecureAppLauncher.log"
    "~/Library/Preferences/com.citrix.*"
    "~/Library/Preferences/com.oracle.java*"
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
    level="$1"
    remove="$2"
    if [[ "$level" == "light" ]]; then
        components=("${RAS_ELEMENTS_LIGHT[@]}")
    else
        components=("${RAS_ELEMENTS_FULL[@]}")
    fi
    for e in "${components[@]}"; do
        # Expand any tilda, etc
        e="${e/#\~/$HOME}"
        OIFS="$IFS"
        IFS=$'\n'
        # shellcheck disable=SC2207,SC2116 # Because it works even if its ugly
        expanded=($(echo "$e"))
        IFS="$OIFS"
        for i in "${expanded[@]}"; do
            if [[ -d "$i" ]]; then
                printf "[-] %-25s : %s\n" "Removing directory" "$i"
                [[ -n "$remove" ]] && rm -r "$i"
            elif [[ -f "$i" ]]; then
                printf "[-] %-25s : %s\n" "Removing file" "$i"
                [[ -n "$remove" ]] && rm "$i"
            elif [[ -h "$i" ]]; then
                printf "[-] %-25s : %s\n" "Removing symlink" "$i"
                [[ -n "$remove" ]] && rm "$i"
            fi
        done
    done
}

function cleanup_receipts() {
    remove=$1
    for r in "${RAS_RECEIPTS[@]}"; do
        if [[ -n "$r" ]]; then
            printf "[-] %-25s : %s\n" "Removing package receipts" "$r"
            [[ -n "$remove" ]] && pkgutil --forget "$r"
        fi
    done
}

if [[ "$1" =~ "-f" ]]; then
    # Full cleanup
    cleanup_receipts "remove"
    cleanup_leftovers "full" "remove"
    echo "[+] Done"
elif [[ "$1" =~ "-l" ]]; then
    # Light cleanup
    cleanup_leftovers "light" "remove"
    echo "[+] Done"
else
    # Check only
    cleanup_receipts
    cleanup_leftovers
    echo "[!] Check-only mode, use $0 [--light | --full] to cleanup files"
    echo "[+] Done"
fi
