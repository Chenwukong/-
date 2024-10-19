extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.npcVis.get(get_tree().current_scene.name).get(self.name).visible:
		self.visible = true
		for i in self.get_children():
			i.visible = true
			i.get_node("npcBody/CollisionPolygon2D").disabled = false
	else:
		for i in self.get_children():
			self.visible = false
			i.visible = false
			i.get_node("npcBody/CollisionPolygon2D").disabled = true
