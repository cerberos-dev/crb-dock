#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
    # Check if dnsmasq is already installed.
    if [[ -n "$(command -v dnsmasq)" ]]; then
        # The package is installed we do nothing
        echo "Dnsmasq already installed, stopping daemon and adding config lines..."

        # Stop DNSMASQ service to make sure we can continue with the steps below
        sudo launchctl stop homebrew.mxcl.dnsmasq
    else
        # We know nothing Jon Snow (so we install dnsmasq via homebrew)
        if test ! "$(which brew)"; then
            echo "Installing homebrew..."

            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        echo "Installing homebrew packages..."

        formulas=(
            dnsmasq
        )

        for formula in "${formulas[@]}"; do
            if brew list "$formula" > /dev/null 2>&1; then
                echo "Package '$formula' already installed."
            else
                brew install "$formula"
            fi
        done
    fi

    # shellcheck disable=SC2129
    # Add IETF RFC 2606 local TLD list to the dnsmasq config
    echo 'address=/.localhost/127.0.0.1' >> "$(brew --prefix)/etc/dnsmasq.conf"
    echo 'address=/.test/127.0.0.1' >> "$(brew --prefix)/etc/dnsmasq.conf"
    echo 'address=/.invalid/127.0.0.1' >> "$(brew --prefix)/etc/dnsmasq.conf"
    echo 'address=/.example/127.0.0.1' >> "$(brew --prefix)/etc/dnsmasq.conf"


    if ! [[ -f '/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist' ]]; then
        # Copy the daemon configuration file into place.
        sudo cp -v "$(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist" /Library/LaunchDaemons

        # Start dnsmasq automatically.
        sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
    fi

    if ! [[ -d '/etc/resolver' ]]; then
        sudo mkdir -v /etc/resolver
    fi

    # Create IETF RFC 2606 local TLD resolver files
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/invalid'
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/example'

    # Make sure dnsmasq is started
    sudo launchctl start homebrew.mxcl.dnsmasq

    # Flush local DNS cache
    sudo killall -HUP mDNSResponder
fi
