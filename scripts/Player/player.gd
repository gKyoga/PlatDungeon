extends CharacterBody2D
class_name Player

signal healthChanged

# Status
var Level = 1
var Spd = 600
var Xp = 0

@export var left = "Left"
@export var right = "Right"
@export var up = "Up"
@export var down = "Down"

@export var max_health: int = 100
var current_health: int

# Movimentação
var dir = Vector2()

func _ready():
	current_health = max_health

func set_health(value: int):
	current_health = clampi(value, 0, max_health)
	healthChanged.emit()

func _physics_process(delta: float) -> void:
	if current_health > 0:
		MovePlayer(delta)

func MovePlayer(delta):
	dir = Vector2()

	if Input.is_action_pressed(up):
		dir += Vector2.UP
	if Input.is_action_pressed(down):
		dir += Vector2.DOWN
	if Input.is_action_pressed(left):
		dir += Vector2.LEFT
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed(right):
		dir += Vector2.RIGHT
		$AnimatedSprite2D.flip_h = false

	if dir != Vector2.ZERO:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")

	velocity = dir.normalized() * Spd
	move_and_slide()


# -------- VIDA --------

func take_damage(amount: int):
	set_health(current_health - amount)
	if current_health <= 0:
		die()

func die():
	# ❌ NÃO MATA O PLAYER
	# ✔ Apenas desativa até ser revivido
	print("PLAYER MORREU")
	set_physics_process(false)
	visible = false


# -------- LEVEL --------

func CalcExpLevel(Level):
	return 20 * Level * Level

func CalcExpNextLevel(Xp):
	var required = CalcExpLevel(Level)
	return max(required - Xp, 0)

func LevelUp():
	if Xp >= CalcExpLevel(Level + 1):
		Level += 1
