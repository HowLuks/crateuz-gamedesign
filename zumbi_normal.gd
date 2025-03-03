extends CharacterBody2D

@export var speed: float = 10
@export var dano: int = 2
@export var vida_max_zumbi = 10
var vida_atual_zumbi

@onready var anim = $AnimatedSprite2D
@onready var player = get_tree().get_nodes_in_group("player")[0]

var attacking = false
var morto = false
var player_in_attack_range = false
var can_attack = true

func _ready():
	add_to_group("zumbi")  
	vida_atual_zumbi = vida_max_zumbi

func _process(delta):
	if morto or not player:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	anim.flip_h = direction.x < 0

	if player_in_attack_range:
		if not attacking:
			print("Iniciando animação de ataque!")
			attacking = true
			anim.play("ataque")
	else:
		attacking = false
		anim.play("mov_direita")

func _on_area_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  
		print("Jogador (Lua) entrou na área de ataque!")
		player_in_attack_range = true
		attacking = true
		anim.play("ataque")
		
		# Aguarda o momento certo da animação para aplicar dano
		await get_tree().create_timer(0.5).timeout  # Ajuste o tempo conforme o frame do ataque

		if player_in_attack_range and body.has_method("receber_dano"):
			body.receber_dano(dano)

		await anim.animation_finished
		attacking = false



func _on_area_ataque_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):  
		player_in_attack_range = false
		print("Jogador saiu da área de ataque!")

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "ataque":
		print("Animação de ataque terminou!")
		can_attack = true
		attacking = false

func _on_animated_sprite_2d_frame_changed():
	if anim.animation == "ataque" and can_attack:
		if anim.frame == 2:  # Altere para o frame desejado
			if player_in_attack_range and player.has_method("receber_dano"):
				print("Aplicando dano ao jogador!")
				player.receber_dano(dano)
				can_attack = false

func receber_dano(dano: int):
	vida_atual_zumbi -= 10
	print("Zumbi", name, "recebeu dano:", dano, "Vida restante:", vida_atual_zumbi)

	if vida_atual_zumbi <= 0:
		morrer()

func morrer():
	if morto:
		return  

	morto = true
	print("Zumbi", name, "morreu!")  
	anim.stop()
	anim.play("morte")  
	print("Animação morte iniciada!")

	await get_tree().create_timer(1.0).timeout  

	print("Animação morte terminou!")  
	queue_free()
