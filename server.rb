require "sinatra"
require "sinatra/cross_origin"
require "json"
require "apkg_to_csv"
require "fileutils"

configure do
  enable :cross_origin
  set :bind, "0.0.0.0"
  set :port, ENV["PORT"] || 4567

  # Configure allowed origins properly
  set :allow_origin, "https://quizy2.vercel.app"
  set :allow_methods, [:get, :post, :options]
  set :allow_headers, ["Content-Type", "Accept", "Authorization", "Token"]
end

register Sinatra::CrossOrigin

before do
  response.headers["Access-Control-Allow-Origin"] = "https://quizy2.vercel.app"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Authorization, Token"
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,POST,OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "https://quizy2.vercel.app"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Authorization, Token"
  200
end

# Make sure this route matches exactly what you call from frontend
post "/parse" do
  cross_origin

  unless params[:file]
    halt 400, { error: "No file uploaded" }.to_json
  end

  FileUtils.mkdir_p("/tmp") # Use absolute path for Railway

  tempfile = params[:file][:tempfile]
  output_path = "/tmp/deck_#{Time.now.to_i}.csv"

  # Run conversion safely
  result = system("apkg-to-csv #{tempfile.path} > #{output_path}")

  unless result && File.exist?(output_path)
    halt 500, { error: "Conversion failed" }.to_json
  end

  content_type "text/csv"
  send_file output_path, filename: "deck.csv"
end
