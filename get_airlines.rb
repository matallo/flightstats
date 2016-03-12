require 'csv'
require 'typhoeus'
require 'json'

FLIGHTSTATS_URL = "https://api.flightstats.com/flex/airlines/rest/v1/json/all"
APPID = ""
APPKEY = ""

CSV.open("airlines.csv", "w") do |csv|
  # csv << airlines.first.keys
  csv << ["fs", "iata", "icao", "name", "active"]

  req_airline = Typhoeus::Request.new(
    "#{FLIGHTSTATS_URL}?appId=#{APPID}&appKey=#{APPKEY}",
    method: :get,
    headers: {
      "Content-Type" => "application/json"
    }
  )

  req_airline.on_complete do |res_airline|
    if res_airline.success?
      json = JSON.parse(res_airline.body)

      airlines = json['airlines']

      unless airlines.nil?
        airlines.each do |r|
          csv << r.values
        end

        puts "-- Saving airlines.csv"
      end
    elsif res_airline.timed_out?
      # aw hell no
      puts "got a time out"
    elsif res_airline.code == 0
      puts res_airline.return_message
    else
      puts "HTTP request failed: #{res_airline.code.to_s}"
    end
  end

  res_airline = req_airline.run
end
