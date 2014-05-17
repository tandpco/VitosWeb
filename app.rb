require 'rubygems'
require 'sinatra'
require 'active_record'

set :bind, "0.0.0.0"
set :port, 4888

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlserver",
  :host     => "websql.vitos.com",
  :username => "webtest",
  :password => "T3st4Th3W3b",
  :database => "vitostest"
)

class Tblstores < ActiveRecord::Base
end

class App < Sinatra::Application
end

get '/' do
    stores = Tblstores.all
    html  = "<html>"
    html  += "<head><title>Stores</title></head>"
    stores.each do |store|
        html += "<p>#{store.Address1}</p>"
    end
    html += "</html>"
    html
end
