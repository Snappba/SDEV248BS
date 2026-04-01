# debug_camera_movement.gd
extends Camera2D

@export var speed: float = 400  # camera movement speed

func _physics_process(delta):
	# Only move if this camera is active
	if not is_current():
		return

	var move = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		move.x += 1
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
	if Input.is_action_pressed("ui_down"):
		move.y += 1
	if Input.is_action_pressed("ui_up"):
		move.y -= 1

	position += move.normalized() * speed * delta
