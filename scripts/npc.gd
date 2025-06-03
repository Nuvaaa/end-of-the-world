extends Area2D
signal dialogue(value)

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Vector4(1, 1, 1, 0))

func _on_body_entered(body):
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Vector4(1, 1, 1, 1))
	emit_signal("dialogue", name)

func _on_body_exited(_body):
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Vector4(1, 1, 1, 0))
	emit_signal("dialogue", null)

func _on_player_pos_x(value):
	$AnimatedSprite2D.flip_h = $AnimatedSprite2D.global_position.x < value
