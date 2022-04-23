require 'csv'
require 'json'

class Hangman
    def initialize(word, correct_letters, wrong_letters=[], guessed_letters=[], guesses_left=10)
        @word = word
        @correct_letters = correct_letters
        @wrong_letters = wrong_letters
        @guessed_letters = guessed_letters
        @guesses_left = guesses_left
    end

    private
    def check_guess(guess)
        @guessed_letters.push(guess)
        word_array = @word.split('')
        if @word.include? guess
            puts "Correct!"
            until word_array.index(guess) == nil
                char_index = word_array.index(guess)
                @correct_letters[char_index] = guess
                word_array[char_index] = nil
            end
        else
            puts "Letter not in word."
            @wrong_letters.push(guess)
            @guesses_left -= 1
        end
    end
    
    public
    def to_json
        JSON.dump ({
            :word => @word,
            :correct_letters => @correct_letters,
            :wrong_letters => @wrong_letters,
            :guessed_letters => @guessed_letters,
            :guesses_left => @guesses_left
        })
    end

    def self.from_json(string)
        data = JSON.load string
        self.new(data['word'], data['correct_letters'], data['wrong_letters'], data['guessed_letters'], data['guesses_left'])
    end

    def display
        puts @correct_letters.join(" ")
        puts "incorrect letters: #{@wrong_letters.join(", ")}"
        puts "guesses left: #{@guesses_left}"
    end

    def get_guess
        while true do
            print "Enter guess: "
            guess = gets.chomp.downcase
            if guess == 'save'
                return 'save game'
            elsif @guessed_letters.include? guess
                puts "Guess was already guessed"
            elsif guess.match?(/[[:alpha:]]/) && guess.length == 1
                check_guess(guess)
                break
            else
                puts "Invalid guess. Must input one letter"
            end
        end
    end

    def game_end?
        if @correct_letters.join == @word
            puts "\nCongrats, you won!"
            puts "Secret word: #{@word}"
            true
        elsif @guesses_left == 0
            puts "\nGave over, no tries left."
            puts "Secret word: #{@word}"
            true
        end
    end
end

def generate_word
    words = CSV.open('word_list.csv', headers: false).readlines
    while true do
        word = words.sample[0]
        return word unless word.length < 5 || word.length > 12
    end
end

def set_dashes(word)
    dashes = []
    word.length.times {dashes.push("_")}
    dashes
end

def load_saved?
    if File.read("saved_game.json") == ""
        return false
    end
    puts "Would you like to load your previously saved game? (yes/no)"
    load_saved = gets.chomp.downcase
    return load_saved == 'yes'
end

def save_game(game)
    File.open('saved_game.json', 'w') {|file| file.puts game.to_json}
end

load_saved = load_saved?()
if load_saved
    game = Hangman.from_json(File.read('saved_game.json').chomp)
else
    word = generate_word()
    dashed_word = set_dashes(word)
    game = Hangman.new(word, dashed_word)
end

puts "\nIf at any point, you would like to save your game's progress, enter 'save' as your guess"
while true do # game loop, break when game over
    game.display
    save_game = game.get_guess
    if save_game == 'save game'
        puts "\nGame Saved"
        save_game(game)
        break
    end
    break if game.game_end?
    puts # add space after every turn
end