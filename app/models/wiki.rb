class Wiki < ApplicationRecord
  belongs_to :user
  
  scope :user_owned_privates, ->(user) { where({ private: true, user: user }) }
  
  after_initialize :init
  
  def not_private!
    self.private = false
  end
  
  private
  
  def init
    self.private = false if self.private.nil?
  end
end
