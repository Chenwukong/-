extends Node2D
@export var id = ""
@export var items = {}
@export var goldAmount = 0
@export var gold: bool = false
@export var special: String = ""
@export var violencePointTreasure: bool = false
@export var chapter: int = 1
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
		if violencePointTreasure:
			if Global.canTake == false:
				DialogueManager.show_chat(load("res://Dialogue/"+ str(1)+ ".dialogue"),get_npc_dialogue("宝箱1"))
			else:
				pass
			if Global.canTake == false:
				return
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
		if special == "柳大夫":
			get_tree().current_scene.get_node("CanvasLayer/importantMsg/Panel/ImportantMsg").text = "柳生留: 有需要的人就拿去吧"
			get_tree().current_scene.get_node("CanvasLayer/importantMsg").visible = true	
		if special == "鱼大爷":
			get_tree().current_scene.get_node("CanvasLayer/importantMsg/Panel/ImportantMsg").text = "鱼大爷怎么遗落了他的帽子"
			get_tree().current_scene.get_node("CanvasLayer/importantMsg").visible = true	
		Global.canTake = false
	
func get_npc_dialogue(npc_id):
	
	var npc = Global.npcs[npc_id]
	var dialogue_index = npc["current_dialogue_index"]

	if npc["dialogues"].size() > dialogue_index:
		var dialogue_entry = npc["dialogues"][dialogue_index]

		if dialogue_entry["unlocked"] and dialogue_entry["chapter"] == 1:
			update_npc_dialogue_index(npc_id)
			if npc["dialogues"][dialogue_index].bgm != null:
			
				get_tree().current_scene.get_node("AudioStreamPlayer2D").stream = load(npc["dialogues"][dialogue_index].bgm)
				get_tree().current_scene.get_node("AudioStreamPlayer2D").play()
			return dialogue_entry["dialogue"]
		
	return "没有更多可说的了"


func update_npc_dialogue_index(npc_id):
	if Global.npcs[npc_id]["constNpc"] == false:
		Global.npcs[npc_id]["current_dialogue_index"] += 1
