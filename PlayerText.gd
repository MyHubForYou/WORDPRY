extends LineEdit


const min_length = 5

# Declare the system text as a class variable
var system_text = "Hello, world!"
var user_input = ""

func _ready():

	set_process_input(true)
	#connect("gui_input", set_process_input(true), "_unhandled_input")

func _on_text_change_rejected(rejected_substring):
	pass # Replace with function body.


func _on_text_submitted(new_text):
	pass # Replace with function body.
