extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#self.set_position(Vector2(587, 200))
	
	var begin = $AnimationPlayer
	
	begin.play("Begin")
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_intro_start_timeout():
	
	var W_Block = $VBoxContainer/HBoxContainer/Control1/W_AnimationPlayer
	var O_Block = $VBoxContainer/HBoxContainer/Control2/O_AnimationPlayer
	var R_Block = $VBoxContainer/HBoxContainer/Control3/R_AnimationPlayer
	var D_Block = $VBoxContainer/HBoxContainer/Control4/D_AnimationPlayer
	var P_Block = $VBoxContainer/HBoxContainer/Control5/P_AnimationPlayer
	var R2_Block = $VBoxContainer/HBoxContainer/Control6/R2_AnimationPlayer
	var Y_Block = $VBoxContainer/HBoxContainer/Control7/Y_AnimationPlayer
	
	
	var random_W = randi_range(1, 3)
	
	var random_O = randi_range(1, 3)
	
	var random_R = randi_range(1, 2)
	
	var random_D = randi_range(1, 3)
	
	var random_P = randi_range(1, 3)
	
	var random_R2 = randi_range(1, 2)
	
	var random_Y = randi_range(1, 3)
	
	if random_W == 1:
		W_Block.queue("CORRECT")
	elif random_W == 2:
		W_Block.queue("CLOSE")
	else:
		W_Block.queue("INCORRECT")
	
	if random_O == 1:
		O_Block.queue("CORRECT")
	elif random_O == 2:
		O_Block.queue("CLOSE")
	else:
		O_Block.queue("INCORRECT")
		
	var i: int = 0
	
	var j: int = 0
	
	if random_R == 1:
		while i < 2:
			R_Block.queue("CORRECT")
			i += 1
	else:
		while i < 2:
			R_Block.queue("CLOSE")
			i += 1

	if random_D == 1:
		D_Block.queue("CORRECT")
	elif random_D == 2:
		D_Block.queue("CLOSE")
	else:
		D_Block.queue("INCORRECT")

	if random_P == 1:
		P_Block.queue("CORRECT")
	elif random_P == 2:
		P_Block.queue("CLOSE")
	else:
		P_Block.queue("INCORRECT")

	if random_R2 == 1:
		while j < 2:
			R2_Block.queue("CORRECT")
			j += 1
	else:
		while j < 2:
			R2_Block.queue("CLOSE")
			j += 1

	if random_Y == 1:
		Y_Block.queue("CORRECT")
	elif random_Y == 2:
		Y_Block.queue("CLOSE")
	else:
		Y_Block.queue("INCORRECT")

func _on_intro_end_timer_timeout():
	var move = $AnimationPlayer
	move.play("End")

func _on_intro_end_timer_2_timeout():
	self.set_position(Vector2(5870, 2000))
	pass # Replace with function body.



func _on_button_pressed():
	_on_intro_end_timer_timeout()
	_on_intro_end_timer_2_timeout()
	pass # Replace with function body.
