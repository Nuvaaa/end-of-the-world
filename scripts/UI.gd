extends CanvasLayer
signal dialogue_ended
var VelX
var VelY
var current_line = -1
var d_active = false
var dialogue = []
var appear = false
var portrait = false
var tempText = ""
var portraitX = 0
var lastPortrait

func _on_player_vel_x(value):
	VelX = value

func _on_player_vel_y(value):
	VelY = value

func _ready():
	$DialogueBox/Text.visible = false
	$DialogueBox/Portrait.self_modulate.a = 0
	$DialogueBox/Box.scale.y = 0

func load_file(file):
	var d_file = FileAccess.open("res://dialogue/" + file + ".json", FileAccess.READ)
	var content = JSON.parse_string(d_file.get_as_text())
	return content

func next_line():
	current_line += 1
	$DialogueBox/Text.text = ""
	if current_line >= len(dialogue):
		d_active = false
		appear = false
		portrait = false
		$DialogueBox/Text.visible = false
		emit_signal("dialogue_ended")
		return false
	
	if dialogue[current_line]['character'] != "None":
		portrait = true
		$DialogueBox/Portrait.texture = load("res://sprites/dialogue/" + dialogue[current_line]['character'] + "/" + dialogue[current_line]['emotion'] + ".png")
		$DialogueBox/Portrait.scale = Vector2(dialogue[current_line]['scale'], dialogue[current_line]['scale'])
		$DialogueBox/Portrait.offset.x = $DialogueBox/Portrait.texture.get_width() / 2
		$DialogueBox/Portrait.offset.y = $DialogueBox/Portrait.texture.get_height() / -2
	else:
		portrait = false
	
	if dialogue[current_line]['character'] != lastPortrait:
		$DialogueBox/Portrait.position.x = portraitX - 2
	lastPortrait = dialogue[current_line]['character']
	
	tempText = dialogue[current_line]['text']

func _input(event):
	if !d_active:
		return false
	if event.is_action_pressed("interact"):
		if tempText == "":
			next_line()
		else:
			$DialogueBox/Text.text = dialogue[current_line]['text']
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
			$DialogueBox/Text.text = $DialogueBox/Text.text + tempText[0]
			tempText = tempText.erase(0, 1)
		$DialogueBox/Text.text = $DialogueBox/Text.text + tempText[0]
		tempText = tempText.erase(0, 1)

func _process(_delta):
	if appear:
		if $DialogueBox/Box.scale.y < 1:
			$DialogueBox/Box.scale.y += 0.2
		if $DialogueBox/Box.scale.y > 1:
			$DialogueBox/Box.scale.y = 1
		if $DialogueBox/Box.scale.y == 1:
			$DialogueBox/Text.visible = true
			text()
	else:
		if $DialogueBox/Box.scale.y > 0:
			$DialogueBox/Box.scale.y -= 0.2
		if $DialogueBox/Box.scale.y < 0:
			$DialogueBox/Box.scale.y = 0
	if portrait:
		if $DialogueBox/Portrait.self_modulate.a < 1:
			$DialogueBox/Portrait.self_modulate.a += 0.2
		if $DialogueBox/Portrait.self_modulate.a > 1:
			$DialogueBox/Portrait.self_modulate.a = 1
		if $DialogueBox/Portrait.position.x < portraitX:
			$DialogueBox/Portrait.position.x += 0.4
		if $DialogueBox/Portrait.position.x > portraitX:
			$DialogueBox/Portrait.position.x = portraitX
	else:
		if $DialogueBox/Portrait.self_modulate.a > 0:
			$DialogueBox/Portrait.self_modulate.a -= 0.2
		if $DialogueBox/Portrait.self_modulate.a < 0:
			$DialogueBox/Portrait.self_modulate.a = 0
		if $DialogueBox/Portrait.position.x > portraitX - 2:
			$DialogueBox/Portrait.position.x -= 0.4
		if $DialogueBox/Portrait.position.x < portraitX - 2:
			$DialogueBox/Portrait.position.x = portraitX - 2
	$Debug.text = " X Velocity : " + str(VelX) + "\n Y Velocity : " + str(VelY)
