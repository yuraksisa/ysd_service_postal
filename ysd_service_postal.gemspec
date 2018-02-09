Gem::Specification.new do |s|
  s.name    = "ysd_service_postal"
  s.version = "0.1.6"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2011-12-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb']
  s.summary = "A postal service"

  s.add_runtime_dependency "pony","~> 1.3"
  s.add_runtime_dependency "tlsmail", "~> 0.0.1"

end
