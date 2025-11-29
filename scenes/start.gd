extends Button

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("START"):
		get_tree().change_scene_to_file("res://scenes/Level_1.tscn")
