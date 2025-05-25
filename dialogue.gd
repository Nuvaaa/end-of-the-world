extends Node
signal dialogue_ended

var current_line = -1
var d_active = false
var dialogue = []
var offset

func _ready():
	$Dialogue.visible = false

func show():
	offset = $Dialogue/Portrait.offset.x
	$Dialogue/Portrait.offset.x -= 10

func load_file(file):
	var d_file = FileAccess.open("res://dialogue/" + file + ".json", FileAccess.READ)
	var content = JSON.parse_string(d_file.get_as_text())
	return content

func next_line():
	current_line += 1
	if current_line >= len(dialogue):
		d_active = false
		$Dialogue.visible = false
		emit_signal("dialogue_ended")
		return false
		
	$Dialogue/Portrait.texture = load("res://sprites/dialogue/" + dialogue[current_line]['character'] + "/" + dialogue[current_line]['emotion'] + ".png")
	$Dialogue/Portrait.scale = Vector2(dialogue[current_line]['scale'], dialogue[current_line]['scale'])
	$Dialogue/Portrait.offset.x = $Dialogue/Portrait.texture.get_width() / 2
	$Dialogue/Portrait.offset.y = $Dialogue/Portrait.texture.get_height() / -2
	
	$Dialogue/Text.text = dialogue[current_line]['text']

func _input(event):
	if !d_active:
		return false
	if event.is_action_pressed("interact"):
		next_line()

func _on_player_start_dialogue(value: Variant) -> void:
	dialogue = load_file(value)
	current_line = -1
	next_line()
	$Dialogue.visible = true
	d_active = true

#func change_text():
	
