extends Sprite2D

var screamed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_2_body_entered(body):
	if body.name == "player":
		if !screamed:
			$AudioStreamPlayer2D.play()
			$AnimationPlayer.play("闪屏")
			get_tree().current_scene.get_node("player").canMove = false
			$ghostTimer.start()
			$Timer2.start()
		visible = true
	



func _on_area_2d_2_body_exited(body):
	if body.name == "player":
		visible = false
	

func _on_timer_2_timeout():
	if !screamed:
		screamed = true
		$TextureRect.visible = true
