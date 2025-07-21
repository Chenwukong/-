extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		child.modulate = "ffffff00"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turnVisible():
	var children = get_children()
	for child in children:
		child.modulate = "ffffff00"	
