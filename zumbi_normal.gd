extends CharacterBody2D


@export var speed: float = 10
@export var dano: int = 2  # Dano do zumbi
@onready var anim = $AnimatedSprite2D
@onready var player = get_tree().get_nodes_in_group("player")[0]  # Obtém o jogador




var attacking = false

func _process(delta):
	if attacking or not player:
		return
	

	# Define a direção em direção ao jogador

	# Define a direção em direção ao jogador

	var direction = (player.global_position - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()


	# Ajusta a animação conforme a direção

	# Ajusta a animação conforme a direção

	anim.flip_h = direction.x < 0
	anim.play("mov_direita")

func _on_attck_area_ataque_body_entered(body) -> void:

	if body.is_in_group("player"):  
		print("Zumbi atacou", body.name)  # Depuração para ver se está atacando certo
		
		# Pegando o nó certo do jogador
		var player = body  # <--- ALTERADO (antes pegava get_parent())
		
		if player.has_method("receber_dano"):
			print("Dano aplicado!")  # Depuração para ver se o dano é chamado
			player.receber_dano(dano)  # Aplica dano

	if body.is_in_group("player"):

		attacking = true
		anim.play("ataque")
		await anim.animation_finished
		attacking = false
