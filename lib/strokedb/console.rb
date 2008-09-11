module StrokeDB
  module Console
    include ::GemConsole
    
    help "no help yet"
    
    def project_name
      "StrokeDB #{::StrokeDB::VERSION}"
    end
    
    def setup
      puts "TODO: some DB setup..."
    end
  end # Console
end # StrokeDB
