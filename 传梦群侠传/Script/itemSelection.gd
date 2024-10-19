extends Button

var magicPanel
var magicIndex
var players
# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.name)
	$Button/amount.text = str(FightScenePlayers.battleItem.get($Button/name.text).number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	magicPanel = get_tree().get_nodes_in_group("magic")
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	self.scale = Vector2(0.4,0.4)
#func _on_button_down():
#
#
#	for i in Global.currPlayer.itemList.size():
#		if Global.currPlayer.itemList[i].info.name == self.get_node("name").text:
#			Global.currUsingItem = Global.currPlayer.itemList[i]
#
#	Global.onItemSelectPicking = false
#	Global.onItemUsePicking = true



func _on_button_2_button_down():

	for i in Global.currPlayer.itemList.size():
		if Global.currPlayer.itemList[i].info.name == $Button/name.text:
			Global.currUsingItem = Global.currPlayer.itemList[i]

	Global.onItemSelectPicking = false
	Global.onItemUsePicking = true


func _on_button_2_mouse_entered():
	pass # Replace with function body.
