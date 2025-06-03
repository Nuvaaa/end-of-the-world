extends CharacterBody2D
var plrPos
var hovering
var sit
var flip
var grabbed
var lastDistance

func _on_player_hey_red(position, hover, sitting, facingLeft):
	plrPos = position + Vector2(0, -16)
	hovering = hover
	sit = sitting
	flip = facingLeft
	
func _process(delta):
	if sit:
		if grabbed:
			position = plrPos - Vector2((int(!flip) * 2 - 1) * 2, -5)
			$Red.animation = "idle"
			$Red.flip_h = !flip
		else:
			$Red.animation = "float"
			velocity = (plrPos - Vector2((int(!flip) * 2 - 1) * 2, -5) - position)
			velocity = velocity.normalized() * 5
			move_and_slide()
			if position.distance_to(plrPos - Vector2((int(!flip) * 2 - 1) * 2, -5)) < 0.1:
				grabbed = true
	elif hovering:
		if grabbed:
			position = plrPos
			$Red.animation = "hover"
		else:
			$Red.animation = "float"
			velocity = (plrPos - position)
			velocity = velocity.normalized() * 600
			move_and_slide()
			if lastDistance - (position.distance_to(plrPos)) < 5:
				position = plrPos
				grabbed = true
	else:
		grabbed = false
		$Red.animation = "float"
		velocity = ((plrPos + Vector2((int(flip) * 2 - 1) * 14, -5)) - position) * 3
		move_and_slide()
	$Red.flip_h = flip
	lastDistance = position.distance_to(plrPos)
	
