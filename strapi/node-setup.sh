#!/bin/bash

# Exit on error
set -e

# Update and install basic packages
sudo apt update
sudo apt install -y npm curl

# Install NVM
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
fi

# Load NVM into the current shell
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use Node.js 20
nvm install 20
nvm use 20

# Install Yarn via corepack (recommended for Node >=16)
corepack enable
corepack prepare yarn@stable --activate

# Install PM2 globally
npm install -g pm2

source ~/.bashrc

# Verify installed versions
echo "✅ Node version: $(node -v)"
echo "✅ NPM version: $(npm -v)"
echo "✅ Yarn version: $(yarn -v)"
echo "✅ NVM version: $(nvm --version)"
echo "✅ PM2 version: $(pm2 -v)"

