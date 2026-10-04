class DashboardController < ApplicationController
  LEADERBOARDS = {
    hiragana: { title: "Хирагана", glyph: "あ", game_names: %w[ classic,hiragana ] },
    katakana: { title: "Катакана", glyph: "ア", game_names: %w[ classic,katakana ] },
    mixed: { title: "Смешанная", glyph: "あア", game_names: %w[classic,hiragana,katakana] },
  }.freeze

  def index
    scored_games = Game.where.not(points: nil)
    @leaderboards = LEADERBOARDS.transform_values do |board|
      board.merge(games: scored_games.where(game_name: board[:game_names]).order(points: :desc, created_at: :desc).limit(10))
    end
    @games_count = Game.count
    @best_score = scored_games.maximum(:points)
    @kana_counts = Kana.group(:kana_type).count
  end
end
