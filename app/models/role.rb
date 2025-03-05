class Role < ApplicationRecord

  has_many :accesses, dependent: :restrict_with_error
  has_many :users, through: :accesses
  belongs_to :approval_workflow, optional: true

  # TODO: maybe it's better to use another abstraction for strategies
  belongs_to :workspace_connection, optional: true
  belongs_to :github_connection, optional: true

  
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :github_team, uniqueness: { scope: :github_connection_id }


  def has_provisioning?
    (workspace_connection_id.present? && workspace_group.present?) || 
    (github_connection_id.present?) # add new strategy via ||
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name is_active approval_workflow_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[accesses approval_workflow]
  end

end