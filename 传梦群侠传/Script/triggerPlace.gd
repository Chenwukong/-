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

	if area.name == "triggerPlaceArea" and Global.triggerPlace.get(triggerEvent).disable == false:
		var player = area.get_parent()
		Global.triggerPlace.get(triggerEvent).disable = true
		print(triggerEvent)
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
				DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue("system"))
			"时追云赶到":			
				DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue("system"))
			"斩妖":			
				DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue("system"))
			"新手警告":
				DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue("传梦"))			
			"初见小二":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("system"))		
			"小二休息":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("system"))	
			"王婆卖瓜":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("system"))	
			"解围金甲":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))	
			"结识金甲":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))					
			"金甲吃饭":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))					
			"帮郎中":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))							
			"看望霍嫬儿":	
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))							
			"初见若昭":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("凌若昭"))			
			"进塔":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))
			"再见凌若昭":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("凌若昭"))	
			"塔2":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))	
			"塔3":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))	
			"塔4":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))									
			"塔5":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))													
			"塔6":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("金甲"))	
			"首入国境":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("system"))																				
			"平定峰":
				DialogueManager.show_chat(load("res://Dialogue/2.dialogue"),get_npc_dialogue("程咬金"))													
			"遣返":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("方寸山秘境"))	
				
			"真方寸山":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("凌若昭"))				
					
			"想策":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("小二"))
			"登顶":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("黑山"))
			"教学千机":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("菩提老祖"))
			"方寸夜晚小二谈恋爱":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("小二"))																																				
			"方寸夜晚小二谈恋爱2":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("小二"))																																																	
			"听见异响":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("system"))											
			"黑山送剑":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("碧玉剑"))			
			"重回建邺":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("system"))			
								
												
			"东海海道":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("system"))																					
			"初遇敖雨":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("敖雨"))		
			"玉箍棒":
				DialogueManager.show_chat(load("res://Dialogue/3.dialogue"),get_npc_dialogue("敖雨"))						
			"救老李头":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("老李头"))			
			"老李头死":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("老李头"))					
							
			"兵分两路":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("兵分两路"))									
			"花果山拦敌1":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("花果山拦敌"))									
			"花果山拦敌2":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("花果山拦敌"))																
			"花果山拦敌3":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("花果山拦敌"))																														
			"再见奔霸":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("花果山拦敌"))															
			"到地府入口":
				DialogueManager.show_chat(load("res://Dialogue/4.dialogue"),get_npc_dialogue("前往地府"))		
			"初见孟婆":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("孟婆"))				
			"真离开地府":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("真离开地府"))	
			"找罐子":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("找罐子"))	
			"重遇上官1":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("重遇上官"))					
			"重遇上官2":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("重遇上官"))	
			"第一次遇鬼":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("第一次遇鬼"))	
			"回忆1":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("回忆"))													
			"进回忆":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("进回忆"))	
			"进回忆2":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("进回忆"))					
			"进回忆3":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("进回忆"))					
			"进回忆4":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("进回忆"))					
			"回忆3":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("回忆3"))							
			"地府决战":
				DialogueManager.show_chat(load("res://Dialogue/5.dialogue"),get_npc_dialogue("地府决战"))						
			"凌若昭回忆":
				DialogueManager.show_chat(load("res://Dialogue/6.dialogue"),get_npc_dialogue("凌若昭回忆"))							
			"再见小二":
				DialogueManager.show_chat(load("res://Dialogue/6.dialogue"),get_npc_dialogue("再见小二"))		
			"寻四圣2":
				DialogueManager.show_chat(load("res://Dialogue/7.dialogue"),get_npc_dialogue("寻四圣"))		
			"寻四圣3":
				DialogueManager.show_chat(load("res://Dialogue/7.dialogue"),get_npc_dialogue("寻四圣"))									
			"方寸山之魔":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("寻四方"))						
			"初见观音":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("初见观音"))				
			"五庄观":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("五庄观"))						
			"五庄观2":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("五庄观"))													
			"除虫":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("除虫"))						
			"再见观音":
				DialogueManager.show_chat(load("res://Dialogue/8.dialogue"),get_npc_dialogue("再见观音"))					
				
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
