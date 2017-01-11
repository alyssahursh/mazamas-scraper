require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry-coolline'
require 'csv'
require 'mechanize'

# Fire up Mechanize
agent = Mechanize.new

CSV.open('leader_data.csv', 'w') do |csv|
  csv << ["First Name", "Last Name", "Image Link", "Climbing Since", "Leader Since", "Preferred Pace", "Climb On", "Volunteer Service", "Climbing Achievement", "Philosophy", "Summit Treat", "Profile"]
end

list_page = HTTParty.get('http://mazamas.org/about-us/climb-leader-profiles/')
parse_list_page = Nokogiri::HTML(list_page)

# Initialize an empty array to store the links
profile_pages = []

# Grab the right element type from the page
leader_section = parse_list_page.css('.nr-right-col-content').css('.gallery_thumb')

# Iterate through the leader_section and find each link and store it.
leader_section.each do |element|
  url = element.children[1].attr('href')
  profile_pages << url
end
puts "Start"
puts profile_pages
puts "Stop"

# Initalize an empty array to store all of the results
leader_array = []

# Iterate through the list of leader profile links
profile_pages.each do |address|
  puts address

  # Grab that link and parse it
  page = HTTParty.get(address)
  parse_page = Nokogiri::HTML(page)

  # Create an empty array to store this leader's data
  leader_data = []

  # Shovel each of the individual elements into the leader's data array
  begin
    leader_data << parse_page.css('.nr-right-col-content').css('h2').text.split(" ")[0]             # Leader First Name
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('h2').text.split(" ")[1]             # Leader Last Name
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('span')[0].children[0].attr('src')   # Image src
    name = parse_page.css('.nr-right-col-content').css('h2').text
    agent.get(parse_page.css('.nr-right-col-content').css('span')[0].children[0].attr('src')).save "~/ada/Capstone/app/assets/images/#{name}.jpg"
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[2].text.split(":")[1][1..-1]    # Climbing Since
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[3].text.split(":")[1][1..-1]    # Leader Since
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[4].text.split(":")[1][1..-1]    # Preferred Pace
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[5].text.split(":")[1][1..-1]    # Climb On
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[7].text                         # Volunteer Service
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[9].text                         # Climbing Achievement
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[11].text                        # Philosophy
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[13].text                        # Summit Treat
  rescue
    leader_data << ""
  end

  begin
    leader_data << parse_page.css('.nr-right-col-content').css('p')[15].text                        # Profile
  rescue
    leader_data << ""
  end

  # Shovel this leader's data into the csv
  CSV.open('leader_data.csv', 'a') do |csv|
    csv << leader_data
  end
end

Pry.start(binding)
