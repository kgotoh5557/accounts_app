class RoomController < ApplicationController
  def index
  end
  
  def show
    @messages = Message.all
  end
  
end
