#encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "info@tongtianshun.com"

  def welcome(usename,email,title)
    @usename = usename
    mail(:to => email,:subject=>title)
  end

  def report(username,email,title)
    @username=username
    mail(:to => email,:subject=>title)
  end

  def sendimage(usename,email,title)
    @usename = usename
  #  attachments.inline['tongtianshun.png'] = File.read('/assets/tongtianshun.png')
    mail(:to => email,:subject=>title)
  end
end
