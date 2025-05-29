extends CharacterBody2D
signal VelX(value)
signal VelY(value)

signal PosX(value)
signal Start_Dialogue(value)
signal HeyRed(position, hover, facingLeft)

var block_input = 0

var gravity = 5
var speed = 90
var jump = 150
var maxSpeed = 315
var spawnpoint = position

var dialogue
var dialogue_cooldown = false

var hover = false
var coyoteFrames = 0

func _ready():
	$Cyan.play()
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

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
		
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x = speed * -1
		else:
			velocity.x = 0
			
		hover = false
		coyoteFrames = 8
	else:
		if Input.is_action_pressed("move_right") and velocity.x < speed:
			velocity.x += speed / 30
		elif Input.is_action_pressed("move_left") and velocity.x > speed * -1:
			velocity.x -= speed / 30
		
		if !hover and Input.is_action_pressed("special") and velocity.y >= 0:
			hover = true
		elif !Input.is_action_pressed("special"):
			hover = false
		
		if coyoteFrames > 0:
			coyoteFrames -= 1
	
	if is_on_floor() or coyoteFrames > 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump * -1
			coyoteFrames = 0
	
	if Input.is_action_pressed("move_left"):
		$Cyan.flip_h = true
	if Input.is_action_pressed("move_right"):
		$Cyan.flip_h = false
	
func _on_dialogue_ended() -> void:
	block_input -= 1
	dialogue_cooldown = 1

func _physics_process(_delta):
	if is_on_floor():
		velocity.y = 0
	elif velocity.y < maxSpeed and !hover:
		velocity.y += gravity
	elif velocity.y > maxSpeed and !hover:
		velocity.y = maxSpeed
	elif velocity.y < maxSpeed / 6 and hover:
		velocity.y += gravity / 2
	elif velocity.y > maxSpeed / 6 and hover:
		velocity.y = maxSpeed / 6
	
	input()
	
	if velocity.x > speed:
		velocity.x = speed
	if velocity.x < speed * -1:
		velocity.x = speed * -1
	if velocity.y > speed * 3:
		velocity.y = speed * 3
	
	
	if is_on_floor():
		if velocity.x != 0:
			$Cyan.animation = "walk"
		else:
			$Cyan.animation = "idle"
	elif !hover:
		if velocity.y < 0:
			$Cyan.animation = "rise"
		else:
			$Cyan.animation = "fall"
	if hover:
		$Cyan.animation = "hover"
	
	emit_signal("VelX", velocity.x)
	emit_signal("VelY", velocity.y)
	emit_signal("PosX", position.x)
	move_and_slide()
	emit_signal("HeyRed", position, hover, $Cyan.flip_h)

func _on_npc_dialogue_range(name):
	dialogue = name
