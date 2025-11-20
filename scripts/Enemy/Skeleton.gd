extends Enemy

@export var speed: float = 100.0
@export var attack_range: float = 80.0 
@export var detect_range: float = 400.0 # Transformei o 400 em variável para facilitar ajustes

var player: Node2D = null # Este será o alvo atual
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	super._ready()
	# Não pegamos mais o player fixo aqui, pois vamos calcular dinamicamente
	set_state(State.IDLE)
	add_to_group("Skeleton") 

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	# Busca o jogador mais próximo a cada frame
	player = get_closest_player()

	if player and is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Se estiver muito longe, o esqueleto desiste/fica Idle
		if distance_to_player > detect_range:
			set_state(State.IDLE)
			velocity = Vector2.ZERO
			if anim_sprite.animation != "Idle":
				anim_sprite.play("Idle")
			return # Sai da função para não executar o resto

		# Lógica de perseguição e ataque
		var direction_to_player = (player.global_position - global_position).normalized()
		
		if direction_to_player.x > 0:
			anim_sprite.flip_h = false
		elif direction_to_player.x < 0:
			anim_sprite.flip_h = true  

		if distance_to_player <= attack_range:
			set_state(State.ATTACK)
			velocity = Vector2.ZERO 
			if anim_sprite.animation != "Attack":
				anim_sprite.play("Attack")
			attack(player)
			
		elif distance_to_player > attack_range:
			set_state(State.CHASE)
			velocity = direction_to_player * speed
			move_and_slide()
			
			if anim_sprite.animation != "Chase":
				anim_sprite.play("Chase")
	else:
		# Se não houver nenhum player vivo ou válido
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Idle":
			anim_sprite.play("Idle")

# --- Nova Função para achar o player mais perto ---
func get_closest_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var min_distance = INF # Começa com infinito
	
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
