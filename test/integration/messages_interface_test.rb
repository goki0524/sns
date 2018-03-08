require 'test_helper'

class MessagesInterfaceTest < ActionDispatch::IntegrationTest
  def setup
   @send_user = users(:michael)
   @receive_user = users(:archer)
  end
  
  test "message interface" do
    #送信側ユーザーでログイン
    log_in_as(@send_user)
    get all_messages_user_path(@send_user)
    get new_message_path
    #無効な送信
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { message_content: " " } }
    end
    assert_select 'div#error_explanation'
    #有効な送信
    message_content = "Real message!"
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { message_content: message_content,
                                            receiver_id: @receive_user.id } }
    end
    assert_redirected_to all_messages_user_url(@send_user)
    follow_redirect!
    #送信した内容が表示されるか
    assert_match message_content, response.body
    get sent_messages_user_path(@send_user)
    assert_match message_content, response.body
    delete logout_path
    #受信側ユーザーでログイン
    log_in_as(@receive_user)
    get all_messages_user_path(@receive_user)
    #メッセージが届いているか確認
    assert_match message_content, response.body
    get receive_messages_user_path(@receive_user)
    assert_match message_content, response.body
    
  end
  
  test "notice function of the message" do
    log_in_as(@send_user)
    get all_messages_user_path(@send_user)
    get new_message_path
    #有効な送信
    message_content = "Real message!"
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { message_content: message_content,
                                            receiver_id: @receive_user.id } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    
  end
  
  
  
  
  
end
