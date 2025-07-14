extends Camera2D
var currScene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	original_position = position
	currScene = get_tree().current_scene.name
	if currScene == "北俱战场" and get_parent().name != "朱雀":
		return
	if currScene == "东海湾":
		$".".limit_left = 0
		$".".limit_top = 0
		$".".limit_right = 2401
		$".".limit_bottom = 2396
	else:
		if get_parent().get_parent().get_node("MarkerLeft"):
			$".".limit_left = get_parent().get_parent().get_node("MarkerLeft").position.x
			$".".limit_top = get_parent().get_parent().get_node("MarkerLeft").position.y
		else:
			$".".limit_left = 0
			$".".limit_top = 0		
		$".".limit_right = get_parent().get_parent().get_node("MarkerRight").position.x
		$".".limit_bottom = get_parent().get_parent().get_node("MarkerRight").position.y			
		

var shake_time := 0.0
var shake_duration := 0.0
var shake_magnitude := 0.0
var shake_direction := Vector2.ZERO
var original_position := Vector2.ZERO
var canShake = false

func _process(delta):
	if canShake:
		if shake_time < shake_duration:
			shake_time += delta
			var rand = randf_range(-1.0, 1.0)
			var offset = shake_direction.normalized() * rand * shake_magnitude
			position = original_position + offset
		else:
			position = original_position

func start_shake(duration: float, magnitude: float, direction := Vector2(1, 1)):
	shake_duration = duration
	shake_magnitude = magnitude
	shake_direction = direction
	shake_time = 0.0
