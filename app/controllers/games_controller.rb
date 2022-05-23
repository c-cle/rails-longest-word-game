require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (("A".."Z").to_a + ("A".."Z").to_a).sample(10)
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    api = URI.open(url).read
    content = JSON.parse(api)
    # @time = end_time - start_time
    attempt_array = params[:word].upcase.chars
    time_end = Time.now
    time_start = Time.parse(params[:timestart])
    @time = time_end - time_start
    @attempt = params[:word]
    @letters = JSON.parse(params[:letters])

    condition = attempt_array.all? { |char| @letters.delete_at(@letters.index(char)) if @letters.include?(char) }

    if (content["found"] == true) & (condition == true)
      @message = "is a valid english word. well done, Bravo."
      @points = (content["length"] * (1 / @time))
      @time
    elsif content["found"] != true
      @message = "is not an english word"
      @points = 0
      @time
    else
      @message = "cannot be built out of the suggested letters"
      @points = 0
      @time
    end
  end
end
