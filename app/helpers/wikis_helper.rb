module WikisHelper
  def authorized_for_private
    current_user.admin? || (current_user.premium? && (@wiki.user_id == current_user.id || controller.action_name == "new"))
  end
  
  def authorized_for_collab
    (current_user.premium? && @wiki.user == current_user) || current_user.admin?
  end
end
