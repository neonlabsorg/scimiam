class Role < ActiveRecord::Base

  has_many :accesses
  has_many :users, through: :accesses

  READWRITE_ATTRS = %w{
    scim_uid
    name
    description
  }

  validates :displayname, presence: true
  validates :displayname, uniqueness: true

  def self.scim_resource_type
    return Scimitar::Resources::Role
  end

  def self.scim_attributes_map
    return {
      id:           :id,
      externalId:   :scim_uid,
      displayName:  :displayname,
      users: [
        {
          list:  :users,
          using: {
            value:   :id,
            display: :displayname
          }
        }
      ],
      active:       :is_active?
    }
  end

  def self.scim_mutable_attributes
    return nil
  end

  def self.scim_queryable_attributes
    return {
      'id'                => { column: :primary_key },
      'externalId'        => { column: :scim_uid },
      'meta.lastModified' => { column: :updated_at },
      'displayName'       => { column: :displayname }
    }
  end

  def self.scim_timestamps_map
    {
      created:      :created_at,
      lastModified: :updated_at
    }
  end

  include Scimitar::Resources::Mixin
end 