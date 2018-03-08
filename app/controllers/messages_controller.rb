class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :set_friends, only: [:new]
  
  def new
    @message = current_user.messages.build
  end
  
  def create
    @message = current_user.messages.build(message_params)
    target_user_id = @message.receiver_id
    target_user = User.find_by(id: target_user_id)
    if @message.save
      flash[:success] = "#{target_user.name}さんへメッセージを送信しました。"
      redirect_to all_messages_user_url(current_user)
      #メッセージの相手にemailを送る
      current_user.send_notice_message_email(target_user)
    else
      @friends = current_user.following.select{ |user| current_user.followers.include?(user) }
      @friends_aar = @friends.map{ |i| [i.name.to_s, i.id] }
      render 'new'
    end
  end
  
  
  
  
 private
  
  def message_params
      params.require(:message).permit(:message_content, :receiver_id)
  end
  
  def set_friends
     @friends = current_user.following.select{ |user| current_user.followers.include?(user) }
     @friends_aar = @friends.map{ |i| [i.name.to_s, i.id] }
  end
  
end
