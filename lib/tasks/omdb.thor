require File.expand_path('config/environment.rb')

class Omdb < Thor
  def import
    movies = Sequel.connect('postgres://zacksiri@localhost:5432/omdb')[:movies]
    movies.each do |movie|
      
    end 
  end
end