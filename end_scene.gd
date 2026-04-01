extends CanvasLayer

var player_dollas := 0
var dolla_threshold := 15
var level_to_reload := ""

@onready var main_label := $ColorRect/VBoxContainer/Label

func _ready():
	# Dynamic message based on dollas
	if player_dollas >= dolla_threshold:
		main_label.text = "You have enough left to survive another week!"
	else:
		main_label.text = "You will have to eat only noodles to survive..."

	# Ensure input works while game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		# Unpause the game
		get_tree().paused = false
		# Remove this end scene from the root
		queue_free()
		# Reload level
		if level_to_reload != "":
			get_tree().change_scene_to_file(level_to_reload)
		else:
			get_tree().reload_current_scene()
