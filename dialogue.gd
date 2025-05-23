extends Node
signal dialogue_ended

var current_line = -1
var d_active = false
var dialogue = []

func _ready():
	$Box1.visible = false

func load_file(file):
	var d_file = FileAccess.open("res://dialogue/" + file + ".json", FileAccess.READ)
	var content = JSON.parse_string(d_file.get_as_text())
	return content

func next_line():
	current_line += 1
	if current_line >= len(dialogue):
		d_active = false
		$Box1.visible = false
		emit_signal("dialogue_ended")
		return false
	$Box1/Box2/Box3/Text.text = dialogue[current_line]['text']

func _input(event):
	if !d_active:
		return false
	if event.is_action_pressed("interact"):
		next_line()

func _on_player_start_dialogue(value: Variant) -> void:
	dialogue = load_file(value)
	current_line = -1
	next_line()
	$Box1.visible = true
	d_active = true

#func change_text():
	
