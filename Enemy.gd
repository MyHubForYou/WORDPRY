extends Sprite2D

@onready var prompt = $RichTextLabel
var prompt_text = prompt.text

const BLUE = Color("#4682b4")
const GREEN = Color("#639765")
const RED = Color("#a65455")

func get_prompt() -> String:
	return prompt_text
	
func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(BLUE) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(GREEN) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""

	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(RED) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()

	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[/color]"
