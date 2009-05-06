require "lib/filesystemwatcher"

def restart
  puts "#{Time.now} - Restarting app..."
  puts ""
  stop
  start
end

def start
  @pid = Kernel.fork do
     # Signal.trap("HUP") { puts "Ouch!"; exit }
    exec('ruby app.rb')
  end
  # puts "Starting app with pid #{@pid}"
end
 
def stop
  # puts "Stopping process #{@pid}"
  Process.kill("KILL", @pid)
  Process.wait(@pid)
  # puts "Process #{@pid} stopped"
end

start 

watcher = FileSystemWatcher.new()
watcher.addDirectory(".", "**/*.rb")
watcher.sleepTime = 1
watcher.start { |status,file|
    if (status == FileSystemWatcher::CREATED)
      puts "Created: #{file}"
    elsif (status == FileSystemWatcher::MODIFIED)
      puts "Modified: #{file}"
    elsif (status == FileSystemWatcher::DELETED)
      puts "Deleted: #{file}"
    else
      puts "something else... ?!?!"
    end
    restart
}
watcher.join
