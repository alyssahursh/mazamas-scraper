require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry-coolline'
require 'csv'
require 'mechanize'

# Open the file
CSV.open('route_data.csv', 'w') do |csv|
  csv << ["Full Route Name", "Route Name", "State", "Location", "Elevation", "Climb Grade", "Elevation Gain", "Driving Distance", "Driving Time", "Typical Duration", "Typical Season", "Glaciated Peak", "Rock Skills Required", "Snow Skills Required", "Rappelling Required", "Crevase Rescue Skills Required", "Typical Gear", "Notes", "Guide Books", ""]
end

# Initialize an empty array to store route links
route_links = []

# Read in the html doc
doc = File.open("all_route_links.html") { |f| Nokogiri::HTML(f) }

# Grab the children!
list_items = doc.css('li ul li').children

# Add links to the route_links array
list_items.each do |item|
  link = item.attr('href')
  route_links << link
end

# Iterate through those links and do something!
route_links.each do |link|

  puts link
  begin
    route_page = HTTParty.get(
      link,
      headers: {
        'Cookie' => "__atssc=google%3B5; mazamas2014_last_visit=1484112798; mazamas2014_last_activity=1484121464; mazamas2014_csrf_token=d19e94ec4ef53d6c5e2f7bd37b89fc9dcf06937c; mazamas2014_expiration=1484128664; __atuvc=21%7C50%2C23%7C51%2C6%7C1%2C79%7C2; __atuvs=5875dca85674b887006; __utmt=1; __utma=41170110.887046104.1481678275.1484112550.1484119210.26; __utmb=41170110.7.10.1484119210; __utmc=41170110; __utmz=41170110.1484119210.26.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); mazamas2014_sessionid=e344bb31fab707de79c512582d9902b476759254; mazamas2014_tracker=%7B%220%22%3A%22index%22%2C%22token%22%3A%2202f630cb272fc3199fa78958457d0083%22%7D",
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
      }
    )

    parse_route_page = Nokogiri::HTML(route_page)

    route_data = []

    begin
      route_data << parse_route_page.css('.nr-right-col-content').css('h1').text # Full Route Name
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[1].children[3].children[0].children[0].text   # Route Name
    rescue
      route_data << ""
    end

    route_data << link.split(".org/")[1].split("-")[0] # State

    begin
      route_data << parse_route_page.css('.nr-route').children[3].children[3].children[0].children[0].text   # Location
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[5].children[3].children[0].children[0].text   # Elevation
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[7].children[3].children[0].children[0].text   # Climb Grade
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[9].children[3].children[0].children[0].text   # Elevation Gain
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[11].children[3].children[0].children[0].text   # Driving Distance
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[13].children[3].children[0].children[0].text   # Driving Time
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[15].children[3].children[0].children[0].text   # Typical Duration
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[17].children[3].children[0].children[0].text   # Typical Season
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[19].children[3].children[0].children[0].text   # Glaciated Peak
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[21].children[3].children[0].children[0].text   # Rock Skills Required
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[23].children[3].children[0].children[0].text   # Snow Skills Required
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[25].children[3].children[0].children[0].text   # Rappelling Required
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[27].children[3].children[0].children[0].text   # Crevasse Rescue Skills Required
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[29].children[3].children[0].children[0].text   # Typical Gear
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[31].children[3].children[0].children[0].text   # Notes
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[33].children[3].children[0].children[0].text   # Guide Books
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[35].children[3].children[0].children[0].children[0].attr('href') # Maps
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[37].children[3].children[0].children[0].text   # Phone Numbers
    rescue
      route_data << ""
    end

    begin
      route_data << parse_route_page.css('.nr-route').children[39].children[3].children[0].children[0].children[0].attr('href') # Web Resources
    rescue
      route_data << ""
    end
  rescue
    route_data = ["Could not collect data for #{link}"]
  end

  # Pry.start(binding)


  CSV.open('route_data.csv', 'a') do |csv|
    csv << route_data
  end

end
