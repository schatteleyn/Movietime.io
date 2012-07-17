#!/usr/bin/env ruby

require 'net/http'
require 'pp'
require 'nokogiri'
require 'json'

URL = "http://movietime.cc/"
URL2 = "http://movies.io/m/search?utf8=%E2%9C%93&q="

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

def films(title)
  # Parsing and scrapping the JSON attributes
  data = Net::HTTP.get(URI.parse(URL2+title))
  if data.match(/redirected/)
  	doc = Nokogiri::HTML.parse(data)
  	l = doc.css('body a').map { |link| link['href'] }
  	url_movie = l[0]
  	resp = Net::HTTP.get(URI.parse(url_movie+"/sources.json"))
    json = JSON.parse(resp)
    parsing(json)
  else
  	puts "Multiple choice to parse."
  end
end

def parsing(json)
  i = 1
  sources = {}
  json['torrents'].each do |movie|
    puts id = "id: #{i}"
    print movie['name']; print ' S:'; print movie['seeders']; print ' L:'; print movie['leechers']; print ' '; puts movie['size']
    magnet = movie['magnet']
    sources[i] = movie
    i += 1
  end
  puts "Which torrent to dowmload ?"
  input = gets.chomp.to_i
  puts sources[input]
  #Net::HTTP.get(URI.parse(sources[input])) # Link to download. Doesn't work.
end

puts movie_list = pp(get_movies())

puts 'Type the number of the movie you want, or r to get 10 new movies: '
input = gets.chomp

if input == 'r'
  puts "Feature not supported for now."
else
	input = input.to_i
  title = movie_list[input].gsub(' ', '+')
  puts films(title)
end
