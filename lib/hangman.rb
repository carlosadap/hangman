class Hangman
  def initialize
    @secret_word = secret_word
  end

  def secret_word
    fname = "5desk.txt"
    random_word = File.readlines(fname).sample.strip  
    unless random_word.length.between?(5,12)
      random_word = File.readlines(fname).sample.strip  
    end
    random_word
  end

  def display_word
    
  end
end