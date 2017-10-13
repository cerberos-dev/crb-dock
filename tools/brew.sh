#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"gs should pass through the the `brew list check`
fi

echo -e "\n\nInstalling homebrew packages..."
echo "=============================="

formulas=(
    dnsmasq
)

for formula in "${formulas[@]}"; do
    if brew list "$formula" > /dev/null 2>&1; then
        echo "$formula already installed... skipping."
    else
        brew install $formula
    fi
done
