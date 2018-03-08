class UsersController < ApplicationController
  before_action :logged_in_user, 
     only: [:index, :edit, :update, :destroy,:following, :followers, :friends, 
            :all_messages, :sent_messages, :receive_messages]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :set_friends, 
     only: [:friends, :all_messages, :sent_messages, :receive_messages]
  
  def index
    #gem will_paginate
    #@users = User.where(activated: true).paginate(page: params[:page])
    @users = User.search(params[:search]).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    unless @user.activated?
      redirect_to root_url
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを確認しアカウントを有効にしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  def following
    @title = "following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def friends
    @title = "friends"
    @user  = User.find(params[:id])
    #TODO: クエリメソッドに書き直す
    @friends = @user.following.select{ |user| @user.followers.include?(user) }
    #TODO: paginateが使えない
    render 'show_friends'
  end
  
  def all_messages
     @all_messages = Message.where(user_id: current_user.id).or(Message.where(receiver_id: current_user.id))
     render 'show_messages_all'
  end
  
  def sent_messages
     @sent_messages = Message.where(user_id: current_user.id)
     render 'show_messages_sent'
  end
  
  def receive_messages
     @receive_messages = Message.where(receiver_id: current_user.id)
     render 'show_messages_receive'
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
#beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def set_friends
     @friends = current_user.following.select{ |user| current_user.followers.include?(user) }
     @friends_aar = @friends.map{ |i| [i.name.to_s, i.id] }
    end
  
end
