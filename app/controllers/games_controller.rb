require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    if included?(@word.upcase, @letters)
      if english_word?(@word)
        @result = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @result = "Sorry but #{@word.upcase} is not a valid English word."
      end
    else
      @result = "Sorry but #{@word.upcase} can't be built out of #{@letters.join(", ")}."
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
