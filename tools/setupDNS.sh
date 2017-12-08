#!/bin/sh

if [ "$(uname)" == "linux-gnu" ]; then
    echo "\n\nRunning on Linux "
fi

if [ "$(uname)" == "Darwin" ]; then
    echo "\n\nRunning on OSX, checking if dependencies are met."

    if brew ls --versions dnsmasq; then
      # The package is installed we do nothing
      echo "\n\nYes DNSMASQ installed."
    else
      # We know nothing Jon Snow (so we install dnsmasq)
        source brew.sh
    fi


    echo 'address=/.yad/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf

    sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
    sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

    sudo mkdir -v /etc/resolver
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
fi
