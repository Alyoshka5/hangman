require 'csv'

class Hangman

    def initialize
        @word = generate_word()
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
end

game = Hangman.new