extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var world = $SubViewportContainer/SubViewport.find_world_2d()
	$SubViewportContainer2/SubViewport.world_2d = world

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
#	$"SubViewportContainer".visible = false
#	$SubViewportContainer2.visible = false
	fade_out(1.0)
	fade_out2(1.0)
func fade_out(duration: float = 1.0):
	
	# 创建 Tween 动画
	var tween = create_tween()
	# 初始状态：完全不透明（alpha = 1）
	modulate = Color(modulate, 1.0)
	# 目标状态：完全透明（alpha = 0）
	tween.tween_property($"SubViewportContainer", "modulate:a", 0.0, duration)
func fade_out2(duration: float = 1.0):
	
	# 创建 Tween 动画
	var tween = create_tween()
	# 初始状态：完全不透明（alpha = 1）
	modulate = Color(modulate, 1.0)
	# 目标状态：完全透明（alpha = 0）
	tween.tween_property($"SubViewportContainer2", "modulate:a", 0.0, duration)
	



func _on_timer_2_timeout():
	$SubViewportContainer3.visible = true
	$"4d89Cdd1".visible = false
