class Movie < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, uniqueness: true

	has_and_belongs_to_many :genres
end
