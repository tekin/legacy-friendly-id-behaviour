class Pet < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :owner

  belongs_to :owner, class_name: 'Person'
end
