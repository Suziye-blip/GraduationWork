class GamesController < ApplicationController
  def index
    @hints = Hint.all
  end
end
