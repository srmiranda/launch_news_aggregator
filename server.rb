require 'sinatra'
require 'csv'
require 'pry'

get '/articles' do
  sites = []
  CSV.foreach('sites.csv') do |row|
    sites << row
  end
  erb :index, locals: { sites: sites }
end

get '/articles/new' do
  erb :new, locals: { new_site: params[:new_site], site_address: params[:site_address], description: params[:description] }
end

post '/articles/new' do
  # Read the input from the form the user filled out
  new_site = params["new_site"]
  site_address = params["site_address"]
  description = params["description"]

  # Open the "sites.csv" file and append the task
  File.open("sites.csv", "a") do |file|
    file.puts(new_site + ',' + site_address + ',' + description)
  end

  # url_exists = false
	#   posts = CSV.foreach("posts.csv", headers:true) do |row|
	#     url_exists = true if row.field?(params["url"])
	#   end

  # Send the user back to the home page which shows
  # the list of sites
  redirect '/articles'
end

set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
