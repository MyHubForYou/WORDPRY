extends TextureRect


var moveSpeed = 1  # Adjust the movement speed as needed

#var control = get_parent()
#var gameover = control.gameover
#var winner = control.WINNER

#var control = get_parent()

var gameover: bool = false
var winner: bool = false



func _ready():
	pass
	#var control = get_parent()
	#winne.connect("game_state_changed", control, "_on_game_state_changed")
	#control.connect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#var spot = Vector2(, 40)
	
	if gameover == true:
		pass
		#position = position.lerp(control.position, moveSpeed * delta)
		#position = position.lerp(Vector2(0, 0), moveSpeed * delta)
		#$ScoreContainer/Sunday.text = "win"
		#$ScoreContainer/Tuesday.text = "win"
	#Control.connect("mySignal", self, "_onMySignal")

func _physics_process(delta):
	rotation_degrees += 0.005
	
	#if WINNER:
			#position = position.lerp($Line2D.position, moveSpeed * delta)
