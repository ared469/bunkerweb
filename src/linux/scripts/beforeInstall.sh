#!/bin/bash

# Function to run a command and check its return code
function do_and_check_cmd() {
    output=$("$@" 2>&1)
    ret="$?"
    if [ $ret -ne 0 ] ; then
        echo "❌ Error from command : $*"
        echo "$output"
        exit $ret
    else
        echo "✔️ Success: $*"
        echo "$output"
    fi
    return 0
}

# Check the os running
if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS=$NAME
    if [[ "$OS" == "Ubuntu" || "$OS" == "Debian" ]]; then
        # Get the version of the package
        VERSION=$(dpkg-query -W -f='${Version}' bunkerweb)
        if dpkg --compare-versions "$VERSION" lt "1.5.6" && [ -f /var/tmp/variables.env ] && [ -f /var/tmp/ui.env ]; then
            echo "ℹ️ Copy /var/tmp/variables.env to /etc/bunkerweb/variables.env"
            do_and_check_cmd cp -f /var/tmp/variables.env /etc/bunkerweb/variables.env
            echo "ℹ️ Copy /var/tmp/ui.env to /etc/bunkerweb/ui.env"
            do_and_check_cmd cp -f /var/tmp/ui.env /etc/bunkerweb/ui.env
        fi
    elif [[ "$OS" == "Red Hat Enterprise Linux" || "$OS" == "Fedora" || "$OS" == "Rocky Linux" ]]; then
        # Get the version of the package
        VERSION=$(rpm -q --queryformat '%{VERSION}' bunkerweb)
        if [ "$(printf '%s\n' "$VERSION" "$(echo '1.5.6' | tr -d ' ')" | sort -V | head -n 1)" = "$VERSION" ] && [ -f /var/tmp/variables.env ] && [ -f /var/tmp/ui.env ]; then
            echo "ℹ️ Copy /var/tmp/variables.env to /etc/bunkerweb/variables.env"
            do_and_check_cmd cp -f /var/tmp/variables.env /etc/bunkerweb/variables.env
            echo "ℹ️ Copy /var/tmp/ui.env to /etc/bunkerweb/ui.env"
            do_and_check_cmd cp -f /var/tmp/ui.env /etc/bunkerweb/ui.env
        fi
    fi
else
    echo "❌ Error: /etc/os-release not found"
    exit 1
fi
