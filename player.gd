extends CharacterBody2D

var gravity = 5
var speed = 90
var jump = 150
var maxSpeed = 315
var spawnpoint = position

func _physics_process(_delta):
	if Input.is_action_pressed("respawn"):
		position = spawnpoint
		velocity = Vector2.ZERO
	
	if is_on_floor():
		velocity.y = 0
	elif velocity.y < maxSpeed:
		velocity.y += gravity
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump * -1
		
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x = speed * -1
		else:
			velocity.x = 0
	else:
		if Input.is_action_pressed("move_right") and velocity.x < speed:
			velocity.x += speed / 30
		elif Input.is_action_pressed("move_left") and velocity.x > speed * -1:
			velocity.x -= speed / 30
	
	if velocity.x > speed:
		velocity.x = speed
	if velocity.x < speed * -1:
		velocity.x = speed * -1
	if velocity.y > speed * 3:
		velocity.y = speed * 3
	
	$AnimatedSprite2D.play()
	
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
	
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
		else:
			$AnimatedSprite2D.animation = "idle"
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "rise"
		else:
			$AnimatedSprite2D.animation = "fall"
	
	move_and_slide()
	$GesPunkte.PlrVelX = velocity.x
