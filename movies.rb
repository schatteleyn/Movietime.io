#!/usr/bin/env ruby

require 'Net/http'
require 'pp'
require 'json'

URL = "http://movietime.cc/"
URL2 = "http://movies.io/m/search?utf8=%E2%9C%93&q="

def get_movies()
  movies = {}
  i = 1
  Net::HTTP.get(URI.parse(URL)).scan(/<img(.*?)>(.*?)<\/img>/) do |movie|
    movie = movie.to_s.match(/\(.*\)/).to_s.split(",")
    movies[i] = movie[1]
    i = i+1
  end
  return movies
end

def to_json(title)
  # Parsing and scrapping the JSON attributes
  data = Net::HTTP.get(URI.parse(URL2+title))
  #Have to go the redirected page. Scrap the href.
  #.match(/data-injected=".*"/).to_s
  data.gsub!(/&amp;/, '')
  data.gsub!(/&quot;/, '"')
  data = data.match(/[^torrents:].*[^}]/)
  return data
end

def download
end

puts movie_list = pp(get_movies())

puts 'Type the number of the movie you want, or r to get 10 new movies: '
input = gets.chomp

if input == 'r'
  puts get_movies()
else
	input = input.to_i
  title = movie_list[input].gsub(' ', '+')
  to_json(title)
  #JSON parsing
end
