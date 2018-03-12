class Wiki < ApplicationRecord
  belongs_to :user
  
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  
  def not_private!
    self.update(private: false)
  end
  
  def public?
    not self.private
  end
end
