class RecordsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @records = Record.all.order(cleartime: :asc, number_of_time: :asc)
  end
end
