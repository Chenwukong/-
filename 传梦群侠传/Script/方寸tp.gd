extends AnimatedSprite2D
@export var color:String = "red"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = color
	if color == "purple":
		self.modulate = "a020f0"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body.is_in_group("mapPlayer"):
		$AudioStreamPlayer.stream = load("res://Audio/SE/018-Teleport01.ogg")
		$AudioStreamPlayer.play()
		if Global.fangCunState == 1:
			if color == "purple":
				#Global.mapPlayerPos = Vector2(802, -173)
				body.position = Vector2(802, -173)
				
			elif color == "green":
				body.position = Vector2(1944, -444)
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "二"
				Global.fangCunState = 2
			else:
				Global.fangCunState = 1
				body.position = Vector2(717, 408)
				Global.triggerPlace.get("遣返").disable = false
		elif Global.fangCunState == 2:
			if color == "red":
				body.position = Vector2(-703,-489)
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "三"
				Global.fangCunState = 3
			else:
				Global.fangCunState = 1
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "一"
				body.position = Vector2(717, 408)
		elif Global.fangCunState == 3:
			if color == "purple":
				body.position = Vector2(-738, -1343)
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "四"
				Global.fangCunState = 4
			else:
				Global.fangCunState = 1
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "一"
				body.position = Vector2(717, 408)				
		elif Global.fangCunState == 4:
			if color == "black":
				body.position = Vector2(339, -1392)
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "五"
				Global.fangCunState = 5
			else:
				Global.fangCunState = 1
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "一"
				body.position = Vector2(717, 408)			
		elif Global.fangCunState == 5:
			if color == "green":
				body.position = Vector2(1088, -1708)
			else:
				Global.fangCunState = 1
				get_tree().current_scene.get_node("CanvasLayer/currState").text = "一"
				body.position = Vector2(717, 408)		
