<?php
/**
 * Created by PhpStorm.
 * User: a123456
 * Date: 2017/4/28
 * Time: 12:51
 */

require_once('./vendor/phpmailer/phpmailer/PHPMailerAutoload.php');

class Email {

    public static function send() {

        /********* 邮件的基本配置 ********/

        $sendAddress  = @"771145867@qq.com";//收件人地址
        $fromAddress  = @"771145867@qq.com";//发送人地址
        $SMTPPassword = @"hoehzlglbpbkbbbh";//SMTP 秘钥

        $fromName     = @"发信人名称";
        $sendName     = @"收信人名称";

        $message = @"亲,测试版本已经发送成功,请注意接收";//邮件标题
        $body    = @"测试包版本发送成功!";//邮件内容，上面设置HTML，则可以是HTML

        /********** END *********/

        $mail          = new PHPMailer(); //建立邮件发送类
        $mail->CharSet = "UTF-8";//设置信息的编码类型

        $mail->IsSMTP(); // 使用SMTP方式发送

        $mail->SMTPDebug  = 1;
        $mail->Host       = "smtp.qq.com"; //使用163邮箱服务器
        $mail->SMTPAuth   = true; // 启用SMTP验证功能
        $mail->SMTPSecure = 'ssl';
        $mail->Username   = $fromAddress;
        $mail->Password   = $SMTPPassword;
        $mail->Port       = 465;//邮箱服务器端口号
        $mail->From       = $fromAddress;
        $mail->FromName   = $fromName;

        $mail->AddAddress($sendAddress, $sendName);
        $mail->IsHTML(true);

        $mail->Subject = $message;
        $mail->Body    = $body;

        if (!$mail->Send()) {
            echo "邮件发送失败. <p>";
            echo "错误原因: " . $mail->ErrorInfo;
            exit;
        } else {
            echo "邮件发送成功!";
        }
    }
}


