#!/usr/bin/env bash

# Don't do anything if a SSH Key is already set up
[ -f ~/.ssh/id_rsa.pub ] && echo "It seems you already have a SSH Key here... existing" && exit

read -p 'Enter your email address for the SSH Key:' email

# generate ssh key
ssh-keygen -t rsa -b 4096 -C "$email"

# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# automatically load keys into the ssh-agent and store passphrases in your keychain
cat > ~/.ssh/config <<EOL
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
EOL

# Add your SSH private key to the ssh-agent and store your passphrase in the keychain
ssh-add -K ~/.ssh/id_rsa

echo "Here is your Public SSH Key (available in your clipboard):"
echo ""
cat /.ssh/id_rsa.pub

# Copy SSH Key to the clipboard
pbcopy < ~/.ssh/id_rsa.pub
