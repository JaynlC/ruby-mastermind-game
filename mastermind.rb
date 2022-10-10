module Messages
  def player_name
    'Enter your player name:'
  end

  def greeting(player)
    puts "Welcome #{player.name} to Mastermind!"
  end

  def player_choose_color
    "Guess (and spell correctly) the four colors in the correct order. Type your color choice, then press enter. Repeat till four colors are selected:"
  end

  def player_input_incorrect(colors)
    "Please pick and spell correctly from the following six colors: #{colors}"
  end
end

module BoardColors
  attr_reader :colors

  def board_colors
    @colors = ['blue', 'yellow', 'orange', 'red', 'white', 'black']
  end
end

class Player
  include Messages

  attr_reader :name

  def initialize()  #MAKE SURE THE PARENTHSESIS IS HERE. Caused a bug. 
    puts player_name()
    @name = gets.chomp.capitalize
  end
end

class Computer
  include BoardColors, Messages
  
  # computer is creator
  def computer_code
  @computer_code = []
    for i in (1..4)
      j = rand(6)
      colors = board_colors()
      @computer_code.push(colors[j])
    end
    @computer_code
  end
end

class Game
  include Messages, BoardColors

  attr_reader :code_to_crack, :player_all_guesses

  def initialize()
    @code_to_crack = Computer.new.computer_code # This is how you call something from new class into an existing class. Create an instance of it. 
  end
  
  def greeting(player)
    super
    puts "This is the six colors you can choose from: #{board_colors()}"
    player_guess()
  end

  private

  def player_guess
    puts "This is code to crack: #{code_to_crack}" # troubleshooting, will be deleted in final draft
    colors = board_colors()
    @player_all_guesses = []
    puts player_choose_color()
    4.times do
      @player_spelt_colors = false
      until @player_spelt_colors
        @player_color_choice = gets.chomp.downcase
        for j in (0...colors.length) 
          if @player_color_choice == colors[j]
            player_all_guesses.push(@player_color_choice)
            puts "Your guesses are: #{player_all_guesses}"
            @player_spelt_colors = true
            break
          end
        end
        unless @player_spelt_colors then puts player_input_incorrect(colors)
        end
      end
    end
    compare_choice()
  end

  def compare_choice
    puts "Your four color guesses are: #{player_all_guesses}"
    #resume here
  end
end


def start_game
  player = Player.new
  game = Game.new.greeting(player)
end

start_game()