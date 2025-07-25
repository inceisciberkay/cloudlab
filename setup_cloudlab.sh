#!/bin/bash

# ==> Packages

sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    build-essential \
    vim \
    htop \
    jq \
    numactl libnuma-dev \
    hwloc \
    msr-tools \
    cpufrequtils \
    tree \
    stow \
    gnuplot \
    clangd \
    python3-venv \
    libevent-dev ncurses-dev \
    libelf-dev libdw-dev libbfd-dev \
    bison \
    pkg-config \
    sysstat \
    i7z \
    cmake libncurses5-dev ninja-build meson \
    linux-tools-common linux-tools-generic linux-tools-$(uname -r)

sudo apt install --reinstall linux-firmware

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
. "$HOME/.nvm/nvm.sh"
nvm install 22

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
echo '. "$HOME/.cargo/env"' >~/.zshenv
cargo install ripgrep eza zoxide bat fd-find just du-dust starship git-delta
cargo install --locked tlrc

wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.zshenv

export PATH=$PATH:~/go/bin
echo 'export PATH=$PATH:~/go/bin' >>~/.zshenv
go install github.com/junegunn/fzf@latest
go install github.com/jesseduffield/lazygit@latest

git clone https://github.com/tmux/tmux.git
cd tmux
git checkout 3.5a
sh autogen.sh
./configure
make && sudo make install
cd -
rm -rf tmux

git clone https://github.com/neovim/neovim.git
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd -
rm -rf neovim

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~
mkdir repos && cd repos
git clone git@github.com:inceisciberkay/dotfiles.git
cd dotfiles
stow *
cd ~/cloudlab

rm *.tar.gz

echo "Packages are installed"

# ==> Benchmarks

sudo chown -R $USER /tdata

cd ~/repos
git clone https://github.com/sbeamer/gapbs.git
cd gapbs
make bench-graphs GRAPH_DIR=/tdata/graphs RAW_GRAPH_DIR=/tdata/graphs/raw
cd ~/cloudlab

echo "Benchmarks are installed"

# ==> Settings

sudo mkdir /dev/hugepages1G
sudo mount -t hugetlbfs -o pagesize=1G none /dev/hugepages1G

. "./config.sh" || exit
check_conf

echo "Settings are applied"
