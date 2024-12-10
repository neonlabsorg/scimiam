class Access < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  validates :user_id, uniqueness: { scope: :role_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[user_id role_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user role]
  end 

end 