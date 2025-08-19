extends Button
var shopItems 
signal item_select_signal
signal buy_signal
var addItemInfo
# Called when the node enters the scene tree for the first time.
func _ready():
	shopItems = get_tree().get_nodes_in_group("miniShopItem")	
	print(addItemInfo)
	addItemInfo = ItemData.addItemInfo[text]	
	get_node("itemPicture").texture = load(ItemData[addItemInfo.type][addItemInfo.name].icon)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	for i in shopItems:
		i.self_modulate = "ffffff"
	emit_signal("item_select_signal",text)
	self_modulate = "gold"
