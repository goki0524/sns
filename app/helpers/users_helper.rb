module UsersHelper
  
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def user_friends(user)
    @friends ||= user.following.select{ |friend| user.followers.include?(friend) }
    return @friends
  end
  
  def user_friends?(self_user, other_user)
    user_friends(self_user).include?(other_user) 
  end
end

