class Hangman
  attr_reader :secret_word

  def initialize
    @secret_word
    @hidden_word
    @display_word
    @mistakes = 0
  end

  def create_secret_word
    fname = "5desk.txt"
    random_word = File.readlines(fname).sample.strip  
    unless random_word.length.between?(5,12)
      random_word = File.readlines(fname).sample.strip  
    end
    @secret_word = random_word
  end

  def create_hidden_word
    @hidden_word = @secret_word.split("")
  end
  
  def create_display_word
    @display_word = @secret_word.split("").map { |char| "_" }
  end

  def create_words
    create_secret_word
    create_hidden_word
    create_display_word
  end

  def display_word
    puts "Type a char that you think this word has"
    @display_word.each { |char| print char + " "}
    print "\n"
  end

  def get_char
    char = gets.chomp
    get_char unless valid_char?(char)
    char
  end

  def valid_char?(char)
    char.length == 1 && char.match?(/[A-Za-z]/)
  end

  def check_char(char)
    if @hidden_word.include?(char)
      @hidden_word.each_with_index do |c, idx|
        @display_word[idx] = c if c == char
      end
    else
      made_mistake
    end
  end

  def made_mistake
    @mistakes += 1
  end

  def play_turn
    display_word
    check_char(get_char)
    puts "success"
  end

  def game_over
    @mistakes >= 5 || @display_word.join("") == @secret_word
  end

  def run
    create_words
    play_turn until @mistakes >= 5
    puts "The game has ended"
  end
end