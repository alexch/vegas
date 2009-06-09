require "sinatra/base"

class Sinatra::Reloader < Rack::Reloader
  def safe_load(file, mtime, stderr = $stderr)
    if file == Sinatra::Application.app_file
      ::Sinatra::Application.reset!
      stderr.puts "#{self.class}: reseting routes"
    end
    super
  end
end

