extends ProgressBar

@export var hide_on_zero: bool = true

@onready var damage_bar = $DamageBar
@onready var timer = $Timer

var _health: int = 0

var health: int:
	get:
		return _health
	set(value):

		var prev_health = _health
		_health = clamp(value, 0, max_value)
		self.value = _health
		
		if _health < prev_health:

			timer.start()
		else:

			damage_bar.value = _health

		if hide_on_zero and _health <= 0:
			hide()
		else:
			show()

func init_health(max_health: int):
	max_value = max_health
	_health = max_health
	value = _health

	damage_bar.max_value = max_health
	damage_bar.value = max_health
	show()

func _ready():
	hide()

func _on_timer_timeout():
	damage_bar.value = _health
