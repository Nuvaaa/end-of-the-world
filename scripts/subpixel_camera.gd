extends Camera2D

var actual_cam_pos : Vector2

func _process(delta):
	actual_cam_pos = actual_cam_pos.lerp($"../Cyan".global_position, delta * 3)
	
	var cam_subpixel_offset = actual_cam_pos.round() - actual_cam_pos
	
	if get_parent().get_parent().get_parent():
		get_parent().get_parent().get_parent().material.set_shader_parameter("cam_offset", cam_subpixel_offset)
	
	global_position = actual_cam_pos.round()
	
	print(actual_cam_pos)
