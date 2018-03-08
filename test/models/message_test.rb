require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @message = @user.messages.build(message_content: "Hello!", receiver_id: 2)
  end
  
  test "should be valid?" do
    assert @message.valid?
  end
  
  test "user id should be present" do
    @message.user_id = nil
    assert_not @message.valid?
  end
  
  test "message_content should be present" do
    @message.message_content = " "
    assert_not @message.valid?
  end
  
  test "content should be at most 1000 characters" do
    @message.message_content = "a" * 1001
    assert_not @message.valid?
  end
  
  test "receiver id should be present" do
    @message.receiver_id = nil
    assert_not @message.valid?
  end
  
  
end
