# StompArea.gd
extends Area2D

@export var bounce_force := -300

func _ready():
	# Connect signal in code (optional if done in editor)
	body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("enemies") and body.has_method("stomped"):
		body.stomped()
		
		# Bounce the player
		var parent_pc = get_parent() as CharacterBody2D
		if parent_pc:
			parent_pc.velocity.y = bounce_force
