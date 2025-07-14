extends Button

var magic
# Called when the node enters the scene tree for the first time.
var players
var currPlayer
var magicIndex
# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale = Vector2(0.3,0.3)
	players = get_tree().get_nodes_in_group("fightScenePlayers")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale = Vector2(0.4,0.4)
	magic = get_tree().get_nodes_in_group("magic")
	for i in players:
		if Global.onAttackingList.size()>0:
			if i.name ==  Global.onAttackingList[0]:
				currPlayer = i	
	if magic:
		for i in magic:	
			if magic.size()> Global.magicSelectIndex and magic[Global.magicSelectIndex]:			
				if i.name == magic[Global.magicSelectIndex].name:
					i.get_node("技能选中").visible = true
					i.get_node("技能未选中").visible = false
				else:
					i.get_node("技能选中").visible = false
					i.get_node("技能未选中").visible = true
				
func _on_pressed():
	print("press")


func _on_button_mouse_entered():

	$"subSound".stream = load("res://Audio/SE/001-System01.ogg")
	$"subSound".play()
	if magic:
		for i in magic:
			if i.name != magic[Global.magicSelectIndex].name:
				pass
			else:
				for x in Global.playerMagicList.size():
					if get_node("Button/name").text == Global.playerMagicList[x].name:
						magicIndex = Global.playerMagicList.find(Global.playerMagicList[x])
						Global.magicSelectIndex = magicIndex
						#i.get_node("Button/name").modulate = "007cff"

func _on_button_button_down():

	if Global.playerMagicList[magicIndex].name == "高等炼体术":
		return	
	if Global.playerMagicList[magicIndex].name == "真身现世" and currPlayer.真身round != 0:	
		return
		
	if !(Global.currUsingMagic.cost > currPlayer.currMp):
		for i in Global.playerMagicList.size():

			if Global.playerMagicList[i].name == get_node("Button/name").text:
				Global.currUsingMagic = Global.playerMagicList[i]
				magicIndex = Global.playerMagicList.find(Global.playerMagicList[i])
				Global.magicSelectIndex = magicIndex

		Global.onMagicSelectPicking = false
		Global.onMagicAttackPicking = true

		$"subSound".stream = load("res://Audio/SE/002-System02.ogg")
		$"subSound".play()



func _on_button_2_button_down():
	if Global.playerMagicList[magicIndex].name == "高等炼体术":
		return	
	if Global.playerMagicList[magicIndex].name == "真身现世" and currPlayer.真身round != 0:	
		return		
		
	if !(Global.currUsingMagic.cost > currPlayer.currMp):
		for i in Global.playerMagicList.size():

			if Global.playerMagicList[i].name == get_node("Button/name").text:
				Global.currUsingMagic = Global.playerMagicList[i]
				magicIndex = Global.playerMagicList.find(Global.playerMagicList[i])
				Global.magicSelectIndex = magicIndex

		Global.onMagicSelectPicking = false
		Global.onMagicAttackPicking = true

		$"subSound".stream = load("res://Audio/SE/002-System02.ogg")
		$"subSound".play()



func _on_button_2_mouse_entered():
	$"subSound".stream = load("res://Audio/SE/001-System01.ogg")
	$"subSound".play()
	if magic:
		for i in magic:
			if i.name != magic[Global.magicSelectIndex].name:
				pass
			else:
				for x in Global.playerMagicList.size():
					if get_node("Button/name").text == Global.playerMagicList[x].name:
						magicIndex = Global.playerMagicList.find(Global.playerMagicList[x])
						Global.magicSelectIndex = magicIndex
