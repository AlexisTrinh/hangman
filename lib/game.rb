module Hangman
	require 'yaml'
	class Game

		attr_reader :clue_word, :secret_word, :wrong_guesses, :right_guesses

		def initialize(secret_word, clue_word = "", wrong_guesses = [], right_guesses = [], remaining_guesses = 10)
			@secret_word = secret_word
			if clue_word.empty? 
				@clue_word = "_" * secret_word.length
			else
				@clue_word = clue_word
			end
			@wrong_guesses = wrong_guesses
			@remaining_guesses = remaining_guesses
			p @remaining_guesses
			@right_guesses = right_guesses
		end

		def guess_word
			puts "guess a letter, or type 'save'"
			guess = gets.chomp
			until valid_guess?(guess)
				puts "please enter a new letter"
				guess = gets.chomp
			end
			check_for_save(guess)
			update_clue_word(guess)
		end

		def display
			puts clue_word.split("").join(" ")
			puts "wrong_guesses: #{wrong_guesses}"
			puts "remaining_guesses: #{@remaining_guesses}"
		end

		def play
			while !is_over?
				display
				guess_word
				@remaining_guesses -= 1
			end
			puts game_over_message
			puts secret_word
		end

		def valid_guess?(guess)
			!(wrong_guesses.include?(guess) || right_guesses.include?(guess))
		end

		def game_over_message
			return "You lose!" if @remaining_guesses <= 0
			return "You win!" if !clue_word.split("").include?("_")
		end

		def is_over?
			@remaining_guesses <= 0 || !clue_word.split("").include?("_")
		end

		def update_clue_word(letter)
			if secret_word.include?(letter)
				secret_word.chars.each_with_index do |char, index|
					@clue_word[index] = char if char == letter
				end
				@right_guesses << letter
			else 
				@wrong_guesses << letter
			end
		end

		def check_for_save(word)
			if word == 'save'
				save
				exit
			end
		end

		def save
			data = YAML::dump(self)
			File.open('./saves/save.yml', 'w') do |f|
				f.puts data
			end
			puts "Saved game"
		end

	end
end
