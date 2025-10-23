extends CharacterBody2D

var moveDirection = Vector2(0, 0)

func walk():
	moveDirection[0] = Input.get_axis("left", "right")

func friction():
	var fric : float
	var tile = $"../Ground".get_cell_tile_data($"../Ground".local_to_map(position + Vector2(0, 16)))
	if tile:
		fric = tile.get_custom_data("friction")
	else:
		fric = 0.1
	
	if fric == 1:
		velocity[0] = moveDirection[0] * 50
	
func _process(_delta):
	walk()
	friction()
	
	move_and_slide()
