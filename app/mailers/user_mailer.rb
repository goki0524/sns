class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウントを有効化にしてください"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワード再設定の通知"
  end
  
  def notice_message(target_user, user)
    @target_user = target_user
    @user = user
    mail to: target_user.email, subject: "#{@user.name}よりメッセージの通知があります"
  end
  
  def notice_follow(target_user, user)
    @target_user = target_user
    @user = user
    mail to: target_user.email, subject: "#{@user.name}にフォローされました"
  end
  
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
end
