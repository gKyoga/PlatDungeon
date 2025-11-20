extends CharacterBody2D
class_name Enemy

enum State { IDLE, CHASE, ATTACK, DEAD }

@export var max_health: int = 100
var current_health: int
var current_state: State = State.IDLE

@onready var health_bar_instance: ProgressBar = $HealthBar

@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.0
var can_attack: bool = true

func _ready():
	current_health = max_health

	if health_bar_instance:
		health_bar_instance.init_health(max_health)
		health_bar_instance.health = current_health
		
func take_damage(amount: int):
	current_health -= amount
	if health_bar_instance:
		health_bar_instance.health = current_health
	if current_health <= 0:
		die()

func die():
	Global.add_score(20)
	
	if self.is_in_group("Skeleton"):
		Global.skeletons_alive -= 1
		Global.skeleton_died.emit()
		print("Skeleton died. Skeletons alive: ", Global.skeletons_alive)
		if Global.skeletons_alive <= 0:
			Global.all_skeletons_dead.emit()

	queue_free()

func set_state(new_state: State):
	current_state = new_state

func attack(target: Node):
	if can_attack and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(attack_damage)
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
