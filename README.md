# xcodebuild
使用脚本自动打包上传</br>
通过根据自己的项目进行配置 即可使用</br>
</br>
########################## 工程基本信息配置 ###########################</br>
</br>
#工程名称</br>
PROJECT_NAME="项目名称"</br>
#需要编译的 targetname 如有多个 需要指定一个</br>
TARGET_NAME="target,名称"</br>
</br>
#ADHOC 测试版本配置</br>
#证书名称 (这两个选项可以通过 查看xcodeproj获得 通过subline打开,并搜索CODE_SIGN即可获取,配置文件同上)</br>
ADHOC_CODE_SIGN_IDENTITY=""</br>
ADHOC_PROVISIONING_PROFILE_NAME=""</br>
</br>
#AppStore 版本配置</br>
APPSTORE_CODE_SIGN_IDENTITY=""</br>
APPSTORE_PROVISIONING_PROFILE_NAME=""</br>
#################### 发送邮件配置 ##################</br>
    /********* 邮件的基本配置 ********/</br>
      $sendAddress  = @"771145867@qq.com";//收件人地址</br>
      $fromAddress  = @"771145867@qq.com";//发送人地址</br>
      $SMTPPassword = @"***************";//SMTP 秘钥</br>
      $fromName     = @"发信人名称";</br>
      $sendName     = @"收信人名称";</br>
      $message = @"亲,测试版本已经发送成功,请注意接收";//邮件标题</br>
      $body    = @"测试包版本发送成功!";//邮件内容，上面设置HTML，则可以是HTML</br>
    /********** END *********/
