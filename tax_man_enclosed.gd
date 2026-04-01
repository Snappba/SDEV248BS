extends CharacterBody2D

@export var speed: float = 80
@export var gravity: float = 900
@export var dolla_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_edge: RayCast2D = $RayCast2D_Edge
@onready var ray_wall: RayCast2D = $RayCast2D_Wall

var direction: int = 1 # 1 = right, -1 = left
var can_turn := true   # prevents spinning

func _ready():
	ray_edge.enabled = true
	ray_wall.enabled = true
	add_to_group("enemies")

func stomped():
	var dolla_scene = preload("res://dollas.tscn")
	var dolla = dolla_scene.instantiate()
	
	get_parent().add_child(dolla)
	dolla.global_position = global_position
	
	queue_free()

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	# Apply horizontal movement
	velocity.x = direction * speed

	# Flip rays based on direction
	ray_edge.target_position.x = abs(ray_edge.target_position.x) * direction
	ray_wall.target_position.x = abs(ray_wall.target_position.x) * direction

	# --- TURN LOGIC (FIXED) ---
	if can_turn and (not ray_edge.is_colliding() or ray_wall.is_colliding()):
		turn_around()

	# Flip sprite
	sprite.flip_h = direction < 0

	# Move the enemy
	move_and_slide()

func turn_around():
	direction *= -1
	can_turn = false

	# Flip ray directions immediately
	ray_edge.position.x = abs(ray_edge.position.x) * direction
	ray_wall.target_position.x = abs(ray_wall.target_position.x) * direction

	# Small delay to prevent rapid flipping
	await get_tree().create_timer(0.2).timeout
	can_turn = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
