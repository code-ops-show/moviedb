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
    indexes :crews
    indexes :genres
  end

  def as_indexes_json(options = {})
    self.as_json(only: [:id, :name, :synopsis],
      include: { 
        crews:  { only: [:id, :name] },
        genres: { only: [:id, :name] }
    })
  end
  

  class RelationError < StandardError
    def initialize(msg = "That Relationship Type doesn't exist")
      super(msg)
    end
  end

  def add_many(type, data)
    if type.in? ['Genre', 'Crew']
      self.send("#{type.downcase.pluralize}=", data.map do |g|
        type.classify.constantize.where(name: g).first_or_create!
      end)
    else
      raise RelationError
    end
  end

end
