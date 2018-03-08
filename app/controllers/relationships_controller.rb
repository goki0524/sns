class RelationshipsController < ApplicationController
 before_action :logged_in_user
 
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
     format.html { redirect_to @user }
     format.js
    end
    #フォローした相手にemailを送る
    current_user.send_notice_follow_email(@user)
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
     format.html { redirect_to @user }
     format.js
    end
  end
  
end
