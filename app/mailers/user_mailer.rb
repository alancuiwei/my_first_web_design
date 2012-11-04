#encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "my@email.here"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgetpassword.subject
  #
  def forgetpassword(myemail,reseturl,username,id)
    @username=username
    @reseturl=reseturl

    mail(:to => myemail,:subject=>"通天顺用户："+username+"的密码重置邮件("+id+")")
  end

  def regeditconfirm(myemail,username,reseturl)
    @username=username
    @reseturl=reseturl

    mail(:to => myemail,:subject=>"通天顺用户："+username+"的注册确认邮件")
  end

  def tryapply(myemail,reseturl,username)
    @username=username
    @reseturl=reseturl

    mail(:to => myemail,:subject=>"通天顺用户："+username+"的试用申请确认邮件")
  end
end
