class Movie < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, uniqueness: true

	has_and_belongs_to_many :genres
  has_and_belongs_to_many :crews

  def add_genres=(genres)
    self.genres = genres.map do |g|
      Genre.where(name: g).first_or_create!
    end
  end

  def add_crews=(crews)
    self.crews = crews.map do |c|
      Crew.where(name: c).first_or_create!
    end
  end
end
