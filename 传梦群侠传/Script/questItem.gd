extends Sprite2D
@export var itemName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var questItem = get_tree().get_nodes_in_group("questItem")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.questItemShow.get(itemName).visible:
		visible = true
	else:
		visible = false


func _on_area_2d_area_entered(area):
	if visible:
		Global.playsound("res://Audio/SE/006-System06.ogg")
		if Global.questItem.has(itemName):
			Global.questItem.get(itemName).number += 1
		else:
			Global.questItem[itemName] ={ "itemName":itemName, "number": 1}
		if area.get_parent().is_in_group("mapPlayer"):	
			queue_free()
	
