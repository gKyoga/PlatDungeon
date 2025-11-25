extends Area2D

@export var next_scene: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Verifica se existem inimigos na cena
		var enemies = get_tree().get_nodes_in_group("Enemy")
		if enemies.size() == 0:
			get_tree().change_scene_to_file(next_scene)
		else:
			print("Ainda existem inimigos na cena!")
