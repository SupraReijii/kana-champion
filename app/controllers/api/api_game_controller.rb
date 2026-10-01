class Api::ApiGameController < ApplicationController
  def create
    game = Game.new(game_params)
    if game.save
      render json: { status: 'ok' }
    else
      render json: { status: 'error', message: game.errors }
    end
  end


  private
  def game_params
    params.require(:game).permit(:game_name, :points, :time, :kana_count, :kana_right)
  end
end