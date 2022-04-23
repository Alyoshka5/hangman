require 'csv'

class Hangman

    def initialize
        @word = generate_word()
        @correct_letters = set_dashes(@word)
        @wrong_letters = []
        @guesse_left = 10
        p @word
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

    public
    def display
        puts @correct_letters.join(" ")
        puts "incorrect letters: #{@wrong_letters.join(", ")}"
        puts "guesses left: #{@guesse_left}"
    end
end

def get_guess
    while true do
        print "Enter guess: "
        guess = gets.chomp
        if guess.match?(/[[:alpha:]]/) && guess.length == 1
            return guess
        else
            puts "Invalid guess. Must input one letter"
        end
    end
end

game = Hangman.new
while true do # game loop, break when game over
    game.display
    guess = get_guess()
        
    puts guess
    break
end