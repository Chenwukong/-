extends Camera2D
var currScene

# Called when the node enters the scene tree for the first time.
func _ready():
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
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
		# Global.currentCamera = self
