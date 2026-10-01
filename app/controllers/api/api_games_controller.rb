class Api::ApiGamesController < ApplicationController
  def create
    game = Game.new(game_params)
  end


  private
  def game_params
    params.require(:game).permit(:game_name, :points, :time, :kana_count, :kana_right)
  end
end