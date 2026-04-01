extends CharacterBody2D

@export var gravity := 800
@export var bounce_force := -150
@export var initial_push := Vector2(0, -200)

@onready var sprite := $Sprite2D
@onready var pickup_area := $Area2D

var collected := false

func _ready():
	velocity = initial_push
	pickup_area.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = bounce_force
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if collected:
		return
	if body.is_in_group("player"):
		if body.has_method("add_dolla"):
			collected = true
			body.add_dolla(1)
			queue_free()  # ✅ remove dolla immediately
