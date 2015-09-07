class Movie < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, uniqueness: true

	has_and_belongs_to_many :genres

  has_many :roles
  has_many :crews, through: :roles

  mapping do 
    indexes :id, index: :not_analyzed
    indexes :name
    indexes :synopsis
    indexes :year
    indexes :language
    indexes :country
    indexes :review,   type: 'float'
  end

  def as_indexed_json(options = {})
    self.as_json(only: [:id, :name, :synopsis, :year, :country, :language, :review],
      include: { 
        crews:  { only: [:id, :name] },
        genres: { only: [:id, :name] }
    })
  end

  

  class << self
    def custom_search(query)
      __elasticsearch__.search(query: multi_match_query(query))
    end

    def multi_match_query(query)
      { 
        multi_match: { 
          query: query,
          type: "best_fields", # possible values "most_fields", "phrase", "phrase_prefix", "cross_fields"
          fields: ["name^9", "synopsis^8", "year", "language^7", "country", "genres.name", "crews.name"],
          operator: "and"
        }
      }
    end
  end
  

  class RelationError < StandardError
    def initialize(msg = "That Relationship Type doesn't exist")
      super(msg)
    end
  end

  def add_many(type, data)
    if type.in? ['Genre', 'Crew']
      # movie.genres = [data]
      self.send("#{type.downcase.pluralize}=", data.map do |g|
        type.classify.constantize.where(name: g).first_or_create!
      end)
    else
      raise RelationError
    end
  end

end
