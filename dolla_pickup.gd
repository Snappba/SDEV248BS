extends Area2D

@export var dolla_value := 1

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):  # add your PC to "player" group
		body.add_dolla(dolla_value)
		queue_free()
