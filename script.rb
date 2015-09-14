require_relative './lib/game.rb'


def new_game
	# Gets the words in an array of strings. New lines are striped
	words = File.readlines("5desk.txt").each {|line| line.chomp!}
	# Selects all words between 5 and 12 characters
	filtered_words = words.select {|word| word.length.between?(5, 12)}
	secret_word = filtered_words.sample.downcase
	#Create a new game
	Hangman::Game.new(secret_word).play
end

def load_game
	yaml = File.read('./saves/save.yml')
	game = YAML::load(yaml)
	game.play
end

puts "What you wanna do? 'new' or 'load'?"
choice = gets.chomp
new_game if choice == "new"
load_game if choice == "load"