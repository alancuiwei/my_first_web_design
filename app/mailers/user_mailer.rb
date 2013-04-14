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
    if risktolerance.to_f>=0 && risktolerance.to_f<=2
      @level=1
    elsif risktolerance.to_f>2 && risktolerance.to_f<=4
      @level=2
    elsif risktolerance.to_f>4 && risktolerance.to_f<=6
      @level=3
    elsif risktolerance.to_f>6 && risktolerance.to_f<=8
      @level=4
    elsif risktolerance.to_f>8 && risktolerance.to_f<=10
      @level=5
    end
    @username = username
    @risktolerance = risktolerance
    mail(:to => email,:subject => title)
  end
end
