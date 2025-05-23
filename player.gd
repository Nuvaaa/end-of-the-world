extends CharacterBody2D
signal VelX(value)
signal VelY(value)
signal Start_Dialogue(value)

var block_input = 0

var gravity = 5
var speed = 90
var jump = 150
var maxSpeed = 315
var spawnpoint = position

var dialogue
var dialogue_cooldown = false

func _ready():
	$AnimatedSprite2D.play()

func _on_test_dialogue_body_entered(body: Node2D) -> void:
	dialogue = "TestDialogue"
	
func _on_test_dialogue_body_exited(body: Node2D) -> void:
	dialogue = null

func input():
	if block_input > 0:
		velocity.x = 0
		return false
	
	if Input.is_action_just_pressed("respawn"):
		position = spawnpoint
		velocity = Vector2.ZERO
	
	if is_on_floor():
		if dialogue != null and Input.is_action_just_pressed("interact") and !dialogue_cooldown:
			emit_signal("Start_Dialogue", dialogue)
			block_input += 1
		elif dialogue_cooldown:
			dialogue_cooldown = false
		
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
	
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
	
func _on_dialogue_box_dialogue_ended() -> void:
	block_input -= 1
	dialogue_cooldown = 1

func _physics_process(_delta):
	
	if is_on_floor():
		velocity.y = 0
	elif velocity.y < maxSpeed:
		velocity.y += gravity
	
	input()
	
	if velocity.x > speed:
		velocity.x = speed
	if velocity.x < speed * -1:
		velocity.x = speed * -1
	if velocity.y > speed * 3:
		velocity.y = speed * 3
	
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
	
	emit_signal("VelX" ,velocity.x)
	emit_signal("VelY" ,velocity.y)
	move_and_slide()
