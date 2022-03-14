module UsersBackofficeHelper
  
  def avatar_url
    avatar = current_user.user_profile.avatar
    puts(ap avatar)
    avatar.attached? ? avatar : 'img.jpg'
    end
   
 
 
end
