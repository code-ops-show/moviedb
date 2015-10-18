class Movie < ActiveRecord::Base
  include Elasticsearch::Model
  # we don't need the line below because we're
  # implementing our own
  # include Elasticsearch::Model::Callbacks

  after_commit  :index_document,  on: [:create, :update]
  after_commit  :delete_document, on: :destroy

  def index_document
    IndexerJob.perform_later('index',  self.id)
  end

  def delete_document
    IndexerJob.perform_later('delete', self.id)
  end

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
    indexes :runtime,      type: 'integer'
    indexes :review,       type: 'float'
    indexes :crews, type: 'nested' do 
      indexes :id,   type: 'integer'
      indexes :name, type: 'string', index: :not_analyzed
    end
    indexes :genres, type: 'nested' do 
      indexes :id,   type: 'integer'
      indexes :name, type: 'string', index: :not_analyzed
    end
  end

  def as_indexed_json(options = {})
    self.as_json(only: [:id, :name, :synopsis, :year, :country, :language, :runtime, :review],
      include: { 
        crews:  { only: [:id, :name] },
        genres: { only: [:id, :name] }
    })
  end

  
  class << self
    def custom_search(query)
      __elasticsearch__.search(query: multi_match_query(query), aggs: aggregations)
    end

    def multi_match_query(query)
      { 
        multi_match: { 
          query: query,
          type: "best_fields", # possible values "most_fields", "phrase", "phrase_prefix", "cross_fields"
          fields: ["name^9", "synopsis^8", "year", "language^7", "country", "genres.name", "crews.name^10"],
          operator: "and"
        }
      }
    end

    def aggregations
      { 
        crews_aggregation: 
        {  
          nested: { path: "crews" }, 
          aggs: crew_aggregation
        }
      }
    end

    def crew_aggregation
      { crews: 
        { 
          terms: { script: "doc['crews.id'].value + '|' + doc['crews.name'].value" }
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
