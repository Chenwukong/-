extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.addStuff()
	if !Global.npcVis.get(get_tree().current_scene.name).get(self.name).visible:
		if name == "吸血鬼组" or name == "小魔头组" or name == "吸血鬼组2":
			for i in get_children():
				i.queue_free()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if name == "吸血鬼组"   or name == "吸血鬼组2"or name == "小魔头组":
		return
	
	
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

func queueFree():
	if !Global.npcVis.get(get_tree().current_scene.name).get(name).visible:
		if name == "吸血鬼组"  or name == "吸血鬼组2" or name == "小魔头组":
			for i in get_children():
				i.queue_free()
