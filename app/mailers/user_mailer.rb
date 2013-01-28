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
end
