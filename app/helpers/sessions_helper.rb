module SessionsHelper
  
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのセッションを永続的にする 永続cookiesの場合はidとtokenを保存する
  def remember(user)
    user.remember #user.rbのrememberメソッド
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  #現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # 記憶トークンcookiesに対応するユーザーを返す
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end
  
    # 1,2,3 は同じ式
    # --- 1 ---　@current_userがnilならば代入する
    #@current_user ||= User.find_by(id: session[:user_id])

    # --- 2 ---  左項から評価しtrueならば処理を終了.変数に値があれば終了
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    
    # --- 3 ---
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    
    # 変数に保存することでデータベースへのアクセスを一回にしている.2回目からアクセスしない
    # 例外が発生するためUser.findではなくUser.find_byを使う. find_byはnilを返す
  
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
   def logged_in?
    !current_user.nil?
   end
  
   # 永続的セッションを破棄する
   def forget(user)
     user.forget
     cookies.delete(:user_id)
     cookies.delete(:remember_token)
   end
  
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト.フレンドリーフォワーディングのため
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを覚えておく.フレンドリーフォワーディングのため
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
  
end
