extends Enemy

@export var speed: float = 100.0
@export var attack_range: float = 80.0
@export var chase_range: float = 400.0
var player_targets: Array = []

# --- Spawn ---
@export var minion_scene: PackedScene
var has_spawned_minions = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("Enemy")
	collision_layer = 4
	collision_mask  = 1
	super._ready()

	player_targets = get_tree().get_nodes_in_group("Player")
	set_state(State.IDLE)

func get_closest_player() -> Node2D:
	var closest: Node2D = null
	var closest_dist := INF

	for p in player_targets:
		if is_instance_valid(p):
			var dist = global_position.distance_to(p.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = p

	return closest

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	# SPAWN DE MINIONS AO CHEGAR A 50% DE VIDA
	if not has_spawned_minions and current_health <= max_health * 0.5:
		spawn_minions()
		has_spawned_minions = true

	var target = get_closest_player()

	if target == null:
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Idle":
			anim_sprite.play("Idle")
		return

	var direction_to_player = (target.global_position - global_position).normalized()
	anim_sprite.flip_h = direction_to_player.x < 0
	var distance_to_player = global_position.distance_to(target.global_position)

	# atacar
	if distance_to_player <= attack_range:
		set_state(State.ATTACK)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Attack":
			anim_sprite.play("Attack")
		attack(target)

	# perseguir
	elif distance_to_player < chase_range:
		set_state(State.CHASE)
		velocity = direction_to_player * speed
		move_and_slide()
		if anim_sprite.animation != "Chase":
			anim_sprite.play("Chase")

	# parado
	else:
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Idle":
			anim_sprite.play("Idle")


func spawn_minions():
	if minion_scene == null:
		print("Nenhum minion definido para spawn!")
		return

	# spawn 2 minions ao redor do inimigo principal
	for i in range(5):
		var minion = minion_scene.instantiate()
		var offset = Vector2(randf_range(-50,50), randf_range(-50,50))
		minion.global_position = global_position + offset
		get_tree().current_scene.add_child(minion)

func die():
	set_state(State.DEAD)
	anim_sprite.play("Dead")
	await anim_sprite.animation_finished
	super.die()
