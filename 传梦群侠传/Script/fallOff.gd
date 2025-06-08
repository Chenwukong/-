extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.name == "triggerPlaceArea":
		Global.getnode("AnimationPlayer").play("坠落")
		Global.playsound("res://Audio/SE/012-System12.ogg")
		$fallTimer.start()

func _on_fall_timer_timeout():
	Global.changeScene("failScene",null)
