class GamesController < ApplicationController

  def new
    @letters = generate_grid(10)
    @start_time = Time.now
  end

  def score
    letters = params[:grid]
    start_time = Time.parse(params[:start_time])
    attempt = params[:attempt]
    @run_game = run_game(attempt, letters, start_time, Time.now)
  end

end

require 'open-uri'
require 'json'

def generate_grid(grid_size)
  (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
end

def run_game(attempt, grid, start_time, end_time)
  result = { time: (end_time - start_time), score: 0 }

  if word_in_the_grid?(attempt, grid) != true
    result[:message] = "Word is not in the grid!"
  elsif english_word?(attempt) != true
    result[:message] = "not an english word"
  else
    result[:score] = 100 - (end_time - start_time) + attempt.length
    result[:message] = "well done"
  end

  return result
end

def word_in_the_grid?(attempt, grid)
  attempt_array = attempt.upcase.split("")
  attempt_array.each do |letter|
    return false if attempt_array.count(letter) > grid.count(letter)
    return false unless grid.include? letter
  end
  return true
end

def english_word?(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  user_serialized = open(url).read
  user = JSON.parse(user_serialized)

  return user["found"] == true
end
