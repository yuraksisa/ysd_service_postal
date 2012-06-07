#
# This module defines the delivery strategies
#
#
#  :to            =>
#  :from          =>
#  :via           => :smtp ...
#  :via_options   =>  
#      :address              => 
#      :port                 =>
#      :user_name            =>
#      :password             =>
#      :enable_starttls_auto =>
#      :domain               =>
#      :authentication       =>
#
module DeliveryStrategies

  #
  # Send the message using the Pony Express mail system
  #
  module PonyDeliveryStrategy
  
    def self.mail(message)
    
      Pony.mail message
    
    end
  
  end
  
  #
  # Send the message using the simple working
  #
  module SimpleWorkerDeliveryStrategy
  
  end

end

# -----------------------------------------------------------------------
# It represents the PostalService used to send messages :
# 
#   Configure the accounts, setup and start sending messages
#   
#   PostalService.accounts(:default, { via => :smtp, via_options => { :address => '', :port => '', :user_name => '', :password } })
#   PostalService.setup()
#   PostalService.post(:to => '', :body => '')
#
# -----------------------------------------------------------------------
module PostalService

  @@default_delivery_strategy = DeliveryStrategies::PonyDeliveryStrategy
  @@options  = {}
  @@accounts = {}

  #
  # @param [Hash] options
  #    Represents the options to send the mail
  #
  #      :to
  #      :cc
  #      :cco
  #      :subject
  #      :body
  #      :html_body
  #
  def self.post(options)
  
    account = @@accounts[options[:account] || :default]
    message = options.merge(account)
    
    # Send the message using the delivery strategy
    delivery_strategy = @@options[:delivery_strategy] || @@default_delivery_strategy
    delivery_strategy.mail message
    
  end

  #
  # Configure the Postal service
  #  
  # @param [Hash] options
  #
  #    Represents the postal service options 
  #
  #     :deliveryStrategy 
  #        The delivery strategy used to send the mails (if we do not want to use the default one)
  #
  #     :enable_tls
  #        To enable SMTP tls
  #
  def self.setup(options=nil)
    @@options = options
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE) if @@options[:enable_tls] 
  end

  #
  # Add a account to the postal service
  # 
  # @param [Symbol] account_id
  #    Represents the account identification
  #
  # @param [Hash] options
  #    :from
  #    :via
  #    :via_options
  #
  def self.account(account_id, options)
    @@accounts[account_id] = options
  end
  

end
  