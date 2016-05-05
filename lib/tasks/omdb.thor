require 'thor'
require File.expand_path('config/environment.rb')

class Omdb < Thor

  desc "import", "Import data from omdb"
  def import
    movie_names = Movie.pluck(:name)
    movies = Sequel.connect('postgres://zacksiri@localhost:5432/omdb')[:movies]
    movies.order(:ID).each do |mdb|
      movie = Movie.create do |m|
        m.name         = mdb[:Title]
        m.synopsis     = mdb[:FullPlot]        unless mdb[:FullPlot]   == 'N/A'
        m.year         = mdb[:Year].to_i
        m.country      = mdb[:Country]         unless mdb[:Country]    == 'N/A'
        m.language     = mdb[:Language]        unless mdb[:Language]   == 'N/A'
        m.runtime      = mdb[:Runtime].to_i    unless mdb[:Runtime]    == 'N/A'
        m.review       = mdb[:imdbRating].to_f unless mdb[:imdbRating] == 'N/A'
        m.release_date = Date.parse(mdb[:Released]) if mdb[:Released]
      end

      movie.add_many('Genre', mdb[:Genre].split(',').map(&:strip))

      if movie.persisted?
        extract_crew('Director', movie, mdb[:Director]) unless mdb[:Director] == 'N/A'
        extract_crew('Writer', movie, mdb[:Writer]) unless mdb[:Writer] == 'N/A'
        extract_crew('Cast', movie, mdb[:Cast]) unless mdb[:Cast] == 'N/A'
      end
      
      puts "-----> Imported #{mdb[:Title]}"
    end 
  end

  no_tasks do 
    def extract_crew(role, movie, data)
      data.split(',').map { |n| n.gsub(/\(\S*\)/, '') }
                     .map(&:strip).each do |crew_name|
        crew = Crew.where(name: crew_name).first_or_create!
        Role.where(crew: crew, movie: movie, job: role).first_or_create!
      end
    end
  end
end