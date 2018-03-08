require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @message = messages(:orange)
  end
  
  #ログインしていない状態での投稿
  test "should redirect create message when not logged in" do
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { message_content: "Hello!", 
                                      receiver_id: 2} }
    end
    assert_redirected_to login_url
  end
  
  
  
  
  
  
  
end
