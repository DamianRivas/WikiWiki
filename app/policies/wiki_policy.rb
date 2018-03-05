class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki
  
  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end
  
  def show?
    scope.where(:id => wiki.id).exists?
  end
  
  def scope
    Pundit.policy_scope!(user, wiki.class)
  end
end