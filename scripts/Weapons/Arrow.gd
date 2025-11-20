extends Area2D
class_name Arrow

# boolean stats
var inGame = false
var atacking = false
var target: Node2D = null

# Stats
var damage = 10.0
var atk_codown = 1.0
var atk_speed = 900


func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * atk_speed * delta
		rotation = direction.angle()
	else:
		# se o target sumiu, destrói a flecha
		queue_free()


func _on_body_entered(body: Node) -> void:
	if is_instance_valid(target) and body == target:
		if target.has_method("take_damage"):
			target.take_damage(damage)
		queue_free()
		print("acertou")
