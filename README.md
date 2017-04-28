# xcodebuild
使用脚本自动打包上传
通过根据自己的项目进行配置 即可使用
########################## 工程基本信息配置 ###########################

#工程名称
PROJECT_NAME="项目名称"
#需要编译的 targetname 如有多个 需要指定一个
TARGET_NAME="target,名称"

#ADHOC 测试版本配置
#证书名称 (这两个选项可以通过 查看xcodeproj获得 通过subline打开,并搜索CODE_SIGN即可获取,配置文件同上)
ADHOC_CODE_SIGN_IDENTITY=""
ADHOC_PROVISIONING_PROFILE_NAME=""

#AppStore 版本配置
APPSTORE_CODE_SIGN_IDENTITY=""
APPSTORE_PROVISIONING_PROFILE_NAME=""
