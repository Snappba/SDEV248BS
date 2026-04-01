extends Control

@export var next_scene: String = "res://main.tscn"

func _ready():
	# Make sure this screen receives input
	set_process_input(true)

func _input(event):
	if event.is_pressed():
		start_game()

func start_game():
	get_tree().change_scene_to_file(next_scene)
