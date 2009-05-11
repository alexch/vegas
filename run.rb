require "lib/filesystemwatcher"

class Runner
  def restart
    beginning = Time.now
    puts "#{beginning.strftime("%T")} - Restarting app..."
    puts ""
    stop
    start
  end

  def start
    @pid = Kernel.fork do
       # Signal.trap("HUP") { puts "Ouch!"; exit }
      exec('ruby app.rb')
    end
    self
  end
 
  def stop
    Process.kill("KILL", @pid)
    Process.wait(@pid)
  end

  def git_head_changed?
    old_git_head = @git_head
    read_git_head
    @git_head and old_git_head and @git_head != old_git_head
  end

  def read_git_head
    git_head_file = File.join(dir, '.git', 'HEAD')
    @git_head = File.exists?(git_head_file) && File.read(git_head_file)
  end

  def listen
    begin
      require 'lib/listener'
      listener = Listener.new(%w(rb erb haml)) do |files|
        p files
        restart
      end.run(".")
    rescue
      watcher = FileSystemWatcher.new()
      watcher.addDirectory(".", "**/*.rb")
      watcher.sleepTime = 1
      watcher.start do |status,file|
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
      end
      watcher.join
    end
  end
end

Runner.new.start.listen
