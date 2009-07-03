#load "irbsh-lib.rb" if IRB.conf[:PROMPT_MODE] == :INF_RUBY
#encoding: utf-8
$KCODE = 'u'
require 'rubygems'
require 'irb/completion'
require 'what_methods'
#require 'to_activerecord'
require 'pp'

begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue => why
  warn "Couldn't load Wirble: #{why}"
end
# Wirble::History のパッチ
module Wirble
  class History
    def save_history
      path, max_size, perms = %w{path size perms}.map { |v| cfg(v) }

      # read lines from history, and truncate the list (if necessary)
      lines = Readline::HISTORY.to_a.uniq
      lines = lines[-max_size, max_size] if lines.size > max_size
      #lines = lines[-max_size, -1] if lines.size > max_size
      # write the history file
      real_path = File.expand_path(path)
      File.open(real_path, perms) { |fh| fh.puts lines }
      say 'Saved %d lines to history file %s.' % [lines.size, path]
    end
  end
end

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 2000
IRB.conf[:PROMPT][:CODE] = {
  :PROMPT_I => " ",
  :PROMPT_N => " ",
  :PROMPT_S => "#=> ",
  :PROMPT_C => nil,
  :RETURN => " #=> %s\n"
}
def codemode!
  conf.prompt_mode = :CODE
end
class Object
  # Return a list of methods defined locally for a particular object.  Useful
  # for seeing what it does whilst losing all the guff that's implemented
  # by its parents (eg Object).
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end
# refeを参照する r メソッドの追加
module Kernel
  def r(arg)
    puts `refe #{arg}`
  end
  private :r
end
class Module
  def r(meth = nil)
    if meth
      if instance_methods(false).include? meth.to_s
        puts `refe #{self}##{meth}`
      else
        super
      end
    else
      puts `refe #{self}`
    end
  end
end
# Rails環境だったら
if IRB.conf[:LOAD_MODULES].join =~ /config\/environment/
  # console上でARが発行するSQLなどを表示するメソッド
  def log_to(stream = STDOUT)
    ActiveRecord::Base.logger = Logger.new(stream)
    ActiveRecord::Base.clear_active_connections!
  end
# http://drnicwilliams.com/2008/01/01/find-objects-in-irb-directly-from-browser-urls/
# In irb, can type:
# people/6 instead of Person.find(6)
# That is, can paste in urls into irb to find objects.
class ModelProxy
  def initialize(klass)
    @klass = klass
  end
  def /(id)
    @klass.find(id)
  end
end
def define_model_find_shortcuts
  model_files = Dir.glob("app/models/**/*.rb")
  model_names = model_files.map { |f| File.basename(f).split('.')[0..-2].join }
  model_names.each do |model_name|
    Object.instance_eval do
      define_method(model_name.pluralize) do |*args|
        ModelProxy.new(model_name.camelize.constantize)
      end
    end
  end
end
else
  require 'active_support'
end
