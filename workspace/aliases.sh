#! /bin/bash

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Set xterm as terminal
export TERM="xterm"

# Custom aliases
#########################################################

# Set directory helpers
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# List everything in directory
alias ll="ls -lah"

# History / Alias helpers
alias ag='alias | grep'
alias hg='history | grep'

# Reload Bash
alias reload=". ~/.bashrc"

# List files by size
alias size='du -sh * | sort -r -n | grep "[0-9][G|M]"'
