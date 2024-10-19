extends Node2D
@export var id = ""
@export var items = {}
@export var goldAmount = 0
@export var gold: bool = false
@export var special: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if id in Global.treasureBox:
		pass
	else:
		Global.treasureBox[id] = {"pickUp": false}
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if id in Global.treasureBox:
		pass
	else:
		Global.treasureBox[id] = {"pickUp": false}
	if Global.treasureBox.get(id).pickUp:
		self.visible = false
	else:
		self.visible = true

func _on_area_2d_body_entered(body):
	if  Global.treasureBox.get(id).pickUp == false and body.name == "player":
		#FightScenePlayers.fightScenePlayerData.get(i).potential += 5
		if gold:
			Global.addGold(goldAmount)
			
		else:
			for i in items.keys():
				var info = ItemData.addItemInfo[i]
				
				Global.addItem(info["name"], info["type"], info["bagPlace"], items[i])
		body.get_node("AudioStreamPlayer2D").stream = load("res://Audio/SE/006-System06.ogg")
		body.get_node("AudioStreamPlayer2D").play()
		queue_free()
		Global.treasureBox.get(id).pickUp = true
		if special:
			get_tree().current_scene.get_node("CanvasLayer/importantMsg/Panel/ImportantMsg").text = "柳生留: 有需要的人就拿去吧"
			get_tree().current_scene.get_node("CanvasLayer/importantMsg").visible = true	
