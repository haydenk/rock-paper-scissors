#!/usr/bin/env ruby

require 'sinatra'
require 'json'

# before we process the route, we'll set the response as
# plain text and set up an array of viable moves that
# a player (and the computer) can perform

before do
  @defeat = {
      rock: :scissors,
      paper: :rock,
      scissors: :paper,
  }
  @throws = @defeat.keys
end

get '/' do
  content_type :html

  @links = @throws
  erb :layout
end

get '/throw/:type' do
  content_type :json

  # the  params[] hash stores query string and form data.
  player_throw = params[:type].to_sym

  # in the case of the player providing a throw that is not valid,
  # we halt with a status code of 403 (Forbidden) and let them
  # know they need to make a valid throw to play.
  if !@throws.include?(player_throw)
    halt 403, {status: "error", :message => "You must throw one of the following: #{@throws}"}.to_json
  end


  # now we can select a random throw for the computer
  computer_throw = @throws.sample


  # compare the player and computer throws to determine a winner

  if player_throw == computer_throw
    status = "tied"
    message = "You tied with the computer, Try again!"
  elsif computer_throw == @defeat[player_throw]
    status = "won"
    message = "Nicely done; #{player_throw.capitalize} beats #{computer_throw.capitalize}!"
  else
    status = "lost"
    message = "Ouch; #{computer_throw.capitalize} beats #{player_throw.capitalize}. Better luck next time!"
  end

  { :status => status, :message => message }.to_json

end