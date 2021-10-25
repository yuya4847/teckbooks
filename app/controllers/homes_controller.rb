require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'

class HomesController < ApplicationController
  def home
  end

  def search
    if user_signed_in?

      @search_keyword = "#{params[:search_content]}"
        @books = RakutenWebService::Books::Book.search(title: "#{@search_keyword}", booksGenreId: "001005")

        if Rails.env == 'development'
          url = "http://book.tsuhankensaku.com/hon/index.php?t=booksearch&q=#{@search_keyword}&sort="
          charset = nil
          html = URI.open(url) do |f|
            charset = f.charset
            f.read
          end
          page = Nokogiri::HTML.parse(html, nil, charset)
          page_count = page.xpath('//div[@id="pagehandle"]/span').count
          sleep 0.3
          @amazon_isbns = []
          @amazon_links = []

         page_count.times do |page_number|
           url = "http://book.tsuhankensaku.com/hon/index.php?t=booksearch&q=#{@search_keyword}&sort=&page=#{page_number + 1}"
           charset = nil
           html = URI.open(url) do |f|
             charset = f.charset
             f.read
           end
           page_html = Nokogiri::HTML.parse(html, nil, charset)

           page_html.xpath('//div[@class="itemtitle"]/a').each do |book|
             @amazon_links << book.attribute('href').value
           end

           page_html.xpath('//td[@class="itemdetail"]/div[5]').each do |book|
             @amazon_isbns << book.text[16..28]
           end
           sleep 0.3
         end

         @amazon_books = []
         @amazon_links.count.times do |num|
           amazon_book = {
             isbn: "#{@amazon_isbns[num]}",
             link: "#{@amazon_links[num]}"
           }
           @amazon_books << amazon_book
         end
        end

        if Rails.env == 'production'
          yahoo_url = URI.parse("https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=#{ENV['YAHOO_PRO_ID']}&genre_category_id=10002&query=#{@search_keyword}")
          yahoo_json = Net::HTTP.get(yahoo_url)
          yahoo_books = JSON.parse(yahoo_json)['hits']
        end
        if Rails.env == 'development'
          yahoo_url = URI.parse("https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=#{ENV['YAHOO_DEV_ID']}&genre_category_id=10002&query=#{@search_keyword}")
          yahoo_json = Net::HTTP.get(yahoo_url)
          yahoo_books = JSON.parse(yahoo_json)['hits']
        end

        google_url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=#{@search_keyword}&country=JP&maxResults=15")
        google_json = Net::HTTP.get(google_url)
        google_books = JSON.parse(google_json)['items']

        @api_books = []
        @books.each do |book|

          @yahoo_link = nil
          yahoo_books.each do |yahoo_book|
            if yahoo_book['code'][16..19] == book.isbn.to_s[8..11]
              @yahoo_link = yahoo_book['url']
            end
          end

          @google_link = nil
          google_books.each do |google_book|
            if google_book['volumeInfo']['industryIdentifiers']
              if google_book['volumeInfo']['industryIdentifiers'][1]
                if google_book['volumeInfo']['industryIdentifiers'][1]['type'] == "ISBN_13"
                  google_isbn13 = google_book['volumeInfo']['industryIdentifiers'][1]['identifier']
                end
              end
              if google_book['volumeInfo']['industryIdentifiers'][0]
                if google_book['volumeInfo']['industryIdentifiers'][0]['type'] == "ISBN_13"
                  google_isbn13 = google_book['volumeInfo']['industryIdentifiers'][0]['identifier']
                end
              end

              if google_isbn13 == book.isbn
                @google_link = google_book['volumeInfo']['infoLink']
                @page_count = google_book['volumeInfo']['pageCount']
              end
            end
          end

          if Rails.env == 'development'
            @amazon_books.each do |amazon_book|
              if amazon_book[:isbn] == book.isbn
                @amazon_link = amazon_book[:link]
              end
            end
          end

          book_data = {
            rakuten: {
              title: "#{book.title}",
              isbn: "#{book.isbn}",
              price: "#{book.item_price}",
              sales_date: "#{book.sales_date}",
              caption: "#{book.item_caption}",
              rakuten_image_url: "#{book.medium_image_url}",
              rakuten_url: "#{book.item_url}"
            },
            google: {
              google_url: "#{@google_link}",
              page_count: "#{@page_count}"
            },
            yahoo: {
              yahoo_url: "#{@yahoo_link}"
            },
            amazon: {
              amazon_url: "#{@amazon_link}"
            }
          }
          @api_books << book_data
        end
        contents = { content: render_to_string(partial: 'homes/items.html.erb', locals: { api_books: @api_books } )}
        render json: contents
    end
  end
end
