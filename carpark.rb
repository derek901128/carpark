require 'httparty'
require 'nokogiri'
require 'uri'
require 'csv'

def fetch_record(uri)
    res = HTTParty.get(uri)
    time, space = Nokogiri::HTML(res)
        .css('table :nth-child(53) div')
        .map{|cell| cell.text }
        .values_at(1, 3)

    [time, space.strip.to_i]
end

url = URI('https://www.dsat.gov.mo/dsat/carpark_realtime_core.aspx')
last_updated = ""

loop do
    time, space = fetch_record(url)
    if time > last_updated
        last_updated = time
        CSV.open("parking.csv", "a"){ |csv| csv << [time, space] }
    else
        p "Nothing's changed"
    end
    sleep(10)
end