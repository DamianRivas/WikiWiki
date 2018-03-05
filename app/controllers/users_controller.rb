class UsersController < ApplicationController
  def user_downgrade
    @user = current_user
    authorize @user
    
    @user.standard!
    
    flash[:alert] = "User account succesfully downgraded."
    
    redirect_back(fallback_location: root_path)
  end
end
