extends Camera2D

@export var locked_y_position := 0.0  # set this to where you want the camera height

func _process(delta):
	global_position.y = -30
	
	
