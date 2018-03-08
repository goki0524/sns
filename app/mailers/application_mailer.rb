class ApplicationMailer < ActionMailer::Base
  
  #default from: "noreply@example.com"
  default from: '"サンプルアプリ" <noreply@example.com>'
  layout 'mailer'
end
