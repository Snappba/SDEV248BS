extends CharacterBody2D

# --- Player stats ---
@export var max_lives := 3
var lives := max_lives
var dollas := 000
var is_invulnerable := false
@export var level_scene_path :="res://main.tscn"
# --- Movement ---
@export var speed := 150
@export var jump_force := -500
@export var gravity := 800
var direction := 0

# --- Camera reference ---
@onready var pc_camera: Camera2D = $Camera2D

# --- HUD reference ---
@onready var hud: Control = get_tree().current_scene.get_node("CanvasLayer/HUD")

func _ready():
	add_to_group("player")
	update_hud()
	
func get_dollas() -> int:
	return dollas

func _physics_process(delta):
	if not pc_camera.is_current():
		return  # freeze player if debug cam is active

	# Horizontal movement
	direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	# Move player
	move_and_slide()

	# Flip sprite
	if direction != 0:
		$Sprite2D.flip_h = direction < 0

	# --- Collision detection with enemies ---
	for i in get_slide_collision_count():
		var col = get_slide_collision(i).get_collider()
		if col.is_in_group("enemies"):
			take_damage(1)

# --- Damage handling ---
func take_damage(amount := 1):
	if is_invulnerable:
		return
	lives -= amount
	update_hud()
	if lives <= 0:
		die()
	else:
		start_invulnerability()

func start_invulnerability():
	is_invulnerable = true
	var sprite = $Sprite2D
	var flicker_time = 1.0
	var interval = 0.1
	var elapsed = 0.0

	while elapsed < flicker_time:
		sprite.modulate.a = 0.3
		await get_tree().create_timer(interval).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(interval).timeout
		elapsed += interval * 2

	is_invulnerable = false
# -- player death --
func die():
	var death_screen = load("res://death_screen.tscn").instantiate()
	death_screen.level_to_reload = level_scene_path
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().current_scene.add_child(death_screen)

	# NOW pause the game
	get_tree().paused = true

	visible = false

# --- Stomp detection ---
func _on_stomp_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.has_method("stomped"):
		body.stomped()
		velocity.y = -300

# --- Dollas ---
func add_dolla(amount := 1):
	dollas += amount
	update_hud()

# --- HUD ---
func update_hud():
	if hud:
		hud.update_hud(lives, dollas)
	else:
		print("HUD not found!")
