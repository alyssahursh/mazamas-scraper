require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry-coolline'
require 'csv'
require 'mechanize'


# Clear out the mountain data csv and write in the headers
CSV.open('mountain_data.csv', 'w') do |csv|
  csv << ["Peak", "State", "Country", "Continent", "Summit Post Link", "Latitude", "Longitude", "Google Link", "Summit Post Name", "Elevation Feet", "Elevation Meters"]
end



# Open the CSV with the links I manually collected
CSV.foreach('mountain_links_spreadsheet.csv', 'r') do |line|
  puts line[1]

  if !line[1].nil? && !line[1] != "Summit Post Link"
    page = HTTParty.get(line[1])
    parse_page = Nokogiri::HTML(page)

    mountain_info = []

    mazamas_name = line[0]
    mountain_info << mazamas_name

    begin
      state = parse_page.css('.data_box').children[3].children[1].children[3].children[1].text.split(', ')[0].strip  # State
      mountain_info << state
    rescue
      mountain_info << ""
    end

    begin
      country = parse_page.css('.data_box').children[3].children[1].children[3].children[1].text.split(', ')[1].strip  # Country
      mountain_info << country
    rescue
      mountain_info << ""
    end

    begin
      continent = parse_page.css('.data_box').children[3].children[1].children[3].children[1].text.split(', ')[2].strip  # Continent
      mountain_info << continent
    rescue
      mountain_info << ""
    end

    begin
      summit_post_link = line[1]
      mountain_info << summit_post_link
    rescue
      mountain_info << ""
    end

    begin
      latitude = parse_page.css('.data_box').children[3].children[1].children[5].children[2].attr('href').split("lat_1=")[1].split("&distance")[0] # Latitude
      mountain_info << latitude
    rescue
      mountain_info << ""
    end

    begin
      longitude = parse_page.css('.data_box').children[3].children[1].children[5].children[2].attr('href').split("lon_1=")[1].split("&map")[0]  # Longitude
      mountain_info << longitude
    rescue
      mountain_info << ""
    end

    begin
      google_link = "https://www.google.com/maps/place/#{latitude},#{longitude}"
      mountain_info << google_link
    rescue
      mountain_info << ""
    end

    begin
      summit_post_name = parse_page.css('.data_box').children[3].children[1].children[7].children[1].text.strip # Summit Post Name
      mountain_info << summit_post_name
    rescue
      mountain_info << ""
    end

    elevation_index = 0

    begin
      if parse_page.css('.data_box').children[3].children[1].children[9].children[1].text.split(" ").length == 5
        elevation_index = 9
      elsif parse_page.css('.data_box').children[3].children[1].children[11].children[1].text.split(" ").length == 5
        elevation_index = 11
      elsif parse_page.css('.data_box').children[3].children[1].children[13].children[1].text.split(" ").length == 5
        elevation_index = 13
      elsif parse_page.css('.data_box').children[3].children[1].children[15].children[1].text.split(" ").length == 5
        elevation_index = 15
      elsif parse_page.css('.data_box').children[3].children[1].children[17].children[1].text.split(" ").length == 5
        elevation_index = 17
      end

      begin
        elevation_feet = parse_page.css('.data_box').children[3].children[1].children[elevation_index].children[1].text.split(" ")[0] # Elevation in Feet
        mountain_info << elevation_feet
      rescue
        mountain_info << ""
      end

      begin
        elevation_meters = parse_page.css('.data_box').children[3].children[1].children[elevation_index].children[1].text.split(" ")[3] # Elevation in meters
        mountain_info << elevation_meters
      rescue
        mountain_info << ""
      end
    rescue
    end





  else
    mountain_info = []
    mountain_info << line[0] # Mazamas Name
    mountain_info << line[2] # State/Location
  end

  # Shovel the scraped data into the csv
  CSV.open('mountain_data.csv', 'a') do |csv|
    csv << mountain_info
  end

  # Pry.start(binding)

end
