#!/bin/bash
#此脚本用来写入recovery
#制作者：陈云
#写于2013年8月于乐蛙总部
adb root
adb remount
until [[ "$cmd0" == "exit" ]]; do
	read -p "你需要烧写的机型：" phone
	case "$phone" in
		"x907" )
			until [ "$cmd1" == "exit" ]; do
				adb push ~/code/cm10.1/out/target/product/x907/recovery.img data/
				adb shell "dd if=/data/recovery.img of=dev/block/mmcblk0p18"
				adb shell "rm data/recovery.img"
				adb reboot recovery
				read -p "是否继续 ? 退出请输入exit:  " cmd1
			done
			;;
		"find5" )
		until [ "$cmd2" == "exit" ]; do
			adb push ~/code/cm10.1/out/target/product/find5/recovery.img data/
				adb shell "dd if=data/recovery.img of=/dev/block/mmcblk0p18"   
				adb reboot recovery
				read -p "是否继续 ? 退出请输入exit:  " cmd2
				adb reboot recovery
		done	
	esac
	read -p "是否继续 ? 退出请输入exit:  " cmd0
done