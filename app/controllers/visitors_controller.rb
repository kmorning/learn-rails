class VisitorsController < ApplicationController

  def new
    #LearnRails.debug 'entering new method'
    @owner = Owner.new
    flash.now[:notice] = 'Welcome!'
    flash.now[:alert] = 'My birthday is soon.'
    #LearnRails.debug "Owner name is #{@owner.name}"
  end

end

