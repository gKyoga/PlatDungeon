extends Player
class_name Archer2

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

#variaveis exportaveis
@export var Arrow : PackedScene

@export var left = "Left"
@export var right = "Right"
@export var up = "Up"
@export var down = "Down"
@export var atck = "Atck"
@export var dash = "Dash"


#-- shot -- 
var shoting = false
var shoting_recharge = false

func _ready():
	super._ready() 

func _physics_process(delta: float) -> void:
	
	MovePlayer(delta)
	
	if  dir != Vector2.ZERO:
		if Input.is_action_just_pressed("Dash") and not dashing and not dash_recharge:
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
	
	if rotating:
		var step = rotation_speed * delta 
		$AnimatedSprite2D.rotation_degrees += step
		rotated += step
		if rotated >= 360:
			rotating = false
			rotated = 0.0
			$AnimatedSprite2D.rotation_degrees = 0
	
	if Input.is_action_just_pressed("Atck1") and not shoting and not shoting_recharge:
		Arrow_Shoot()
		shoting_recharge = true
		await get_tree().create_timer(1.0).timeout
		shoting_recharge = false
		shoting = false


func start_dash():
	if dash_count >= 1:
		dashing = true
		dash_timer = DASH_TIME
		dash_count = 0
		start_rotation()

func start_rotation():
	rotating = true
	rotated = 0.0

func Arrow_Shoot():
	shoting = true
	$AnimatedSprite2D.play("basic_atack")
	get_tree().create_timer(3.0).timeout
 
	var arrow = Arrow.instantiate()
	arrow.global_position = $Bow.global_position

	arrow.target = $EnemyDetectArea.enemy_target 
	
	owner.add_child(arrow)

func die():
	set_physics_process(false)
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	super.die()
