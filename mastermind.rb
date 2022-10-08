module Messages
  def player_name
    'Enter your player name:'
  end

  def greeting(player)
    puts "Welcome #{player.name} to Mastermind!"
  end
end

module BoardColors
  def board_colors
    colors = ['blue', 'yellow', 'orange', 'red', 'white', 'black']
  end
end

class Player
  include Messages

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
      colors = board_colors
      @computer_code.push(colors[j])
    end
    puts "This is computer_code: #{@computer_code}" # for troubleshooting & testing
    @computer_code
  end
end

class Game
  include Messages

  attr_reader :code_to_crack

  def initialize()
    @code_to_crack = Computer.new.computer_code # This is how you call something from new class into an existing class. Create an instance of it. 
  end

  private
  
  def greeting(player)
    super
    player_guess()
  end

  def player_guess
    # resume here
    puts "This is code to crack: #{code_to_crack}"
  end

end

def start_game
  player = Player.new
  game = Game.new.greeting(player)
end

start_game()