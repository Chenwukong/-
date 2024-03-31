extends Node2D
@export var triggerEvent = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	triggerEvent = self.name
	if triggerEvent in Global.triggerPlace:
		pass
	else:
		Global.triggerPlace[triggerEvent] = {"trigger":false, "disable": false} 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var places = get_tree().get_nodes_in_group("triggerPlace")
	for i in places:
		if Global.triggerPlace.get(i.name).disable == true:
			i.get_node("Area2D/CollisionShape2D").disabled = true
		if Global.triggerPlace.get(i.name).disable == false:
			i.get_node("Area2D/CollisionShape2D").disabled = false

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("mapPlayer") and Global.triggerPlace.get(triggerEvent).disable == false:
		var player = area.get_parent()
		match triggerEvent:
			"二娃请求":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("二娃"))
			"城主施舍":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("城主"))
			"王姨尖叫":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("王姨"))
			"王姨遇险":		
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("王姨"))
			"管家请求":		
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("管家"))				
			"初见奔霸":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("奔霸"))	
			"时追云杀完2":
				Global.onFight = true
				get_tree().current_scene.bossFight("虾兵蟹将", "","system")	
			"时追云杀完3":
				Global.onFight = true
				get_tree().current_scene.bossFight("虾兵蟹将", "","system")	
			"杀戮":
				get_tree().change_scene_to_file("res://Scene/"+"建邺城右"+".tscn")
				Global.dial = "system"							
			"时追云进城":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("system"))
			"时追云赶到":			
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("system"))
			"斩妖":			
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("system"))
			"新手警告":
				DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),get_npc_dialogue("传梦"))					
func get_npc_dialogue(npc_id):
	
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
