require 'mechanize'
require 'nokogiri'

class Synchronizer
  def initialize
    @agent = Mechanize.new
    @base_url = 'http://bookmeter.com'
    login
    bookmeter_asins
  end

  def sync
    wishlist_asins.each {|asin| add_book(asin) }
  end

  private

  def login
    login_url = @base_url + '/login'

    @agent.get(login_url) do |page|
      page.form_with(:action => '/login') do |form|
        formdata = {
          :mail => ENV['BOOKMETER_MAIL'],
          :password => ENV['BOOKMETER_PASSWORD'],
        }
        form.field_with(:name => 'mail').value = formdata[:mail]
        form.field_with(:name => 'password').value = formdata[:password]
      end.submit
    end
    self
  end

  def wishlist_asins
    wishlist_url = ENV['WISHLIST_URL']

    asins = []
    while wishlist_url
      page = @agent.get(wishlist_url)
      doc = Nokogiri::HTML(page.content)

      # get asins
      item_urls = '//div[contains(@class, "g-item-details")]/div/div/div/h5/a/@href'
      asins.concat(doc.xpath(item_urls).map {|url| url.to_s.match(/\/dp\/([A-Z0-9]{10})\?/).captures[0] })

      # pagination
      wishlist_url = doc.xpath('//li[contains(@class, "a-last") and not(contains(@class, "a-disabled"))]/a/@href').first
    end

    # use number-only asins (= ISBN-10 of books)
    asins.select {|asin| asin =~ /[0-9]{10}/ }
  end

  def bookmeter_asins
    # noop
  end

  def add_book(asin)
    post_url = @base_url + '/action/add_book_quick.php'
    data = { :asin => asin, :type => 'pre', :from_dialog => 1, :from_page => 'book', :mixi_not_post => 1, :facebook_not_post => 1, :twitter_not_post => 1 }
    @agent.post post_url, data
  end

  def remove_book(asin)
    # noop
  end
end

Synchronizer.new.sync
