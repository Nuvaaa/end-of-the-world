extends Polygon2D

var fadeGoal = 0

func _ready():
	visible = true

func _process(delta):
	if fadeGoal > self_modulate.a:
		self_modulate.a += 0.05
		if self_modulate.a > fadeGoal:
			self_modulate.a = fadeGoal
	elif fadeGoal < self_modulate.a:
		self_modulate.a -= 0.05
		if self_modulate.a < fadeGoal:
			self_modulate.a = fadeGoal
