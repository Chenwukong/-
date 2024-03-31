extends Button

var magicPanel
var magicIndex
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	magicPanel = get_tree().get_nodes_in_group("magic")


func _on_button_down():
	for i in Global.playerMagicList.size():
		if Global.playerMagicList[i].name == get_node("name").text:
			Global.currUsingMagic = Global.playerMagicList[i]
			magicIndex = Global.playerMagicList.find(Global.playerMagicList[i])
			Global.magicSelectIndex = magicIndex
			
	Global.onMagicSelectPicking = false
	Global.onMagicAttackPicking = true

	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()




func _on_magic_mouse_entered():
	print(1231111)
		

func _on_magic_focus_entered():
	print(321)


func _on_button_mouse_entered():
	print("hello")
