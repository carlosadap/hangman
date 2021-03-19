# frozen_string_literal: true

class Hangman
  attr_reader :secret_word

  def initialize(n_guesses = 5)
    @n_guesses = n_guesses
    @secret_word
    @hidden_word
    @display_word
    @mistakes_array = []
  end

  def create_secret_word
    fname = '5desk.txt'
    random_word = File.readlines(fname).sample.strip
    random_word = File.readlines(fname).sample.strip unless random_word.length.between?(5, 12)
    @secret_word = random_word.downcase
  end

  def create_hidden_word
    @hidden_word = @secret_word.split('')
  end

  def create_display_word
    @display_word = @secret_word.split('').map { |_char| '_' }
  end

  def create_words
    puts 'Creating a new word...'
    create_secret_word
    create_hidden_word
    create_display_word
  end

  def display_word
    puts 'Type a char that you think this word has'
    puts 'Or "save" to save the game'
    @display_word.each { |char| print "#{char} " }
    print "\n"
  end

  def display_attempts
    unless @mistakes_array.length.zero?
      puts 'You tried these charactares already:'
      @mistakes_array.each { |char| print "#{char} " }
      print "\n"
    end
  end

  def get_char
    char = gets.chomp
    get_char unless valid_char?(char) || save_game?(char)
    char
  end

  def save_game?(char)
    char == 'save'
  end

  def save_game
    puts "What is the name of the save file?"
    fname = gets.chomp
    if file_exists?(fname)
      puts "File already exists"
      save_game
    end
    save_file(fname)
  end

  def save_file(fname)
    File.write("./saves/#{fname}", "#{@n_guesses}\n#{@secret_word}\n#{@hidden_word}\n#{@display_word}")
  end

  def file_exists?(fname)
    File.exists?("./saves/#{fname}")
  end

  def valid_char?(char)
    char.length == 1 && char.match?(/[A-Za-z]/)
  end

  def check_char(char)
    char = char.downcase
    if @hidden_word.include?(char)
      @hidden_word.each_with_index do |c, idx|
        @display_word[idx] = c if c == char
      end
    elsif @mistakes_array.include?(char)
      puts 'You already tried this chararacter'
    else
      made_mistake(char)
    end
  end

  def made_mistake(char)
    @mistakes_array << char
    print "The secret word doesn't contain the character #{char}\n\n"
  end

  def play_turn
    display_word
    display_attempts
    char = get_char
    save_game?(char) ? save_game : check_char(char)
  end

  def game_over
    @mistakes_array.length >= @n_guesses || @display_word.join('') == @secret_word
  end

  def check_ending
    if @mistakes_array.length >= @n_guesses
      puts 'Too many mistakes, you lost'
      puts "The secret word was #{secret_word}"
    else
      puts "You made it! The secret word was #{secret_word}"
    end
  end

  def ask_load
    puts 'Would like to load a saved game? (y/n)'
    gets.chomp == "y" ? load_game : create_words
  end

  def load_game
    puts 'What is the name of the file?'
    fname = gets.chomp
    if file_exists?(fname)
      save_file = File.open("./saves/#{fname}")
      file_data = save_file.readlines.map(&:chomp)
      puts file_data
      @n_guesses, @secret_word, @hidden_word, @display_word = file_data
      @n_guesses = @n_guesses.to_i
      save_file.close
    else
      puts "The file '#{fname}' doesn't exist"
      ask_load
    end
  end

  def run
    ask_load
    play_turn until game_over
    check_ending
  end
end
