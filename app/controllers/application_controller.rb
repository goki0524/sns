class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless  logged_in?
        store_location #フレンドリーフォワーディングのためにURLを記憶
        flash[:danger] = "ログインしてください。"
        redirect_to login_path
      end
    end
    
end
