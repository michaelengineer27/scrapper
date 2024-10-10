require "test_helper"

class DataControllerTest < ActionDispatch::IntegrationTest

  @@url  = 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm'

  test "The scrapper should be able to scrap the page successfully" do
    payload = { url: @@url, "fields": {} }
    get '/data', params: payload
    assert_response :success
  end

  test "The scrapper should be able to find price" do
    payload = { url: @@url, "fields": {"price": ".price-box__price"} }
    get '/data', params: payload
    price = JSON.parse(response.body)["price"]
    assert_equal price, "20 990,-673,-"
  end

  test "The scrapper should be able to find rating count" do
    payload = { url: @@url, "fields": {"rating_count": ".ratingCount"} }
    get '/data', params: payload
    rating_count = JSON.parse(response.body)["rating_count"]
    assert_equal rating_count, "16 hodnocení"
  end

  test "The scrapper should be able to find rating value" do
    payload = { url: @@url, "fields": {"rating_value": ".ratingValue"} }
    get '/data', params: payload
    rating_value = JSON.parse(response.body)["rating_value"]
    assert_equal rating_value, "4,8"
  end
  
  test "The scrapper should be able to find meta tags" do
    payload = { url: @@url, "fields": {"meta":  ["keywords", "twitter:image"]} }
    get '/data', params: payload
    keywords = JSON.parse(response.body)['meta']["keywords"]
    twitter_image = JSON.parse(response.body)['meta']["twitter:image"]
    assert_equal keywords, "AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,Automatické pračky AEG,Chytré pračky,Chytré pračky AEG"
    assert_equal twitter_image, "https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360"
  end
  
end
