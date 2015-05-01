class Crew < ActiveRecord::Base
  has_and_belongs_to_many :movies

  validates :name, uniqueness: true
end
