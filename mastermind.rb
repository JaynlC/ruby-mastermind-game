module Messages
  def player_name
    'Enter your player name:'
  end

  def new_line
    "\n"
  end

  def creator_guessor_query
    "Do you want to be the code creator or guessor? Type 'creator' or 'guessor' " 
  end

  def greeting(player)
    puts new_line()
    puts "Welcome #{player.name} to Mastermind!"
  end

  def color_options(colors)
    "This is the six colors you can choose from: #{colors}"
  end

  def player_choose_color
    "Choose your four colors in the desired order. Type your color choice, then press enter. Repeat till four colors are selected:"
  end

  def player_input_incorrect(input)
    "Please pick and spell correctly from the following: #{input}"
  end

  def end_game_message(player)
    "Thank You #{player.name} for Playing Mastermind!"
  end
end

module BoardColors
  attr_reader :colors

  def board_colors
    @colors = ['blue', 'yellow', 'orange', 'red', 'white', 'black']
  end
end

class Player
  include Messages, BoardColors

  attr_reader :name, :player_color_choices

  def initialize()
    puts player_name()
    @name = gets.chomp.capitalize
  end

  def color_choices
    colors = board_colors()
    @player_color_choices = []
    puts player_choose_color()
    4.times do
      @player_spelt_colors = false
      until @player_spelt_colors
        @player_color_choice = gets.chomp.strip.downcase
        for j in (0...colors.length) 
          if @player_color_choice == colors[j]
            player_color_choices.push(@player_color_choice)
            puts "Your color choices: #{player_color_choices}"
            @player_spelt_colors = true
            break
          end
        end
        unless @player_spelt_colors then puts player_input_incorrect(colors)
        end
      end
    end
    puts "Your four color choices are: #{player_color_choices}"
    player_color_choices
  end
end

class Computer
  include BoardColors, Messages
  
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

  attr_reader :player, :code_to_crack

  def initialize()
    @player = Player.new
    greeting(player)
  end

  def greeting(player)
    super
    creator_or_guessor()
  end

  private

  def creator_or_guessor
    puts creator_guessor_query()
    puts new_line()
    @game_selected = false
    until @game_selected
      @game_choice = gets.chomp.strip.downcase
      if @game_choice == "guessor"
        guessor_game_initialise()
        @game_selected = true
      elsif @game_choice == "creator"
        creator_game_initialise()
        @game_selected = true
      else puts player_input_incorrect("'creator' or 'guessor'")
      end
    end
  end

  def guessor_game_initialise()
    @game_player_is_guessor = true
    @code_to_crack = Computer.new.computer_code()
    @@player_guess_count = 0
    @@computer_guess_count = 0
    puts color_options(board_colors)
    player_guess()
  end

  def creator_game_initialise()
    @game_player_is_guessor = false
    @@computer_guess_count = 0
    @@player_guess_count = 0
    puts color_options(board_colors)
    @player_code = player.color_choices()
    @computer_guess = Computer.new.computer_code()
    feedback_variables(@player_code, @computer_guess)
  end

  def player_guess
    puts "This is the code to crack in player_guess #{code_to_crack}" # delete line once game draft complete
    @player_guesses = player.color_choices()
    @@player_guess_count += 1
    feedback_variables(@player_guesses, code_to_crack)
  end

  def feedback_variables(player_code, computer_code)
    @@matches = 0
    @@partials = 0
    analyse_matches(player_code.dup, computer_code.dup)
  end

  def analyse_matches(player_code, computer_code)
    @match_color_index = []
    player_code.each_with_index do |player_color, player_color_index| 
      if player_color == computer_code[player_color_index]
        @@matches += 1
        @match_color_index.push(player_color_index)
      end
    end
    delete_match_indices(player_code, @match_color_index)
    delete_match_indices(computer_code, @match_color_index)
    analyse_partials(player_code.dup, computer_code.dup)
  end

  def delete_match_indices(color_code, match_indices)
    color_code.reject!.with_index {|_color, index| match_indices.include? index }
  end

  def analyse_partials(player_code, computer_code)
    player_code.each_with_index do |player_color, player_color_index| 
      computer_code.each_with_index do |computer_color, computer_color_index|
        if player_color == computer_color && player_color_index != computer_color_index
          @@partials += 1
          computer_code.delete_at(computer_color_index)
          break
        end
      end
    end
    winner_check()
  end

  def winner_check
    puts "Total Matches: #{@@matches}"
    puts "Total Partials: #{@@partials}"
    if @@player_guess_count < 13 && @game_player_is_guessor == true
      puts "Number of guesses remaining: #{12 - @@player_guess_count}"
      @@matches == 4 ? winner_screen() : player_guess()
    elsif @@computer_guess_count < 13 && @game_player_is_guessor == false
      puts "Number of guesses remaining: #{12 - @@computer_guess_count}"
      @@matches == 4 ? winner_screen() : analyse_computer_guess()
    else lost_screen()
    end
  end

  def analyse_computer_guess()
    #resume here
    #make sure user is prompted every time PC enters a guess, i.e. make code creator interactive.
    puts "resume here"
  end

  def winner_screen
    puts new_line()
    puts "Congratulations, You win!"
    puts new_line()
    end_of_game()
  end

  def lost_screen
    puts "Unlucky you have lost."
    end_of_game()
  end

  def end_of_game
    @player_selected = false
    until @player_selected
      puts "Would you like to play again? Type 'yes' or 'no'"
      @answer = gets.chomp.strip.downcase
      if @answer == "yes"
        @player_selected = true
        greeting(player)
      elsif @answer == "no"
        @player_selected = true
        puts end_game_message(player)
      end
    end
  end
end


def start_game
  Game.new
end

start_game()