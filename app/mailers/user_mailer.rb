#encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "info@tongtianshun.com"

  def welcome(usename,email,title)
    @usename = usename
    mail(:to => email,:subject=>title)
  end

  def forgetpassword(email,title)
    mail(:to => email,:subject=>title)
  end

  def report(username,email,title)
    @username=username
    mail(:to => email,:subject=>title)
  end

  def targetreport(username,email,title)
    @username=username
    mail(:to => email,:subject=>title)
  end

  def sendimage(usename,email,title)
    @usename = usename
  #  attachments.inline['tongtianshun.png'] = File.read('/assets/tongtianshun.png')
    mail(:to => email,:subject=>title)
  end
  def sendimageproduct(usename,email,title,array,type)
    @usename = usename
    @array = array
    @type = type
    mail(:to => email,:subject=>title)
  end
  def sendimageproduct_bank(usename,email,title,array)
    @usename = usename
    @array = array
    mail(:to => email,:subject=>title)
  end
end
