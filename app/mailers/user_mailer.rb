class UserMailer < ActionMailer::Base
  default from: "info@tongtianshun.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm(usename,email,title)
    @usename = usename
        @email = email
    mail(:to => "cuiwei@tongtianshun.com",:subject=>title)
  end

   def login(usename,asset_allocation,wbreedinfo,title)
     @usename = usename
     @risktolerance=asset_allocation.split('|')[3]
     @response=asset_allocation.split('|')[12]
     @portfolio=asset_allocation.split('|')[13]
     @concern=asset_allocation.split('|')[11]
     @options=asset_allocation.split('|')[9]
     @age=asset_allocation.split('|')[4]
     @lnw=asset_allocation.split('|')[5]
     @income=asset_allocation.split('|')[6]
     @wbreedinfo=wbreedinfo
     @trade=asset_allocation.split('|')[10]
     @goal=asset_allocation.split('|')[8]
     mail(:to => "cuiwei@tongtianshun.com",:subject=>title)
   end

  def applyuser(usename,tel,asset_allocation,wbreedinfo,title)
    @usename = usename
    @tel = tel
    @risktolerance=asset_allocation.split('|')[3]
    @response=asset_allocation.split('|')[12]
    @portfolio=asset_allocation.split('|')[13]
    @concern=asset_allocation.split('|')[11]
    @options=asset_allocation.split('|')[9]
    @age=asset_allocation.split('|')[4]
    @lnw=asset_allocation.split('|')[5]
    @income=asset_allocation.split('|')[6]
    @wbreedinfo=wbreedinfo
    @trade=asset_allocation.split('|')[10]
    @goal=asset_allocation.split('|')[8]
    if asset_allocation==nil
      @apply=1
    end
    mail(:to => "cuiwei@tongtianshun.com",:subject=>title)
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


  def capply(username,tel,email,title)
    @username = username
    @email = email
    @tel = tel
    @title = title
    mail(:to => "cuiwei@tongtianshun.com",:subject => title)
  end

  def application(username,email,title)
    @username = username
    mail(:to => email,:subject => title)
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

  def apply(username,risktolerance,email,title)
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
