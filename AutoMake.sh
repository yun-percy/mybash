#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#写于2014年3月 窝窝

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
reset
echo
echo
echo
echo ===========================欢迎使用Linux下一键编译工具======================
echo
echo 请确保在 /home/***/下有 Workspace文件夹，并且源码目录为/home/***/code/cm10.1/
echo 如果不是，可自行修改本执行语句的路径
echo
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo 
echo                         大爷，准备现在开始工作？
echo 
echo 
echo                          任意键开始工作
read -p " " welcome
reset 
for (( i = 0; i < 10; i++ )); do
	#statements

echo
echo ===========================欢迎使用Linux下一键编译工具======================
echo
echo 请选择今天的工作内容：
echo
echo 1: framework-res
echo 2: Contacts
echo 3: Phone                               
echo 4: Mms
echo 00:源码	
echo
echo =========================================================================
echo
echo
read -p "请输入相关序号" number
echo
case $number in
	"1" )
		project=framework-res
		location=system/framework
		Resources_location=frameworks/base/core/res
		;;
	"2" )
		project=Contacts
		location=system/app
		Resources_location=packages/apps/$project	
		;;
	"3" )
		project=Phone
		location=system/app
		Resources_location=packages/apps/$project	
		;;
	"4" )
		project=Mms
		location=system/app
		Resources_location=packages/apps/$project	
		;;
	"5" )
		project=23
		location = system/app
		Resources_location=packages/apps/$project	
		;;
	"00" )
		project=Resources
		break
		;;
esac
echo
echo 正在跳转至$project 工程页面......
echo
cd ./../
mkdir Workspace
cd Workspace
mkdir out
mkdir CM_res
mkdir Sign
echo
echo  
clear
for (( i = 0; i < 100; i++ )); do
	echo 
	echo ============================您现在位于$project处理界面=====================
	echo
	echo 1:反编译
	echo 2:回编译      
	echo 3:推送到手机
	echo 4:搭建框架  
	echo 5:重启手机
	echo 6:编译源码的$project+签名+推送
	echo 7:签名 apk
	echo
	echo
	echo =========================================================================
	echo
	read -p "      请根据功能输入序号   " fuction
	case $fuction in
	"1" )
		rm -rf $project
		./apktool d ${project}.apk $project
		;;
	"2" )
		for (( i = 0; i < 100; i++ )); do
			rm ./out/${project}.apk
			rm ./out/$project_de.apk
			./apktool b $project ./output/$project_de.apk
			java -jar signapk.jar testkey.x509.pem testkey.pk8 ./output/$project_de.apk ./output/${project}.apk
			adb root
			while [ $? = 1 ]; do  
				echo "======root failed, re-root again======"  
				sleep 3
				adb root
				done
			adb remount
			while [ $? = 1 ]; do  
				echo "======remount failed, re-remount again======"  
				sleep 3
				adb remount  
				done
			adb push ./out/${project}.apk $location
			read -p "返回上一级请输入：e:    " ex
			if [[ "$ex" == "e" ]]; then
				break
				fi
			done
		
		;;
	"3" )
		adb root
		adb remount
		adb push ./output/${project}.apk $location

		;;
	"4" )
		./apktool if framework-res.apk
		;;
	"5" )
		adb reboot
		;;
	"6")
		echo 正在进入源码目录，请稍候......
		echo 
		cd ../code/cm10.1
		echo 开始初始化编译环境......
		echo
		. build/envsetup.sh
		echo 初始化 find5的编译环境.....
		echo
		breakfast find5
		echo
		echo 初始化成功，即将开启编译模式
		echo
		echo
		echo
				for (( i = 0; i < 100; i++ )); do					
					echo
					echo 正在编译源码$project.apk 请稍候......
					echo
					echo
					mmm $Resources_location
					echo
					echo
					echo 返回 推送目录……
					echo
					cd ../../Workspace
					rm ./CM_res/*.apk
					echo Copying.....
					cp ../code/cm10.1/out/target/product/find5/$location/${project}.apk ./CM_res/${project}2.apk
					echo
					echo
					echo Signing.....
					java -jar signapk.jar testkey.x509.pem testkey.pk8 ./CM_res/${project}2.apk ./CM_res/${project}.apk
					echo
					echo
					echo pushing.....
					adb root
					while [ $? = 1 ]; do  
						echo "======root failed, re-root again======"  
						sleep 3
						adb root
					done
					adb remount
					while [ $? = 1 ]; do  
						echo "======remount failed, re-remount again======"  
						sleep 3
						adb remount  
					done
					adb push ./CM_res/${project}.apk $location
					echo 完成!
					echo
					echo 任意键开始下一轮编译
					echo
					read -p "返回上一级请输入：e:    " ex
					if [[ "$ex" == "e" ]]; then
						break
					fi
					cd ../code/cm10.1
				done
		
		;;
	"7" )
		echo Signing.....
		java -jar signapk.jar testkey.x509.pem testkey.pk8 ./Sign/$project.apk ./Sign/${project}2.apk
		rm ./Sign/$project.apk
		mv ./Sign/${project}2.apk ./Sign/${project}.apk
		adb root
					while [ $? = 1 ]; do  
						echo "======root failed, re-root again======"  
						sleep 3
						adb root
					done
					adb remount
					while [ $? = 1 ]; do  
						echo "======remount failed, re-remount again======"  
						sleep 3
						adb remount  
					done
					adb push ./Sign/${project}.apk $location
					echo "正在重启手机"
					
		;;
		"e" )
		break
		;;
	esac

done
done