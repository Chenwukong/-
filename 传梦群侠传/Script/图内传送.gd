extends AnimatedSprite2D

@export var TPposition: Vector2



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("mapPlayer"):
		area.get_parent().position = Vector2(TPposition)
