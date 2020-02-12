class User < ActiveRecord::Base 
    has_many :portfolios
    has_many :stocks, through: :portfolios

    def  get_portfolio_stocks
        user_id = self.id 
        array = Portfolio.where(user_id: user_id)
        
        stock_ids = array.map do |relationship|
            relationship.stock_id
        end 
        output = stock_ids.map do |id|
            Stock.where("id = ?", id)
        end
    end 

    def get_symbols_portfolio
        output = get_portfolio_stocks

        market_value = get_portfolio_stocks.sum do |stock, y|
            stock.price
        end 
        stock_and_price = output.map do |x, y|
             "#{x.symbol}  $#{x.price}"
        end 

        symbols = output.map do |x, y|
            "#{x.symbol}"
       end 
        if stock_and_price == []
            puts "\n" * 10
            puts "Your portfolio is empty."
        else 
            puts "\n" * 10
            puts "Your porfolio has these stocks:"
            puts stock_and_price
            puts "\nYour Total Portfolio Market Value: $#{market_value}"
        end 
        symbols
    end 

    def look_up(symbol)
        response = Unirest.get "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/get-detail?region=US&lang=en&symbol=#{symbol}",
        headers:{
            "X-RapidAPI-Host" => "apidojo-yahoo-finance-v1.p.rapidapi.com",
            "X-RapidAPI-Key" => "dafb7f16bbmsh88ffcdd851dbd91p135ccbjsn8936bcff69ee"
        }
    
        if response.body != ""
            puts "\n" * 80
            puts "Name: #{response.body["quoteType"]["shortName"]}"
            puts "Symbol: #{response.body["quoteType"]["symbol"]}"
            puts "Last day's close: $#{response.body["price"]["regularMarketPreviousClose"]["raw"]}"
            puts "Percent Change: #{response.body["price"]["regularMarketChange"]["raw"]}%"

            stock_hash = {
                symbol: response.body["quoteType"]["symbol"],
                price: response.body["price"]["regularMarketPreviousClose"]["raw"],
                percent_change: response.body["price"]["regularMarketChange"]["raw"]
            }
        else 
            puts "Invalid stock symbol"
            
        end 
    end 

    def look_up_earnings(symbol)
        response = Unirest.get "https://finnhub-realtime-stock-price.p.rapidapi.com/stock/earnings?symbol=#{symbol}",
        headers:{
            "X-RapidAPI-Host" => "finnhub-realtime-stock-price.p.rapidapi.com",
            "X-RapidAPI-Key" => "dafb7f16bbmsh88ffcdd851dbd91p135ccbjsn8936bcff69ee"
        }
        puts "\n" * 40
        puts "#{symbol} earnings for the last 4 quarters:\n
        "
        puts "  EPS |  DATE"
        puts "$#{response.body[0]["actual"]} | #{response.body[0]["period"]}"
        puts "$#{response.body[1]["actual"]} | #{response.body[1]["period"]}"
        puts "$#{response.body[2]["actual"]} | #{response.body[2]["period"]}"
        puts "$#{response.body[3]["actual"]} | #{response.body[3]["period"]}"
        
        
    end 

    def get_analyst_recommendations(symbol)
                response = Unirest.get "https://finnhub-realtime-stock-price.p.rapidapi.com/stock/recommendation?symbol=#{symbol}",
        headers:{
            "X-RapidAPI-Host" => "finnhub-realtime-stock-price.p.rapidapi.com",
            "X-RapidAPI-Key" => "dafb7f16bbmsh88ffcdd851dbd91p135ccbjsn8936bcff69ee"
        }
        puts "\n" * 40
        puts "#{symbol} analyst recommendations for this month:
        "
        puts "BUY: #{response.body[0]["buy"]}"
        puts "HOLD: #{response.body[0]["hold"]}"
        puts "SELL: #{response.body[0]["sell"]}"
        puts "STRONG BUY: #{response.body[0]["strongBuy"]}"
        puts "STRONG SELL: #{response.body[0]["strongSell"]}"
        
        # binding.pry

        
    end 

   

    def buy_stock(symbol)
        hash = look_up(symbol)
        if hash != nil
            stock = Stock.find_or_create_by(symbol: hash[:symbol])
            stock.update(price: hash[:price])
            stock.update(percent_change: hash[:percent_change])
            Portfolio.create(user_id: self.id, stock_id: stock.id)
            puts "\n" * 80
            puts FONT.write("#{symbol}") 
            puts "You bought #{symbol} stock."
        end
    end 

    def sell_stock(symbol)

        if !get_symbols_portfolio.any? do |stock|
            stock == symbol.upcase
            end
            puts "You don't own #{symbol} stock."
        else 
        
            stock = Stock.find_by(symbol: symbol)
            id = stock.id
            
            other = self.portfolios.find_by(stock_id: id)
            other.destroy
            puts "\n" * 80
            puts FONT.write("#{symbol}")  
            puts "You just sold #{symbol} stock."
        end 
        
    end 

    def most_bought_stock
        new_stock = Stock.all.max_by do |stock|
            stock.users.count
        end
        puts "\n" * 80
        puts "This is the most bought stock:"
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