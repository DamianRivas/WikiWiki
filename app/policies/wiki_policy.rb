class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki
  
  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end
  
  def show?
    scope.where(id: wiki.id).exists?
  end
  
  def scope
    Pundit.policy_scope!(user, wiki.class)
  end
  
  class Scope < Scope
    def resolve
      public_wikis = scope.where(private: false)
      
      if user.nil?
        public_wikis
      elsif user.admin?
        scope.all
      elsif user.premium?
        user_owned_privates = scope.where(user: user, private: true)
        
        public_wikis.or(user_owned_privates)
      else
        public_wikis
      end
    end
  end
end