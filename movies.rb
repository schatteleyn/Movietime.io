#!/usr/bin/env ruby

require 'Net/http'
require 'pp'

URL = "http://movietime.cc/"

def get_movies()
  movies = {}
  i = 1
  Net::HTTP.get(URI.parse(URL)).scan(/<img(.*?)>(.*?)<\/img>/m) do |movie|
    movie = movie.to_s.match(/\(.*\)/).to_s.split(",")
    movies[i] = movie[1]
    i = i+1
  end
  return movies
end

def download(title)
end

puts movie_list = pp(get_movies())

puts 'Type the number of the movie you want, or r to get 10 new movies: '
input = gets.chomp

if input == 'r'
  puts get_movies()
else
	input = input.to_i
  title = movie_list[input]
  #download(title)
end
