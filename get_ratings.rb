require 'csv'
require 'typhoeus'
require 'json'

FLIGHTSTATS_URL = "https://api.flightstats.com/flex/ratings/rest/v1/json/route"
APPID = ""
APPKEY = ""

CSV.open("ratings.csv", "w") do |csv|
  # csv << ratings.first.keys
  csv << ["departureAirportFsCode", "arrivalAirportFsCode", "airlineFsCode", "flightNumber", "codeshares", "directs", "observations", "ontime", "late15", "late30", "late45", "cancelled", "diverted", "ontimePercent", "delayObservations", "delayMean", "delayStandardDeviation", "delayMin", "delayMax", "allOntimeCumulative", "allOntimeStars", "allDelayCumulative", "allDelayStars", "allStars"]

  # from http://blog.cartodb.com/jets-and-datelines/
  # https://gist.githubusercontent.com/pramsey/8eae41eae99cb07fd9a7/raw/6cbc092b831a9c5d3c884400549a9ef64426db76/routes.csv
  CSV.foreach('routes.csv') do |row|
    req_rating = Typhoeus::Request.new(
      "#{FLIGHTSTATS_URL}/#{row[4]}/#{row[6]}?appId=#{APPID}&appKey=#{APPKEY}",
      method: :get,
      headers: {
        "Content-Type" => "application/json"
      }
    )

    req_rating.on_complete do |res_rating|
      if res_rating.success?
        json = JSON.parse(res_rating.body)

        ratings = json['ratings']

        unless ratings.nil?
          ratings.each do |r|
            # rating_id = "#{r['airlineFsCode']}#{r['flightNumber']}"
            csv << r.values
          end

          puts "-- Saving #{row[0]} in ratings.csv"
        end
      elsif res_rating.timed_out?
        # aw hell no
        puts "got a time out"
      elsif res_rating.code == 0
        puts res_rating.return_message
      else
        puts "HTTP request failed: #{res_rating.code.to_s}"
      end
    end

    res_rating = req_rating.run
  end
end
