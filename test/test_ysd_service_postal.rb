  PostalService.account(:default, {:via => :smtp, :via_options => {:address => 'smtp.gmail.com', :port => '587', :user_name => 'user.account' , :password => 'password', :enable_starttls_auto => true, :domain => 'localhost@localdomain', :authentication => :plain }})
  PostalService.setup( :enable_tls => true )
  PostalService.post(:to => 'someone@gmail.com', :subject => 'Test', :body => 'Hello World!')
