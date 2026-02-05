class RecordsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @records = Record.all.order(created_at: :desc)
  end
end
