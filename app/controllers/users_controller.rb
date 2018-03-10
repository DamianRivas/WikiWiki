class UsersController < ApplicationController
  def user_downgrade
    @user = current_user
    authorize @user
    
    @user.standard!
    
    Wiki.where(user_id: @user).update_all(private: false)
    
    flash[:alert] = "User account succesfully downgraded. All your wikis are now public."
    
    redirect_back(fallback_location: root_path)
  end
end
