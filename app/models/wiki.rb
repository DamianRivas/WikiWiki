class Wiki < ApplicationRecord
  belongs_to :user
  
  def not_private!
    self.private = false
  end
end
