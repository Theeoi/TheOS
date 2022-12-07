#!/usr/bin/env bash

git clone https://github.com/gnab/rtl8812au.git
cd rtl8812au
sudo ./install.sh

cd ..
rm -r rtl8812au
