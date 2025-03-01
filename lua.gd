extends CharacterBody2D

@export var speed: float = 50.0

@onready var anim = $"Movimentação"

var last_horizontal_direction = 1

func _ready():
	add_to_group("player")

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		last_horizontal_direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		last_horizontal_direction = -1
	
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		direction.y = -1
	
	velocity = direction.normalized() * speed
	
	if direction != Vector2.ZERO:
		anim.flip_h = last_horizontal_direction == -1
		anim.play("andar_direita")
	else:
		anim.flip_h = last_horizontal_direction == -1
		anim.play("parado_direita")
	
	move_and_slide()
