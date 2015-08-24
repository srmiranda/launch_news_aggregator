require 'sinatra'
require 'csv'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

get '/articles' do
  db_connection do |conn|
    sites = conn.exec('SELECT * FROM articles')
    erb :index, locals: { sites: sites }
  end
end

get '/articles/new' do
  erb :new, locals: { new_site: params[:new_site], site_address: params[:site_address], description: params[:description] }
end

post '/articles/new' do
  # Read the input from the form the user filled out
  new_site = params["new_site"]
  site_address = params["site_address"]
  description = params["description"]

  db_connection do |conn|
    conn.exec_params("INSERT INTO articles (new_site, site_address, description) VALUES ($1, $2, $3)", [new_site, site_address, description]);
  end

  redirect '/articles'
end

set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
