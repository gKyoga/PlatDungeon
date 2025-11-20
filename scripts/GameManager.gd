# Gerenciador das fases do jogo =) 
extends Node2D

@export var skeleton_scene: PackedScene
@export var boss_orc_scene: PackedScene

# Esta lista não será mais usada para spawnar os esqueletos, mas pode ser mantida para outros propósitos futuros.
var spawn_positions: Array = [
	#Vector2(13, 15),
	#Vector2(1054, 590),
	#Vector2(1061, 389),
	#Vector2(86, 548),
	#Vector2(200, 200),
	#Vector2(800, 100),
	#Vector2(100, 400),
	#Vector2(900, 500)
]

func _ready():
	Global.all_skeletons_dead.connect(on_all_skeletons_dead)
	Global.skeleton_died.connect(on_skeleton_died)
	
	var initial_skeletons = get_tree().get_nodes_in_group("Skeleton")
	Global.skeletons_alive = initial_skeletons.size()
	
	if Global.skeletons_alive == 0:
		spawn_skeletons()

func spawn_skeletons():
	var player = get_tree().get_first_node_in_group("Player")

	if not player:
		print("ERRO: Jogador não encontrado! Não foi possível spawnar esqueletos.")
		return

	var spawn_distance = 300.0 

	for i in range(Global.max_skeletons):
		var skeleton = skeleton_scene.instantiate()

		# Calcula uma nova posição aleatória para CADA esqueleto
		var random_angle = randf_range(0, 2 * PI)
		var offset = Vector2(spawn_distance, 0).rotated(random_angle)
		var spawn_position = player.global_position + offset

		skeleton.global_position = spawn_position
		add_child(skeleton)
		Global.skeletons_alive += 1
		skeleton.add_to_group("Skeleton")

# Gerencia a quantidade de esqueletos na primeira fase e spawna o Boss
func on_all_skeletons_dead():
	if Global.skeletons_killed_total >= 2 and not Global.boss_orc_spawned:
		spawn_boss_orc()
		Global.boss_orc_spawned = true
	else:
		# Verifica se o chefe já apareceu; se sim, não spawna mais esqueletos.
		if not Global.boss_orc_spawned:
			spawn_skeletons()

func spawn_boss_orc():
	print("Boss Orc will spawn!")
	
	var player = get_tree().get_first_node_in_group("Player")
	
	if not player:
		print("ERRO: Jogador não encontrado! O chefe aparecerá em uma posição aleatória.")
		var random_pos = spawn_positions[randi() % spawn_positions.size()]
		var boss_orc = boss_orc_scene.instantiate()
		boss_orc.position = random_pos
		add_child(boss_orc)
		Global.max_skeletons = 0
		return

	var spawn_distance = 250.0 
	
	var random_angle = randf_range(0, 2 * PI)
	
	var offset = Vector2(spawn_distance, 0).rotated(random_angle)
	
	var spawn_position = player.global_position + offset

	var boss_orc = boss_orc_scene.instantiate()
	boss_orc.global_position = spawn_position
	add_child(boss_orc)
	
	Global.max_skeletons = 0

func on_skeleton_died():
	print("Esqueletos mortos: ", Global.skeletons_killed_total)
