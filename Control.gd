extends Control

# system_text is what the user needs to type
var system_text = ""
# user_text is what the user types
var user_text = ""

var words = []
var activeWord = "XXXXXXXXXXXX"     #Display XXX's until a word is chosen


# the word must be exactly this length
const min_length = 6

var guesses = 0 # the number of guesses the user has made

var MAX_GUESSES: int = 8 # the maximum number of guesses allowed

# todays score
var points = 0

var sunday_score = 0
var monday_score = 0
var tuesday_score = 0
var wednesday_score = 0
var thursday_score = 0
var friday_score = 0
var saturday_score = 0

var weekly_score = 0

var sunday_text = "Sunday 0"
var monday_text = "Monday 0"
var tuesday_text = "Tuesday 0"
var wednesday_text = "Wednesday 0"
var thursday_text = "Thursday 0"
var friday_text = "Friday 0"
var saturday_text = "Saturday 0"

var weekly_text = "Weekly Score 0"

var guess_1 = ""
var guess_2 = ""
var guess_3 = ""
var guess_4 = ""
var guess_5 = ""
var guess_6 = ""
var guess_7 = ""
var guess_8 = ""


var firstLetter: bool = false
var secondLetter: bool = false
var thirdLetter: bool = false
var fourthLetter: bool = false
var fifthLetter: bool = false
var sixthLetter: bool = false

var time = Time

var WINNER: bool = false

var current_datetime = Time.get_date_dict_from_system()

var year = current_datetime["year"]
var month = current_datetime["month"]
var day = current_datetime["day"]
var weekday = current_datetime["weekday"]

var year_last_played = current_datetime["year"]
var month_last_played = current_datetime["month"]
var day_last_played = current_datetime["day"]
var weekday_last_played = current_datetime["weekday"]

var time_last_played: float = Time.get_unix_time_from_system()

const SAVE_FILE = "user://save_file.save"

var game = 0

var sunday_reset = 0

var rng: RandomNumberGenerator

var emoji_text = ""


# consider enum for <compare> like:
#enum DAYS {SUNDAY=0, MONDAY=1, TUESDAY=2, WEDNESDAY=3, THURSDAY=4, FRIDAY=5, SATURDAY=6}


func return_weekday_score(compare: int) -> int:
	# what is compare?
	# consider match statement instead of long if elif block
	match compare:
		Time.WEEKDAY_SUNDAY: return sunday_score
		Time.WEEKDAY_MONDAY: return monday_score
		Time.WEEKDAY_TUESDAY: return tuesday_score
		Time.WEEKDAY_WEDNESDAY: return wednesday_score
		Time.WEEKDAY_THURSDAY: return thursday_score
		Time.WEEKDAY_FRIDAY: return friday_score
		Time.WEEKDAY_SATURDAY: return saturday_score
		_: return 0
	
	
	
	#if compare == 0:
	#	return sunday_score
	#elif compare == 1:
	#	return monday_score
	#elif compare == 2:
	#	return tuesday_score
	#elif compare == 3:
	#	return wednesday_score
	#elif compare == 4:
	#	return thursday_score
	#elif compare == 5:
	#	return friday_score
	#elif compare == 6:
	#	return saturday_score
	#else:
	#	return 0

func reset_every_week():
	
	##if same week over two months, or the same month, or same week but new year
	if month - month_last_played == 1 or month - month_last_played == 0 or (month == 1 and month_last_played == 12):
		
		var day_compare: int = weekday + 1
		
		while day_compare <= 6:
				
			if return_weekday_score(day_compare) != 0:
				reset()
			else:
				day_compare += 1
		
	else:
		reset()

func reset_on_week_passed():
	
	if (weekday == Time.WEEKDAY_SUNDAY and sunday_reset == 0) or week_since_played() == true:
		reset()
		
	if weekday == Time.WEEKDAY_SUNDAY and sunday_reset == 0:
	#so the system only resets once on sundays
		sunday_reset = 1

func reset():
	
	monday_score = 0
	tuesday_score = 0
	wednesday_score = 0
	thursday_score = 0
	friday_score = 0
	saturday_score = 0
		
	monday_text = "Monday 0"
	tuesday_text = "Tuesday 0"
	wednesday_text = "Wednesday 0"
	thursday_text = "Thursday 0"
	friday_text = "Friday 0"
	saturday_text = "Saturday 0"
	
	emoji_text = ""
	
	game = 0
	
	reset_current_progress()
	
	set_weekly_scoreboards()

func save():
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	
	#for score in dailyscores:
	#    file.store_var(score);
	file.store_var(sunday_score)
	file.store_var(monday_score)
	file.store_var(tuesday_score)
	file.store_var(wednesday_score)
	file.store_var(thursday_score)
	file.store_var(friday_score)
	file.store_var(saturday_score)
	
	file.store_var(weekly_score)
	
	file.store_var(sunday_text)
	file.store_var(monday_text)
	file.store_var(tuesday_text)
	file.store_var(wednesday_text)
	file.store_var(thursday_text)
	file.store_var(friday_text)
	file.store_var(saturday_text)
	
	file.store_var(weekly_text)
	
	#file.store_string(guess_1)
	file.store_var(guess_1)
	file.store_var(guess_2)
	file.store_var(guess_3)
	file.store_var(guess_4)
	file.store_var(guess_5)
	file.store_var(guess_6)
	file.store_var(guess_7)
	file.store_var(guess_8)
	
	file.store_var(game)
	
	print("game saved: " + str(game))
	
	file.store_var(month_last_played)
	
	file.store_var(weekday_last_played)
	
	file.store_float(time_last_played)
	
	file.store_var(sunday_reset)
	
	file.store_var(emoji_text)
	
	file.close()

func load_score():
	
	if FileAccess.file_exists(SAVE_FILE):
		
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		
		sunday_score = file.get_var()
		monday_score = file.get_var()
		tuesday_score = file.get_var()
		wednesday_score = file.get_var()
		thursday_score = file.get_var()
		friday_score = file.get_var()
		saturday_score = file.get_var()
		
		weekly_score = file.get_var()
		
		sunday_text = file.get_var()
		monday_text = file.get_var()
		tuesday_text = file.get_var()
		wednesday_text = file.get_var()
		thursday_text = file.get_var()
		friday_text = file.get_var()
		saturday_text = file.get_var()
		
		weekly_text = file.get_var()

		# consider using array of a strings for guesses, like guesses: string[] = [...]
		guess_1 = file.get_var()
		guess_2 = file.get_var()
		guess_3 = file.get_var()
		guess_4 = file.get_var()
		guess_5 = file.get_var()
		guess_6 = file.get_var()
		guess_7 = file.get_var()
		guess_8 = file.get_var()
		
		game = file.get_var()
		
		month_last_played = file.get_var()
		
		weekday_last_played = file.get_var()
		
		time_last_played = file.get_float()
		
		sunday_reset = file.get_var()
		
		emoji_text = file.get_var()
		
		file.close()
		
	else:
		print("file not found")
		
		
func week_since_played() -> bool:
	const seconds_in_day = 86400.00
	var days_passed: float = (Time.get_unix_time_from_system() - time_last_played) / seconds_in_day
	print(str(Time.get_unix_time_from_system()) + " - " + str(time_last_played) + " / " + str(seconds_in_day))
	print("time since last played: " + str(days_passed))
	
	if days_passed >= 7.00000:
		return true
	else:
		return false

func weeklyScore():
	
	if weekday == Time.WEEKDAY_SUNDAY:
		
		sunday_score = points
		sunday_text = "Sunday " + "[color=0fcc7e]" + str(sunday_score) + "[/color]"
		
		monday_score = 0
		monday_text = "Monday 0"
		tuesday_score = 0
		tuesday_text = "Tuesday 0"
		wednesday_score = 0
		wednesday_text = "Wednesday 0"
		thursday_score = 0
		thursday_text = "Thursday 0"
		friday_score = 0
		friday_text = "Friday 0"
		saturday_score = 0
		saturday_text = "Saturday 0"
		
		
	if weekday == Time.WEEKDAY_MONDAY:
		monday_score = points
		monday_text = "Monday " + "[color=0fcc7e]"  + str(monday_score) + "[/color]"
		
		sunday_reset = 0

		tuesday_score = 0
		tuesday_text = "Tuesday 0"
		wednesday_score = 0
		wednesday_text = "Wednesday 0"
		thursday_score = 0
		thursday_text = "Thursday 0"
		friday_score = 0
		friday_text = "Friday 0"
		saturday_score = 0
		saturday_text = "Saturday 0"

	if weekday == Time.WEEKDAY_TUESDAY:
		tuesday_score = points
		tuesday_text = "Tuesday " + "[color=0fcc7e]" + str(tuesday_score) + "[/color]"
		
		sunday_reset = 0
		
		wednesday_score = 0
		wednesday_text = "Wednesday 0"
		thursday_score = 0
		thursday_text = "Thursday 0"
		friday_score = 0
		friday_text = "Friday 0"
		saturday_score = 0
		saturday_text = "Saturday 0"

	if weekday == Time.WEEKDAY_WEDNESDAY:
		wednesday_score = points
		wednesday_text = "Wednesday " + "[color=0fcc7e]" + str(wednesday_score) + "[/color]"
		
		sunday_reset = 0
		
		thursday_score = 0
		thursday_text = "Thursday 0"
		friday_score = 0
		friday_text = "Friday 0"
		saturday_score = 0
		saturday_text = "Saturday 0"
		
	if weekday == Time.WEEKDAY_THURSDAY:
		thursday_score = points
		thursday_text = "Thursday " + "[color=0fcc7e]" + str(thursday_score) + "[/color]"
		
		sunday_reset = 0

		friday_score = 0
		friday_text = "Friday 0"
		saturday_score = 0
		saturday_text = "Saturday 0"

	if weekday == Time.WEEKDAY_FRIDAY:
		friday_score = points
		friday_text = "Friday " + "[color=0fcc7e]" + str(friday_score) + "[/color]"
		
		sunday_reset = 0
		
		saturday_score = 0
		saturday_text = "Saturday 0"
		
	if weekday == Time.WEEKDAY_SATURDAY:
		saturday_score = points
		saturday_text = "Saturday " + "[color=0fcc7e]" + str(saturday_score) + "[/color]"

		sunday_reset = 0
		
	weekly_score = sunday_score + monday_score + tuesday_score + wednesday_score + thursday_score + friday_score + saturday_score
	
	weekly_text =  "Weekly Score " + str(weekly_score)
	
	set_weekly_scoreboards()
	

func set_weekly_scoreboards():
	
	$GameOverScreen/ScoreContainer/Sunday.text = str(sunday_text)
	$GameOverScreen/ScoreContainer/Monday.text = str(monday_text)
	$GameOverScreen/ScoreContainer/Tuesday.text = str(tuesday_text)
	$GameOverScreen/ScoreContainer/Wednesday.text = str(wednesday_text)
	$GameOverScreen/ScoreContainer/Thursday.text = str(thursday_text)
	$GameOverScreen/ScoreContainer/Friday.text = str(friday_text)
	$GameOverScreen/ScoreContainer/Saturday.text = str(saturday_text)
	
	$GameOverScreen/ScoreContainer/PanelContainer/WeeklyScore.text = str(weekly_text)
	
	save()
	

func set_answer_board():
	$GameOverScreen/ScoreContainer/HBoxContainer/Control1/Block/Letter.text = system_text.substr(0, 1)
	$GameOverScreen/ScoreContainer/HBoxContainer/Control2/Block/Letter.text = system_text.substr(1, 2)
	$GameOverScreen/ScoreContainer/HBoxContainer/Control3/Block/Letter.text = system_text.substr(2, 3)
	$GameOverScreen/ScoreContainer/HBoxContainer/Control4/Block/Letter.text = system_text.substr(3, 4)
	$GameOverScreen/ScoreContainer/HBoxContainer/Control5/Block/Letter.text = system_text.substr(4, 5)
	$GameOverScreen/ScoreContainer/HBoxContainer/Control6/Block/Letter.text = system_text.substr(5, 6)

func score(user_text: String, system_text: String):
	
	var total_right: int = 0
	
	#wont change the score if the game is already done
	if game == 1:
		
		print("You already finished this game")
		
		pass
		
	else:
		
		if user_text[0] == system_text[0]:
			
			total_right += 1
			
			if firstLetter == false:
				firstLetter = true
				points += (MAX_GUESSES - guesses) * 125
		
		if user_text[1] == system_text[1]:
			
			total_right += 1
			
			if secondLetter == false:
				secondLetter = true
				points += (MAX_GUESSES - guesses) * 125
	
		if user_text[2] == system_text[2]:
			
			total_right += 1
			
			if thirdLetter == false:
				thirdLetter = true
				points += (MAX_GUESSES - guesses) * 125
	
		if user_text[3] == system_text[3]:
			
			total_right += 1
			
			if fourthLetter == false:
				fourthLetter = true
				points += (MAX_GUESSES - guesses) * 125
	
		if user_text[4] == system_text[4]:
			
			total_right += 1
			
			if fifthLetter == false:
				fifthLetter = true
				points += (MAX_GUESSES - guesses) * 125
	
		if user_text[5] == system_text[5]:
			
			total_right += 1
			
			if sixthLetter == false:
				sixthLetter = true
				points += (MAX_GUESSES - guesses) * 125
				
		
		# user gets bonus for solving the puzzle
		if total_right == system_text.length():
			points += 1000 * (MAX_GUESSES - guesses)
		
	
	$Panel/Pointstext.text = "Score " + str(points)

@onready var camera = $Camera2D

func gameover():

	$PlayerText.clear()
	$PlayerText.deselect()
		
	var spot = Vector2(0, 0)
		
	var screen = $GameOverScreen

	screen.set_position(Vector2(593, 200))
	
	$GameOverScreen/ScoreContainer.set_position(Vector2(593, 200))
	
	var animate = $GameOverScreen/AnimateGAMEOVER
	
	animate.queue("Show")
	
	
	animate = $GameOverScreen/AnimateContainer
	
	animate.queue("ShowContainer")
	
	print("game already won: " + str(game))
	if game == 1:
		
		pass
		
	else:
		
		emoji_text = ""
		
		emoji_text = "WORDPRY SCORE " + str(points) + "\n"
		
		for i in range(system_text.length()):
			accuracy(str(guess_1), system_text, i)
		emoji_text += "\n"
	
		if guess_2 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_2), system_text, i)
			emoji_text += "\n"
		
		if guess_3 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_3), system_text, i)
			emoji_text += "\n"
		
		if guess_4 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_4), system_text, i)
			emoji_text += "\n"
	
		if guess_5 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_5), system_text, i)
			emoji_text += "\n"
	
		if guess_6 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_6), system_text, i)
			emoji_text += "\n"
			
		if guess_7 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_7), system_text, i)
			emoji_text += "\n"
			
		if guess_8 != "":
			for i in range(system_text.length()):
				accuracy(str(guess_8), system_text, i)
			emoji_text += "\n"
			
	$EmojiBackground/EmojiScore.text = str(emoji_text)
	
	if game == 1:
		load_score()
		$EmojiBackground/EmojiScore.text = str(emoji_text)
		set_weekly_scoreboards()
		
	else:

		game = 1
	
		print("saved score is " + monday_text)
	
		weeklyScore()
		

func load_progress():
	# guesses = [guess1, guess2, guess3....]
	# for i in range(len(guesses)):
	# 	if guess[i] == "":
	#       pass
	#   else
	#       animate_row(i, guesses[i], system_text)
	#		score(guesses[i], system_text)
	#		weeklyScore()
	# 		num_guesses += 1
	
	#if guess_1 != "":
	if guess_1 == "":
		pass
	else:
		animate_row_1(guess_1, system_text)
		score(guess_1, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_2 == "":
		pass
	else:
		animate_row_2(guess_2, system_text)
		score(guess_2, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_3 == "":
		pass
	else:
		animate_row_3(guess_3, system_text)
		score(guess_3, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_4 == "":
		pass
	else:
		animate_row_4(guess_4, system_text)
		score(guess_4, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_5 == "":
		pass
	else:
		animate_row_5(guess_5, system_text)
		score(guess_5, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_6 == "":
		pass
	else:
		animate_row_6(guess_6, system_text)
		score(guess_6, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_7 == "":
		pass
	else:
		animate_row_7(guess_7, system_text)
		score(guess_7, system_text)
		weeklyScore()
		guesses += 1
	
	if guess_8 == "":
		pass
	else:
		animate_row_8(guess_8, system_text)
		score(guess_8, system_text)
		weeklyScore()
		guesses += 1

func reset_current_progress():
	
	guess_1 = ""
	guess_2 = ""
	guess_3 = ""
	guess_4 = ""
	guess_5 = ""
	guess_6 = ""
	guess_7 = ""
	guess_8 = ""
	
	
func rng_word_retrieval():
	rng = RandomNumberGenerator.new()
	rng.randomize()  # Initialize with a random seed

	#load the words into an array
	var word_list = load_word_of_the_day()
	
	var looptimes = year + month + day
	
	for i in range(looptimes):
		rng.seed = looptimes
	randomize()
	system_text = word_list[rng.randi_range(0, word_list.size())]
	
	#activeWord =  word_list[rng.randi_range(0, word_list.size())]
	print(str(system_text))
	#system_text = activeWord

func play_again():
	
	load_score()
	
	reset_current_progress()

	if weekday == Time.WEEKDAY_SUNDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(sunday_score) + "[/color]"
		
	if weekday == Time.WEEKDAY_MONDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(monday_score) + "[/color]"
		
	if weekday == Time.WEEKDAY_TUESDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(tuesday_score) + "[/color]"
		tuesday_text = "Tuesday " + "[color=0fcc7e]" + str(tuesday_score) + "[/color]"
		$GameOverScreen/ScoreContainer/Tuesday.text = tuesday_text
		
	if weekday == Time.WEEKDAY_WEDNESDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(wednesday_score) + "[/color]"
		
	if weekday == Time.WEEKDAY_THURSDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(thursday_score) + "[/color]"
		
	if weekday == Time.WEEKDAY_FRIDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(friday_score) + "[/color]"
		
	if weekday == Time.WEEKDAY_SATURDAY and game == 1:
		
		$Panel/Pointstext.text = "Score " + "[color=0fcc7e]" + str(saturday_score) + "[/color]"

func quick():
	
	reset_current_progress()
	
	sunday_reset = 0
	
	game = 0
	
	reset()
	
	save()

func _ready():

	rng_word_retrieval()
	
	load_score()
	
	if weekday_last_played != weekday:
		
		print("new day")
		game = 0
		
		reset_current_progress()
		
	else:
		print("same day")
		
	
	reset_on_week_passed()
	
	reset_every_week()
	
	month_last_played = current_datetime["month"]
	weekday_last_played = current_datetime["weekday"]
	time_last_played = Time.get_unix_time_from_system()

	save()
	
	set_answer_board()
	
	if game == 1:
		
		play_again()
		
		reset_current_progress()
		
	else:
		
		var intro_screen = $Intro_Screen
		intro_screen.set_position(Vector2(587, 200))
		
		load_progress()

func _on_player_text_text_submitted(new_text):
	
	new_text = new_text.to_upper()
	
	#checks if the user word is the minimum length
	if new_text.length() == 0:
		$Inform.text = "Enter 6 letter word"
		pass
	else:
	
		if new_text.length() < min_length:
		
			$Inform.text = "Too short!"
			pass
		
		else:
		
				# checks if the user typed a valid word
				if new_text not in loadWords():
				
					$Inform.text = "UNLISTED WORD"
					pass
				
				else:
				
					user_text = new_text
				
					if guesses == 0:
						guess_1 = user_text
					elif guesses == 1:
						guess_2 = user_text
					elif guesses == 2:
						guess_3 = user_text
					elif guesses == 3:
						guess_4 = user_text
					elif guesses == 4:
						guess_5 = user_text
					elif guesses == 5:
						guess_6 = user_text
					elif guesses == 6:
						guess_7 = user_text
					elif guesses == 7:
						guess_8 = user_text
			
					# Compare the user's input text to the system text
					compareWords(user_text, system_text)
					
					if game != 1:
						
						var temp1 = guess_1
						var temp2 = guess_2
						var temp3 = guess_3
						var temp4 = guess_4
						var temp5 = guess_5
						var temp6 = guess_6
						var temp7 = guess_7
						var temp8 = guess_8
						
						load_score()
						
						guess_1 = temp1
						guess_2 = temp2
						guess_3 = temp3
						guess_4 = temp4
						guess_5 = temp5
						guess_6 = temp6
						guess_7 = temp7
						guess_8 = temp8
						
						save()
						
					if WINNER == true:
						
						gameover()

						pass
					
					else:
						print("your guess was incorrect.")
						
						guesses += 1
						$PlayerText.text = ""
						
						if guesses >= MAX_GUESSES:
							
							gameover()
							
							pass

#Words the player may guess
func loadWords():
	
	var word = "res://SixLetterWords.txt"
	var lines = []                              #set an empty array
	var file = FileAccess.open(word, FileAccess.READ) #create an instance
	file.open("res://SixLetterWords.txt", file.READ)
	while not file.eof_reached():               #while we're not at end of file
		lines.append(file.get_line())           #append each line to the array
	return lines                                #send the array back
	

#Potential answers
func load_word_of_the_day():
	
	var word = "res://CommonSixLetterWords.txt"
	var lines = []                              #set an empty array
	var file = FileAccess.open(word, FileAccess.READ) #create an instance
	file.open("res://CommonSixLetterWords.txt", file.READ)
	while not file.eof_reached():               #while we're not at end of file
		lines.append(file.get_line())           #append each line to the array
	return lines                                #send the array back

func count_letter_occurrences(letter: String, word: String) -> int:
	
	var system_count = 0
	
	var user_count = 0
		
	for char in word:
		if char == letter:
			system_count += 1
			
	return system_count

func animate_row_1(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer/Control6/Block/Letter.text = user_text.substr(5, 6)
	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		
		if user_text[0] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
func animate_row_2(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer2/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer2/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer2/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer2/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer2/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer2/Control6/Block/Letter.text = user_text.substr(5, 6)
	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer2/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

func animate_row_3(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer3/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer3/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer3/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer3/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer3/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer3/Control6/Block/Letter.text = user_text.substr(5, 6)
	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
				
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer3/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
func animate_row_4(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer4/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer4/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer4/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer4/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer4/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer4/Control6/Block/Letter.text = user_text.substr(5, 6)

	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer4/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")


func animate_row_5(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer5/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer5/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer5/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer5/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer5/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer5/Control6/Block/Letter.text = user_text.substr(5, 6)

	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer5/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

func animate_row_6(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer6/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer6/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer6/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer6/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer6/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer6/Control6/Block/Letter.text = user_text.substr(5, 6)
	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer6/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

func animate_row_7(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer7/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer7/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer7/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer7/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer7/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer7/Control6/Block/Letter.text = user_text.substr(5, 6)

	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer7/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer7/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer7/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer7/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	# blocks = [
	#$VFlowContainer/HBoxContainer7/Control5/AnimationPlayer
	#]
	animateBlock = $VFlowContainer/HBoxContainer7/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer7/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")


func animate_row_8(user_text: String, system_text: String):
	
	$VFlowContainer/HBoxContainer8/Control1/Block/Letter.text = user_text.substr(0, 1)
	$VFlowContainer/HBoxContainer8/Control2/Block/Letter.text = user_text.substr(1, 2)
	$VFlowContainer/HBoxContainer8/Control3/Block/Letter.text = user_text.substr(2, 3)
	$VFlowContainer/HBoxContainer8/Control4/Block/Letter.text = user_text.substr(3, 4)
	$VFlowContainer/HBoxContainer8/Control5/Block/Letter.text = user_text.substr(4, 5)
	$VFlowContainer/HBoxContainer8/Control6/Block/Letter.text = user_text.substr(5, 6)
	
	var animateBlock
	
	var spot: int
	
	spot = 0
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control1/AnimationPlayer
	
	if user_text[0] == system_text[0]:

		for i in count_letter_occurrences(user_text[0], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[0] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[0]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[0]:
					system_count += 1
			
			var letter: String = user_text[0]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[0], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 1
	
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control2/AnimationPlayer
	

	if user_text[1] == system_text[1]:

		for i in count_letter_occurrences(user_text[1], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[1] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[1]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[1]:
					system_count += 1
			
			var letter: String = user_text[1]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[1], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")

	
	spot = 2
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control3/AnimationPlayer
	
	if user_text[2] == system_text[2]:

		for i in count_letter_occurrences(user_text[2], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[2] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[2]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[2]:
					system_count += 1
			
			var letter: String = user_text[2]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[2], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 3
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control4/AnimationPlayer
	
	if user_text[3] == system_text[3]:

		for i in count_letter_occurrences(user_text[3], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[3] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[3]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[3]:
					system_count += 1
			
			var letter: String = user_text[3]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[3], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 4
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control5/AnimationPlayer
	
	if user_text[4] == system_text[4]:

		for i in count_letter_occurrences(user_text[4], system_text):
			animateBlock.queue("CORRECT")

	else:
		if user_text[4] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[4]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[4]:
					system_count += 1
			
			var letter: String = user_text[4]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[4], system_text):
				
					animateBlock.queue("CLOSE")

		else:
			animateBlock.play("INCORRECT")
			
	spot = 5
	
	animateBlock = $VFlowContainer/HBoxContainer8/Control6/AnimationPlayer
	
	if user_text[5] == system_text[5]:

		for i in count_letter_occurrences(user_text[5], system_text):
			animateBlock.queue("CORRECT")

	else:
		
		if user_text[5] in system_text:
			
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
			
			for char in user_text:
				if char == user_text[5]:
					user_count += 1
	
			for char in system_text:
				if char == user_text[5]:
					system_count += 1
			
			var letter: String = user_text[5]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				for i in count_letter_occurrences(user_text[5], system_text):
				
					animateBlock.queue("CLOSE")
		else:
			animateBlock.play("INCORRECT")
			
func accuracy(user_text: String, system_text: String, spot: int):
	
	if user_text[spot] == system_text[spot]:
		
		emoji_text += "🟩"
		
	else:
		
		if user_text[spot] in system_text:
			
			var system_count = 0
	
			var user_count = 0
			
			var matching = 0
	
			for char in system_text:
				if char == user_text[spot]:
					system_count += 1
			
			var letter: String = user_text[spot]
			
			#if user_count == system_count:
			for i in system_text.length():
				if letter == system_text[i] and letter == user_text[i]:
					matching += 1
			
			if matching < system_count:
				
				emoji_text += "🟧"
			
			else:
				
				emoji_text += "⬜️"
			
		else:
			
			emoji_text += "🟥"



func compareWords(user_text: String, system_text: String):

	WINNER = true
	
	if game != 1:
		score(user_text, system_text)
	
	if guesses == 0:
		#✅️☑️🟥🟧🟨🟩🟦🟪🟫⬛️⬜️#️⃣*️⃣0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟
		
		animate_row_1(user_text, system_text)
	elif guesses == 1:
		animate_row_2(user_text, system_text)
	elif guesses == 2:
		animate_row_3(user_text, system_text)
	elif guesses == 3:
		animate_row_4(user_text, system_text)
	elif guesses == 4:
		animate_row_5(user_text, system_text)
	elif guesses == 5:
		animate_row_6(user_text, system_text)
	elif guesses == 6:
		animate_row_7(user_text, system_text)
	elif guesses == 7:
		animate_row_8(user_text, system_text)

	# Iterate over each letter in the words and compare them
	for i in range(system_text.length()):
		
		if user_text[i] != system_text[i]:

			WINNER = false

func _on_player_text_text_changed(new_text: String):
	
	$Inform.text = ""
	
	if guesses == 0:
		
		$VFlowContainer/HBoxContainer/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer/Control6/Block/Letter.text = new_text.substr(5, 6)
		
	else: if guesses == 1:
		$VFlowContainer/HBoxContainer2/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer2/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer2/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer2/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer2/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer2/Control6/Block/Letter.text = new_text.substr(5, 6)
		
	else: if guesses == 2:
		
		$VFlowContainer/HBoxContainer3/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer3/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer3/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer3/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer3/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer3/Control6/Block/Letter.text = new_text.substr(5, 6)

	else: if guesses == 3:
		
		$VFlowContainer/HBoxContainer4/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer4/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer4/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer4/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer4/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer4/Control6/Block/Letter.text = new_text.substr(5, 6)

	else: if guesses == 4:
		
		$VFlowContainer/HBoxContainer5/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer5/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer5/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer5/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer5/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer5/Control6/Block/Letter.text = new_text.substr(5, 6)
		

	else: if guesses == 5:
		
		$VFlowContainer/HBoxContainer6/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer6/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer6/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer6/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer6/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer6/Control6/Block/Letter.text = new_text.substr(5, 6)

	else: if guesses == 6:
		
		$VFlowContainer/HBoxContainer7/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer7/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer7/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer7/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer7/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer7/Control6/Block/Letter.text = new_text.substr(5, 6)

	else: if guesses == 7:
		
		$VFlowContainer/HBoxContainer8/Control1/Block/Letter.text = new_text.substr(0, 1)
		$VFlowContainer/HBoxContainer8/Control2/Block/Letter.text = new_text.substr(1, 2)
		$VFlowContainer/HBoxContainer8/Control3/Block/Letter.text = new_text.substr(2, 3)
		$VFlowContainer/HBoxContainer8/Control4/Block/Letter.text = new_text.substr(3, 4)
		$VFlowContainer/HBoxContainer8/Control5/Block/Letter.text = new_text.substr(4, 5)
		$VFlowContainer/HBoxContainer8/Control6/Block/Letter.text = new_text.substr(5, 6)
		
	else:
		pass


func _on_a_button_pressed():
	$PlayerText.text += "A"
	_on_player_text_text_changed($PlayerText.text)

func _on_b_button_pressed():
	$PlayerText.text += "B"
	_on_player_text_text_changed($PlayerText.text)

func _on_c_button_pressed():
	$PlayerText.text += "C"
	_on_player_text_text_changed($PlayerText.text)
	
func _on_d_button_pressed():
	$PlayerText.text += "D"
	_on_player_text_text_changed($PlayerText.text)

func _on_e_button_pressed():
	$PlayerText.text += "E"
	_on_player_text_text_changed($PlayerText.text)

func _on_f_button_pressed():
	$PlayerText.text += "F"
	_on_player_text_text_changed($PlayerText.text)

func _on_g_button_pressed():
	$PlayerText.text += "G"
	_on_player_text_text_changed($PlayerText.text)

func _on_h_button_pressed():
	$PlayerText.text += "H"
	_on_player_text_text_changed($PlayerText.text)

func _on_i_button_pressed():
	$PlayerText.text += "I"
	_on_player_text_text_changed($PlayerText.text)

func _on_j_button_pressed():
	$PlayerText.text += "J"
	_on_player_text_text_changed($PlayerText.text)

func _on_k_button_pressed():
	$PlayerText.text += "K"
	_on_player_text_text_changed($PlayerText.text)

func _on_l_button_pressed():
	$PlayerText.text += "L"
	_on_player_text_text_changed($PlayerText.text)

func _on_m_button_pressed():
	$PlayerText.text += "M"
	_on_player_text_text_changed($PlayerText.text)

func _on_n_button_pressed():
	$PlayerText.text += "N"
	_on_player_text_text_changed($PlayerText.text)

func _on_o_button_pressed():
	$PlayerText.text += "O"
	_on_player_text_text_changed($PlayerText.text)

func _on_p_button_pressed():
	$PlayerText.text += "P"
	_on_player_text_text_changed($PlayerText.text)

func _on_q_button_pressed():
	$PlayerText.text += "Q"
	_on_player_text_text_changed($PlayerText.text)

func _on_r_button_pressed():
	$PlayerText.text += "R"
	_on_player_text_text_changed($PlayerText.text)

func _on_s_button_pressed():
	$PlayerText.text += "S"
	_on_player_text_text_changed($PlayerText.text)

func _on_t_button_pressed():
	$PlayerText.text += "T"
	_on_player_text_text_changed($PlayerText.text)

func _on_u_button_pressed():
	$PlayerText.text += "U"
	_on_player_text_text_changed($PlayerText.text)
	
func _on_v_button_pressed():
	$PlayerText.text += "V"
	_on_player_text_text_changed($PlayerText.text)

func _on_w_button_pressed():
	$PlayerText.text += "W"
	_on_player_text_text_changed($PlayerText.text)
	
func _on_x_button_pressed():
	$PlayerText.text += "X"
	_on_player_text_text_changed($PlayerText.text)

func _on_y_button_pressed():
	$PlayerText.text += "Y"
	_on_player_text_text_changed($PlayerText.text)

func _on_z_button_pressed():
	$PlayerText.text += "Z"
	_on_player_text_text_changed($PlayerText.text)
	
func _on_back_button_pressed():
	$PlayerText.text = $PlayerText.text.substr(0, $PlayerText.text.length() - 1)
	_on_player_text_text_changed($PlayerText.text)
	
func _on_enter_button_pressed():
	_on_player_text_text_submitted($PlayerText.text)


func _on_share_button_pressed():
	
	DisplayServer.clipboard_set(str(emoji_text))
	
	$GameOverScreen/ScoreContainer/PanelContainer2/Score_shared.text = "SCORE SAVED TO CLIPBOARD!"
