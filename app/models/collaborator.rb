class Collaborator < ApplicationRecord
  belongs_to :user
  belongs_to :wiki
  
  validates :user_id, presence: true
  
  def leader
    wiki.user
  end
end
