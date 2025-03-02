extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 256.0  # Velocidade da flecha

func _ready() -> void:
	randomize()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	translate(direction * delta * speed)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("zumbi"):  # Verifica se o corpo atingido é um zumbi
		var dano = 2
		print("Flecha atingiu ", body.name)

		if body.has_method("receber_dano"):
			print("Dano aplicado de", dano)
			body.receber_dano(dano)

		queue_free()  # Destroi a flecha após atingir algo
