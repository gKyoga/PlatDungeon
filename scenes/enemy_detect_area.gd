extends Area2D

var enemy_in_area = []
var enemy_target : Node2D  = null


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if enemy_in_area.size() == 0:
		enemy_target = null
		return
	
	var closest = null
	var min_distance = INF
	for i in enemy_in_area:
		if not is_instance_valid(i):
			continue
		var dist = global_position.distance_squared_to(i.global_position)
		if dist < min_distance:
			min_distance = dist
			closest = i
	
	enemy_target = closest
	
	pass



func _on_body_entered(body: Node2D ) -> void:
	if body.is_in_group("Enemy"):
		if body not in enemy_in_area:
			enemy_in_area.append(body)
		print("Entrou: ", body.name)


func _on_body_exited(body: Node2D ) -> void:
	
	if body in enemy_in_area:
		enemy_in_area.erase(body)
	if body == enemy_target:
		enemy_target = null
	
	print("Saiu: ", body.name)
	pass # Replace with function body.
