require 'csv'

class Hangman
    def initialize
        @word = generate_word()
        @correct_letters = set_dashes(@word)
        @wrong_letters = []
        @guessed_letters = []
        @guesses_left = 10
    end

    private
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
    def display
        puts @correct_letters.join(" ")
        puts "incorrect letters: #{@wrong_letters.join(", ")}"
        puts "guesses left: #{@guesses_left}"
    end

    def get_guess
        while true do
            print "Enter guess: "
            guess = gets.chomp
            if @guessed_letters.include? guess
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



game = Hangman.new
while true do # game loop, break when game over
    game.display
    game.get_guess
    break if game.game_end?
    puts # add space after every turn
end