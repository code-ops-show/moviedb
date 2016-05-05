class Crew < ActiveRecord::Base
  has_many :roles
  has_many :movies, through: :roles

  validates :name, uniqueness: true
end
