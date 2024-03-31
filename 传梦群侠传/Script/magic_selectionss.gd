extends Button

var magic
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	magic = get_tree().get_nodes_in_group("magic")
	
func _on_pressed():
	print("press")


func _on_button_mouse_entered():
	$"subSound".stream = load("res://Audio/SE/001-System01.ogg")
	$"subSound".play()
	if magic:
		for i in magic:
			if i.name != self.name:
				i.get_node("Button/name").modulate = "ffffff"	
			else:
				for x in Global.playerMagicList.size():
					if get_node("Button/name").text == Global.playerMagicList[x].name:
						var magicIndex = Global.playerMagicList.find(Global.playerMagicList[x])
						Global.magicSelectIndex = magicIndex

						i.get_node("Button/name").modulate = "007cff"

func _on_button_button_down():

	for i in Global.playerMagicList.size():
		if Global.playerMagicList[i].name == get_node("Button/name").text:
			Global.currUsingMagic = Global.playerMagicList[i]
			var magicIndex = Global.playerMagicList.find(Global.playerMagicList[i])
			Global.magicSelectIndex = magicIndex

	Global.onMagicSelectPicking = false
	Global.onMagicAttackPicking = true

	$"subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"subSound".play()

