extends Node2D

signal camera(x1, x2, y1, y2)

var opacity = 0

func _on_overlaycollision_body_entered(body):
	if body.name == "Player":
		opacity = 0.9
		emit_signal("camera", position.x - get_viewport_rect().size.x / 2, position.x + get_viewport_rect().size.x / 2, position.y - get_viewport_rect().size.y / 2, position.y + get_viewport_rect().size.y / 2)

func _on_overlaycollision_body_exited(body):
	if body.name == "Player":
		opacity = 0
		emit_signal("camera", -10000000, 10000000, -10000000, 10000000)

func _process(delta):
	if has_node("Polygon2D"):
		if opacity > $Polygon2D.self_modulate.a:
			$Polygon2D.self_modulate.a += 0.1
			$Outside.self_modulate.a -= 0.11
			if opacity < $Polygon2D.self_modulate.a:
				$Polygon2D.self_modulate.a = 0.9
				$Outside.self_modulate.a = 0
		elif opacity < $Polygon2D.self_modulate.a:
			$Polygon2D.self_modulate.a -= 0.1
			$Outside.self_modulate.a += 0.11
			if opacity > $Polygon2D.self_modulate.a:
				$Polygon2D.self_modulate.a = 0
				$Outside.self_modulate.a = 1
	
	if visible:
		$Ground.collision_layer = 1
	else:
		$Ground.collision_layer = 0
