class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki
  
  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end
  
  def show?
    scope.where(id: wiki.id).exists?
  end
  
  def edit?
    if wiki.public?
      user.present?
    else
      user.present? && user.admin? || (user.try(:premium?) && wiki.user == user) || wiki.collaborators.find_by_user_id(user)
    end
  end
  
  def scope
    Pundit.policy_scope!(user, wiki.class)
  end
  
  class Scope < Scope
    def resolve
      public_wikis = scope.where(private: false)
      
      collab_wikis = scope.where(id: Collaborator.where(user: user).pluck(:wiki_id)) if user
      
      if user.try(:admin?)
        scope.all
      elsif user.try(:premium?)
        user_owned_privates = scope.where(user: user, private: true)
        
        public_wikis.or(user_owned_privates).or(collab_wikis)
      elsif user.try(:standard?)
        public_wikis.or(collab_wikis)
      else
        public_wikis
      end
    end
  end
end
