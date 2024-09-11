extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	self.visible = false


func _on_visibility_changed():
	if self.visible == false:
		pass
	else:
		$Timer.start()
		$AudioStreamPlayer2D.play()
