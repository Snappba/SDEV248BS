# debug_camera.gd
extends Node

@onready var pc_camera = $PC/Camera2D
@onready var debug_camera = $DebugCamera

var using_debug := false

func _input(event):
	if event.is_action_pressed("toggle_debug_cam"):
		using_debug = !using_debug
		if using_debug:
			debug_camera.make_current()
		else:
			pc_camera.make_current()
