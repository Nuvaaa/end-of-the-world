extends Node
signal dialogue_ended

var current_line = -1
var d_active = false
var dialogue = []
var appear = false
var tempText = ""
var portraitX = 0
var lastPortrait

func _ready():
	$Dialogue/Text.visible = false
	$Dialogue/Portrait.self_modulate.a = 0
	$Dialogue/Box.scale.y = 0

func load_file(file):
	var d_file = FileAccess.open("res://dialogue/" + file + ".json", FileAccess.READ)
	var content = JSON.parse_string(d_file.get_as_text())
	return content

func next_line():
	current_line += 1
	$Dialogue/Text.text = ""
	if current_line >= len(dialogue):
		d_active = false
		appear = false
		$Dialogue/Text.visible = false
		emit_signal("dialogue_ended")
		return false
		
	$Dialogue/Portrait.texture = load("res://sprites/dialogue/" + dialogue[current_line]['character'] + "/" + dialogue[current_line]['emotion'] + ".png")
	$Dialogue/Portrait.scale = Vector2(dialogue[current_line]['scale'], dialogue[current_line]['scale'])
	$Dialogue/Portrait.offset.x = $Dialogue/Portrait.texture.get_width() / 2
	$Dialogue/Portrait.offset.y = $Dialogue/Portrait.texture.get_height() / -2
	
	if dialogue[current_line]['character'] != lastPortrait:
		$Dialogue/Portrait.position.x = portraitX - 2
	lastPortrait = dialogue[current_line]['character']
	
	tempText = dialogue[current_line]['text']

func _input(event):
	if !d_active:
		return false
	if event.is_action_pressed("interact"):
		if tempText == "":
			next_line()
		else:
			$Dialogue/Text.text = dialogue[current_line]['text']
			tempText = ""

func _on_player_start_dialogue(value: Variant) -> void:
	dialogue = load_file(value)
	current_line = -1
	next_line()
	d_active = true
	appear = true

func text():
	if tempText != "":
		while tempText[0] == " ":
			$Dialogue/Text.text = $Dialogue/Text.text + tempText[0]
			tempText = tempText.erase(0, 1)
		$Dialogue/Text.text = $Dialogue/Text.text + tempText[0]
		tempText = tempText.erase(0, 1)

func _process(_delta):
	if appear:
		if $Dialogue/Portrait.self_modulate.a < 1:
			$Dialogue/Portrait.self_modulate.a += 0.2
			$Dialogue/Box.scale.y += 0.2
		if $Dialogue/Portrait.self_modulate.a > 1:
			$Dialogue/Portrait.self_modulate.a = 1
			$Dialogue/Box.scale.y = 1
		if $Dialogue/Portrait.self_modulate.a == 1:
			$Dialogue/Text.visible = true
			text()
		if $Dialogue/Portrait.position.x < portraitX:
			$Dialogue/Portrait.position.x += 0.4
		if $Dialogue/Portrait.position.x > portraitX:
			$Dialogue/Portrait.position.x = portraitX
	else:
		if $Dialogue/Portrait.self_modulate.a > 0:
			$Dialogue/Portrait.self_modulate.a -= 0.2
			$Dialogue/Box.scale.y -= 0.2
		if $Dialogue/Portrait.self_modulate.a < 0:
			$Dialogue/Portrait.self_modulate.a = 0
			$Dialogue/Box.scale.y = 0
		if $Dialogue/Portrait.position.x > portraitX - 2:
			$Dialogue/Portrait.position.x -= 0.4
		if $Dialogue/Portrait.position.x < portraitX - 2:
			$Dialogue/Portrait.position.x = portraitX - 2
