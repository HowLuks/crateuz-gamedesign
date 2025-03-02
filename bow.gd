extends Node2D

@onready var animation: AnimationPlayer = $Animation
@onready var bow: Sprite2D = $Bow
const ARROW: PackedScene = preload("res://arrow.tscn")

var is_attacking: bool = false
var last_direction = Vector2.RIGHT  # Direção inicial do arco

# Parâmetros ajustáveis para translação do arco
var offset_distance = 10  # Ajuste esse valor conforme necessário

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		animation.play("attack")
		is_attacking = true

func spawn_arrow() -> void:
	var arrow = ARROW.instantiate()
	
	# Posicionar a flecha na frente do arco e alinhar sua rotação
	arrow.global_position = global_position
	arrow.direction = last_direction
	arrow.rotation = bow.rotation  # Flecha herda a rotação do arco

	get_tree().root.call_deferred("add_child", arrow)

func update_rotation(new_direction: Vector2):
	last_direction = new_direction  # Atualiza a direção do arco

	# Definir posição relativa do arco com base na direção
	if new_direction == Vector2.RIGHT:
		bow.position = Vector2(offset_distance, 0)
		bow.rotation_degrees = 0
	elif new_direction == Vector2.LEFT:
		bow.position = Vector2(-offset_distance, 0)
		bow.rotation_degrees = 180
	elif new_direction == Vector2.UP:
		bow.position = Vector2(0, -offset_distance)
		bow.rotation_degrees = -90
	elif new_direction == Vector2.DOWN:
		bow.position = Vector2(0, offset_distance)
		bow.rotation_degrees = 90

func _on_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false
