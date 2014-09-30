
module LearnRails

  # Debug format (bold blue)
  DEBUG_MSG = "\033[1;34;40m[DEBUG]\033[0m "

  def self.debug( msg )
    Rails.logger.debug DEBUG_MSG + msg
  end
  
end

