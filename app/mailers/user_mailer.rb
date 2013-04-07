class UserMailer < ActionMailer::Base
  default from: "info@tongtianshun.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm(usename)
    @usename = usename
    mail to: "cuiwei@tongtianshun.com"
  end

  def reserve(usename,tel,email,bname,trustee,btype,startvalue,investamount,returnrate,investperiod,sailsstart,collectperiod)
    @usename = usename
    @tel = tel
    @email = email
    @bname = bname
    @trustee = trustee
    @btype = btype
    @startvalue = startvalue
    @investamount = investamount
    @returnrate = returnrate
    @investperiod = investperiod
    @sailsstart = sailsstart
    @collectperiod = collectperiod
    mail to: "cuiwei@tongtianshun.com"
      end

  def comments(username,company,comment,accept,aid)
    @username = username
    @company = company
    @comment = comment
    @aid = aid
    mail(:to => accept)
  end

  def comments2(username,company,comment,accept,aid)
    @username = username
    @company = company
    @comment = comment
    @aid = aid
    mail(:to => accept)
  end

  def risktolerance(username,risktolerance,email,title)
    @username = username
    @risktolerance = risktolerance
    mail(:to => email,:subject => title)
  end
end
