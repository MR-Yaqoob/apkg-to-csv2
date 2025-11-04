require "sinatra"
require "json"
require "apkg_to_csv"
require "sinatra/cross_origin"
require "fileutils"

# Enable CORS
configure do
  enable :cross_origin
end

# Allow preflight requests (OPTIONS)
options "*" do
  response.headers["Allow"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Authorization, Token"
  200
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*' # Allow all origins
end

set :port, ENV["PORT"] || 4567
set :bind, "0.0.0.0"

post "/convert" do
  # Check file upload
  unless params[:file]
    halt 400, { error: "No file uploaded" }.to_json
  end

  # Create temp folder if not exists
  FileUtils.mkdir_p("./tmp")

  tempfile = params[:file][:tempfile]
  timestamp = Time.now.to_i
  output_path = "./tmp/deck_#{timestamp}.csv"

  # Run conversion using apkg-to-csv
  system("apkg-to-csv #{tempfile.path} > #{output_path}")

  # Check if output exists
  unless File.exist?(output_path)
    halt 500, { error: "Conversion failed" }.to_json
  end

  # Send CSV back
  content_type "text/csv"
  send_file output_path, filename: "deck.csv"
end
