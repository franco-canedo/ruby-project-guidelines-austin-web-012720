require 'pry'
# User.destroy_all
# Stock.destroy_all
# Portfolio.destroy_all

mike = User.create(:name => 'Mike', :password => 'hello')
carlos = User.create(name: "Carlos", password: "bye")

aapl = Stock.create(symbol: "AAPL", price: 200, percent_change: 0.05)
msft = Stock.create(symbol: "MSFT", price: 100, percent_change: 0.10)

mike_aapl = Portfolio.create(user_id: mike.id, stock_id: aapl.id, shares: 10)
mike_msft = Portfolio.create(user_id: mike.id, stock_id: msft.id, shares: 20)

carlos_aapl = Portfolio.create(user_id: carlos.id, stock_id: aapl.id)



binding.pry

puts "hello"

