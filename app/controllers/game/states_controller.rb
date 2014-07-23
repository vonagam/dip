class StatesController < ApplicationController
  load_resource :game
  before_action :find_side

  def index
    @side = @game.side_of current_user
  end
end
