extends Node

const SAVE_FILE = "user://save_file.save"

var g_date = {"number": 1, "string": "test" }

var sunday_score = 0
var monday_score = 0
var tuesday_score = 0
var wednesday_score = 0
var thursday_score = 0
var friday_score= 0
var saturday_score = 0

var weekly_score = 0

var test_save: String = "Testing String 123"

func save():
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	
	file.store_32(sunday_score)
	file.store_32(monday_score)
	file.store_32(tuesday_score)
	file.store_32(wednesday_score)
	file.store_32(thursday_score)
	file.store_var(friday_score)
	file.store_32(saturday_score)
	
	file.store_32(weekly_score)
	
	
	
	file.store_string(test_save)
	
	$GameOverScreen/ScoreContainer/Tuesday.text += test_save
	
	print("saving scores...")
	
	file.close()

func load_score():
	
	
	
	if FileAccess.file_exists(SAVE_FILE):
		
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		
		print("last word: " + test_save)
		
		#var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		
		sunday_score = file.get_32()
		monday_score = file.get_32()
		tuesday_score = file.get_32()
		wednesday_score = file.get_32()
		thursday_score = file.get_32()
		friday_score = file.get_32()
		saturday_score = file.get_32()
		weekly_score = file.get_32()
		
	else:
		print("file not found")
		#highscore = 0

func _ready():
	save(g_date)
	print(load_date())

