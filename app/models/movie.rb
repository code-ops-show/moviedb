class Movie < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, uniqueness: true

	has_and_belongs_to_many :genres
  has_and_belongs_to_many :crews

  def add_many(type, data)
    type.in? ['Genre', 'Crew']
    type_plural = type.downcase.pluralize
    
    self.send("#{type_plural}=", data.map do |g|
      type.classify.constantize.where(name: g).first_or_create!
    end)
  end

end
