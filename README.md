# Scraping
A scraper built to grab data from [mazamas.org](http://www.mazamas.org), rearrange it, and use the results to grab related data from [summitpost.org](http://www.summitpost.org)

## About
This scraper was built to scrape data for use in a [web application](https://github.com/alyssahursh/mazamas) for the [Mazamas](http://mazamas.org).

Using the Ruby gems HTTParty and Nokogiri, I created a small scraping script that (with permission from the Mazamas) spoofs authentication on [mazamas.org](http://mazamas.org) and collects information about the Mazamas climb leaders and the mountains and routes on which the organization schedules climbs.

I then used the mountain and route information scraped from the Mazamas to scrape [Summit Post](http://www.summitpost.org) for additional information (such as summit coordinates and elevation). 

From there, I was able to seed a route database for use by the [web application](https://github.com/alyssahursh/mazamas).
