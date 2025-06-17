extends AnimatedSprite2D
@export_file var path : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_changed():
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()
	
#func _on_animation_looped():
#	$AudioStreamPlayer.stream = load(path)
#	$AudioStreamPlayer.play()
