extends PointLight2D

var is_increasing = true
var max_energy = 1.0
var min_energy = 0.0
@export var blink_speed = 0.7

func _process(delta):
	if is_increasing:
		energy += blink_speed
		if energy >= max_energy:
			is_increasing = false
	else:
		energy -= blink_speed
		if energy <= min_energy:
			is_increasing = true
