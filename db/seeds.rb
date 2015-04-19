# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


["Action", "Crime", "Drama", "Animation", "Adventure", "Comedy"].each do |genre|
  Genre.create(name: genre)
end

[ 
  {name: "Frozen",     synopsis: "When the newly crowned Queen Elsa accidentally uses her power to turn things into ice to curse her home in infinite winter, her sister, Anna, teams up with a mountain man, his playful reindeer, and a snowman to change the weather condition.", genres: ["Animation", "Adventure", "Comedy"]},
  {name: "Big Hero 6", synopsis: "The special bond that develops between plus-sized inflatable robot Baymax, and prodigy Hiro Hamada, who team up with a group of friends to form a band of high-tech heroes.", genres: ["Animation", "Action", "Adventure"]},
  {name: "Blackhat",   synopsis: "A furloughed convict and his American and Chinese partners hunt a high-level cybercrime network from Chicago to Los Angeles to Hong Kong to Jakarta.", genres: ["Action", "Crime", "Drama"]}
].each do |data|
  movie = Movie.create(name: data[:name], synopsis: data[:synopsis])

  movie.genres.push(Genre.where(name: data[:genres]))
end 



