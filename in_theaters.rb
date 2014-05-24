require 'json'
require 'net/http'

if !ENV.has_key?("ROTTEN_TOMATOES_API_KEY")
  puts "You need to set the ROTTEN_TOMATOES_API_KEY environment variable."
  exit 1
end

api_key = ENV["ROTTEN_TOMATOES_API_KEY"]
uri = URI("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{api_key}")

response = Net::HTTP.get(uri)
movie_data = JSON.parse(response)

# movie_data = JSON.parse(File.read('in_theaters.json'))

puts "In Theaters Now:\n\n"

movie_hash = {}

movie_data["movies"].each do |movie|
  avgscore = (movie["ratings"]["critics_score"].to_i + movie["ratings"]["audience_score"].to_i) / 2
  title = movie["title"]
  mpaa = movie["mpaa_rating"]
  cast = ""
  for i in 0..2
    if !movie["abridged_cast"][i].nil?
      cast += movie["abridged_cast"][i]["name"]
      if i < 2
        cast += ", "
      end
    end
  end
  cast += "."

  movie_hash[title] = [avgscore, mpaa, cast]

end

movie_hash = movie_hash.sort_by { |title, info| -info[0] }

movie_hash.each do |mov, arr|
    puts "#{arr[0]} - #{mov} (#{arr[1]}) starring #{arr[2]}"
end
