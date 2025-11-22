extends Player
class_name Archer

# --- Dash ---
const DASH_SPEED = 900
const DASH_TIME = 0.2
var dashing = false
var dash_timer = 0.0
var dash_count = 1
var dash_recharge = false

# --- Rotação ---
var rotating = false
var rotation_speed = 700
var rotated = 0.0

# Exportáveis
@export var Arrow : PackedScene
@export var atck = "Atck"
@export var dash = "Dash"

# --- Tiro ---
var shoting = false
var shoting_recharge = false

func _ready():
	super._ready()

func _physics_process(delta: float) -> void:

	# PRIORIDADE: se está atacando, não pode trocar animação
	if shoting:
		return

	MovePlayer(delta)

	# D A S H
	if dir != Vector2.ZERO:
		if Input.is_action_just_pressed(dash) and not dashing and not dash_recharge:
			start_dash()
			dash_recharge = true
			await get_tree().create_timer(2.0).timeout
			dash_count += 1
			dash_recharge = false

		if dashing:
			global_position += dir.normalized() * DASH_SPEED * delta
			dash_timer -= delta
			if dash_timer <= 0:
				dashing = false

	# ROTAÇÃO DO SPRITE DURANTE O DASH
	if rotating:
		var step = rotation_speed * delta
		$AnimatedSprite2D.rotation_degrees += step
		rotated += step
		if rotated >= 360:
			rotating = false
			rotated = 0.0
			$AnimatedSprite2D.rotation_degrees = 0

	# ATAQUE
	if Input.is_action_just_pressed(atck) and not shoting and not shoting_recharge:
		Arrow_Shoot()
		shoting_recharge = true
		await get_tree().create_timer(1.0).timeout
		shoting_recharge = false


# --- Dash ---
func start_dash():
	if dash_count >= 1:
		dashing = true
		dash_timer = DASH_TIME
		dash_count = 0
		start_rotation()

func start_rotation():
	rotating = true
	rotated = 0.0


# --- DISPARO DE FLECHA ---
func Arrow_Shoot() -> void:
	shoting = true

	$AnimatedSprite2D.play("basic_atack")

	# Tempo real da animação
	var anim = "basic_atack"
	var frames = $AnimatedSprite2D.sprite_frames.get_frame_count(anim)
	var fps = $AnimatedSprite2D.sprite_frames.get_animation_speed(anim)
	var anim_time = frames / fps

	# Espera terminar a animação
	await get_tree().create_timer(anim_time).timeout

	# CRIA A FLECHA APÓS A ANIMAÇÃO
	var arrow = Arrow.instantiate()
	arrow.global_position = $Bow.global_position + Vector2(-60, -160)
	arrow.target = $EnemyDetectArea.enemy_target
	get_tree().current_scene.add_child(arrow)

	shoting = false


# --- MORTE ---
func die():
	set_physics_process(false)
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	super.die()
