extends Area2D
class_name Food

# Indica se a comida está ativa no jogo
var inGame: bool = false

# Quanto a comida cura
var heal: float = 25.0

# Tempo de vida da comida antes de sumir
@export var lifetime: float = 10.0
var timer: float = 0.0

func _physics_process(delta: float) -> void:
	if inGame:
		timer += delta
		if timer >= lifetime:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if inGame and body.is_in_group("Player"):
		body.current_health += heal
		if body.current_health > body.max_health:
			body.current_health = body.max_health

			# Emite o signal para atualizar UI, se houver
			if body.has_signal("healthChanged"):
				body.healthChanged.emit()
		
		queue_free()
