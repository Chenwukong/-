extends AnimatedSprite2D
@export var itemSale = []
@export var npcName = ""
@export var audio = ""
@export var animal = false
var index = null
var dialogues = ""
var player
var newStream
var onChase = false
@export var talked = false
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
	if talked:
		visible = false
		Global.npcVis.get(get_tree().current_scene.name)[name].visible = false	
	if Global.npcs.has(npcName):
		index = Global.npcs[npcName]["current_dialogue_index"]
		dialogues = Global.npcs[npcName]["dialogues"]
		
		if dialogues and index != null:
			if index < dialogues.size():
				if Global.npcs[npcName]["dialogues"][Global.npcs[npcName]["current_dialogue_index"]].unlocked == true and !Global.onTalk:
					$AnimatedSprite2D.visible = true
				else:
					$AnimatedSprite2D.visible = false
			else:
				$AnimatedSprite2D.visible = false
					
				
				
	if self.visible == false:
		$npcBody/CollisionPolygon2D.disabled = true

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
		var npc = Global.npcs[npcName]
		#DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue(npcName))
		var dialogue_index = npc["current_dialogue_index"]	
		var dialogue_entry = npc["dialogues"][dialogue_index]
	
		DialogueManager.show_chat(load("res://Dialogue/"+str(dialogue_entry.chapter)+".dialogue"),get_npc_dialogue(npcName))		
		
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
			if dialogue_entry["unlocked"]:
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



func _on_button_button_down():
	if talked or Global.onPet:
		return
		
	if Global.onTalk or Global.onFight :
		return	
	
	player = get_tree().current_scene.get_node("player")
	var distance = self.position.distance_to(player.position)

	if distance > 130:
		return
	if Global.onTalk:
		return
	if name == "小师弟" or name == "小师弟2" or name == "小师弟3" or name == "野鬼1"or name == "野鬼2"or name == "野鬼3"or name == "野鬼4"or name == "野鬼5":
		talked = true
	if audio != "":
		get_parent().get_node("npcAudio").stream = load(newStream)
		get_parent().get_node("npcAudio").play()
		
	if Global.npcs.has(npcName):
		print("havename")
		var npc = Global.npcs[npcName]
		#DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue(npcName))
		var dialogue_index = npc["current_dialogue_index"]	
		var dialogue_entry
		if dialogue_index != npc["dialogues"].size():
			dialogue_entry = npc["dialogues"][dialogue_index]
			DialogueManager.show_chat(load("res://Dialogue/"+str(dialogue_entry.chapter)+".dialogue"),get_npc_dialogue(npcName))		
		else:
			dialogue_entry = 1
			DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue(npcName))		
		
		get_tree().current_scene.get_node("player")
		if itemSale.size() > 0:
			Global.currShopItem = itemSale
func tion(animationName):
	$effect.visible = true
	$effect.play(animationName)


func _on_button_mouse_exited():
	Global.onButton = false
