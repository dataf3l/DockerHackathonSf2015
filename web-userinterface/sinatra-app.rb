# require 'rubygems'
require 'sinatra'
# require 'Haml'
require 'erb'
 **set :views, Proc.new { File.join(root, "../views") }**

enable :run

get '/' do
  erb :index
  # haml :index
end

