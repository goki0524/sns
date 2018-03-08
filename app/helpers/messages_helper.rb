module MessagesHelper
  
  #送信Messageの送り先のユーザー名を返す
  def receiver_name(friends, receiver_id)
    friend = friends.select{|name, id| id == receiver_id}
    return if friend.empty?
    p "TO: #{friend[0][0]}"
  end
  
end
