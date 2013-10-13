#encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "info@tongtianshun.com"

  def confirm(usename,email,tel,title)
    @usename = usename
        @email = email
        @tel = tel
    mail(:to => "cuiwei@tongtianshun.com",:subject=>title)
  end

  def welcome(usename,email,title)
    @usename = usename
    mail(:to => email,:subject=>title)
  end

  def report(email,title)
    mail(:to => email,:subject=>title)
  end

  def sendimage(usename,email,title)
    @usename = usename
  #  attachments.inline['tongtianshun.png'] = File.read('/assets/tongtianshun.png')
    mail(:to => email,:subject=>title)
  end
end
