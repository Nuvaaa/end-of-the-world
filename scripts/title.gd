extends Node2D

var fadeGoal = 0
var selection = 1
var scene = ""
var fadeout = false
var savegame = FileAccess.file_exists("user://savegame.save")

func _ready():
	$Fade.visible = true
	if !savegame:
		$continue.self_modulate.a = 0.5
		selection = 2

func _process(delta):
	if fadeGoal > $Fade.self_modulate.a:
		$Fade.self_modulate.a += 0.05
		if $Fade.self_modulate.a > fadeGoal:
			$Fade.self_modulate.a = fadeGoal
	elif fadeGoal < $Fade.self_modulate.a:
		$Fade.self_modulate.a -= 0.05
		if $Fade.self_modulate.a < fadeGoal:
			$Fade.self_modulate.a = fadeGoal
	
	
	if !fadeout:
		if Input.is_action_just_pressed("up"):
			selection -= 1
			$selectsound.play()
			if selection < 1 or selection < 2 and !savegame:
				selection = 4
		if Input.is_action_just_pressed("down"):
			selection += 1
			$selectsound.play()
			if selection > 4:
				if !savegame:
					selection = 2
				else:
					selection = 1
		
		if selection == 1:
			$arrow.position = $continue.position
			# if Input.is_action_just_pressed("interact"):
		elif selection == 2:
			$arrow.position = $newgame.position
			if Input.is_action_just_pressed("interact"):
				scene = "res://scenes/game.tscn"
				fadeout = true
				fadeGoal = 1
		elif selection == 3:
			$arrow.position = $options.position
			# if Input.is_action_just_pressed("interact"):
		elif selection == 4:
			$arrow.position = $quit.position
			if Input.is_action_just_pressed("interact"):
				get_tree().quit()
	else:
		if $Fade.self_modulate.a == fadeGoal:
			get_tree().change_scene_to_file(scene)
	
