extends Enemy

@export var speed: float = 100.0
@export var attack_range: float = 80.0
@export var chase_range: float = 400.0
var player_targets: Array = []

# --- Spawn ---
@export var minion_scene: PackedScene
var has_spawned_minions = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar = $HealthBar


func _ready():
	add_to_group("Enemy")
	collision_layer = 4
	collision_mask = 1
	super._ready()

	# vida herdada da classe Enemy
	current_health = max_health

	if is_instance_valid(health_bar):
		health_bar.init_health(max_health)
		health_bar.health = current_health

	player_targets = get_tree().get_nodes_in_group("Player")
	set_state(State.IDLE)
	print("HB:", health_bar)


func take_damage(amount: int):
	current_health -= amount
	if health_bar_instance:
		health_bar_instance.health = current_health
	if current_health <= 0:
		die()

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

	if not has_spawned_minions and current_health <= max_health * 0.5:
		spawn_minions()
		has_spawned_minions = true

	var target = get_closest_player()

	if target == null:
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		anim_sprite.play("Idle")
		return

	var direction = (target.global_position - global_position).normalized()
	anim_sprite.flip_h = direction.x < 0
	var dist = global_position.distance_to(target.global_position)

	if dist <= attack_range:
		set_state(State.ATTACK)
		velocity = Vector2.ZERO
		anim_sprite.play("Attack")
		attack(target)

	elif dist < chase_range:
		set_state(State.CHASE)
		velocity = direction * speed
		move_and_slide()
		anim_sprite.play("Chase")

	else:
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		anim_sprite.play("Idle")


func spawn_minions():
	if minion_scene == null:
		print("Nenhum minion definido!")
		return

	for i in range(5):
		var minion = minion_scene.instantiate()
		var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		minion.global_position = global_position + offset
		get_tree().current_scene.add_child(minion)


func die():
	set_state(State.DEAD)
	anim_sprite.play("Dead")
	await anim_sprite.animation_finished
	super.die()
