#!/bin/bash

user_path="/home/docker"
tmp_dir="${user_path}/__tmp__"
mkdir "${tmp_dir}"
cd "${tmp_dir}"

echo "Setting the locales and tzdata for date and location." && \
sudo dpkg-reconfigure locales && \
sudo dpkg-reconfigure tzdata

echo "Installing FZF..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
echo "...done"

echo "Installing vim, tmux and git resources..."
git clone https://github.com/huexotzinca/dotfiles && \
echo "---- creating .vim and .vimrc ----" && \
cp -r dotfiles/vim "${user_path}/.vim" && \
cp dotfiles/vimrc "${user_path}/.vimrc" && \
cp dotfiles/gitconfig "${user_path}/.gitconfig" && \
cp dotfiles/gitignore "${user_path}/.gitignore" && \
git config --global --unset user.name && \
git config --global --unset user.email && \
echo "---- configuring tmux... ----" && \
mkdir -p ~/.tmux/plugins && \
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
cp dotfiles/tmux.conf "${user_path}/.tmux.conf" && \
tmux source "${user_path}/.tmux.conf" && \
echo "---- updating vim plug and installing plugins... ----" && \
vim +PlugUpgrade +qa && vim +PlugInstall +qa &&
echo "...done"

rm -rf "${tmp_dir}"

# TODO: Fix npm upgrade dependencies.
# gem update && npm i -g npm && npm -g update
