extends CharacterBody2D

@export var speed: float = 50.0
@export var vida_max = 10
var vida_atual

@onready var anim = $"Movimentação"
@onready var barra_de_vida: ProgressBar = $barra_de_vida
@onready var bow = $"./Hand"  # Pegando o arco pelo caminho correto

var last_direction: Vector2 = Vector2.RIGHT  # Direção inicial

func _ready():
	add_to_group("player")
	vida_atual = vida_max
	barra_de_vida.value = vida_atual  # Inicializa a barra de vida

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		direction.y = -1
	
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
		_update_bow()
	
	velocity = direction.normalized() * speed
	
	if direction != Vector2.ZERO:
		anim.flip_h = last_direction.x < 0
		anim.play("andar_direita")
	else:
		anim.flip_h = last_direction.x < 0
		anim.play("parado_direita")
	
	move_and_slide()
	
	# Depuração: Verifique se a Lua está colidindo com algo
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Colidiu com:", collision.get_collider().name)

func _update_bow():
	if bow:
		bow.global_position = global_position  # Arco segue Lua
		bow.update_rotation(last_direction)  # Ajusta a direção do arco

func receber_dano(dano: int):
	vida_atual -= dano
	barra_de_vida.value = vida_atual  # Atualiza a barra de vida
	
	print("Vida atual:", vida_atual)  # Para depuração

	if vida_atual <= 0:
		morrer()
		get_tree().change_scene_to_file("res://inicio tela.tscn")

func morrer():
	queue_free()  # Remove o personagem do jogo (pode adicionar uma animação antes)
