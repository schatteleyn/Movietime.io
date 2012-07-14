#!/usr/bin/env ruby

require 'Net/http'
require 'pp'

URL = "http://movietime.cc/"

movies = {}
i = 1
getMovies = Net::HTTP.get(URI.parse(URL)).scan(/<img(.*?)>(.*?)<\/img>/m) do |movie|
  movie = movie.match(/\(.*\)/).to_s.split(",")
  movies[i] = movie[1]
  i = i+1
end

puts pp(movies)
