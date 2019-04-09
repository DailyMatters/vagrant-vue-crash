#!/usr/bin/env bash

# ===================================================================
# Variables
# ===================================================================
UPDATE_SYSTEM=0

# ===================================================================
# Pretify logging to screen
# ===================================================================
printLog() {
  printf "[Vagrant Provisioning] $1\n";
}

installManPages() {
  FILE=/usr/bin/man
  if [ ! -f $FILE ]; then
    printLog "Installing man pages";
    apt-get --quiet -y install man;
  fi
}

installVim() {
  printLog "Installing Vim";
  apt-get --quiet -y install vim-gnome
}

installGit() {
  if [ ! -f /usr/bin/git ]; then
    printLog "Adding Git version control";
    apt-get --quiet -y install git
  fi
}

configureShell() {
  # ===================================================================
  # Set up annoying shell and vim configs for root.
  # ===================================================================
  value=$(grep -c "set -o vi" ~root/.bashrc)
  if [ $value -eq 0 ]; then
    echo 'set -o vi' >> ~root/.bashrc
  fi

  if [ ! -f ~root/.vimrc ]; then
    touch ~root/.vimrc
  fi

  value=$(grep -c "set tabstop=2" ~root/.vimrc)
  if [ $value -eq 0 ]; then
    echo 'set tabstop=2' >> ~root/.vimrc
	echo 'set number' >> ~root/.vimrc
	echo 'set hlsearch' >> ~vagrant/.vimrc
	echo 'set incsearch' >> ~vagrant/.vimrc
  fi

  # ===================================================================
  # Setting up annoying shell and vim configs for vagrant.
  # ===================================================================
  value=$(grep -c "set -o vi" ~vagrant/.bashrc)
  if [ $value -eq 0 ]; then
    echo 'set -o vi' >> ~vagrant/.bashrc
  fi

  if [ ! -f ~vagrant/.vimrc ]; then
    touch ~vagrant/.vimrc
    chown vagrant.vagrant ~vagrant/.vimrc
  fi

  value=$(grep -c "set tabstop=2" ~vagrant/.vimrc)
  if [ $value -eq 0 ]; then
    echo 'set tabstop=2' >> ~vagrant/.vimrc
	echo 'set number' >> ~vagrant/.vimrc
	echo 'set hlsearch' >> ~vagrant/.vimrc
	echo 'set incsearch' >> ~vagrant/.vimrc
  fi

}

installManPages;
installVim;
installGit;
configureShell;

# ===================================================================
# Install npm and vue related packages.
# ===================================================================
  printLog "Installing curl";
  apt-get --quiet -y install curl

  curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -

  apt-get install --quiet -y nodejs

  # Install Vue-CLI
  npm install -g @vue/cli

  # Install Vue-Router
  npm install vue-router

  # Install UUID
  npm install uuid

  # Install axios for http requests (fetchAPI is also a possibility)
  npm install axios

  # Cloning crash course repo
  git clone https://github.com/DailyMatters/VueCrashTodoList.git
# ===================================================================
# Update environment via apt.
# ===================================================================
if [ $UPDATE_SYSTEM -eq 1 ]; then
  printLog "Updating Environment\n";
  apt-get --quiet -y update
fi
