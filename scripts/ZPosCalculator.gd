extends Node2D
class_name ZPosCalculator

@onready var target = get_parent()

@export var CanMove = false

@export var modify = 0.0

var active = true
func _ready():
	
	target.z_index = global_position.y
	
	pass 



func _process(_delta):
	
	
#	target.z_index = target.position.y + modify
	
	if active and CanMove:
		target.z_index = global_position.y
	
	pass
