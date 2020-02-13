
require_relative '../Models/user.rb'
class CommandLineInterface < User

    def greet
        puts FONT.write("STOCK PORTFOLIO")
        puts "Welcome to Your StockPorfolio, the best place to buy stocks!
        \n"
    end 

    def account?
        answer = PROMPT.ask("Do you have an account? type yes or no\n")
        
        if answer == "no"
            create_account
        else answer == "yes"
            log_in
        end 
    end 

    def create_account
        puts "Let's create a new account!"
        name = PROMPT.ask("Enter your new username:\n")
        password = ask("Enter a new password:  \n") { |q| q.echo = "*" }

        User.find_or_create_by(name: name, password: password)
        log_in
    end 

    def log_in
        name = PROMPT.ask("Type in your username to log in\n")
        @user = User.find_by(name: name)

        if !@user
            puts "Wrong username, click enter to try again."
            input = PROMPT.ask("Or type c to create account")
            if input == "c" || input == "C"
                create_account
            else 
                log_in
            end
        else 
            get_password
        end 
    end 

    def get_password
        input_password = ask("Type in your password:  \n") { |q| q.echo = "*" }
        
            if @user.password == input_password
                puts "\n" * 80
                choose_action
            elsif input_password == "q" || input_password == "Q"
                account?
            else 
                puts "Wrong password, try again!"
                puts "Or type q to quit"
                    get_password
            end 
    end 

    def choose_action
        puts "\n" *80
        puts "Welcome #{@user.name}!"
        choice = %w(Look_Up_Stock Buy_Stock View_Your_Portfolio View_Most_Popular_Stock Sell_Stock Log_Out)
        @input = PROMPT.select("Please choose an option", choice)
        perform_action
    end 
        
            
    def perform_action
        case @input
            when "Look_Up_Stock"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                response = @user.look_up(symbol.upcase)
               
                while response == nil do 
                    symbol = PROMPT.ask("Type in a stock symbol\n")
                    response = @user.look_up(symbol.upcase)
                end 
            when "Buy_Stock"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                shares = PROMPT.ask("Type in number of shares\n")
                @user.buy_stock(symbol.upcase, shares)
            when "View_Your_Portfolio"
                @user.get_symbols_portfolio
                portfolio_menu
            when "View_Most_Popular_Stock"
                @user.most_bought_stock
            when "Sell_Stock"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                shares = PROMPT.ask("Type in number of shares\n")
                @user.sell_stock(symbol.upcase, shares)
            when "Log_Out"
                @user = nil
                puts "\n" * 80
                puts "YOU HAVE BEEN LOGGED OUT!"
                puts "\n" * 5
                greet
                puts "\n" * 5
                account?
            else 
                puts "\n" * 50
                puts "Not a valid number, try again."
                choose_action
               
        end 
        back_to_menu
    end 

    def back_to_menu
        choices = %w(Main_Menu Log_Out)
        response = PROMPT.select("Options", choices)
        
        if response == "Main_Menu" 
            choose_action
        elsif response == "Log_Out"
            @user = nil
            puts "Goodbye"
            greet
            account?
        else 
            puts "Wrong command"
            back_to_menu
        end 
    end 

    def portfolio_menu
        choices = %w(Buy_Stock Sell_Stock Get_Stock_Earnings Get_Analyst_Recommendations Main_Menu)
        @portfolio_input = PROMPT.select("Please choose an uption", choices)
        portfolio_menu_case      
    end 

    def portfolio_menu_case
        case @portfolio_input
            when "Buy_Stock"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                shares = PROMPT.ask("Type in number of shares\n")
                @user.buy_stock(symbol.upcase, shares)
            when "Sell_Stock"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                shares = PROMPT.ask("Type in number of shares\n")
                @user.sell_stock(symbol.upcase, shares)
            when "Get_Stock_Earnings"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                @user.look_up_earnings(symbol.upcase)
            when "Get_Analyst_Recommendations"
                symbol = PROMPT.ask("Type in a stock symbol\n")
                @user.get_analyst_recommendations(symbol.upcase)
            when "Main_Menu"
                choose_action
            else 
                puts "Wrong command"
                portfolio_menu
        end 
        @user.get_symbols_portfolio
        portfolio_menu

        
    end 
        
    
end 