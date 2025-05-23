extends CanvasLayer
var VelX
var VelY

func _on_player_vel_x(value):
	VelX = value

func _on_player_vel_y(value):
	VelY = value

func _process(_delta):
	$Debug.text = " X Velocity : " + str(VelX) + "\n Y Velocity : " + str(VelY)
