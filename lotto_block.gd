extends Node2D

# --- Exports ---
@export var dolla_scene: PackedScene
@export var unscratched_region := Rect2(0, 32, 32, 32)
@export var scratched_region := Rect2(32, 32, 32, 32)

# --- Nodes ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var bump_area: Area2D = $BumpArea

# --- State ---
var scratched := false

func _ready():
	# Enable region on sprite
	sprite.region_enabled = true
	sprite.region_rect = unscratched_region

	# Connect bump signal
	bump_area.body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if scratched:
		return
	if not body.is_in_group("player"):
		return

	# --- Check if player is below the block ---
	if body.global_position.y < global_position.y:
		return  # hit from above, ignore

	# --- Scratch the block ---
	scratched = true
	sprite.region_rect = scratched_region

	# --- Spawn a dolla above the block ---
	if dolla_scene:
		var dolla = dolla_scene.instantiate()
		get_parent().add_child(dolla)
		# Place dolla slightly above block
		dolla.global_position = global_position + Vector2(0, -sprite.region_rect.size.y-50)
