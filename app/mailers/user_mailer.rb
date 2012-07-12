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
end
