extends Panel
var players = []
var playerIndex = 0
var menuItems
var appended = false
var updated = false
var itemUseFlag = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	menuItems = get_tree().get_nodes_in_group("bagMenuItem")
	
	if Global.onMenuItemUsing:
		
		updateStatus()
		if !updated:
			updated = true
			for i in Global.onTeamPlayer.size():
			
				get_node("itemPlayer"+str(i+1)+"/mpText/mpBar/mpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currMp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addMp))
				get_node("itemPlayer"+str(i+1)+"/hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currHp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addHp))		
				
				get_node("itemPlayer"+str(i+1)+"/hpText/hpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addHp)
				get_node("itemPlayer"+str(i+1)+"/hpText/hpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currHp 
				get_node("itemPlayer"+str(i+1)+"/mpText/mpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).addMp)
				get_node("itemPlayer"+str(i+1)+"/mpText/mpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currMp 				
				
				
		if !appended:
			for i in Global.onTeamPlayer.size():
				Global.itemPlayers.append(get_node("itemPlayer"+str(i+1)))	
				get_node("itemPlayer"+str(i+1)).visible = true

				
			for i in range(len(Global.onTeamPlayer)):
				var player = Global.onTeamPlayer[i]
				var player_icon = load(FightScenePlayers.fightScenePlayerData[player].icon)
				get_node("itemPlayer" + str(i + 1) + "/menuPlayerPic").texture = player_icon
			appended = true
		
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
			updated = false
			Global.itemPlayers = []			
#			for i in Global.onTeamPlayer.size():
#				@get_node("itemPlayer"+str(i+1)).queue_free()
			Global.onMenuItemUsing = false
			appended = false
			Global.onItemSelect = true
			
			
			
			$".".visible = false
			for i in menuItems:
				if i.get_node("itemNum").text == "0":
					$"../..".itemSelectIndex = 0
					i.queue_free()		
					
#		if Input.is_action_just_pressed("ui_accept") and !Global.noKeyboard:	
#			if itemUseFlag:
#				itemUseFlag = false
#
#			else:
#				visible = true
#				itemUseFlag = true
#				return
#
#			useItem()
			
			
			
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
	itemUseFlag = false
	if Global.currMenuItem in ItemData.consume or Global.currMenuItem in ItemData.battleConsume:
		var item = FightScenePlayers.consumeItem.get(Global.currMenuItem)
		if item == null:
			FightScenePlayers.battleItem.get(Global.currMenuItem)
			item = FightScenePlayers.battleItem.get(Global.currMenuItem)
	
		if item == null:
			return
		if item.number > 0:
			
			$"../../../subSound".stream = load("res://Audio/SE/002-System02.ogg")
			$"../../../subSound".play()
			
			if item.info.effect == "mp":
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp == FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp +decrypt( FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp):
					return
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp + item.info.value > FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp):
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp)

				else:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp += item.info.value

				item.number -= 1
				for i in menuItems:
					if i.get_node("itemName").text == Global.currMenuItem:
						i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)
					if i.get_node("itemNum").text == "0":
						i.visible = false	
								
			if item.info.effect == "hp": 
				
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp == FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp):
					return
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp + item.info.value > FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp):
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + decrypt( FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp)
				else:
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp += item.info.value
				item.number -= 1
				for i in menuItems:
					if i.get_node("itemName").text == Global.currMenuItem:
						i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)
					if i.get_node("itemNum").text == "0":
						i.visible = false				
			if item.info.effect == "special":
				
				if item.info.name == "可食用人参果":
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp += 500 * Global.enKey	
				
				if item.info.name == "怪力鱼":
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addStr += 5 * Global.enKey						
				
				if item.info.name == "鳊鱼":
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addAbilityPower += 5 * Global.enKey	
				
				if item.info.name == "娃娃鱼":
					FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp += 50 * Global.enKey	
				updateStatus()	
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
		var item = FightScenePlayers.keyItem.get(Global.currMenuItem)
		self.visible = false
		$"../../../subSound".stream = load("res://Audio/SE/056-Right02.ogg")
		$"../../../subSound".play()
		Global.onMenuItemUsing = false
		Global.onItemSelect = true	
		if Global.currMenuItem == "筋斗云":
			if Global.playerSpeed == 300:
				Global.onWalkDoubleSpeed = true
				Global.playerSpeed = 500
				Global.showMsg("移动速度加快！")
			else:
				Global.onWalkDoubleSpeed = false
				Global.playerSpeed = 300
				Global.showMsg("移动速度恢复正常！")
			
		if Global.currMenuItem == "避祸香囊":
			if Global.onSkipFight == true:
				Global.baseChance = 0
				Global.onSkipFight = false
				Global.showMsg("能遇到妖怪了！")
			else:
				Global.baseChance= 800
				Global.onSkipFight = true
				Global.showMsg("遇不到妖怪了！")
		if Global.currMenuItem == "洗髓丹":
			for i in FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).item.keys():
				if FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).item[i] != null:
					Global.showMsg("请脱掉装备")
					return
			Global.showMsg(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).name + "已洗髓")		
			item.number -= 1
			for i in menuItems:
				if i.get_node("itemName").text == Global.currMenuItem:
					i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)					
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addStr = 0	
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addAbilityPower = 0	
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addPlayerSpeed = 0
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp = 0
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp = 0
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addCritChance = 0
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addBlockChance = 0
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).potential = (FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).level - 1 + Global.totalPotentialBall) * 5 * Global.enKey
			FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).potential +=  50 * ( Global.gameRound -1 )
		if Global.currMenuItem == "圣兽洗髓":
			Global.showMsg("全部盟友已洗髓")		
			item.number -= 1
			for i in menuItems:
				if i.get_node("itemName").text == Global.currMenuItem:
					i.get_node("itemNum").text = str(int(i.get_node("itemNum").text) - 1)		
			for i in Global.onTeamPet.size():		
				
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).addStr = 500	
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).addAbilityPower = 500	
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).addPlayerSpeed = 0
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).addHp = 0
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).addMp = 0
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).potential = (FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i]).level - 1 + Global.totalPotentialBall) * 5 * Global.enKey
				FightScenePlayers.fightScenePlayerData.get(Global.onTeamPet[i-1]).potential += 50 * (Global.gameRound - 1)
	
	
	
	
	for key in FightScenePlayers.consumeItem.keys():
		if FightScenePlayers.consumeItem[key]["number"] <= 0:
			FightScenePlayers.consumeItem.erase(key)
func decrypt(value):
	return value / Global.enKey
func updateStatus():
	
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/mpText/mpBar/mpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp))
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp))		
	
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/hpText/hpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addHp)
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/hpText/hpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currHp 
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/mpText/mpBar").max_value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).mp + decrypt(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).addMp)
	get_node("itemPlayer"+str(Global.itemPlayerIndex+1)+"/mpText/mpBar").value = FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[Global.itemPlayerIndex]).currMp 	

