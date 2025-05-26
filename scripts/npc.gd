extends Area2D
signal dialogue(value)

func _ready():
	$Interact.visible = false

func _on_body_entered(body):
	$Interact.visible = true
	emit_signal("dialogue", name)

func _on_body_exited(_body):
	$Interact.visible = false
	emit_signal("dialogue", null)

func _on_player_pos_x(value):
	$AnimatedSprite2D.flip_h = $AnimatedSprite2D.global_position.x < value
