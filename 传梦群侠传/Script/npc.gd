extends AnimatedSprite2D
@export var itemSale = []
@export var npcName = ""
@export var audio = ""
@export var animal = false
var player
var newStream
# Called when the node enters the scene tree for the first time.
func _ready():
	newStream =  audio.substr(1, audio.length() - 2)
	for i in Global.npcVis:
		if self.name in Global.npcVis.get(i):	
			if Global.npcVis.get(i).get(self.name).visible == false:
				self.visible = false
				get_node("npcBody/npcShape").disabled = true
			else:
				self.visible = true
				get_node("npcBody/npcShape").disabled = false

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	for i in Global.npcVis:
		if self.name in Global.npcVis.get(i):
			if get_tree().current_scene.name == i:
				if Global.npcVis.get(i).get(self.name).visible == false:
					self.visible = false
					get_node("npcBody/npcShape").disabled = true
					$npcBody/CollisionPolygon2D.disabled = true
				else:
					self.visible = true
					get_node("npcBody/npcShape").disabled = false
					$npcBody/CollisionPolygon2D.disabled = false

func _on_button_pressed():

	if Global.onTalk or Global.onFight:
		return
	if audio != "":
		get_parent().get_node("npcAudio").stream = load(newStream)
		get_parent().get_node("npcAudio").play()
	if Global.npcs.has(npcName):
		DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue(npcName))
		get_tree().current_scene.get_node("player")
		if itemSale.size() > 0:
			Global.currShopItem = itemSale
			
#

func get_npc_dialogue(npc_id):
	if Global.npcs.has(npc_id):
		var npc = Global.npcs[npc_id]
		var dialogue_index = npc["current_dialogue_index"]
	
		if npc["dialogues"].size() > dialogue_index:
			var dialogue_entry = npc["dialogues"][dialogue_index]

			if dialogue_entry["unlocked"] and dialogue_entry["chapter"] == Global.current_chapter_id:
				update_npc_dialogue_index(npc_id)
				if npc["dialogues"][dialogue_index].bgm != null:
				
					self.get_parent().get_node("AudioStreamPlayer2D").stream = load(npc["dialogues"][dialogue_index].bgm)
					self.get_parent().get_node("AudioStreamPlayer2D").play()
				return dialogue_entry["dialogue"]
			
		return "没有更多可说的了"
	

func update_npc_dialogue_index(npc_id):
	if Global.npcs[npc_id]["constNpc"] == false:
		Global.npcs[npc_id]["current_dialogue_index"] += 1

func complete_task(chapter_id, task_id):
	if Global.chapters.has(chapter_id) and Global.chapters[chapter_id]["tasks"].has(task_id):
		Global.chapters[chapter_id]["tasks"][task_id] = true
		for npc_id in Global.npcs.keys():
			update_npc_dialogue_index(npc_id)


func _on_button_mouse_entered():
	player = get_tree().current_scene.get_node("player")
	var distance = self.position.distance_to(player.position)
	if !Global.onFight:
		Global.onButton = true
	if !Global.onFight and distance < 130:
		$AnimatedSprite2D.visible = true
func _on_button_mouse_exited():
	$AnimatedSprite2D.visible = false
	Global.onButton = false

func _on_button_button_down():
	player = get_tree().current_scene.get_node("player")
	var distance = self.position.distance_to(player.position)
	print(distance)
	if distance > 130:
		return
	if Global.onTalk:
		return
	if audio != "":
		get_parent().get_node("npcAudio").stream = load(newStream)
		get_parent().get_node("npcAudio").play()
	if Global.npcs.has(npcName):
		
		DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue(npcName))
		get_tree().current_scene.get_node("player")
		if itemSale.size() > 0:
			Global.currShopItem = itemSale
