extends Panel
var players = []
var playerIndex = 0
var menuItems
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	menuItems = get_tree().get_nodes_in_group("bagMenuItem")
	if Global.onMenuItemUsing:
		for i in Global.onTeamPlayer.size():
			Global.itemPlayers.append(get_node("itemPlayer"+str(i+1)))	
			
			get_node("itemPlayer"+str(i+1)+"/mpText/mpBar/mpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currMp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addMp)
			get_node("itemPlayer"+str(i+1)+"/hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currHp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addHp)		
			
			get_node("itemPlayer"+str(i+1)+"/hpText/hpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addHp
			get_node("itemPlayer"+str(i+1)+"/hpText/hpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currHp
			
			get_node("itemPlayer"+str(i+1)+"/mpText/mpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addMp
			get_node("itemPlayer"+str(i+1)+"/mpText/mpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currMp
		for i in range(len(Global.onTeamPlayer)):
			var player = Global.onTeamPlayer[i]
			var player_icon = load(FightScenePlayers.fightScenePlayerData[player].icon)
			get_node("itemPlayer" + str(i + 1) + "/menuPlayerPic").texture = player_icon


			
		if Input.is_action_just_pressed("ui_down"):
			if Global.itemPlayerIndex == Global.itemPlayers.size() -1 :
				Global.itemPlayerIndex = 0
			else:
				Global.itemPlayerIndex += 1
		if Input.is_action_just_pressed("ui_up"):
			if Global.itemPlayerIndex == 0 :
				Global.itemPlayerIndex = Global.itemPlayers.size() -1
			else:
				Global.itemPlayerIndex -= 1
		if Input.is_action_just_released("esc"):
			Global.onMenuItemUsing = false
			Global.onItemSelect = true
			$".".visible = false
			for i in menuItems:
				if i.get_node("itemNum").text == "0":
					$"../..".itemSelectIndex = 0
					i.queue_free()			
		if Input.is_action_just_released("ui_accept"):	
			pass
		for i in Global.itemPlayers:
			if i == Global.itemPlayers[Global.itemPlayerIndex]:
				i.self_modulate = "ffffff"
			else:
				i.self_modulate = "ffffff31"
			

func _on_menu_player_but_1_button_down():
	Global.itemPlayerIndex = 0
	useItem()
func _on_menu_player_but_2_button_down():
	Global.itemPlayerIndex = 1
	useItem()

func _on_menu_player_but_3_button_down():
	Global.itemPlayerIndex = 2
	useItem()

func _on_menu_player_but_4_button_down():
	Global.itemPlayerIndex = 3
	useItem()
func useItem():
	if Global.currMenuItem in ItemData.consume:
		var item = FightScenePlayers.consumeItem.get(Global.currMenuItem)
		if item == null:
			return
		if item.number > 0:
			$"../../../subSound".stream = load("res://Audio/SE/002-System02.ogg")
			$"../../../subSound".play()
			
			if item.info.effect == "mp":
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp == FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp:
					return
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp + item.info.value > FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp
				else:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp += item.info.value
				item.number -= 1
				for i in menuItems:
					if i.get_node("itemName").text == Global.currMenuItem:
						i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)
					if i.get_node("itemNum").text == "0":
						i.visible = false				
			if item.info.effect == "hp":
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp == FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp:
					return
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp + item.info.value > FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp
				else:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp += item.info.value
				item.number -= 1
				for i in menuItems:
					if i.get_node("itemName").text == Global.currMenuItem:
						i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)
					if i.get_node("itemNum").text == "0":
						i.visible = false				
		else:
			$"../../../subSound".stream = load("res://Audio/SE/057-Wrong01.ogg")
			$"../../../subSound".play()
			
	elif Global.currMenuItem in ItemData.keyItem:
		self.visible = false
		$"../../../subSound".stream = load("res://Audio/SE/056-Right02.ogg")
		$"../../../subSound".play()
		Global.onMenuItemUsing = false
		Global.onItemSelect = true		
		if Global.currMenuItem == "避祸香囊":
			if Global.onSkipFight == true:
				$"../../..".FIGHT_SCENE_TRIGGER_PROBABILITY = 1500
				Global.onSkipFight = false
			else:
				$"../../..".FIGHT_SCENE_TRIGGER_PROBABILITY = 0
				Global.onSkipFight = true
				
	for key in FightScenePlayers.consumeItem.keys():
		if FightScenePlayers.consumeItem[key]["number"] == 0:
			FightScenePlayers.consumeItem.erase(key)
