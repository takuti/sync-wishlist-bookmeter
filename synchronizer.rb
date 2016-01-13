require 'mechanize'
require 'nokogiri'

wishlist_url = ENV['WISHLIST_URL']
agent = Mechanize.new

asins = []
while wishlist_url
  page = agent.get(wishlist_url)
  doc = Nokogiri::HTML(page.content)

  # get asins
  item_urls = '//div[contains(@class, "g-item-details")]/div/div/div/h5/a/@href'
  asins.concat(doc.xpath(item_urls).map {|url| url.to_s.match(/\/dp\/([A-Z0-9]{10})\?/).captures[0] })

  # pagination
  wishlist_url = doc.xpath('//li[contains(@class, "a-last") and not(contains(@class, "a-disabled"))]/a/@href').first
end

# use number-only asins (= ISBN of books)
asins.select! {|asin| asin =~ /[0-9]{10}/ }
