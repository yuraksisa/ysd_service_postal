require 'pony' unless defined?Pony

#
# This module defines the delivery strategies
#
# Delivery strategies implement a mail method which sends the message
#
module DeliveryStrategies

  #
  # Mail (through Pony Express)
  #
  module PonyDeliveryStrategy
    
    #
    # mail
    #  
    def self.mail(message)
      Pony.mail message
    end
  
  end
  
end