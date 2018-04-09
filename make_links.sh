#!/bin/bash


echo "making the necesary symlinks"

echo
echo "making .vim symlink"
if [ -d $HOME/.vim ] || [ -L $HOME/.vim ]; then
	rm -rf $HOME/.vim
fi
ln -s $(pwd)/vim $HOME/.vim

echo
echo "making .vimrc symlink"
if [ -e $HOME/.vimrc ] || [ -L $HOME/.vimrc ]; then
	echo "removing existing .vimrc symlink"
	rm $HOME/.vimrc
fi
ln -s $(pwd)/vimrc $HOME/.vimrc

echo
echo "making .tmux.conf symlink"
if [ -e $HOME/.tmux.conf ] || [ -L $HOME/.tmux.conf ]; then
	echo "removing existing .tmux.conf symlink"
	rm $HOME/.tmux.conf
fi
ln -s $(pwd)/tmux.conf $HOME/.tmux.conf

echo 
echo "adding bashrc"
if [ -e $HOME/.bashrc ] || [ -L $HOME/.bashrc ]; then
	echo "removing existing .bashrc symlink"
	rm $HOME/.bashrc
fi
ln -s $(pwd)/bashrc $HOME/.bashrc

echo 
echo "making .gitconfig symlink"
if [ -e $HOME/.gitconfig ] || [ -L $HOME/.gitconfig ]; then
	echo "removing existing .gitconfig symlink"
	rm $HOME/.gitconfig
fi
ln -s $(pwd)/gitconfig $HOME/.gitconfig

echo 
echo "adding bash functions and aliases"
if [ -e $HOME/.bash_aliases ] || [ -L $HOME/.bash_aliases ]; then
	echo "removing existing .bash_aliases symlink"
	rm $HOME/.bash_aliases
fi
ln -s $(pwd)/bash_aliases $HOME/.bash_aliases

