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

var dialogue
var dialogue_cooldown = false

var hover = false
var coyoteFrames = 0
var lastMovementTime = 0
var sitting = false
var grabbing = false
var jumpBuffer = 0

func _ready():
	$Cyan.play()

func input():
	if block_input > 0:
		velocity.x = 0
		return false
	
	if grabbing:
		velocity.y = 0
		if not Input.is_action_pressed("left") and not Input.is_action_pressed("right") or not $RayCast2DGrab.is_colliding():
			grabbing = false
	else:
		if $RayCast2DGrab.target_position.x == -7 and Input.is_action_pressed("left") and not $RayCast2DCheck.is_colliding() and $RayCast2DGrab.is_colliding() and velocity.y >= 0:
			grabbing = true
		elif $RayCast2DGrab.target_position.x == 7 and Input.is_action_pressed("right") and not $RayCast2DCheck.is_colliding() and $RayCast2DGrab.is_colliding() and velocity.y >= 0:
			grabbing = true
	
	if is_on_floor():
		if dialogue != null and Input.is_action_just_pressed("interact") and !dialogue_cooldown:
			emit_signal("Start_Dialogue", dialogue)
			sitting = false
			block_input += 1
		elif dialogue_cooldown:
			dialogue_cooldown = false
		
		if Input.is_action_pressed("right"):
			velocity.x = speed
		elif Input.is_action_pressed("left"):
			velocity.x = speed * -1
		else:
			velocity.x = 0
			
		hover = false
		coyoteFrames = 8
	else:
		if Input.is_action_pressed("right") and velocity.x < speed:
			velocity.x += speed / 30
		elif Input.is_action_pressed("left") and velocity.x > speed * -1:
			velocity.x -= speed / 30
		
		if !hover and Input.is_action_pressed("special") and velocity.y >= 0:
			hover = true
		elif !Input.is_action_pressed("special"):
			hover = false
		if grabbing:
			hover = false
		
		if coyoteFrames > 0:
			coyoteFrames -= 1
	
	if is_on_floor() or coyoteFrames > 0 or grabbing:
		if Input.is_action_just_pressed("jump") or jumpBuffer > 0:
			velocity.y = jump * -1
			coyoteFrames = 0
			grabbing = false
			jumpBuffer = 0
	elif Input.is_action_just_pressed("jump"):
		jumpBuffer = 5
	elif not Input.is_action_pressed("jump"):
		jumpBuffer = 0
	if jumpBuffer > 0:
		jumpBuffer -= 1
	
	if Input.is_action_pressed("left"):
		$Cyan.flip_h = true
		$RayCast2DGrab.target_position.x = -7
		$RayCast2DCheck.target_position.x = -7
	if Input.is_action_pressed("right"):
		$Cyan.flip_h = false
		$RayCast2DGrab.target_position.x = 7
		$RayCast2DCheck.target_position.x = 7
	
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
		if Time.get_ticks_msec() - lastMovementTime >= 7000:
			if $Cyan.frame == 0 and $Cyan.animation == "idle":
				$Cyan.animation = "sit"
			elif $Cyan.frame == 6 and sitting:
				$Cyan.animation = "sitting"
			elif $Cyan.frame > 0 and $Cyan.animation == "sit":
				sitting = true
		elif velocity.x != 0:
			sitting = false
			$Cyan.animation = "walk"
		else:
			$Cyan.animation = "idle"
	elif !hover:
		if velocity.y < 0:
			$Cyan.animation = "rise"
		elif grabbing:
			$Cyan.animation = "grab"
		else:
			$Cyan.animation = "fall"
	if hover:
		$Cyan.animation = "hover"
	if velocity != Vector2.ZERO or block_input > 0:
		lastMovementTime = Time.get_ticks_msec()
	
	emit_signal("VelX", velocity.x)
	emit_signal("VelY", velocity.y)
	emit_signal("PosX", position.x)
	move_and_slide()
	emit_signal("HeyRed", position, hover, sitting, $Cyan.flip_h)

func _on_npc_dialogue_range(name):
	dialogue = name
