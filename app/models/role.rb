class Role < ActiveRecord::Base

  has_many :accesses
  has_many :users, through: :accesses
  belongs_to :approver_set, optional: true

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name is_active approver_set_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[accesses approver_set]
  end

end 