class User < ActiveRecord::Base
    has_many :portfolios
    has_many :stocks, through: :portfolios

    def get_symbols_portfolio
        self.stocks.map do |x, y|
            # binding.pry
            x.symbol 
        end 
    end 

    def look_up(symbol)
        response = Unirest.get "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/get-detail?region=US&lang=en&symbol=#{symbol}",
  headers:{
    "X-RapidAPI-Host" => "apidojo-yahoo-finance-v1.p.rapidapi.com",
    "X-RapidAPI-Key" => "dafb7f16bbmsh88ffcdd851dbd91p135ccbjsn8936bcff69ee"
  }
    # binding.pry
    puts "Name: #{response.body["quoteType"]["shortName"]}"
    puts "Symbol: #{response.body["quoteType"]["symbol"]}"
    puts "Last day's close: $#{response.body["price"]["regularMarketPreviousClose"]["raw"]}"
    puts "Percent Change: #{response.body["price"]["regularMarketChange"]["raw"]}%"

    stock_hash = {
        symbol: response.body["quoteType"]["symbol"],
        price: response.body["price"]["regularMarketPreviousClose"]["raw"],
        percent_change: response.body["price"]["regularMarketChange"]["raw"]
    }
    end 

    def look_up_earnings(symbol)
        response = Unirest.get "https://finnhub-realtime-stock-price.p.rapidapi.com/stock/earnings?symbol=#{symbol}",
        headers:{
            "X-RapidAPI-Host" => "finnhub-realtime-stock-price.p.rapidapi.com",
            "X-RapidAPI-Key" => "dafb7f16bbmsh88ffcdd851dbd91p135ccbjsn8936bcff69ee"
        }
    end 

   

    def buy_stock(symbol)
        hash = look_up(symbol)
        stock = Stock.find_or_create_by(hash)
        Portfolio.create(user_id: self.id, stock_id: stock.id)
    end 

    def sell_stock(symbol)
        stock = Stock.find_by(symbol: symbol)
        id = stock.id
    
        other = self.portfolios.find_by(stock_id: id)
        other.destroy
    end 

    def most_bought_stock
        new_stock = Stock.all.max_by do |stock|
            stock.users.count
        end

        puts new_stock.symbol
        puts new_stock.price
        puts new_stock.percent_change
    end 

    def highest_price_portfolio
        self.stocks.max_by do |stock|
            stock.price
        end 
    end 

end 