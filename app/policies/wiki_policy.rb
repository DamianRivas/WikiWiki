class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki
  
  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end
  
  def show?
    Wiki.where(:id => wiki.id).exists?
  end
  
  def scope
    Pundit.policy_scope!(user, wiki.class)
  end
  
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end