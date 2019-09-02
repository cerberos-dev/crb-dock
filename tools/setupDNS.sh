#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
    # Check if dnsmasq is already installed.
    if [[ -n "$(command -v dnsmasq)" ]]; then
        # The package is installed we do nothing
        echo "Dnsmasq already installed, stopping daemon and adding config lines"

        # Stop DNSMASQ service to make sure we can continue with the steps below
        sudo launchctl stop homebrew.mxcl.dnsmasq
    else
        # We know nothing Jon Snow (so we install dnsmasq)
        source brew.sh
    fi

    # Add .yad and .sprd to the config
    echo 'address=/.yad/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
    echo 'address=/.sprd/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
    echo 'address=/.crb/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf

    if ! [[ -f '/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist' ]]; then
        # Copy the daemon configuration file into place.
        sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons

        # Start Dnsmasq automatically.
        sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
    fi

    if ! [[ -d '/etc/resolver' ]]; then
        sudo mkdir -v /etc/resolver
    fi

    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/yad'
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/sprd'
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/crb'

    # Make sure DNSMASQ is started
    sudo launchctl start homebrew.mxcl.dnsmasq

    # Flush local DNS cache
    sudo killall -HUP mDNSResponder
fi
