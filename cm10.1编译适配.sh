#!/bin/bash
#此脚本用来编译CM相关机型的相关选项
#制作者：陈云
#写于2013年9

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo 欢迎使用8X25编译指令集
echo
echo
cd ~/code/cm10.1/
echo                 ------------支持的机型如下：--------
echo                   find5 x907 t930
echo
echo
read -p "请输入需要编译的机型：    " phone
echo
. build/envsetup.sh && lunch cm_${phone}-eng
echo
echo
for (( i = 0; i < 100; i++ ))
do
echo =======================================================
echo 				你要编译的机型是：  $phone
echo
echo 				输入 1   编译boot.img
echo 				输入 2   编译recovery.img
echo 				输入 3   编译刷机包
echo  				输入 4   编译framework-res.apk
echo				输入 5   编译android.policy.jar
echo				输入 6   编译lewa-framwork.jar/framework.jar/framework_ext.jar
echo				输入 7   编译 services.jar
echo				输入 8   编译SystemUI.apk
echo
echo				输入 0   重启
echo 				输入 00  进入Recovery
echo
echo
read -p "请输入你要编译$phone的什么东西:  " mode
case $mode in
	"1" )
		make bootimage -j8
		echo
		echo 正在重启烧录boot.img到手机，请等待......
		echo
		adb reboot bootloader
		echo
		fastboot flash boot ./out/target/product/${phone}/boot.img
		echo
		fastboot reboot
		;;
	"2" )
		make recoveryimage -j8
		echo
		echo
		echo 正在重启烧录recovery.img到手机，请等待......
		echo
		echo
#			adb root
#			adb remount
#			adb reboot bootloader
#			fastboot flash recovery ./out/target/product/${phone}/recovery.img
#			fastboot reboot
		echo
		echo
		;;
	"3" )
		breakfast find5
		brunch ${phone}-eng -j8
		echo
		echo
		echo 正在push到 sdcard……请稍等
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/${phone}-ota-eng.yunchen.zip /sdcard
		;;
	"4" )
		mmm frameworks/base/core/res
		echo
		echo
		echo 自动push到手机中……请稍后……
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/system/framework/framework-res.apk system/framework
		adb reboot
		;;
	"5" )
		mmm frameworks/base/policy
		echo
		echo
		echo
		echo 自动push到手机中……请稍后……
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/system/framework/android.policy.jar system/framework
		echo
		echo
		adb reboot
		;;
	"6" )
		mmm frameworks/base
		echo
		echo
		echo
		echo 自动push到手机中……请稍后……
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/system/framework system/framework
		echo
		echo
		adb reboot
		;;
	"7" )
		mmm frameworks/base/services/java
		echo
		echo
		echo
		echo 自动push到手机中……请稍后……
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/system/framework/services.jar system/framework
		echo
		echo
		adb reboot
		;;
		"7" )
		mmm frameworks/base/packages/SystemUI
		echo
		echo
		echo
		echo 自动push到手机中……请稍后……
		echo
		echo
		adb root
		adb remount
		echo
		echo
		adb push ./out/target/product/${phone}/system/app/SystemUI.apk system/app
		echo
		echo
		adb reboot
		;;
	"0" )
		echo 正在重启......
		adb root
		adb remount
		adb reboot
		echo
		echo
		;;
	"00" )
		echo 正在进入recovery......
		adb root
		adb remount
		adb reboot recovery
		echo
		echo
		;;

esac
read -p "是否需要打开输出文件夹？ 默认不打开（y／n）："  choice
case $choice in
	"y" )
		nautilus ./out/target/product/${phone}
		;;
	"n" )
		;;	
esac
done

read -p "欢迎下次继续使用，小菜鸟" exit