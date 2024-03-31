extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Label2.text = str(Global.killedAmount)
	$Control/Button2.grab_focus()
	$AudioStreamPlayer2D.stream = load("res://Audio/BGS/啊弥拖佛.ogg")
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.stream = load("res://Audio/BGS/钟声.ogg")
	$AudioStreamPlayer2D2.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	get_tree().change_scene_to_file(("res://Scene/主页.tscn"))


func _on_button_pressed():
	get_tree().quit()
