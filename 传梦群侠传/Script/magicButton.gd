extends Button

var magicPanel
var magicIndex
var players
var currPlayer
var magic
# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	magic = get_tree().get_nodes_in_group("magic")
	magicPanel = get_tree().get_nodes_in_group("magic")
	

func _on_button_down():
	for i in players:
		if i.name ==  Global.onAttackingList[0]:
			currPlayer = i

	if !(Global.currUsingMagic.cost > currPlayer.currMp):
		for i in Global.playerMagicList.size():
			if Global.playerMagicList[i].name == "高等炼体术":
				return			
			if Global.playerMagicList[i].name == get_node("name").text:
				Global.currUsingMagic = Global.playerMagicList[i]
				magicIndex = Global.playerMagicList.find(Global.playerMagicList[i])
				Global.magicSelectIndex = magicIndex
			
		Global.onMagicSelectPicking = false
		Global.onMagicAttackPicking = true

	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()




func _on_magic_mouse_entered():

	$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
	$"../subSound".play()
	if magic:
		for i in magic:
			if i.name != self.name:
				#i.get_node("name").modulate = "ffffff"	
				$"../技能选中".texture = load("res://战斗技能-技能选中.png")
			else:
				for x in Global.playerMagicList.size():
					if get_node("name").text == Global.playerMagicList[x].name:
						var magicIndex = Global.playerMagicList.find(Global.playerMagicList[x])
						Global.magicSelectIndex = magicIndex
						$"../技能选中".texture = load("res://战斗技能-技能未选中.png")
						i.get_node("name").modulate = "007cff"

		

func _on_magic_focus_entered():
	print(321)


func _on_button_mouse_entered():

	$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
	$"../subSound".play()
	if magic:
		for i in magic:
			if i.name != self.name:
				i.get_node("name").modulate = "ffffff"	
				$"../技能选中".texture = load("res://战斗技能-技能选中.png")
			else:
				for x in Global.playerMagicList.size():
					if get_node("name").text == Global.playerMagicList[x].name:
						var magicIndex = Global.playerMagicList.find(Global.playerMagicList[x])
						Global.magicSelectIndex = magicIndex
						$"../技能选中".texture = load("res://战斗技能-技能未选中.png")
						i.get_node("name").modulate = "007cff"
