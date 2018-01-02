#!/bin/sh

export LC_ALL=zh_CN.GB2312;export LANG=zh_CN.GB2312
cd ..
base_path="`dirname $0`"
base_path="`(cd \"$base_path\"; pwd)`"
echo "路径$base_path"

path_arr=$(echo $base_path|tr "/" "\n")

echo "分割路径 $path_arr"

for s in ${path_arr[@]}
do
if [ "${s}"x = "iOS-JLH"x ]; then
app_path=`printf "$app_path/%s" $s`
break
else
app_path=`printf "$app_path/%s" $s`
fi

done
echo "app基本路径＝$app_path"

###############进入项目目录
projectName="JieLeHua" #项目所在目录的名称
isWorkSpace="$2"  #判断是用的workspace还是直接project，workspace设置为true，否则设置为false
projectDir="${app_path}/" #项目所在目录的绝对路径

###############配置下载的文件名称和路径等相关参数


##########################################################################################
##############################以下部分为自动生产部分，不需要手动修改############################
##########################################################################################

####################### FUCTION  START #######################
replaceString(){
local inputString="$1"
result="${inputString//(/}"
result="${result//)/}"
echo "$result"
}

rm -rf ./build
###############获取版本号,bundleID
infoPlist="${projectDir}${projectName}/Info.plist"
bundleDisplayName=`/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" $infoPlist`
bundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $infoPlist`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $infoPlist`
bundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $infoPlist`
###############在网页上显示的名字和bundleDisplayName一致

#修改编译环境

######
PREPROCESSOR_DEFINITIONS="DEBUG"
#####


if [ "${PREPROCESSOR_DEFINITIONS}"x = "DEBUG"x ]; then

buildConfig="Debug"
bundleDisplayName="测试"
CODE_SIGN="iPhone Developer: 艳东 平 (MP3JD5ZTK9)"
ProvisioningProfile="Jielehua33"

else
# 发布appstore用＊＊＊＊＊＊＊＊
#buildConfig="Release"
#bundleDisplayName="AppStore"
#CODE_SIGN="iPhone Distribution: Vision Credit  Financial Technology Company Limited (YWEH5GVC2C)"
#ProvisioningProfile="借乐花Dis11"
#测试线上环境
buildConfig="Debug"
bundleDisplayName="Release"
CODE_SIGN="iPhone Developer: 艳东 平 (MP3JD5ZTK9)"
ProvisioningProfile="Jielehua33"

fi

appName=$bundleDisplayName
echo "$bundleDisplayName"
echo "v_$bundleVersion  b_$bundleBuildVersion"

##############开始编译app
if $isWorkSpace ; then  #判断编译方式
echo  "开始编译workspace111...."
echo "$projectDir$projectName.xcworkspace"

xcodebuild -workspace ${projectDir}$projectName.xcworkspace -scheme $projectName GCC_PREPROCESSOR_DEFINITIONS="${PREPROCESSOR_DEFINITIONS}" -configuration $buildConfig CODE_SIGN_IDENTITY="${CODE_SIGN}"  clean build SYMROOT=$app_path
else
echo  "开始编译target12222...."
cd ${projectDir}
xcodebuild -target $projectName -configuration $buildConfig clean build SYMROOT=$app_path
fi
#判断编译结果
if test $? -eq 0
then
echo "编译成功"
else
echo "编译失败"
echo "\n"
exit 1
fi

###############开始打包成.ipa
appDir="${app_path}/$buildConfig-iphoneos"  #app所在路径
ipaDir="${app_path}"  #ipa所在路径

time=`date +%Y%m%d%H%M`
echo $time
echo "------$appDir"
echo "开始打包$projectName.xcarchive成$projectName.ipa....."

ipaPath="$ipaDir/ZZPackIpa/${time}_${bundleDisplayName}"
if [ ! -d $ipaDir/ZZPackIpa/${time}_${bundleDisplayName} ];then
mkdir -p $ipaDir/ZZPackIpa/${time}_${bundleDisplayName}
cd $ipaDir/ZZPackIpa/${time}_${bundleDisplayName}
fi

xcrun -sdk iphoneos PackageApplication -v "$appDir/$projectName.app" -o "$ipaPath/${projectName}_${bundleDisplayName}_V${bundleVersion}(${bundleBuildVersion})_${time}.ipa" --embed "$ProvisioningProfile"
#将app打包成ipa

cp -rp "$appDir/$projectName.app.dSYM" "$directory"
echo "ipa 路径＝$ipaPath"

rm -rf $appDir
