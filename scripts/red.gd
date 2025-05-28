extends CharacterBody2D
var plrPos
var hovering
var flip
var grabbed
var lastDistance

func _on_player_hey_red(position, hover, facingLeft):
	plrPos = position + Vector2(0, -16)
	hovering = hover
	flip = facingLeft
	
func _process(delta):
	if hovering:
		$Red.animation = "hover"
		if grabbed:
			position = plrPos
			$Red.flip_h = flip
		else:
			velocity = (plrPos - position)
			velocity = velocity.normalized() * 600
			move_and_slide()
			if lastDistance - (position.distance_to(plrPos)) < 5:
				position = plrPos
				grabbed = true
	else:
		grabbed = false
		$Red.animation = "float"
		velocity = ((plrPos + Vector2(0, -5)) - position) * 3
		move_and_slide()
		if velocity.x != 0:
			$Red.flip_h = velocity.x < 0
	lastDistance = position.distance_to(plrPos)
	
