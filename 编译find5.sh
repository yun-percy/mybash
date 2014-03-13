#!/bin/bash
#此脚本用来编译CM相关机型的相关选项
#制作者：陈云
#写于2013年9

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd ~/code/cm10.1
source build/envsetup.sh
breakfast find5
croot
brunch find5