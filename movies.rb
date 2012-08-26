#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'pp'

URL = "http://movietime.cc/"
API = "http://api.movies.io/movies/search?q="
SEARCH = "http://movies.io/m/search?q="

def get_movies()
  movies = {}
  i = 1
  Net::HTTP.get(URI.parse(URL)).scan(/<img(.*?)>(.*?)<\/img>/) do |movie|
    movie = movie.to_s.match(/\(.*\)/).to_s.split(",")
    movies[i] = movie[1]
    i += 1
  end
  return movies
end

def parsing(json, title)
  i = 1
  movie_list = {}
  if !json['movies'].nil?
    json['movies'].each do |movie|
      print id = "id:#{i} - "
      puts movie['movie']['title']
      movie_list[i] = movie
      i += 1
    end
  input = gets.strip.to_i
  get_torrent(movie_list[input])
  else
    search = URI.escape(SEARCH+title)
    `open #{search}` # Change this command if you're on linux
  end
end

def get_torrent(json)
  i = 1
  sources = {}
  json['movie']['sources']['torrents'].each do |torrent|
    puts "id: #{i}"
    print torrent['name']; print ' S:'; print torrent['seeders']; print ' L:'; print torrent['leechers']; print ' '; puts torrent['size'].to_i / (1024*1024) + 'MB'
    magnet = torrent['magnet']
    sources[i] = magnet
    i += 1
  end
  puts "Which torrent to download ?"
  input = gets.strip.to_i
  `open #{sources[input]}` # Link to download. Change the open command by the one of your system if your on Linux
end

puts movie_list = pp(get_movies())

puts 'Type the number of the movie you want, or "r" to get 10 new movies: '
input = gets.strip

while input == 'r'
  puts movie_list = pp(get_movies())
  puts 'Type the number of the movie you want, or "r" to get 10 new movies: ' 
  input = gets.strip
end
input = input.to_i
if input.between?(1,10)
  puts title = movie_list[input]
  resp = Net::HTTP.get(URI.parse(URI.escape(API+title)))
  json = JSON.parse(resp)
  puts parsing(json, title)
else
	puts 'You press the wrong key. Press r to reload, or the id of the movie.'
end
