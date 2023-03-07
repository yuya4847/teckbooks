require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'

class HomesController < ApplicationController
  def guest_sign_in
    user = User.where(email: 'example@samp.com')[0]
    sign_in user
    flash[:notice] = "ゲストログインしました。"
    redirect_to userpage_path(user.id)
  end

  def guest_sign_in_review_show
    user = User.where(email: 'example@samp.com')[0]
    sign_in user
    flash[:notice] = "ゲストログインしました。"
    redirect_to review_path(params[:id])
  end

  def home
    @knetaki_review = Review.find(1)
    @azarashi_review = Review.find(2)
    @kumamon_review = Review.find(3)
  end

  def terms
  end

  def privacy_policy
  end

  def suggest
    @search_keyword = "#{params[:suggest_content]}"
    @suggest_books = RakutenWebService::Books::Book.search(title: "#{@search_keyword}", booksGenreId: "001005").first(15)
    suggest_titles = []
    @suggest_books.each do |suggest_book|
      suggest_titles << suggest_book.title
    end
    contents = { suggest_books: suggest_titles }
    render json: contents
  end

  def search
    if user_signed_in?
      @search_keyword = "#{params[:search_content]}"
      @books = RakutenWebService::Books::Book.search(title: "#{@search_keyword}", booksGenreId: "001005")
      url = URI.encode("http://book.tsuhankensaku.com/hon/index.php?t=booksearch&q=#{@search_keyword}&sort=")
      charset = nil
      html = URI.open(url) do |f|
        charset = f.charset
        f.read
      end
      page = Nokogiri::HTML.parse(html, nil, charset)
      page_count = page.xpath('//div[@id="pagehandle"]/span').count
      @amazon_isbns = []
      @amazon_links = []

      page_count.times do |page_number|
        url = URI.encode("http://book.tsuhankensaku.com/hon/index.php?t=booksearch&q=#{@search_keyword}&sort=&page=#{page_number + 1}")
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
        sleep 1.0
      end

      @amazon_books = []
      @amazon_links.count.times do |num|
        amazon_book = {
          isbn: "#{@amazon_isbns[num]}",
          link: "#{@amazon_links[num]}",
        }
        @amazon_books << amazon_book
      end

      yahoo_url = URI.parse(URI.encode("https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=#{ENV['YAHOO_PRO_ID']}&genre_category_id=10002&query=#{@search_keyword}"))
      yahoo_json = Net::HTTP.get(yahoo_url)
      yahoo_books = JSON.parse(yahoo_json)['hits']

      google_url = URI.parse(URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{@search_keyword}&country=JP&maxResults=15"))
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

        @amazon_books.each do |amazon_book|
          if amazon_book[:isbn] == book.isbn
            @amazon_link = amazon_book[:link]
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
            rakuten_url: "#{book.item_url}",
          },
          google: {
            google_url: "#{@google_link}",
            page_count: "#{@page_count}",
          },
          yahoo: {
            yahoo_url: "#{@yahoo_link}",
          },
          amazon: {
            amazon_url: "#{@amazon_link}",
          },
        }
        @api_books << book_data
      end
      contents = { content: render_to_string(partial: 'homes/items.html.erb', locals: { api_books: @api_books }) }
      render json: contents
    end
  end
end
