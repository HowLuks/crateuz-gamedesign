extends CharacterBody2D

@export var speed: float = 25.0
@export var change_direction_time: float = 1

@onready var anim = $AnimatedSprite2D

var direction = Vector2.ZERO
var timer = 0.0
var attacking = false

func _process(delta):
	if attacking:
		return
	
	timer -= delta
	if timer <= 0:
		change_direction()
		timer = change_direction_time
	
	velocity = direction * speed
	move_and_slide()
	
	anim.flip_h = direction.x < 0
	anim.play("mov_direita")

func change_direction():
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	direction = directions[randi() % directions.size()]


func _on_attck_area_ataque_body_entered(body) -> void:
	if body.is_in_group("player"):
		attacking = true
		anim.play("attack")
		await anim.animation_finished
		attacking = false
