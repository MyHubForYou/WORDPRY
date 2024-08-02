extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	#set_global_position(Vector2(50, 50))
	
	rotation_degrees -= 0.01
	#rotation_degrees -= 1
	pass
