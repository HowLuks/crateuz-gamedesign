extends Node2D

@onready var animation: AnimationPlayer = $Animation
@onready var bow: Sprite2D = $Bow
@onready var lua = $"./Lua"  # Ajuste o caminho conforme a hierarquia do nó

const ARROW: PackedScene = preload("res://arrow.tscn")

var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		animation.play("attack")
		is_attacking = true

func spawn_arrow() -> void:
	var arrow = ARROW.instantiate()
	
	# Posicionar a flecha na frente de Lua, na direção do arco
	arrow.global_position = global_position + lua.last_direction * 10  
	arrow.direction = lua.last_direction  # Ajustar direção da flecha

	get_tree().root.call_deferred("add_child", arrow)

func _on_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false
