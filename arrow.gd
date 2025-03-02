extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 256.0  # Velocidade da flecha

func _ready() -> void:
	randomize()
	connect("area_entered", Callable(self, "_on_collision"))
	connect("body_entered", Callable(self, "_on_collision"))

func _physics_process(delta: float) -> void:
	translate(direction * delta * speed)

# Função chamada quando a flecha colide com algo
func _on_collision(_collider):
	print("colidiu")



func _on_body_entered(body: CharacterBody2D) -> void:
	var dano = 2 
	print("flecha pegou no ", body.name)  # Depuração para ver se está atacando certo
		
		# Pegando o nó certo do jogador
	var zumbi = body  # <--- ALTERADO (antes pegava get_parent())
		
	if zumbi.has_method("receber_dano"):
		print("Dano aplicado!")  # Depuração para ver se o dano é chamado
		zumbi.receber_dano(dano)
	queue_free()
