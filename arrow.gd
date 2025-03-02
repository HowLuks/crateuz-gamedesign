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
	#queue_free()  # Remove a flecha ao colidir
