#!/bin/bash

cdir=$(pwd)

echo $cdir

echo "setting symlinks..."
$cdir/make_links.sh
echo "finished setting symlinks"
echo


echo "configuring fonts..."
$cdir/fonts/install.sh
echo "finished configuring fonts"
echo
