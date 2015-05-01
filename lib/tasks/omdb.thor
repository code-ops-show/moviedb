require 'thor'
require File.expand_path('config/environment.rb')

class Omdb < Thor
  def import
    movies = Sequel.connect('postgres://zacksiri@localhost:5432/omdb')[:movies]
    movies.each do |movie|
      Movie.create do |m|
        m.name     = movie[:Title]
        m.synopsis = movie[:FullPlot] unless movie[:FullPlot] == 'N/A'
        m.year     = 
      end
    end 
  end
end