extends Node2D

@export var level_scene_path := "res://main.tscn"
@export var dolla_threshold := 10

@onready var area := $LevelEnd

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Stop the trigger from firing multiple times
		area.monitoring = false

		# Load the end scene
		var end_scene_res = preload("res://end_scene.tscn")
		var end_scene = end_scene_res.instantiate()

		# Pass player stats and level info
		end_scene.level_to_reload = level_scene_path
		end_scene.player_dollas = body.dollas
		end_scene.dolla_threshold = dolla_threshold

		# Add it to the root so it renders above the paused main scene
		get_tree().get_root().add_child(end_scene)

		# Pause the game AFTER adding the CanvasLayer
		get_tree().paused = true
