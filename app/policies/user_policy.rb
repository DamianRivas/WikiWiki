class UserPolicy < ApplicationPolicy
  attr_reader :user, :model
  
  def initialize(user, model)
    @user = user
    @model = model
  end
  
  def user_downgrade?
    @user.premium?
  end
end