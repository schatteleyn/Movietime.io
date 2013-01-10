#!/usr/bin/env ruby

require 'net/http'
require 'json'

URL = "http://dstbny.com/movies/"
API = "http://api.movies.io/movies/search?q="
SEARCH = "http://movies.io/m/search?q="

def size_convertor(size)
  mb = (1024*1024).to_f
  gb = (mb*1024).to_f

  if size/mb < 1000
  	return (size/mb).round(2).to_s + "MB"
  else
  	return (size/gb).round(2).to_s + "GB"
  end
end

def get_movies()
  movies = {}
  i = 1
  Net::HTTP.get(URI.parse(URL)).scan(/<img(.*?)>(.*?)<\/img>/) do |movie|
    movie = movie.to_s.match(/\(.*\)/).to_s.split(",")
    movies[i] = movie[1]
    i += 1
  end
  movies.each do |id, title|
    puts "#{id} - #{title}"
  end
  puts 'Type the number of the movie you want, or "r" to get 10 new movies: '
  return movies
end

def parsing(json, title)
  i = 1
  movie_list = {}
  if !json['movies'].nil?
    json['movies'].each do |movie|
      print id = "id:#{i} - "
      puts movie['title']
      movie_list[i] = movie
      i += 1
  end
  puts "Choose your movie:"
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
  json['sources']['torrents'].each do |torrent|
    puts "id: #{i}"
    print torrent['name']; print ' S:'; print torrent['seeders']; print ' L:'; print torrent['leechers']; print ' '; puts size_convertor(torrent['size'].to_f)
    magnet = torrent['magnet']
    sources[i] = magnet
    i += 1
  end
  puts "Which torrent to download ?"
  input = gets.strip.to_i
  `open #{sources[input]}` # Link to download. Change the open command by the one of your system if your on Linux
end

movie_list = get_movies()
input = gets.strip

while input == 'r'
  movie_list = get_movies()
  input = gets.strip
end
input = input.to_i
if input.between?(1,10)
  puts title = movie_list[input]
  resp = Net::HTTP.get(URI.parse(URI.escape(API+title)))
  json = JSON.parse(resp)
  puts parsing(json, title)
else
	puts 'You pressed the wrong key. Press r to reload, or the id of the movie.'
end
