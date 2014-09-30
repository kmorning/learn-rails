class VisitorsController < ApplicationController

  def new
    #LearnRails.debug 'entering new method'
    @owner = Owner.new
    #LearnRails.debug "Owner name is #{@owner.name}"
  end

end

