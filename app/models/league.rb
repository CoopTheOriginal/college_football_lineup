class League < ApplicationRecord
  has_and_belongs_to_many :users

  has_secure_password validations: false

  belongs_to :creator, class_name: 'User'
end
