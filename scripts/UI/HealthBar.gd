extends ProgressBar

@export var hide_on_zero: bool = true

@onready var damage_bar = $DamageBar
@onready var timer = $Timer

var _health: int = 0

var health: int:
	get:
		return _health
	set(value):
		value = clamp(value, 0, max_value)

		var prev = _health
		_health = value

		self.value = _health   # atualiza barra principal

		# animação do dano
		if _health < prev:
			timer.start()
		else:
			damage_bar.value = _health

		# esconder barra se vida zerar
		if hide_on_zero and _health <= 0:
			hide()
		else:
			show()


func init_health(max_health: int):
	min_value = 0
	max_value = max_health

	_health = max_health

	self.value = _health

	damage_bar.min_value = 0
	damage_bar.max_value = max_health
	damage_bar.value = max_health

	show()


func _ready():
	hide()


func _on_timer_timeout():
	damage_bar.value = _health
