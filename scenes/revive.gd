extends Area2D

func _on_body_entered(body: Node2D) -> void:
	set_process(true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):

		var players = get_tree().get_nodes_in_group("Player")

		for p in players:
			if is_instance_valid(p):
				reset_player(p)

		set_process(false)


func reset_player(player: Node2D):
	# Reseta a vida
	if player.has_variable("current_health") and player.has_variable("max_health"):
		player.current_health = player.max_health

		# Atualiza a UI de vida
		if player.has_signal("healthChanged"):
			player.healthChanged.emit()
