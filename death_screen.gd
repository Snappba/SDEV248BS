extends CanvasLayer

var level_to_reload := ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Works while paused

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		retry()

func retry():
	get_tree().paused = false
	
	if level_to_reload != "":
		get_tree().change_scene_to_file(level_to_reload)
	else:
		print("No level assigned!")
