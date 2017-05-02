#!/bin/sh

TEMP=`getopt cpueh: -- $*`
# TEMP=`/usr/bin/getopt cpuh: -- $*`

# if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
if [ $? != 0 ] ; then echo "Terminating..." exit 2 ; fi
eval set -- "$TEMP"

HELP="usage: $0 \t[-c <compile>] [-p <packageing method>] \n\t\t\t\t[-u <Whether or not up>]\n\n
Option example:\n\n
-c,\t\t compile model set,\t example: -c release , -c debug   \t* debug is default method\n
-p,\t\t packaging model set,\t example: -p appstore, -p ad-hoc \t* ad-hoc is default method\n
-u,\t\t Whether to upload set,\t example: -u y , -u n             \t\t\t* no is default method\n
-e,\t\t send email set,\t example: -e y , -e n              \t\t\t* no is default\n
-h,-help\t print help \n"
# echo $HELP
COMPILE=true
PACKAGE=true
UP=false
EMAIL=true

shift
for i
do
    case $i in
        -c|"'-c'"|-C|"'-C'")
                COMPILE=$2
                if [[ $2 =~ ^-[a-z] ]]; then
                    shift
                else
                    shift 2
                fi
            ;;
        -p|"'-p'"|-P|"-P")
                PACKAGE=$2
                if [[ $2 =~ ^-[a-z] ]]; then
                    shift
                else
                    shift 2
                fi
            ;;
        -h|"'-h'"|--h|"'--h'"|-H|"'-H'"|-help|"-help"|--help|"--help")
                echo $HELP
                exit
            ;;
        -u|"'-u'"|-U|"-U")
                UP=$2
                if [[ $2 =~ ^-[a-z] ]]; then
                    shift
                else
                    shift 2
                fi
            ;;
        -e|"'-e'"|-E|"-E")
                EMAIL=$2
                if [[ $2 =~ ^-[a-z] ]]; then
                    shift
                else
                    shift 2
                fi
            ;;
        -[a-zA-Z])
                echo "\nUnknown option: "$i"\n"
                echo $HELP
                exit
            ;;
    esac
done

#To deal with arg

case $COMPILE in
    debug|"debug"|-*|''|true)
            COMPILE=true
        ;;
    release|"release"|false)
          COMPILE=false
        ;;
    *)
        echo $HELP
        exit
    ;;
esac

case $PACKAGE in
    ad-hoc|"ad-hoc"|-*|true)
        PACKAGE=true
        ;;
    appstore|"appstore"|false)
        PACKAGE=false
        ;;
    *)
        echo $HELP
        exit
    ;;
esac

case $UP in
    n|"n"|-*|''|false)
        UP=false
        ;;
    y|"y"|true)
        UP=true
        ;;
    *)
        echo $HELP
        exit
    ;;
esac

case $EMAIL in
    n|"n"|-*|''|false)
        EMAIL=false
        ;;
    y|"y"|true)
        EMAIL=true
        ;;
    *)
        echo $HELP
        exit
    ;;
esac



echo "COMPILE : "$COMPILE
echo "PACKAGE : "$PACKAGE
echo "PU \t: "$UP
echo "EMAIL \t"$EMAIL

exit


echo "~~~~~~~~~~~~~~~~~~~~ 开始执行打包脚本 ~~~~~~~~~~~~~~~~~~~~"

########################## 工程基本信息配置 ###########################

#工程名称
PROJECT_NAME="Demo"
#需要编译的 targetname 如有多个 需要指定一个
TARGET_NAME="Demo"

#ADHOC 测试版本配置
#证书名称 (这两个选项可以通过 查看xcodeproj获得 通过subline打开,并搜索CODE_SIGN即可获取,配置文件同上)
ADHOC_CODE_SIGN_IDENTITY="iPhone Developer"
ADHOC_PROVISIONING_PROFILE_NAME=""

#AppStore 版本配置
APPSTORE_CODE_SIGN_IDENTITY=""
APPSTORE_PROVISIONING_PROFILE_NAME=""

#项目是否使用了Cocopods(默认为true)
IS_COCOPODS=true

######################### 基本信息完成 #####################

#证书名
CODE_SIGN_IDETITY=${ADHOC_CODE_SIGN_IDENTITY}
#描述文件
PROVISIONING_PROFILE_NAME=${ADHOC_PROVISIONING_PROFILE_NAME}

#开始时间
BEGIIN_TIME=`date +%s`
DATE=`date '+%Y-%m-%d-%T'`

#编译模式 默认有Debug Release
CONFIGURATION_TARGET=Debug
#编译的路径
BUILD_PATH=~/Desktop/${TARGET_NAME}_${DATE}
#archive路径
ARCHIVE_PATH=${BUILD_PATH}/${TARGET_NAME}.xcarchive
#输出的ipa目录(默认在桌面)
IPA_PATH=${BUILD_PATH}

#导出ipa 所需要的plist文件(这里提供了两个,注意是在项目的根目录下)
ADHOC_EXPORT_OPTIONS_PLIST=./ADHOCExportOptionsPlist.plist #测试的plist文件
APPSTORE_EXPORT_OPTIONS_PLIST=./AppStoreExportOptionsPlist.plist #AppStore的plist文件

#默认为测试模式
EXPORT_OPTIONS_PLIST=${ADHOC_EXPORT_OPTIONS_PLIST}

#是否上传蒲公英
UPLOAD_PGYER=false

#是否发送邮件
SEND_EMAIL=true

echo "~~~~~~~~~~~~~~~~~~~~~~~ 选择编译模式 ~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "             1 Debug (测试模式)"
echo "             2 Release"

#获取用户输入的模式类型 并存入变量里
read -p "请选择编译类型:" pattern
sleep 0.5
user_pattern="$pattern"

#对用户的输入进行判断

#判断是否是数字
if [ -n $user_pattern ]
    then
         if [ $user_pattern -eq 1 ]
            then
                CONFIGURATION_TARGET=Debug
        elif [ $user_pattern -eq 2 ]
            then
                CONFIGURATION_TARGET=Release
        else
                echo "请按提示正确输入......"
                exit 1
        fi
else
    echo "输入错误! 请按提示正确输入......"
    exit 1
fi

echo "~~~~~~~~~~~~~~~~~~~~ 选择打包方式 ~~~~~~~~~~~~~~~~~~~~~~"
echo "             1 ad-hoc(默认) "
echo "             2 AppStore "

#获取用户输入的模式类型 并存入变量
read  -p "请选择打包方式:" parameter
sleep 0.5
method="$parameter"

#进行判断
if [ -n "$method" ]
    then
        #设置相关配置变量
        if [ "$method" -eq "1" ]
            then
                CODE_SIGN_IDETITY=${ADHOC_CODE_SIGN_IDENTITY}
                PROVISIONING_PROFILE_NAME=${ADHOC_PROVISIONING_PROFILE_NAME}
                EXPORT_OPTIONS_PLIST=${ADHOC_EXPORT_OPTIONS_PLIST}
        elif [ "$method" -eq "2" ]
            then
                CODE_SIGN_IDETITY=${APPSTORE_CODE_SIGN_IDENTITY}
                PROVISIONING_PROFILE_NAME=${APPSTORE_PROVISIONING_PROFILE_NAME}
                EXPORT_OPTIONS_PLIST=${APPSTORE_EXPORT_OPTIONS_PLIST}
        else
            echo "请按照提示正确输入......"
            exit 1
        fi
else
    EXPORT_OPTIONS_PLIST=${ADHOC_EXPORT_OPTIONS_PLIST}
fi

echo "~~~~~~~~~~~~~~~~~~ 是否上传测试平台(这里是蒲公英) ~~~~~~~~~~~~~~~~~~~~~~~~"
echo "            1 不上传(默认)"
echo "            2 上传 "

#获取用户的输入
read -p "请选择是否上传:" param
sleep 0.5

if [ -n "$param" ]
    then
        if [ "$param" -eq "1" ]
            then
                UPLOAD_PGYER=false
        elif [ "$param" -eq "2" ]
            then
                UPLOAD_PGYER=true
        else
            echo "请按照提示正确输入......"
            exit 1
        fi
else
    UPLOAD_PGYER=false
fi

echo "~~~~~~~~~~~~~~~~~ 是否发送邮件 ~~~~~~~~~~~~~~~~~~~~~~"
echo "            1 是(默认)"
echo "            2 否 "

read -p "发送邮件时:请确认邮件是否以配置完成!!!  请输入:" sendEmail
sleep 0.5

if [ -n $sendEmail ]
    then
        if [ $sendEmail -eq 1 ]
            then
                SEND_EMAIL=true
        elif [ $sendEmail -eq 2 ]
            then
                SEND_EMAIL=flase
        else
            echo "请按照提示正确输入!"
            exit 1
        fi
else
    echo "请按照提示正确输入"
    exit 1
fi

#~~~~~~~~~~~~~~~~~~~~~~~ 现在开始编译 ~~~~~~~~~~~~~~~~~~~
echo "~~~~~~~~~~~~~~~~~~ 是否使用了Cocopods ~~~~~~~~~~~~~~~~~~~~~~~~"
echo "            1 是(默认)"
echo "            2 否 "

read -p "是否使用了Cocopods版本管理工具:" use
sleep 0.5

if [ -n "$use" ]
    then
        if [ $use -eq 1 ]
            then
                IS_COCOPODS=true
        elif [ $use -eq 2 ]
            then
                IS_COCOPODS=false
        else
                echo "请按照提示正确输入......"
                exit 1
        fi
else
    IS_COCOPODS=false
fi


#使用了Cocopods 则需要编译 xcworkspace
if [ $IS_COCOPODS = true ]
    then
        echo "~~~~~~~~ 编译 Cocopods 版本 ~~~~~~~"
        #首先进行清理clean,以免出现奇怪的错误
        xcodebuild clean -workspace ${PROJECT_NAME}.xcworkspace \
        -configuration \
        ${CONFIGURATION} -alltargets

        #清理完成后开始构建版本使用 xcodebuild archive
        xcodebuild archive -workspace ${PROJECT_NAME}.xcworkspace \
        -scheme ${TARGET_NAME} \
        -archivePath ${ARCHIVE_PATH} \
        -configuration ${CONFIGURATION_TARGET} \
        CODE_SIGN_IDENTITY="${CODE_SIGN_IDETITY}" \
        PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME}"
else
    #未使用Cocopods 则需要编译 xcodeproj
    #都需要进行清理
    echo "~~~~~~~~ 编译 正常版本 ~~~~~~~"
    xcodebuild clean -project ${PROJECT_NAME}.xcodeproj \
    -configuration \
    ${CONFIGURATION} - alltargets

    #开始构建版本
    xcodebuild archive -project ${PROJECT_NAME}.xcodeproj \
    -scheme ${TARGET_NAME} \
    -archivePath ${ARCHIVE_PATH} \
    -configuration ${CONFIGURATION_TARGET} \
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDETITY}" \
    PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME}"
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~ 查看是否版本构建成功 ~~~~~~~~~~~~~~~~~~~~~~~~"
#xcrachive 是一个文件夹不是个文件 所以使用 -d 来判断

echo "~~~~~~~~~~ $ARCHIVE_PATH"
if [ -d $ARCHIVE_PATH ]
    then
        echo "版本构建成功!"
else
    echo "版本构建失败......"
    rm -rf $BUILD_PATH #删除错误文件
    exit 1
fi

END_TIME=`date +%s`
ARCHIVE_TIME="构建版本所耗时间$[ END_TIME - BEGIIN_TIME]秒"


echo "~~~~~~~~~~~~~~~~~~~ 开始导出ipa包 ~~~~~~~~~~~~~~~~~~~~"

BEGIIN_TIME=`date +%s`

xcodebuild -exportArchive \
-archivePath ${ARCHIVE_PATH} \
-exportOptionsPlist ${EXPORT_OPTIONS_PLIST} \
-exportPath ${IPA_PATH}

echo "~~~~~~~~~~~~~~~~~~~~~~~~~ 检查ipa是否导出成功 ~~~~~~~~~~~~~~~~~~~~~~"

IPA_PATH=${IPA_PATH}/${TARGET_NAME}.ipa

#如果是文件则说明成功
if [ -f $IPA_PATH ]

    then
        echo "导出ipa成功!"
#open $BUILD_PATH
else

    echo "ipa导出失败......"
    #结束时间
    END_TIEM=`date +%s`
    echo "$ARCHIVE_TIME"
    echo "导出ipa 所耗时间$[ END_TIEM - BEGIIN_TIME]秒"
    exit 1
fi

END_TIEM=`date +%s`
EXPORT_TIME="导出ipa 所耗时间$[ END_TIEM - BEGIIN_TIME]秒"

#上传测试平台(这里是蒲公英)
INSTALL_TYPE=1
PASSWORD=1
if [ $UPLOAD_PGYER = true ]
    then
        #上传蒲公英的参数可通过查看蒲公英的API进行了解 http://www.pgyer.com/doc/api
        echo "~~~~~~~~~~~~~~~~~~~~~ 准备上传 ipa 到蒲公英 ~~~~~~~~~~~~~~"
        echo "~~~~~~~~~~~~选择应用安装方式~~~~~~~~~~~~~"
        echo "           1 公开安装(默认)"
        echo "           2 密码安装"
        echo "           3 邀请安装"

        #读取用户输入
        read -p "请选择安装方式:" install_type
        sleep 0.5
        type=$install_type

        if [ -n $type ]
            then
                case $type in
                1)
                    INSTALL_TYPE=1
                    ;;
                2)
                    INSTALL_TYPE=2
                        echo "~~~~~~~~~~~~~~ 请输入安装密码 ~~~~~~~~~~~~~~"
                        read -p "请输入密码:" password
                        sleep 0.5
                        PASSWORD=$password
                    ;;
                3)
                    INSTALL_TYPE=3
                    ;;
                *)
                    INSTALL_TYPE=1
                    exit 1
                esac

                #开始上传
                curl -F "file=@$IPA_PATH" \
                -F "uKey=ef9bbdd84dea6d9fa92bc99b9093de52" \
                -F "_api_key=a01f3e8713d04aa7d61a2dc403a0979c" \
                -F "password=$PASSWORD" \
                -F "installType=$INSTALL_TYPE" \
                https://www.pgyer.com/apiv1/app/upload --verbose

                #判断上次命令是否执行成功 成功返回0 失败返回非0
                if [ $? -eq 0 ]
                    then
                        echo "~~~~~~~~~~~~~~~~ 恭喜 ipa 上传成功 ~~~~~~~~~~~~~~~"

                    else
                        echo "~~~~~~~~~~~~~~~~~ NO ipa 上传失败 ~~~~~~~~~~~~~~~"
                fi
        fi
fi

#发送邮件
if [ $SEND_EMAIL = true ]
    then
        echo "~~~~~~~~~~ 发送邮件 ~~~~~~~~"
        php Email/SendEmail.php $TARGET_NAME
else
    echo "~~~~~~~~~~~~~~~~ 邮件发送失败 $sendEmail~~~~~~~~~~~~~"
fi


echo "~~~~~~~~~~~~~~~~~~~~~~~~ 打印配置信息 ~~~~~~~~~~~~~~~~~~~~~~~~"
echo "开始执行脚本的时间: ${DATE}"
echo "编译版本的模式: ${CONFIGURATION_TARGET}"
echo "导出ipa文件的配置信息: ${EXPORT_OPTIONS_PLIST}"
echo "打包文件路径: ${ARCHIVE_PATH}"
echo "导出ipa 包路径: ${IPA_PATH}"

echo "$ARCHIVE_TIME"
echo "$EXPORT_TIME"

exit 0