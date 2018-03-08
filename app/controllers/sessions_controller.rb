class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    #ログインフォームからpostで送られた情報をparamsで受け取る
    @user = User.find_by(email: params[:session][:email].downcase)
    #ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
     #has_secure_passwordメソッドにより、authenticateが使える
    if @user && @user.authenticate(params[:session][:password])
      #有効なユーザーのみログインさせる
      if @user.activated?
        log_in(@user)
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        redirect_back_or(root_url)
      else
        message  = "アカウントが有効ではありません。 "
        message += "メールを確認しアカウントを有効にしてください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Eメールアドレス、またはパスワードが間違えています。'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
