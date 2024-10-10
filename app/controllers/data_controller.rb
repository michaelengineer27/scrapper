class DataController < ApplicationController 
  require "uri"
  require "net/http"
  require 'nokogiri'

  def scrap
    url = params[:url]
    fields = params[:fields]

    content = page_content(url)
    
    page = Nokogiri::HTML(content)
    data = {}
    (fields || []).each do |key, selector|
      if key == "meta"
        data["meta"] = {}
        selector.each { |tag|
          data["meta"][tag] = page.at("meta[name='#{tag}']")['content'] || ""
        }
      else
        data[key] = page.css(selector).text.strip
      end
    end

    render json: data
  end 

  private 

  def page_content(url)
    Rails.cache.fetch(url, expires_in: 1.hour) do
      puts "The URL is not cached. Getting live content ..."
      url = URI(url)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = https.request(request)
      
      tries = 0

      # Try until get a successful response
      while response.code != "200" && tries <= 20
        response = https.request(request)
        tries += 1 
      end

      return "unavailable" if tries > 10
      response.read_body
    end
  end
end