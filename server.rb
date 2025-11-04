require "sinatra"
require "json"
require "apkg_to_csv"
require "sinatra/cross_origin"
require "fileutils"

# Enable CORS
configure do
  enable :cross_origin
  set :bind, "0.0.0.0"
  set :port, ENV["PORT"] || 4567
end

# Preflight requests (OPTIONS)
options "*" do
  response.headers["Allow"] = "HEAD,GET,POST,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Authorization, Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

# Before filter for all requests
before do
  response.headers["Access-Control-Allow-Origin"] = "*" # allow all origins
end

post "/convert" do
  unless params[:file]
    halt 400, { error: "No file uploaded" }.to_json
  end

  # Create tmp folder
  tmp_dir = "./tmp"
  FileUtils.mkdir_p(tmp_dir)

  tempfile = params[:file][:tempfile]
  timestamp = Time.now.to_i
  output_path = File.join(tmp_dir, "deck_#{timestamp}.csv")

  # Run conversion
  system("apkg-to-csv #{tempfile.path} > #{output_path}")

  # Check if CSV was created
  unless File.exist?(output_path)
    halt 500, { error: "Conversion failed" }.to_json
  end

  # Send CSV back
  content_type "text/csv"
  send_file output_path, filename: "deck.csv"
ensure
  # Cleanup tmp files older than 1 hour
  Dir.glob("#{tmp_dir}/*.csv").each do |file|
    File.delete(file) if File.mtime(file) < Time.now - 3600
  end
end
