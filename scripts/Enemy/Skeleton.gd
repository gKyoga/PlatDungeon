extends Enemy

@export var speed: float = 150.0
@export var attack_range: float = 80.0 
@export var detect_range: float = 400.0

var player: Node2D = null
var locked_on_target := false  # 👈 NOVO

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	super._ready()
	set_state(State.IDLE)
	add_to_group("Skeleton")

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	player = get_closest_player()

	# --- Se já travou o alvo e o player ainda existe, continua perseguindo ---
	if locked_on_target and player and is_instance_valid(player):
		chase_player(delta)
		return

	# --- Caso normal: só detecta antes de entrar em perseguição ---
	if player and is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= detect_range:
			locked_on_target = true  # 👈 TRAVA NO PLAYER
			chase_player(delta)
		else:
			idle()
	else:
		idle()


func chase_player(delta):
	if not player or !is_instance_valid(player):
		locked_on_target = false
		idle()
		return

	var distance_to_player = global_position.distance_to(player.global_position)
	var direction_to_player = (player.global_position - global_position).normalized()

	# virar sprite
	anim_sprite.flip_h = direction_to_player.x < 0

	# atacar
	if distance_to_player <= attack_range:
		set_state(State.ATTACK)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Attack":
			anim_sprite.play("Attack")
		attack(player)
		return

	# perseguir
	set_state(State.CHASE)
	velocity = direction_to_player * speed
	move_and_slide()
	if anim_sprite.animation != "Chase":
		anim_sprite.play("Chase")


func idle():
	set_state(State.IDLE)
	velocity = Vector2.ZERO
	if anim_sprite.animation != "Idle":
		anim_sprite.play("Idle")


func get_closest_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var min_distance = INF

	for p in players:
		if is_instance_valid(p):
			var dist = global_position.distance_squared_to(p.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_player = p

	return closest_player


func die():
	set_state(State.DEAD)
	anim_sprite.play("Dead")
	await anim_sprite.animation_finished
	super.die()
