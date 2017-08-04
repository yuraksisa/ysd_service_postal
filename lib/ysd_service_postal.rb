require 'net/smtp'
require 'ysd_delivery_strategies'

# 
# PostalService used to send messages
# 
# Usage:
#
#   # Configure the accounts, setup and start sending messages
#  
#   PostalService.accounts(:default, { via => :smtp, 
#     via_options => { :address => 'smtp.server', :port => 'smpt.port', 
#     :user_name => 'user', :password => 'password'} })
#
#   PostalService.setup(:enable_tls => true)
#
#   # Send a message
#
#   PostalService.instance.post(:to => '', :body => '')
#
# -----------------------------------------------------------------------
module PostalService

  @@default_delivery_strategy = DeliveryStrategies::PonyDeliveryStrategy
  @@options  = {}
  @@accounts = {}
  @@setup = false

  #
  # Post a message from an account using a delivery strategy
  #
  # @param [Hash] options
  #
  #      :to          Destination
  #      :cc          Copy
  #      :cco         Hidden copy
  #      :subject     Subject
  #      :body        Body
  #      :html_body   HTML body
  #
  def self.post(options)

    settings_account = setup_account_from_settings

    raise 'No accounts have been defined. Use PostalService.accounts' if @@accounts.empty? and settings_account.nil?
    raise 'No valid account has been choosen' if options.has_key?(:account) and not @@accounts.has_key?(:account)
    raise 'PostalService was not set up. Use PostalService.setup' unless @@setup

    account = settings_account || @@accounts[options[:account] || :default]
    delivery_strategy = options[:delivery_strategy] || @@default_delivery_strategy

    delivery_strategy.mail options.merge(account)
    
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
    @@setup = true
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

  private

  def self.setup_account_from_settings

    from = SystemConfiguration::SecureVariable.get_value('smtp.from','.')
    return nil if from.nil? or from == '.'

    host = SystemConfiguration::SecureVariable.get_value('smtp.host','.')
    port = SystemConfiguration::SecureVariable.get_value('smtp.port','.')
    username = SystemConfiguration::SecureVariable.get_value('smtp.username','.')
    password = SystemConfiguration::SecureVariable.get_value('smtp.password','.')
    domain = SystemConfiguration::SecureVariable.get_value('smtp.domain','.')
    authentication = SystemConfiguration::SecureVariable.get_value('smtp.authentication','login')
    starttls_auto = SystemConfiguration::SecureVariable.get_value('smtp.starttls_auto','yes').to_bool

    {:from => from,
     :via => :smtp,
     :via_options => {
         :address => host,
         :port => port,
         :user_name => username,
         :password => password,
         :enable_starttls_auto => starttls_auto,
         :domain => domain,
         :authentication => authentication.to_sym }}

  end

end
  