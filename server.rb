require "sinatra"
require "json"
require "apkg_to_csv"

set :port, ENV["PORT"] || 4567
set :bind, "0.0.0.0"

post "/convert" do
  content_type "application/json"

  unless params[:file]
    halt 400, { error: "No file uploaded" }.to_json
  end

  tempfile = params[:file][:tempfile]
  output_path = "./tmp/#{Time.now.to_i}.csv"
  Dir.mkdir("./tmp") unless Dir.exist?("./tmp")

  # Run the conversion using the gem
  system("apkg-to-csv #{tempfile.path} > #{output_path}")

  # Send the converted CSV back
  content_type "text/csv"
  send_file output_path, filename: "deck.csv"
end
