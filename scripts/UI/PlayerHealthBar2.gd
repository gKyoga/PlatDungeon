extends ProgressBar

var player: Node = null

func _ready():
	player = get_tree().current_scene.find_child("Archer2", true, false)

	if player:
		player.healthChanged.connect(update)
		update()
	else:
		push_error("Archer2 não encontrado na cena!")

func update():
	if player:
		value = player.current_health * 100 / player.max_health
