extends CharacterBody2D

@export var speed: float = 60
@export var patrol_distance: float = 128  # how far from the start position
@export var dolla_texture: Texture2D
var start_pos: Vector2
var direction: int = 1
const GRAVITY = 800
var is_dead := false

func _ready():
	start_pos = global_position
	add_to_group("enemies")
func stomped():
	
	if is_dead:
		return
	is_dead = true
	print("spawning dolla") # debug
	# Instance the Dolla scene 
	var dolla_scene = preload("res://dollas.tscn")  # path to Dolla scene
	var dolla_instance = dolla_scene.instantiate()
	
	# Add to the same parent as the taxman
	get_parent().add_child(dolla_instance)
	
	# Position at the taxman's current location
	dolla_instance.global_position = global_position
	# Remove the taxman
	queue_free()
func _physics_process(delta):
	velocity.x = speed * direction
	move_and_slide()
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Flip sprite based on direction
	$Sprite2D.flip_h = direction < 0
	
	# Turn around if we reach patrol distance
	if abs(global_position.x - start_pos.x) >= patrol_distance:
		direction *= -1

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
