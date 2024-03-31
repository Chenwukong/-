extends Sprite2D
@export var itemName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var questItem = get_tree().get_nodes_in_group("questItem")
	if Global.onQuest == false:
		for i in questItem:
			i.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if Global.onQuest:
		Global.addItem(itemName,"battleConsume","questItem",1)
		if Global.questItem.has(itemName):
			Global.questItem.get(itemName).number += 1
		else:
			Global.questItem[itemName] ={ "itemName":itemName, "number": 1}
		if area.get_parent().is_in_group("mapPlayer"):	
			queue_free()
		
