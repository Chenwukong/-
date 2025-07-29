extends Control

var buttonIndex = 0
var characterIndex = 0
var buttons
var playerStatus
var menuMagic
var menuMagicIndex = 0 


var onMenuSelectCharacter = false
var onMagicPage = false
var menuMagicButtonScene = preload("res://Scene/menuMagic.tscn")
var armorItemSelectIndex
var onArmorItemSelect 
var armorItemButton 
var onBagArmorItemSelect = false
var canPress = true
var BagArmorItemIndex = 0
var arrows
var bagArmorItems 
var bagArmorItemsData
var onItemIndexSelect

var shoes
var hats
var cloths
var weapons
var accessories
var quitIndex = 0
var skillIndex = 0
var skillButtons 


var pointOnHp = 0
var pointOnStr = 0
var pointOnLuck = 0
var pointOnSpeed = 0
var pointOnMagic = 0
var saveSlots
var loadSlots
var mapPlayer
var itemTypeIndex = 0
var menuItems
var itemSelectIndex = 0
var bagMenuItems
# Called when the node enters the scene tree for the first time.
func _ready():
	$"保存页面/VideoStreamPlayer".stream = load("res://mainPageBack.ogv")
	$"保存页面/VideoStreamPlayer".play()
	buttons = get_tree().get_nodes_in_group("menuButton")
	playerStatus = get_tree().get_nodes_in_group("PlayerStatus")
	menuMagic = get_tree().get_nodes_in_group("menuMagic")
	armorItemButton = get_tree().get_nodes_in_group("armorItemButton")
	arrows = get_tree().get_nodes_in_group("arrow")
	bagArmorItems = get_tree().get_nodes_in_group("bagArmorItem")
	skillButtons = get_tree().get_nodes_in_group("skillButton")
	saveSlots = get_tree().get_nodes_in_group("saveSlot")
	loadSlots = get_tree().get_nodes_in_group("loadSlot")
	menuItems = get_tree().get_nodes_in_group("menuItem")

func format_time(seconds):
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var second = seconds % 60
	FightScenePlayers.seconds = seconds 
	return "%02d:%02d:%02d" % [hours, minutes, second]
	
func _process(delta):
	if (Global.onPhone or Global.noKeyboard) and Global.menuOut:
		$closeButton.visible = true
		$backButton.visible = true
		
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
	for i in Global.onTeamPlayer.size():
		playerStatus[i].visible = true 
	
	mapPlayer = get_tree().get_nodes_in_group("mapPlayer")
	if Global.menuOut:
		buttons[buttonIndex].grab_focus()
	get_node("系统信息/银两/goldValue").text = str(decrypt(FightScenePlayers.golds))
	get_node("系统信息/游戏时间/playTimeValue").text = str(format_time(FightScenePlayers.seconds))	
	menuMagic = get_tree().get_nodes_in_group("menuMagic")
	
	for i in buttons:
		if i.name != buttons[buttonIndex].name:
			i.flat = true
		else:
			i.flat = false	

	
	if Global.menuOut and !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemPage:
	
		if Global.onFight == false and Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
			if buttonIndex == buttons.size() - 1:
				buttonIndex = 0
				buttons[buttonIndex].grab_focus()
			else:
				buttonIndex += 1
				buttons[buttonIndex].grab_focus()
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
		if Global.onFight == false and Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:
			if buttonIndex == 0:
				buttonIndex = buttons.size() - 1
				buttons[buttonIndex].grab_focus()
			else:
				buttonIndex -= 1
				buttons[buttonIndex].grab_focus()
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
		if Global.onFight == false and (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
			characterIndex = 0
#			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#			get_parent().get_node("subSound").play()				
			if Global.onMagicPage == false:
				buttonIndex = 0 
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			
		for i in Global.onTeamPlayer.size():
			var player = get_node("status/Player" + str(i + 1))
			player.get_node("characterIcon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].icon)
			if Global.onTeamPlayer[i] == "小二":
				player.get_node("characterIcon").scale = Vector2(0.27,0.27)
			
			player.get_node("expText/expValue").text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].exp))+ "/" + str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].needExp))
			
			player.get_node("name").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].name
			player.get_node("levelText/levelValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].level)
			
			player.get_node("hpText/hpBar").max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].hp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addHp)
			player.get_node("hpText/hpBar").value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currHp
			player.get_node("hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currHp)+ "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].hp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addHp))
			
			player.get_node("mpText/mpBar").max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].mp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addMp)
			player.get_node("mpText/mpBar").value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currMp
			player.get_node("mpText/mpBar/mpValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currMp)+ "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].mp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addMp))
		
		for i in playerStatus.size():
			for x in playerStatus:
				if playerStatus[i].name != playerStatus[characterIndex].name:
					x.self_modulate = "#ffffff"
	
		if buttons[buttonIndex].name == "道具":
			
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onItemPage == false and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	
				Global.onItemPage = true
				$"道具页面".visible = true
				canPress = false
				$"../canPress".start()
				
		if buttons[buttonIndex].name == "法术":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onMagicPage == false and !Global.noKeyboard:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	
				
				
		if buttons[buttonIndex].name == "装备":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onArmorItemPage == false and !Global.noKeyboard:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))		
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "状态":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onStatusPage and !Global.noKeyboard:
				
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))	
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "保存冒险":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onSavePage and !Global.noKeyboard:
				Global.onSavePage = true
				$"保存页面".visible = true
				Global.saveIndex = 0
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	

				for i in saveSlots.size():
					var savePath = "user://saveFile"+str(i)
					var file = FileAccess.open(savePath, FileAccess.READ)

					if file and file.file_exists(savePath):
						var data = file.get_var()	
						saveSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
						saveSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)
#						saveSlots[i].get_node("systemTime").text = data.formatDate
		if buttons[buttonIndex].name == "读取进度":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onLoadPage and Global.menuOut and !Global.noKeyboard:
				Global.onLoadPage = true
		
				$"读取页面".visible = true
				Global.saveIndex = 0
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	
			
				for i in loadSlots.size():
					
					var savePath = "user://saveFile"+str(i)
					var file = FileAccess.open(savePath, FileAccess.READ)
					
					if file and file.file_exists(savePath):
						var data = file.get_var()	
						loadSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
						loadSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)
						loadSlots[i].get_node("systemTime").text = data.formatDate
		if buttons[buttonIndex].name == "升级加点":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.noKeyboard:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))	
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "返回现实":
			if !Global.onFight and Input.is_action_just_released("ui_accept") and !Global.onQuitMenu and !Global.noKeyboard:
				Global.onQuitMenu = true
				$"退出页面".visible = true	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	

	if Global.onMenuSelectCharacter:
		var style = get_theme_stylebox("StyleBoxFlat")
		style.bg_color = Color(1, 1, 1, 1)
		
		
		if Input.is_action_just_pressed("ui_down")and !Global.noKeyboard:
			if characterIndex == Global.onTeamPlayer.size() - 1:
				characterIndex = 0
			else:
				characterIndex += 1
			get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
			for i in playerStatus.size():
				playerStatus[i].self_modulate = "ffffff"
					
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:
			if characterIndex == 0:
				characterIndex = Global.onTeamPlayer.size() - 1
			else:
				characterIndex -= 1
			for i in playerStatus.size():
				playerStatus[i].self_modulate = "ffffff"				
			get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
			canPress = false
	
			$"../canPress".start()
			get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
			get_parent().get_node("subSound").play()	
			Global.onMenuSelectCharacter = false
			if buttons[buttonIndex].name == "法术":
				get_node("法术页面").visible = true
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
				Global.onMagicPage = true
				for i in FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic:
					var menuMagic = menuMagicButtonScene.instantiate()

					if i.has("level"):
						menuMagic.get_node("Button/name").text = i.name + "（" + str(i.level) + "） "
						menuMagic.get_node("Button/cost").text = str(i.currExp) + "/" + str(i.needExp)
						menuMagic.get_node("Button/icon").texture = load(i.icon)
					else:
						menuMagic.get_node("Button/name").text = i.name
					get_node("法术页面/技能表/ScrollContainer/GridContainer").add_child(menuMagic)
					
			if buttons[buttonIndex].name == "装备":
				get_node("装备页面").visible = true
				get_node("装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
				Global.onArmorItemPage = true
				armorItemSelectIndex = 0
				onArmorItemSelect = true
				for i in bagArmorItems.size():
					bagArmorItems[i].get_node("itemImage").texture = null
					bagArmorItems[i].get_node("itemImage/item").text = ""
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
					bagArmorItems[i].self_modulate = "ffffff"
			if buttons[buttonIndex].name == "状态":
				Global.onStatusPage	= true
				$"状态页面".visible = true

			if buttons[buttonIndex].name == "升级加点":
				Global.onSkillPointPage = true
				$"加点页面".visible = true
				skillIndex = 0
				

		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard :
			Global.onMenuSelectCharacter = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			characterIndex = 0
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			move_menuButton_to_top()
	if Global.onItemPage:
		get_node("系统信息").visible = false
		if Input.is_action_just_pressed("ui_up") and !Global.onItemSelect and !Global.onMenuItemUsing and !Global.noKeyboard:
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
			for i in bagMenuItems:
				i.queue_free()			
			if itemTypeIndex ==0:
				itemTypeIndex = menuItems.size()-1
			else:			
				itemTypeIndex -= 1
		if Input.is_action_just_pressed("ui_down") and !Global.onItemSelect and !Global.onMenuItemUsing and !Global.noKeyboard:
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
			for i in bagMenuItems:
				i.queue_free()
			if itemTypeIndex == menuItems.size()-1:
				itemTypeIndex = 0
			else:			
				itemTypeIndex += 1
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.onItemSelect and !Global.onMenuItemUsing and !Global.noKeyboard:
			move_menuButton_to_top()
			itemTypeIndex = 0
			$"道具页面".visible = false
			Global.onItemPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()				
		for i in menuItems.size():
			if menuItems[i].name == menuItems[itemTypeIndex].name:
				menuItems[i].modulate = "red"			
			else:
				menuItems[i].modulate =  "ffffff"
		if Input.is_action_just_pressed("ui_accept") and !Global.onItemSelect and !Global.onMenuItemUsing and canPress and !Global.noKeyboard:	
		
			var itemScene = load("res://Scene/menuItem.tscn")
			itemSelectIndex = 0
			if itemTypeIndex == 0:
				$"道具页面/道具分类/常规物品".emit_signal("button_down")
				
			
			if itemTypeIndex == 1:
				$"道具页面/道具分类/战斗物品".emit_signal("button_down")
			if itemTypeIndex == 2:
				$"道具页面/道具分类/武器".emit_signal("button_down")
			if itemTypeIndex == 3:
				$"道具页面/道具分类/足护".emit_signal("button_down")
			if itemTypeIndex == 4:
				$"道具页面/道具分类/头饰".emit_signal("button_down")
			if itemTypeIndex == 5:
				$"道具页面/道具分类/衣甲".emit_signal("button_down")
			if itemTypeIndex == 6:
				$"道具页面/道具分类/饰品".emit_signal("button_down")
			if itemTypeIndex == 7:
				$"道具页面/道具分类/特殊道具".emit_signal("button_down")
		if Global.onItemSelect:
			if bagMenuItems.size()>0:
				$"道具页面/介绍/Label".text = bagMenuItems[itemSelectIndex].description
				
				
			if Input.is_action_just_pressed("ui_accept") and !Global.onMenuItemUsing and canPress and !Global.noKeyboard:
				
				canPress = false
				$"../canPress".start()
				if Global.onMenuItemUsing:
					return 
				Global.itemPlayerIndex = 0
				Global.itemPlayers = []
				if bagMenuItems[itemSelectIndex].get_node("itemName").text in FightScenePlayers.battleItem:
					Global.onItemSelect = false
					Global.onMenuItemUsing = true
					$"道具页面/角色表".visible = true
				if bagMenuItems[itemSelectIndex].get_node("itemName").text in FightScenePlayers.consumeItem:
					Global.onItemSelect = false
					Global.onMenuItemUsing = true
					$"道具页面/角色表".visible = true
				if bagMenuItems[itemSelectIndex].get_node("itemName").text in FightScenePlayers.keyItem:
					if FightScenePlayers.keyItem.get(bagMenuItems[itemSelectIndex].get_node("itemName").text).info.effect != null:
						Global.onItemSelect = false
						Global.onMenuItemUsing = true
						$"道具页面/角色表".visible = true
								
				Global.currMenuItem = bagMenuItems[itemSelectIndex].get_node("itemName").text
				
				$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
				$"../subSound".play()					
			if Input.is_action_just_pressed("ui_up") and !Global.onMenuItemUsing and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()
				if itemSelectIndex ==0:
					itemSelectIndex = bagMenuItems.size()-1
				else:			
					itemSelectIndex -= 1
					
			if Input.is_action_just_pressed("ui_down") and !Global.onMenuItemUsing and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()
				if itemSelectIndex == bagMenuItems.size()-1:
					itemSelectIndex = 0
				else:			
					itemSelectIndex += 1	
			if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
				for i in bagMenuItems:
					i.queue_free()	
					$"道具页面/介绍/Label".text = ""
				get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
				get_parent().get_node("subSound").play()
				Global.onItemSelect = false			
			if bagMenuItems.size()>0:				
				for i in bagMenuItems:
					if i == bagMenuItems[itemSelectIndex]:
						i.get_node("itemName").modulate = "red"
					else:
						i.get_node("itemName").modulate = "ffffff"
		if Global.onMenuItemUsing:
			if Input.is_action_just_pressed("ui_accept") and canPress  and !Global.noKeyboard :
				$"道具页面/角色表".useItem()
	
	
	if Global.onMagicPage:
		get_node("系统信息").visible = false
		if menuMagic.size() > 0:
			for i in menuMagic:
				if i != menuMagic[menuMagicIndex]:
					i.get_node("name").modulate = "white"
			menuMagic[menuMagicIndex].get_node("name").modulate = "yellow"
		
			
			if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()				
				if menuMagicIndex <= 2:
					return
				else:
					menuMagicIndex -= 3
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
	
			if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()				
				if menuMagicIndex >= menuMagic.size() - 2:
					return
				else:
					if menuMagicIndex + 3 >= 0 && menuMagicIndex + 3 < menuMagic.size():
						menuMagicIndex += 3
					else:
						return
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
			if Input.is_action_just_pressed("ui_left") and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
				if menuMagicIndex == 0:
					return
				menuMagicIndex -= 1
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
			if Input.is_action_just_pressed("ui_right") and !Global.noKeyboard:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
				if menuMagicIndex == menuMagic.size() - 1:
					return
				menuMagicIndex += 1
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
			if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
				get_node("系统信息").visible = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
				get_parent().get_node("subSound").play()	
				Global.onMagicPage = false
				menuMagicIndex = 0
				get_node("法术页面").visible = false
				get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
				move_menuButton_to_top()
				for i in get_tree().get_nodes_in_group("menuMagic"):
					i.get_parent().queue_free()
				characterIndex = 0
	
	if Global.onArmorItemPage:
		bagArmorItemsData = FightScenePlayers.bagArmorItem
		get_node("系统信息").visible = false
		armorItemButton[0].get_node("itemType/icon").texture = null
		armorItemButton[0].get_node("itemType/icon/itemName").text = ""
		armorItemButton[1].get_node("itemType/icon").texture = null
		armorItemButton[1].get_node("itemType/icon/itemName").text = ""
		armorItemButton[2].get_node("itemType/icon").texture = null
		armorItemButton[2].get_node("itemType/icon/itemName").text = ""	
		armorItemButton[3].get_node("itemType/icon").texture = null
		armorItemButton[3].get_node("itemType/icon/itemName").text = ""		
		armorItemButton[4].get_node("itemType/icon").texture = null
		
		armorItemButton[4].get_node("itemType/icon/itemName").text = ""					
		$"装备页面/装备栏/status/level/levelValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].level)
		$"装备页面/装备栏/status/伤害/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg))
		$"装备页面/装备栏/status/物理防御/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense))
		$"装备页面/装备栏/status/魔法抗性/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense))
		$"装备页面/装备栏/status/速度/value".text = str(round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed)))
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon:
		
			armorItemButton[0].get_node("itemType/icon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.icon)
			armorItemButton[0].get_node("itemType/icon/itemName").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes:
			armorItemButton[1].get_node("itemType/icon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.icon)
			armorItemButton[1].get_node("itemType/icon/itemName").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat:
			armorItemButton[2].get_node("itemType/icon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.icon)
			armorItemButton[2].get_node("itemType/icon/itemName").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth:
			armorItemButton[3].get_node("itemType/icon/itemName").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name
			armorItemButton[3].get_node("itemType/icon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.icon)
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories:
			armorItemButton[4].get_node("itemType/icon/itemName").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name
			armorItemButton[4].get_node("itemType/icon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.icon)
		
		if onArmorItemSelect:
			if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
				if armorItemSelectIndex == 4:
					armorItemSelectIndex = 0
				else:
					armorItemSelectIndex += 1
				$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
				$"../subSound".play()			
			if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:
				if armorItemSelectIndex == 0:
					armorItemSelectIndex = 4
				else:
					armorItemSelectIndex -= 1
				$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
				$"../subSound".play()
			if armorItemSelectIndex == 0:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon:
					$"装备页面/装备介绍/description".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.description
				else:
					$"装备页面/装备介绍/description".text = ""					
			if armorItemSelectIndex == 1:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes:
					$"装备页面/装备介绍/description".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.description	
				else:
					$"装备页面/装备介绍/description".text = ""		
			if armorItemSelectIndex == 2:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat:
					$"装备页面/装备介绍/description".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.description
				else:
					$"装备页面/装备介绍/description".text = ""			
			
			if armorItemSelectIndex == 3:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth:
					$"装备页面/装备介绍/description".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.description						
				else:
					$"装备页面/装备介绍/description".text = ""
	
			if armorItemSelectIndex == 4:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories:
					$"装备页面/装备介绍/description".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.description		
				else:
					$"装备页面/装备介绍/description".text = ""
		
		
		
		for i in armorItemButton:
			if i.name == armorItemButton[armorItemSelectIndex].name:
				i.get_node("itemType").self_modulate = "6cffff"		
			else:
				i.get_node("itemType").self_modulate = "ffffff"
		
		
				
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !onBagArmorItemSelect and !Global.noKeyboard:
			move_menuButton_to_top()
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			Global.onArmorItemPage = false
			get_node("装备页面").visible = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			characterIndex = 0
			onBagArmorItemSelect = false
	
		if onArmorItemSelect and Input.is_action_just_released("ui_accept") and canPress and !Global.noKeyboard:
			onBagArmorItemSelect = true
			BagArmorItemIndex = 0  
			onArmorItemSelect = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
			get_parent().get_node("subSound").play()	
			canPress = false
			$"../canPress".start()
#			for arrow in arrows:
#				arrow.visible = true
#				arrow.modulate = "00ff00"
				
		if  onBagArmorItemSelect:
			if FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text):
				$"装备页面/装备介绍/description".text = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.description
			else:
				$"装备页面/装备介绍/description".text = ""
			
			for i in bagArmorItems:
				if bagArmorItems[BagArmorItemIndex] == i:
					i.self_modulate = "red"
				else:
					i.self_modulate = "ffffff"
			if armorItemSelectIndex == 0:
				weapons = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "weapon" and bagArmorItemsData[i].info.user == FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name:
						weapons.append(bagArmorItemsData[i])
				
				for i in weapons.size():
					bagArmorItems[i].get_node("itemImage").texture = load(weapons[i].info.icon )
					bagArmorItems[i].get_node("itemImage/item").text = weapons[i].info.name
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(weapons[i].number)
					
					
					
				if weapons.size() > BagArmorItemIndex and weapons[BagArmorItemIndex]:
					if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon != null:
						if decrypt(weapons[BagArmorItemIndex].info.value.additionDmg) > decrypt( FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg) :
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg + weapons[BagArmorItemIndex].info.value.additionDmg))
						elif decrypt(weapons[BagArmorItemIndex].info.value.additionDmg) <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg:
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg  + weapons[BagArmorItemIndex].info.value.additionDmg))

						elif decrypt(weapons[BagArmorItemIndex].info.value.additionDmg) ==  decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg):
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg+ weapons[BagArmorItemIndex].info.value.additionDmg))
					else:
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg + weapons[BagArmorItemIndex].info.value.additionDmg))
					
				
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
					$"装备页面/装备栏/status/伤害/value/arrow".visible = false
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 0 and !Global.noKeyboard:
						
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon != null:
							
							if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == "梦澹":
								Global.gai = false
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg
							
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name):
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name].number += 1
							else:
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name] = {
		  						"info": ItemData.weapon.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name),
								"type": "weapon",
								"number": 1,
								"added": false
							}
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = null	
							$"装备页面/装备栏/items/button1/itemType/icon".texture = null
							$"装备页面/装备栏/items/button1/itemType/icon/itemName".text = ""
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()
				#如果选中的背包位子不是空的,切换武器
				elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "" and FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user ==FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name:
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 0 and !Global.noKeyboard:
		
						#如果选中的背包位子不是空的，并且武器不是空的
						if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "" :
							print(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text)
							if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "梦澹":
								
								Global.gai = true
							if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == "梦澹":
								Global.gai = false							
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
							
							#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name):
					
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
									return
								else:
									FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
									FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name).number += 1
									FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
									for i in bagArmorItems.size():
										bagArmorItems[i].get_node("itemImage").texture = null
										bagArmorItems[i].get_node("itemImage/item").text = ""
										bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()
							else:

								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name] = {
		  						"info": ItemData.weapon.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name),
								"type": "weapon",
								"number": 1,
								"added": false
								}
								FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
								FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()						
						else:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg

							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()
			if armorItemSelectIndex == 1:
				shoes = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "shoes":
						shoes.append(bagArmorItemsData[i])
				for i in shoes.size():
					bagArmorItems[i].get_node("itemImage").texture = load(shoes[i].info.icon )
					bagArmorItems[i].get_node("itemImage/item").text = shoes[i].info.name
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(shoes[i].number)
				if shoes.size() > BagArmorItemIndex and shoes[BagArmorItemIndex]:
					if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes != null:
						if shoes[BagArmorItemIndex].info.value.addPlayerSpeed >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed :
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)))
						elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)))

						elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(decrypt(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)))
					else:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)))
						
			
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
					$"装备页面/装备栏/status/速度/value/arrow".visible = false
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 1 and !Global.noKeyboard:
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes != null:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name):
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name].number += 1
							else:
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name] = {
		  						"info": ItemData.shoes.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name),
								"type": "shoes",
								"number": 1,
								"added": false
							}
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = null	
							$"装备页面/装备栏/items/button2/itemType/icon".texture = null
							$"装备页面/装备栏/items/button2/itemType/icon/itemName".text = ""
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()							
					#如果选中的背包位子不是空的
				elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "" and   (FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user ==FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex or FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user == "all" ):
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 1 and !Global.noKeyboard:
						#如果选中的背包位子不是空的，并且武器不是空的
						if $"装备页面/装备栏/items/button2/itemType/icon/itemName".text != "":
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
				
							#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name):
					
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
									return
								else:
									FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
									FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name).number += 1
									FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
									for i in bagArmorItems.size():
										bagArmorItems[i].get_node("itemImage").texture = null
										bagArmorItems[i].get_node("itemImage/item").text = ""
										bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()							
							else:

								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name] = {
		  						"info": ItemData.shoes.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name),
								"type": "shoes",
								"number": 1,
								"added": false
								}
								FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
								FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()						
						else:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""	
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()												
			if armorItemSelectIndex == 2:
				hats = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "hat":
						hats.append(bagArmorItemsData[i])
				for i in hats.size():
					bagArmorItems[i].get_node("itemImage").texture = load(hats[i].info.icon )
					bagArmorItems[i].get_node("itemImage/item").text = hats[i].info.name
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(hats[i].number)
				if hats.size() > BagArmorItemIndex and hats[BagArmorItemIndex]:
					if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat != null:
						if hats[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense :
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense + hats[BagArmorItemIndex].info.value.addPhysicDefense))
						elif hats[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense  + hats[BagArmorItemIndex].info.value.addPhysicDefense))

						elif hats[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense+ hats[BagArmorItemIndex].info.value.addPhysicDefense))
					else:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + hats[BagArmorItemIndex].info.value.addPhysicDefense))
						
			
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "" :
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 2 and !Global.noKeyboard:
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat != null:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name):
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name].number += 1
							else:
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name] = {
		  						"info": ItemData.hat.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name),
								"type": "hat",
								"number": 1,
								"added": false
							}
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = null	
							$"装备页面/装备栏/items/button3/itemType/icon".texture = null
							$"装备页面/装备栏/items/button3/itemType/icon/itemName".text = ""
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()							
					#如果选中的背包位子不是空的
				elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != ""  and (FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user ==FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex or FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user == "all" ):
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 2 and !Global.noKeyboard:
						#如果选中的背包位子不是空的，并且武器不是空的
						if $"装备页面/装备栏/items/button3/itemType/icon/itemName".text != "":
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
				
							#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name):
					
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
									return
								else:
									FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
									FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name).number += 1
									FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
									for i in bagArmorItems.size():
										bagArmorItems[i].get_node("itemImage").texture = null
										bagArmorItems[i].get_node("itemImage/item").text = ""
										bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()							
							else:

								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name] = {
		  						"info": ItemData.hat.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name),
								"type": "hat",
								"number": 1,
								"added": false
								}
								FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
								FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()						
						else:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""						
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()			
			
			if armorItemSelectIndex == 3:
				cloths = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "cloth":
						cloths.append(bagArmorItemsData[i])
				for i in cloths.size():
					
					bagArmorItems[i].get_node("itemImage").texture = load(cloths[i].info.icon )
					bagArmorItems[i].get_node("itemImage/item").text = cloths[i].info.name
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(cloths[i].number)
					
					
					
				if cloths.size() > BagArmorItemIndex and cloths[BagArmorItemIndex]:
					if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth != null:
						if cloths[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense :
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense + cloths[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense + cloths[BagArmorItemIndex].info.value.addMagicDefense))
						
						elif cloths[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense  + cloths[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense  + cloths[BagArmorItemIndex].info.value.addMagicDefense))
						elif cloths[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense+ cloths[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense+ cloths[BagArmorItemIndex].info.value.addMagicDefense))				
					else:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + cloths[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense + cloths[BagArmorItemIndex].info.value.addMagicDefense))						
			
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = false
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 3 and !Global.noKeyboard:
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth != null:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name):
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name].number += 1
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()							
							
							else:
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name] = {
		  						"info": ItemData.cloth.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name),
								"type": "cloth",
								"number": 1,
								"added": false
							}
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = null	
							$"装备页面/装备栏/items/button4/itemType/icon".texture = null
							$"装备页面/装备栏/items/button4/itemType/icon/itemName".text = ""
							
					#如果选中的背包位子不是空的
				elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != ""  and (FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user ==FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex or FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user == "all" ):
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 3 and !Global.noKeyboard:
						#如果选中的背包位子不是空的，并且武器不是空的
						if $"装备页面/装备栏/items/button4/itemType/icon/itemName".text != "":
						
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
							
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
				
							#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name):
					
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
									return
								else:
									FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
									FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name).number += 1
									FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
									for i in bagArmorItems.size():
										bagArmorItems[i].get_node("itemImage").texture = null
										bagArmorItems[i].get_node("itemImage/item").text = ""
										bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
									$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
									$"../subSound".play()
							else:
								$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
								$"../subSound".play()
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name] = {
		  						"info": ItemData.cloth.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name),
								"type": "cloth",
								"number": 1,
								"added": false
								}
								FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
								FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
						
						else:
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""	
			if armorItemSelectIndex == 4:
				accessories = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "accessories":
						accessories.append(bagArmorItemsData[i])
				for i in accessories.size():
					
					bagArmorItems[i].get_node("itemImage").texture = load(accessories[i].info.icon )
					bagArmorItems[i].get_node("itemImage/item").text = accessories[i].info.name
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(accessories[i].number)
				if accessories.size() > BagArmorItemIndex and accessories[BagArmorItemIndex]:
					if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories != null:
						if accessories[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense :
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense))
							
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg))					
							
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed))							
					
					
					
					
						elif accessories[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense))
							
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg))					
							
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed))		
						
						
						
						
						elif accessories[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense))
							
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg))					
							
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed))		
						
					
					
					
					else:
							$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
							$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense))
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense))						
							
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed))
							
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
						
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg))									
			
			
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":

					$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = false
					$"装备页面/装备栏/status/伤害/value/arrow".visible = false
					$"装备页面/装备栏/status/速度/value/arrow".visible = false
					
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 4 and !Global.noKeyboard:
						FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()						
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories != null:
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addHp
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()				
							
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name):
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name].number += 1
							else:
								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name] = {
		  						"info": ItemData.accessories.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name),
								"type": "accessories",
								"number": 1,
								"added": false
							}
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = null	
							$"装备页面/装备栏/items/button5/itemType/icon".texture = null
							$"装备页面/装备栏/items/button5/itemType/icon/itemName".text = ""
							
					#如果选中的背包位子不是空的
				elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != ""  and (FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user ==FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name or FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user == "all" ):
					
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 4 and !Global.noKeyboard:
						FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()	
									
						#如果选中的背包位子不是空的，并且武器不是空的
						
						if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
							
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addHp + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
				
							#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
							if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name):
					
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
									return
								else:
									FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
									FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name).number += 1
									FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
									for i in bagArmorItems.size():
										bagArmorItems[i].get_node("itemImage").texture = null
										bagArmorItems[i].get_node("itemImage/item").text = ""
										bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
							else:

								FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name] = {
		  						"info": ItemData.accessories.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name),
								"type": "accessories",
								"number": 1,
								"added": false
								}
								FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
								FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
						else:
							if FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user == "时追云":
								if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name == "时追云":
									pass
								else:
									return 
							
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp
							
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""						
					
					
			
			

			if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
				onArmorItemSelect = true
				onBagArmorItemSelect = false
				get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
				get_parent().get_node("subSound").play()	
				for arrow in arrows:
					arrow.visible = false
					arrow.modulate = "ffffff"
				for i in bagArmorItems.size():
					bagArmorItems[i].get_node("itemImage").texture = null
					bagArmorItems[i].get_node("itemImage/item").text = ""
					bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
					bagArmorItems[i].self_modulate = "ffffff"
			if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:
				if BagArmorItemIndex <= 2:
					return
				else:
					BagArmorItemIndex  -= 3
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()						
			if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
				if BagArmorItemIndex  > 8:
					return
				else:
					BagArmorItemIndex  += 3	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left") and !Global.noKeyboard:
				if BagArmorItemIndex  == 0:
					return
				BagArmorItemIndex  -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right") and !Global.noKeyboard:
				if BagArmorItemIndex  == 11:
					return
				BagArmorItemIndex += 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()	
			
	if Global.onStatusPage:
		get_node("系统信息").visible = false
		$"状态页面/Panel/weapon".texture = null
		$"状态页面/Panel/weapon/Label".text = "武器(空)"
		$"状态页面/Panel/shoes".texture = null
		$"状态页面/Panel/shoes/Label".text = "足护(空)"
		$"状态页面/Panel/hat".texture = null
		$"状态页面/Panel/hat/Label".text = "头饰(空)"
		$"状态页面/Panel/cloth".texture = null
		$"状态页面/Panel/cloth/Label".text = "衣甲(空)"
		$"状态页面/Panel/accessories".texture = null
		$"状态页面/Panel/accessories/Label".text = "饰品(空)"
		$"状态页面/Panel/name".text = Global.onTeamPlayer[characterIndex]
		$"状态页面/Panel/levelLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].level)
		$"状态页面/Panel/exp/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].exp))
		$"状态页面/Panel/next/value".text =  str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].needExp) - decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].exp))
	
		$"状态页面/Panel/hpText/hpBar".max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].hp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp)
		$"状态页面/Panel/hpText/hpBar".value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currHp
		$"状态页面/Panel/hpText/hpBar/hpValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currHp) + "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].hp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp))
		
		$"状态页面/Panel/mpText/mpBar".max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].mp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMp)
		$"状态页面/Panel/mpText/mpBar".value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currMp
		$"状态页面/Panel/mpText/mpBar/mpValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currMp) + "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].mp + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMp))
	
		$"状态页面/Panel/addDmgLabel/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg)) 
		$"状态页面/Panel/physicDefenseLabel/value".text =  str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].physicDefense + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense))
		$"状态页面/Panel/magicDefenseLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].magicDefense + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense))
		$"状态页面/Panel/strengthLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].str + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addStr))
		$"状态页面/Panel/critLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].critChance + round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addCritChance))) + "%"
		$"状态页面/Panel/speedLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerSpeed + round(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed)))
		$"状态页面/Panel/magicLabel/value".text = str(decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].abilityPower) + decrypt(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addAbilityPower))
		$"状态页面/Panel/icon".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].smallIcon)
		
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon:
			$"状态页面/Panel/weapon".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.icon)
			$"状态页面/Panel/weapon/Label".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name
		
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes:
			$"状态页面/Panel/shoes".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.icon)
			$"状态页面/Panel/shoes/Label".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name
		
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat:
			$"状态页面/Panel/hat".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.icon)
			$"状态页面/Panel/hat/Label".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name
		
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth:
			$"状态页面/Panel/cloth".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.icon)
			$"状态页面/Panel/cloth/Label".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name
		
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories:
			$"状态页面/Panel/accessories".texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.icon)
			$"状态页面/Panel/accessories/Label".text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
			Global.onMenuSelectCharacter = false
			move_menuButton_to_top()
			$"状态页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			get_node("系统信息").visible = true
			Global.onStatusPage = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))			
			characterIndex = 0				
	if Global.onQuitMenu:
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
			move_menuButton_to_top()
			$"退出页面".visible = false
			Global.onQuitMenu = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()				
			
		if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
			if quitIndex == 1:
				quitIndex = 0
			else:		
				quitIndex += 1
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:		
			if quitIndex == 0:
				quitIndex = 1
			else:		
				quitIndex -= 1	
			
		if quitIndex == 0:
			$"退出页面/退出信息/返回标题".self_modulate = "000000"
			$"退出页面/退出信息/退出游戏".self_modulate = "ffffff"
		else:
			$"退出页面/退出信息/返回标题".self_modulate = "ffffff"
			$"退出页面/退出信息/退出游戏".self_modulate = "000000"
		if Input.is_action_just_pressed("ui_accept") and !Global.noKeyboard:
			if quitIndex == 1:
				get_tree().quit()
			else:
				get_tree().change_scene_to_file("res://Scene/主页.tscn")
				Global.menuOut = false
				Global.onQuitMenu = false
				$".".visible = false
				$"退出页面".visible = false
				
	if Global.onSkillPointPage:

		Global.onMenuSelectCharacter = false
		var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	
		$"加点页面/属性区/最大气血/最大气血数字".text = str(currPlayer.hp + decrypt(currPlayer.addHp)) 
		$"加点页面/属性区/最大仙能/最大仙能数字".text = str(currPlayer.mp + decrypt(currPlayer.addMp))
		
		$"加点页面/属性区/格挡概率/value".text = str(currPlayer.blockChance + decrypt(currPlayer.addBlockChance)) + " => "
		$"加点页面/属性区/格挡概率/value/changedValue".text = str(currPlayer.blockChance + decrypt(currPlayer.addBlockChance))
		
		$"加点页面/属性区/力量/value".text = str(currPlayer.str + round(decrypt(currPlayer.addStr))) + " => "
		$"加点页面/属性区/力量/value/changedValue".text = str(currPlayer.str + round(decrypt(currPlayer.addStr))) 
		
		$"加点页面/属性区/暴击/value".text = str(currPlayer.critChance + decrypt(currPlayer.addCritChance)) + " => "
		$"加点页面/属性区/暴击/value/changedValue".text = str(currPlayer.critChance + decrypt(currPlayer.addCritChance))
		
		$"加点页面/属性区/敏捷/value".text = str(currPlayer.playerSpeed + round(decrypt(currPlayer.addPlayerSpeed))) + " => "
		$"加点页面/属性区/敏捷/value/changedValue".text = str(currPlayer.playerSpeed + round(decrypt(currPlayer.addPlayerSpeed)))
		
		$"加点页面/属性区/仙力/value".text = str(decrypt(currPlayer.abilityPower) + decrypt(currPlayer.addAbilityPower)) + " => "
		
		$"加点页面/属性区/仙力/value/changedValue".text = str(decrypt(currPlayer.abilityPower) + decrypt(currPlayer.addAbilityPower))
		$"加点页面/属性区/角色名".text = currPlayer.name
		$"加点页面/属性区/等级/等级数字".text = str(currPlayer.level)
		$"加点页面/属性区/剩余加点/value".text = str(decrypt(currPlayer.potential))
		

		for i in skillButtons: 
			if i.name == skillButtons[skillIndex].name:
				i.get_node("加点文本").modulate = "red"
			else:
				i.get_node("加点文本").modulate = "ffffff"
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") )and !Global.noKeyboard:
			$"加点页面/属性区/最大气血/最大气血数字".modulate = "ffffff"
			$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = false
			$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"
			$"加点页面/属性区/格挡概率/value/changedValue/increaseValue"	.visible = false						
			$"加点页面/属性区/力量/value/changedValue".modulate = "ffffff"		
			$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = false		
			$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
			$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false				
			$"加点页面/属性区/敏捷/value/changedValue".modulate = "ffffff"			
			$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = false				
			$"加点页面/属性区/仙力/value/changedValue".modulate = "ffffff"		
			$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = false	
			$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ffffff"		
			$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = false				
			
			
			currPlayer.potential += pointOnLuck + pointOnHp +pointOnSpeed + pointOnMagic + pointOnStr
					
			pointOnLuck= 0
			pointOnHp= 0
			pointOnSpeed= 0
			pointOnMagic= 0
			pointOnStr = 0	
			
			move_menuButton_to_top()
			$"加点页面".visible = false
			Global.onSkillPointPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))			
			characterIndex = 0
		if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
			if skillIndex == 6:
				skillIndex = 0
			else:		
				skillIndex += 1
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:		
				if skillIndex  == 0:
					skillIndex  = 6
				else:		
					skillIndex -= 1	
		if skillIndex == 0:
			$"加点页面/介绍区/Label".text = "最大气血值7点"
			$"加点页面/介绍区/总共提高".visible = true				
		if skillIndex == 1:
			$"加点页面/介绍区/Label".text = "力量1点"
			$"加点页面/介绍区/Label2".text = ""							
		if skillIndex == 2:
			$"加点页面/介绍区/Label".text = "暴击概率0.25点"
			$"加点页面/介绍区/Label2".text = "格挡概率0.25点"						
		if skillIndex == 3:
			$"加点页面/介绍区/Label".text = "最大敏捷1点"
			$"加点页面/介绍区/Label2".text = ""					
		if skillIndex == 4:
			$"加点页面/介绍区/Label".text = "灵力1点"
			$"加点页面/介绍区/Label2".text = "最大仙能7点"	
			$"加点页面/介绍区/总共提高".visible = true						
		if skillIndex == 5:
			$"加点页面/介绍区/Label".text = "保存分配情况"
			$"加点页面/介绍区/Label2".text = ""	
			$"加点页面/介绍区/总共提高".visible = false		
		if skillIndex == 6:
			$"加点页面/介绍区/Label".text = "重置分配点数"
			$"加点页面/介绍区/Label2".text = ""							
			$"加点页面/介绍区/总共提高".visible = false		
					
		if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
			Global.playsound("res://Audio/SE/002-System02.ogg")
			if skillIndex == 0 and currPlayer.potential > 0:
				pointOnHp += 1 * Global.enKey
				currPlayer.potential -= Global.enKey 
				
				
				$"加点页面/属性区/最大气血/最大气血数字".modulate = 	"ff0000"
				$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = true
				$"加点页面/属性区/最大气血/最大气血数字/increaseValue".text = "(+ " + str(decrypt(pointOnHp) * 7) + ")"
#				if pointOnHp >0:
#					$"加点页面/属性区/物理防御/value/changedValue".modulate = "ff0000"
#				$"加点页面/属性区/物理防御/value/changedValue"
#				$"加点页面/属性区/物理防御/value/changedValue/increaseValue".visible = true
#				$"加点页面/属性区/物理防御/value/changedValue/increaseValue"	.text = "(+ " + str(pointOnHp * 1) + ")"
			elif skillIndex == 1 and currPlayer.potential > 0:
				pointOnStr += 1 * Global.enKey
				currPlayer.potential -= Global.enKey 
				
				if pointOnStr >0:
					$"加点页面/属性区/力量/value/changedValue".modulate = "ff0000"
				$"加点页面/属性区/力量/value/changedValue"	
				$"加点页面/属性区/力量/value/changedValue/increaseValue".text = "(+ " + str(decrypt(pointOnStr) * 1) + ")"
				$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = true
			elif skillIndex == 2 and currPlayer.potential > 0:
				pointOnLuck += 1 * Global.enKey
				currPlayer.potential -= Global.enKey 
				if pointOnLuck >0:
					$"加点页面/属性区/暴击/value/changedValue".modulate = "ff0000"				
					$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ff0000"	
				$"加点页面/属性区/格挡概率/value/changedValue"
				$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".text = "(+ " + str(decrypt(pointOnLuck) * 0.25) + ")"	
										
				$"加点页面/属性区/暴击/value/changedValue"
				$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/暴击/value/changedValue/increaseValue".text = "(+ " + str(decrypt(pointOnLuck) * 0.25) + ")"	
			elif skillIndex == 3 and currPlayer.potential > 0:	
				pointOnSpeed += 1 * Global.enKey
				currPlayer.potential -= Global.enKey 
				if pointOnSpeed  >0:
					$"加点页面/属性区/敏捷/value/changedValue".modulate = "ff0000"					
				$"加点页面/属性区/敏捷/value/changedValue"	
				$"加点页面/属性区/敏捷/value/changedValue/increaseValue".text = "(+ " + str(decrypt(pointOnSpeed) * 1) + ")"
				$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = true
			elif skillIndex == 4 and currPlayer.potential > 0:	
				pointOnMagic += 1 * Global.enKey
				currPlayer.potential -= Global.enKey 
				if pointOnMagic >0:
					$"加点页面/属性区/仙力/value/changedValue".modulate = "ff0000"				
					$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ff0000"
					
				$"加点页面/属性区/仙力/value/changedValue"
				$"加点页面/属性区/仙力/value/changedValue/increaseValue".text = "(+ " + str(decrypt(pointOnMagic) * 1) + ")"
				$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/最大仙能/最大仙能数字"
				$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".text = "(+ " + str(decrypt(pointOnMagic) * 7) + ")"
				$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = true
				
			elif skillIndex == 5:	
				Global.playsound("res://Audio/SE/007-System07.ogg")
				if pointOnHp > 0:
					currPlayer.addHp += pointOnHp * 7 
					currPlayer.addPhysicDefense += pointOnHp 
					$"加点页面/属性区/最大气血/最大气血数字".modulate = "ffffff"
					$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = false
					$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"
					$"加点页面/属性区/格挡概率/value/changedValue/increaseValue"	.visible = false				
				if pointOnStr > 0:	
					currPlayer.addStr += pointOnStr 
					$"加点页面/属性区/力量/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = false
				if pointOnLuck > 0:	
					currPlayer.addCritChance += pointOnLuck * 0.25 
					currPlayer.addBlockChance += pointOnLuck * 0.25
					$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false
					$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = false
				if pointOnSpeed > 0 :
					currPlayer.addPlayerSpeed += pointOnSpeed * 0.5 
					$"加点页面/属性区/敏捷/value/changedValue".modulate = "ffffff"			
					$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = false
				if pointOnMagic > 0:
					currPlayer.addAbilityPower	+=  pointOnMagic
					currPlayer.addMp += pointOnMagic * 7 
					$"加点页面/属性区/仙力/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = false	
					$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ffffff"		
					$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = false
								
				pointOnLuck= 0
				pointOnHp= 0
				pointOnSpeed= 0
				pointOnMagic= 0
				pointOnStr = 0
				
			elif skillIndex == 6:	
				$"加点页面/属性区/最大气血/最大气血数字".modulate = "ffffff"
				$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = false
				$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"
				$"加点页面/属性区/格挡概率/value/changedValue/increaseValue"	.visible = false						
				$"加点页面/属性区/力量/value/changedValue".modulate = "ffffff"		
				$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = false		
				$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
				$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false				
				$"加点页面/属性区/敏捷/value/changedValue".modulate = "ffffff"			
				$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = false				
				$"加点页面/属性区/仙力/value/changedValue".modulate = "ffffff"		
				$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = false	
				$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ffffff"		
				$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = false				
				
				Global.playsound("res://Audio/SE/004-System04.ogg")
				currPlayer.potential += pointOnLuck + pointOnHp +pointOnSpeed + pointOnMagic + pointOnStr
						
				pointOnLuck= 0
				pointOnHp= 0
				pointOnSpeed= 0
				pointOnMagic= 0
				pointOnStr = 0				
	if Global.onSavePage:
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
			move_menuButton_to_top()
			Global.onSavePage = false
			$"保存页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true			
		if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
			if Global.saveIndex == 3:
				Global.saveIndex = 0
			else:
				Global.saveIndex += 1	

			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:	
			if Global.saveIndex == 0:
				Global.saveIndex = 3
			else:
				Global.saveIndex -= 1
	
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
			saveGame()

			get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
			get_parent().get_node("subSound").play()		

			var savePath = "user://saveFile"+str(Global.saveIndex)
			var file = FileAccess.open(savePath, FileAccess.READ)	
			if file.file_exists(savePath):
				var data = file.get_var()	
				saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
				saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id	)
				saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate			
		for i in saveSlots:
			if i.name == saveSlots[Global.saveIndex].name:
				i.self_modulate = "0000ff"	
			else:
				i.self_modulate = "ffffff94"	
	if Global.onLoadPage:
		if (Input.is_action_just_pressed("esc") or  Input.is_action_just_pressed("rightClick") ) and !Global.noKeyboard:
			move_menuButton_to_top()
			Global.onLoadPage = false
			$"读取页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true			
		if Input.is_action_just_pressed("ui_down") and !Global.noKeyboard:
			if Global.saveIndex == 3:
				Global.saveIndex = 0
			else:
				Global.saveIndex += 1	

			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:	
			if Global.saveIndex == 0:
				Global.saveIndex = 3
			else:
				Global.saveIndex -= 1
	
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress  and !Global.noKeyboard:
			
			var savePath = "user://saveFile"+str(Global.saveIndex)
			var file = FileAccess.open(savePath, FileAccess.READ)	
			
			if file and file.file_exists(savePath):
				var data = file.get_var()	
				saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
				saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
				saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate
			
				loadGame()
				Global.onLoadPage = false
				$"读取页面".visible = false
				Global.menuOut = false
				$".".visible = false

				
				
				get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
				get_parent().get_node("subSound").play()		
							
		for i in  loadSlots:
			if i.name == loadSlots[Global.saveIndex].name:
				i.self_modulate = "0000ff"	
			else:
				i.self_modulate = "ffffff94"	
						
				
func _on_can_press_timeout():
	canPress = true
	
func saveGame():
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	var data = {}
	
	FightScenePlayers.saveData()
	
	data.FightScenePlayers = FightScenePlayers.datas

	
	Global.save()
	data.Global = Global.saveData
	
	
	var datetime = Time.get_datetime_dict_from_system()
	
	var formatDate = str(datetime.year) + "/" + str(datetime.month) + "/" + str(datetime.day) + "  " + str(datetime.hour) + ":" + str(datetime.minute) + ":" + str(datetime.second)
	data.formatDate = formatDate

	file.store_var(data)

func loadGame():
	
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	var data = file.get_var()		
	if Global.uniqueId != data.Global.uniqueId:
		return

	FightScenePlayers.datas = data.FightScenePlayers
	
	FightScenePlayers.loadData()
	

	Global.saveData = data.Global
	
	
	if mapPlayer:
		mapPlayer[0].queue_free()
	
	Global.loadData()
	Global.load = true
	$"../addChild".start()
	get_parent().get_parent().modulate = "#000000"
func _on_video_stream_player_finished():
	$"保存页面/VideoStreamPlayer".play()
	
func format_times(seconds):
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var second = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, second]
func instances():
	var instance = preload("res://Scene/player.tscn").instantiate()


func _on_add_child_timeout():
	
	var instance = preload("res://Scene/player.tscn").instantiate()
	instance.name = "player"
	instance.position = Global.mapPlayerPos
	$"..".add_child(instance)
	$"..".modulate = "ffffff"


func _on_video_stream_player_2_finished():
	$"读取页面/VideoStreamPlayer2".play()

func _on_道具_button_down():	
	if !Global.noKeyboard:
		return
	if !Global.onSavePage and !Global.onLoadPage and !Global.onArmorItemPage:
		buttonIndex = 0
		move_道具页面_to_top()
		if !Global.onFight and Global.onItemPage == false:
			canPress = false
			$"../canPress".start()	
				
			$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
			$"../subSound".play()	
			Global.onItemPage = true
			$"道具页面".visible = true

func _on_法术_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onSavePage and !Global.onLoadPage:
		buttonIndex = 1
		if !Global.onMenuSelectCharacter and !Global.onMagicPage:
			move_status_to_top()
			canPress = false
			$"../canPress".start()
			get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
			Global.onMenuSelectCharacter = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
			get_parent().get_node("subSound").play()		
func _on_装备_button_down():
	if !Global.noKeyboard:
		return
	buttonIndex = 2
	if !Global.onMenuSelectCharacter and !Global.onArmorItemPage:
		canPress = false
		$"../canPress".start()
		move_status_to_top()
		get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
		Global.onMenuSelectCharacter = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()		
func _on_状态_button_down():
	if !Global.noKeyboard:
		return
	buttonIndex = 3
	if !Global.onMenuSelectCharacter and !Global.onStatusPage:
		canPress = false
		$"../canPress".start()		
		move_status_to_top()
		get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
		Global.onMenuSelectCharacter = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()		


func _on_保存冒险_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter and !Global.onSavePage:
		buttonIndex = 4
		move()
	
		canPress = false
		$"../canPress".start()
		Global.onSavePage = true
		$"保存页面".visible = true
		Global.saveIndex = 0
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()	

		for i in saveSlots.size():
			var savePath = "user://saveFile"+str(i)
			
			var file = FileAccess.open(savePath, FileAccess.READ)

			if file and file.file_exists(savePath):
				var data = file.get_var()	
				saveSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
				saveSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)


func _on_读取进度_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter and !Global.onLoadPage:
		buttonIndex = 5
		move()
		Global.onLoadPage = true
		canPress = false
		$"../canPress".start()
		$"读取页面".visible = true
		Global.saveIndex = 0
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()	
	
		for i in loadSlots.size():
			
			var savePath = "user://saveFile"+str(i)
			var file = FileAccess.open(savePath, FileAccess.READ)
			
			if file and file.file_exists(savePath):
				var data = file.get_var()	
				loadSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
				loadSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)

func _on_升级加点_button_down():
	if !Global.noKeyboard:
		return
	buttonIndex = 6
	move()
	if !Global.onMenuSelectCharacter and !Global.onSkillPointPage:
		canPress = false
		$"../canPress".start()
		move_status_to_top()		
		get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
		Global.onMenuSelectCharacter = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()		

func _on_返回现实_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter and !Global.onQuitMenu:
		buttonIndex = 7
		move()
		Global.onQuitMenu = true
		$"退出页面".visible = true	
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()	
func move():
	if buttonIndex == 0:
		move_道具页面_to_top()
	elif buttonIndex == 1:
		move_法术页面_to_top()
	elif buttonIndex == 2:
		move_装备页面_to_top()	
	elif buttonIndex == 3:
		move_状态页面_to_top()	
	elif buttonIndex == 4:
		move_保存页面_to_top()	
	elif buttonIndex == 5:
		move_读取页面_to_top()	
	elif buttonIndex == 6:
		move_加点页面_to_top()			
	elif buttonIndex == 7:
		move_退出页面_to_top()	
	
		
func _on_player_1_button_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter:
		return
	move_menuButton_to_top()
	move()
	Global.onMenuSelectCharacter = false
	characterIndex = 0
	if buttons[buttonIndex].name == "状态":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onStatusPage	= true
		$"状态页面".visible = true

	if buttons[buttonIndex].name == "升级加点":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onSkillPointPage = true
		$"加点页面".visible = true
		skillIndex = 0	
	
	if buttons[buttonIndex].name == "法术":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		get_node("法术页面").visible = true
		get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
		Global.onMagicPage = true
		for i in FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic:
			var menuMagic = menuMagicButtonScene.instantiate()

			if i.has("level"):
				menuMagic.get_node("Button/name").text = i.name + "(" + str(i.level) + ") "
				menuMagic.get_node("Button/cost").text = str(i.currExp) + "/" + str(i.needExp)
				menuMagic.get_node("Button/icon").texture = load(i.icon)
			else:
				menuMagic.get_node("Button/name").text = i.name
			get_node("法术页面/技能表/ScrollContainer/GridContainer").add_child(menuMagic)	
	if buttons[buttonIndex].name == "装备":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()				
		get_node("装备页面").visible = true
		get_node("装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
		Global.onArmorItemPage = true
		armorItemSelectIndex = 0
		onArmorItemSelect = true
		for i in bagArmorItems.size():
			bagArmorItems[i].get_node("itemImage").texture = null
			bagArmorItems[i].get_node("itemImage/item").text = ""
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			bagArmorItems[i].self_modulate = "ffffff"



func _on_player_2_button_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter:
		return	
	move_menuButton_to_top()
	move()
	Global.onMenuSelectCharacter = false
	characterIndex = 1
	if buttons[buttonIndex].name == "状态":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onStatusPage	= true
		$"状态页面".visible = true

	if buttons[buttonIndex].name == "升级加点":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onSkillPointPage = true
		$"加点页面".visible = true
		skillIndex = 0	
	
	if buttons[buttonIndex].name == "法术":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		get_node("法术页面").visible = true
		get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
		Global.onMagicPage = true
		for i in FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic:
			var menuMagic = menuMagicButtonScene.instantiate()

			if i.has("level"):
				menuMagic.get_node("Button/name").text = i.name + "(" + str(i.level) + ") "
				menuMagic.get_node("Button/cost").text = str(i.currExp) + "/" + str(i.needExp)
				menuMagic.get_node("Button/icon").texture = load(i.icon)
			else:
				menuMagic.get_node("Button/name").text = i.name
			get_node("法术页面/技能表/ScrollContainer/GridContainer").add_child(menuMagic)	
	if buttons[buttonIndex].name == "装备":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()				
		get_node("装备页面").visible = true
		get_node("装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
		Global.onArmorItemPage = true
		armorItemSelectIndex = 0
		onArmorItemSelect = true
		for i in bagArmorItems.size():
			bagArmorItems[i].get_node("itemImage").texture = null
			bagArmorItems[i].get_node("itemImage/item").text = ""
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			bagArmorItems[i].self_modulate = "ffffff"


func _on_player_3_button_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter:
		return	
	move_menuButton_to_top()
	move()
	Global.onMenuSelectCharacter = false
	characterIndex = 2
	if buttons[buttonIndex].name == "状态":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onStatusPage	= true
		$"状态页面".visible = true

	if buttons[buttonIndex].name == "升级加点":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onSkillPointPage = true
		$"加点页面".visible = true
		skillIndex = 0	
	
	if buttons[buttonIndex].name == "法术":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		get_node("法术页面").visible = true
		get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
		Global.onMagicPage = true
		for i in FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic:
			var menuMagic = menuMagicButtonScene.instantiate()

			if i.has("level"):
				menuMagic.get_node("Button/name").text = i.name + "(" + str(i.level) + ") "
				menuMagic.get_node("Button/cost").text = str(i.currExp) + "/" + str(i.needExp)
				menuMagic.get_node("Button/icon").texture = load(i.icon)
			else:
				menuMagic.get_node("Button/name").text = i.name
			get_node("法术页面/技能表/ScrollContainer/GridContainer").add_child(menuMagic)	
	if buttons[buttonIndex].name == "装备":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()				
		get_node("装备页面").visible = true
		get_node("装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
		Global.onArmorItemPage = true
		armorItemSelectIndex = 0
		onArmorItemSelect = true
		for i in bagArmorItems.size():
			bagArmorItems[i].get_node("itemImage").texture = null
			bagArmorItems[i].get_node("itemImage/item").text = ""
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			bagArmorItems[i].self_modulate = "ffffff"



func _on_player_4_button_button_down():
	if !Global.noKeyboard:
		return
	if !Global.onMenuSelectCharacter:
		return	
	move_menuButton_to_top()
	move()
	Global.onMenuSelectCharacter = false
	characterIndex = 3
	if buttons[buttonIndex].name == "状态":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onStatusPage	= true
		$"状态页面".visible = true

	if buttons[buttonIndex].name == "升级加点":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		Global.onSkillPointPage = true
		$"加点页面".visible = true
		skillIndex = 0	
	
	if buttons[buttonIndex].name == "法术":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()			
		get_node("法术页面").visible = true
		get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
		Global.onMagicPage = true
		for i in FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic:
			var menuMagic = menuMagicButtonScene.instantiate()

			if i.has("level"):
				menuMagic.get_node("Button/name").text = i.name + "(" + str(i.level) + ") "
				menuMagic.get_node("Button/cost").text = str(i.currExp) + "/" + str(i.needExp)
				menuMagic.get_node("Button/icon").texture = load(i.icon)
			else:
				menuMagic.get_node("Button/name").text = i.name
			get_node("法术页面/技能表/ScrollContainer/GridContainer").add_child(menuMagic)	
	if buttons[buttonIndex].name == "装备":
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()				
		get_node("装备页面").visible = true
		get_node("装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
		Global.onArmorItemPage = true
		armorItemSelectIndex = 0
		onArmorItemSelect = true
		for i in bagArmorItems.size():
			bagArmorItems[i].get_node("itemImage").texture = null
			bagArmorItems[i].get_node("itemImage/item").text = ""
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			bagArmorItems[i].self_modulate = "ffffff"



func _on_体力加点_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 0
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		currPlayer.potential -= Global.enKey 
		pointOnHp += 1
		$"加点页面/属性区/最大气血/最大气血数字".modulate = 	"ff0000"
		$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = true
		$"加点页面/属性区/最大气血/最大气血数字/increaseValue".text = "(+ " + str(pointOnHp * 7) + ")"

	
	
	
func _on_力量加点_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 1
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnStr += 1
		currPlayer.potential -= Global.enKey 
		if pointOnStr >0:
			$"加点页面/属性区/力量/value/changedValue".modulate = "ff0000"
		$"加点页面/属性区/力量/value/changedValue"	
		$"加点页面/属性区/力量/value/changedValue/increaseValue".text = "(+ " + str(pointOnStr * 1) + ")"
		$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = true

func _on_气运加点_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 2
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnLuck += 1
		currPlayer.potential -= Global.enKey
		if pointOnLuck >0:
			$"加点页面/属性区/暴击/value/changedValue".modulate = "ff0000"				
			$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ff0000"	
		$"加点页面/属性区/格挡概率/value/changedValue"
		$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = true
		$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".text = "(+ " + str(pointOnLuck * 0.25) + ")"	
								
		$"加点页面/属性区/暴击/value/changedValue"
		$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = true
		$"加点页面/属性区/暴击/value/changedValue/increaseValue".text = "(+ " + str(pointOnLuck * 0.25) + ")"	

func _on_敏捷加点_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 3
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnSpeed += 1
		currPlayer.potential -= Global.enKey 
		if pointOnSpeed  >0:
			$"加点页面/属性区/敏捷/value/changedValue".modulate = "ff0000"					
		$"加点页面/属性区/敏捷/value/changedValue"	
		$"加点页面/属性区/敏捷/value/changedValue/increaseValue".text = "(+ " + str(pointOnSpeed * 1.0) + ")"
		$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = true

func _on_仙力加点_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 4
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnMagic += 1
		currPlayer.potential -= Global.enKey 
		if pointOnMagic >0:
			$"加点页面/属性区/仙力/value/changedValue".modulate = "ff0000"				
			$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ff0000"
			
		$"加点页面/属性区/仙力/value/changedValue"
		$"加点页面/属性区/仙力/value/changedValue/increaseValue".text = "(+ " + str(pointOnMagic * 1) + ")"
		$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = true
		$"加点页面/属性区/最大仙能/最大仙能数字"
		$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".text = "(+ " + str(pointOnMagic * 7) + ")"
		$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = true
				

func _on_确认按钮_button_down():
	if !Global.noKeyboard:
		return
		
	Global.playsound("res://Audio/SE/007-System07.ogg")
	skillIndex = 5
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if pointOnHp > 0:
		currPlayer.addHp += pointOnHp * 7 * Global.enKey 
		currPlayer.addPhysicDefense += pointOnHp * 1 * Global.enKey 
		$"加点页面/属性区/最大气血/最大气血数字".modulate = "ffffff"
		$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = false
		$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"
		$"加点页面/属性区/格挡概率/value/changedValue/increaseValue"	.visible = false				
	if pointOnStr > 0:	
		currPlayer.addStr += pointOnStr * Global.enKey 
		$"加点页面/属性区/力量/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = false
	if pointOnLuck > 0:	
		currPlayer.addCritChance += pointOnLuck * 0.25 * Global.enKey
		currPlayer.addBlockChance += pointOnLuck * 0.25 * Global.enKey 
		$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false
		$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = false
	if pointOnSpeed > 0 :
		currPlayer.addPlayerSpeed += pointOnSpeed * Global.enKey 
		$"加点页面/属性区/敏捷/value/changedValue".modulate = "ffffff"			
		$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = false
	if pointOnMagic > 0:
		currPlayer.addAbilityPower	+=  pointOnMagic * Global.enKey 
		currPlayer.addMp += pointOnMagic * 7 * Global.enKey 
		$"加点页面/属性区/仙力/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = false	
		$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ffffff"		
		$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = false
					
	pointOnLuck= 0
	pointOnHp= 0
	pointOnSpeed= 0
	pointOnMagic= 0
	pointOnStr = 0

func _on_重置按钮_button_down():
	if !Global.noKeyboard:
		return
	skillIndex = 6
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	$"加点页面/属性区/最大气血/最大气血数字".modulate = "ffffff"
	$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = false
	$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"
	$"加点页面/属性区/格挡概率/value/changedValue/increaseValue"	.visible = false						
	$"加点页面/属性区/力量/value/changedValue".modulate = "ffffff"		
	$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = false		
	$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
	$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false				
	$"加点页面/属性区/敏捷/value/changedValue".modulate = "ffffff"			
	$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = false				
	$"加点页面/属性区/仙力/value/changedValue".modulate = "ffffff"		
	$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = false	
	$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ffffff"		
	$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = false				
	
	
	currPlayer.potential += (pointOnLuck + pointOnHp +pointOnSpeed + pointOnMagic + pointOnStr) * Global.enKey
			
	pointOnLuck= 0
	pointOnHp= 0
	pointOnSpeed= 0
	pointOnMagic= 0
	pointOnStr = 0	


func _on_save_0_button_button_down():
	if !Global.noKeyboard:
		return

	Global.saveIndex = 0
	saveGame()

	get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
	get_parent().get_node("subSound").play()		

	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	if file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id	)
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate		


func _on_save_1_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 1
	saveGame()

	get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
	get_parent().get_node("subSound").play()		

	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	if file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id	)
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate		



func _on_save_2_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 2
	saveGame()

	get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
	get_parent().get_node("subSound").play()		

	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	if file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id	)
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate		



func _on_save_3_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 3
	saveGame()

	get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
	get_parent().get_node("subSound").play()		

	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	if file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id	)
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate		



func _on_load_0_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 0
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	
	if file and file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate
	
		loadGame()
		Global.onLoadPage = false
		$"读取页面".visible = false
		Global.menuOut = false
		$".".visible = false

		
		
		get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
		get_parent().get_node("subSound").play()		


func _on_load_1_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 1
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	
	if file and file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate
	
		loadGame()
		Global.onLoadPage = false
		$"读取页面".visible = false
		Global.menuOut = false
		$".".visible = false

		
		
		get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
		get_parent().get_node("subSound").play()	


func _on_load_2_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 2
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	
	if file and file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate
	
		loadGame()
		Global.onLoadPage = false
		$"读取页面".visible = false
		Global.menuOut = false
		$".".visible = false

		
		
		get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
		get_parent().get_node("subSound").play()	


func _on_load_3_button_button_down():
	if !Global.noKeyboard:
		return
	Global.saveIndex = 3
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)	
	
	if file and file.file_exists(savePath):
		var data = file.get_var()	
		saveSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
		saveSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
		saveSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate
	
		loadGame()
		Global.onLoadPage = false
		$"读取页面".visible = false
		Global.menuOut = false
		$".".visible = false

		
		
		get_parent().get_node("subSound").stream = load("res://Audio/SE/008-System08.ogg")
		get_parent().get_node("subSound").play()	


func _on_weapon_but_button_down():
	if !Global.noKeyboard:
		return

	armorItemSelectIndex = 0
	if armorItemSelectIndex != 0:
		onBagArmorItemSelect = false
	else:
		pass
		
	onBagArmorItemSelect = true	
	onBagArmorItemSelect = true
	BagArmorItemIndex = 0  
	onArmorItemSelect = false
	get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
	get_parent().get_node("subSound").play()	
	canPress = false
	$"../canPress".start()
	weapons = []
	for i in bagArmorItemsData:
		if bagArmorItemsData[i].type == "weapon":
			weapons.append(bagArmorItemsData[i])
	for i in weapons.size():
		bagArmorItems[i].get_node("itemImage").texture = load(weapons[i].info.icon )
		bagArmorItems[i].get_node("itemImage/item").text = weapons[i].info.name
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(weapons[i].number)
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
		
		
func _on_shoes_but_button_down():
	if !Global.noKeyboard:
		return
	armorItemSelectIndex = 0
	if armorItemSelectIndex != 0:
		onBagArmorItemSelect = false
	else:
		pass
	armorItemSelectIndex = 1
	onBagArmorItemSelect = true
	BagArmorItemIndex = 0  
	onArmorItemSelect = false
	get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
	get_parent().get_node("subSound").play()	
	canPress = false
	$"../canPress".start()
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""

func _on_hat_but_button_down():
	if !Global.noKeyboard:
		return
	armorItemSelectIndex = 0
	if armorItemSelectIndex != 2:
		onBagArmorItemSelect = false
	else:
		pass	
	armorItemSelectIndex = 2
	onBagArmorItemSelect = true
	BagArmorItemIndex = 0  
	onArmorItemSelect = false
	get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
	get_parent().get_node("subSound").play()	
	canPress = false
	$"../canPress".start()
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""

func _on_cloth_but_button_down():
	if !Global.noKeyboard:
		return
	armorItemSelectIndex = 3
	if armorItemSelectIndex != 3:
		onBagArmorItemSelect = false
	else:
		pass	
	onBagArmorItemSelect = true
	BagArmorItemIndex = 0  
	onArmorItemSelect = false
	get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
	get_parent().get_node("subSound").play()	
	canPress = false
	$"../canPress".start()
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""

func _on_acc_but_button_down():
	if !Global.noKeyboard:
		return
	armorItemSelectIndex = 4
	armorItemSelectIndex = 4
	if armorItemSelectIndex != 4:
		onBagArmorItemSelect = false
	else:
		pass	
	onBagArmorItemSelect = true
	BagArmorItemIndex = 0  
	onArmorItemSelect = false
	get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
	get_parent().get_node("subSound").play()	
	canPress = false
	$"../canPress".start()
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""


func _on_bag_button_1_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 0
	bagButton()


func _on_bag_button_2_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 1
	bagButton()

func _on_bag_button_3_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 2
	bagButton()

func _on_bag_button_4_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 3
	bagButton()


func _on_bag_button_5_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 4
	bagButton()




func _on_bag_button_6_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 5
	bagButton()




func _on_bag_button_7_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 6
	bagButton()


func _on_bag_button_8_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 7
	bagButton()



func _on_bag_button_9_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 8
	bagButton()



func _on_bag_button_10_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 9
	bagButton()




func _on_bag_button_11_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 10
	bagButton()

func _on_bag_button_12_button_down():
	if !Global.noKeyboard:
		return
	BagArmorItemIndex = 11
	bagButton()

func move_status_to_top():
	self.move_child($status, self.get_child_count() - 3)
func move_menuButton_to_top():
	self.move_child($menuButton, self.get_child_count() - 3)
func move_道具页面_to_top():
	self.move_child($"道具页面", self.get_child_count() - 3)
func move_法术页面_to_top():
	self.move_child($"法术页面", self.get_child_count() - 3)
func move_装备页面_to_top():
	self.move_child($"装备页面", self.get_child_count() - 3)

func move_状态页面_to_top():
	self.move_child($"状态页面", self.get_child_count() - 3)
func move_系统信息_to_top():
	self.move_child($"系统信息", self.get_child_count() - 3)
func move_退出页面_to_top():
	self.move_child($"退出页面", self.get_child_count() - 3)
func move_加点页面_to_top():
	self.move_child($"加点页面", self.get_child_count() - 3)
func move_保存页面_to_top():
	self.move_child($"保存页面", self.get_child_count() - 3)
func move_读取页面_to_top():
	self.move_child($"读取页面", self.get_child_count() - 3)



func _on_常规物品_button_down():
	
	if Global.noKeyboard:
		return
	
#	if FightScenePlayers.consumeItem.size() ==0:
#		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()
	itemTypeIndex = 0
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.consumeItem:
		var itemIns = itemScene.instantiate()
		itemIns.get_node("itemName").text = i
		itemIns.get_node("itemNum").text = str(FightScenePlayers.consumeItem.get(i).number)
		itemIns.texture = load(FightScenePlayers.consumeItem.get(i).info.icon)
		$"道具页面/介绍/Label".text = FightScenePlayers.consumeItem.get(i).info.description
		$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true				
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems =get_tree().get_nodes_in_group("bagMenuItem")

	
func _on_战斗物品_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()	
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 1
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.battleItem:
		var itemIns = itemScene.instantiate()
		itemIns.texture = load(FightScenePlayers.battleItem.get(i).info.icon)
		itemIns.get_node("itemName").text = i
		itemIns.get_node("itemNum").text = str(FightScenePlayers.battleItem.get(i).number)
		$"道具页面/介绍/Label".text = FightScenePlayers.battleItem.get(i).info.description
		$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)		
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true	
			
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_武器_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 2
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.bagArmorItem:
		if FightScenePlayers.bagArmorItem.get(i).type == "weapon":
			var itemIns = itemScene.instantiate()
			itemIns.texture = load(FightScenePlayers.bagArmorItem.get(i).info.icon)
			itemIns.get_node("itemName").text = i
			itemIns.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(i).number)
			$"道具页面/介绍/Label".text = FightScenePlayers.bagArmorItem.get(i).info.description
			$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)	
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true					
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_足护_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()		
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 3
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.bagArmorItem:
		if FightScenePlayers.bagArmorItem.get(i).type == "shoes":
			var itemIns = itemScene.instantiate()
			itemIns.texture = load(FightScenePlayers.bagArmorItem.get(i).info.icon)
			itemIns.get_node("itemName").text = i
			itemIns.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(i).number)
			$"道具页面/介绍/Label".text = FightScenePlayers.bagArmorItem.get(i).info.description
			$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)	
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true		
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_头饰_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 4
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.bagArmorItem:
		if FightScenePlayers.bagArmorItem.get(i).type == "hat":
			var itemIns = itemScene.instantiate()
			itemIns.texture = load(FightScenePlayers.bagArmorItem.get(i).info.icon)
			itemIns.get_node("itemName").text = i
			itemIns.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(i).number)
			$"道具页面/介绍/Label".text = FightScenePlayers.bagArmorItem.get(i).info.description
			$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)	
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true					
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_衣甲_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 5
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.bagArmorItem:
		if FightScenePlayers.bagArmorItem.get(i).type == "cloth":
			var itemIns = itemScene.instantiate()
			itemIns.texture = load(FightScenePlayers.bagArmorItem.get(i).info.icon)
			itemIns.get_node("itemName").text = i
			itemIns.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(i).number)
			$"道具页面/介绍/Label".text = FightScenePlayers.bagArmorItem.get(i).info.description
			$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)	
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true					
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_饰品_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 6
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.bagArmorItem:
		if FightScenePlayers.bagArmorItem.get(i).type == "accessories":
			var itemIns = itemScene.instantiate()
			itemIns.texture = load(FightScenePlayers.bagArmorItem.get(i).info.icon)
			itemIns.get_node("itemName").text = i
			itemIns.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(i).number)
			$"道具页面/介绍/Label".text = FightScenePlayers.bagArmorItem.get(i).info.description
			$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)	
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true					
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
func _on_特殊道具_button_down():
	if Global.noKeyboard:
		return
	canPress = false
	$"../canPress".start()
	itemSelectIndex = 0
	$"道具页面/介绍/Label".text = ""
	for i in $"道具页面/物品/ScrollContainer/VBoxContainer".get_children():
		i.queue_free()	
	itemTypeIndex = 7
	Global.onItemSelect = true
	Global.onItemIndexSelect = false
	var itemScene = load("res://Scene/menuItem.tscn")
	for i in FightScenePlayers.keyItem:
		var itemIns = itemScene.instantiate()
		itemIns.texture = load(FightScenePlayers.keyItem.get(i).info.icon)
		itemIns.get_node("itemName").text = i
		itemIns.get_node("itemNum").text = str(FightScenePlayers.keyItem.get(i).number)
		$"道具页面/介绍/Label".text = FightScenePlayers.keyItem.get(i).info.description
		$"道具页面/物品/ScrollContainer/VBoxContainer".add_child(itemIns)
	if $"道具页面/物品/ScrollContainer/VBoxContainer".get_children().size() == 0:
		Global.onItemSelect = false
		Global.onItemIndexSelect = true				
	$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../subSound".play()
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")


func _on_texture_button_button_down():
	pass # Replace with function body.


func _on_退出游戏按钮_button_down():
	pass # Replace with function body.

func bagButton():
#	if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name == "姜韵" and Global.onGhost:
#		return
	if armorItemSelectIndex == 0:

		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon" and bagArmorItemsData[i].info.user == FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name:
				weapons.append(bagArmorItemsData[i])
		for i in weapons.size():
			bagArmorItems[i].get_node("itemImage").texture = load(weapons[i].info.icon )
			bagArmorItems[i].get_node("itemImage/item").text = weapons[i].info.name
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(weapons[i].number)

			
		if weapons.size() > BagArmorItemIndex and weapons[BagArmorItemIndex]:
			if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon != null:
				if weapons[BagArmorItemIndex].info.value.additionDmg >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg :
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg + weapons[BagArmorItemIndex].info.value.additionDmg)
				elif weapons[BagArmorItemIndex].info.value.additionDmg <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg:
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg  + weapons[BagArmorItemIndex].info.value.additionDmg)

				elif weapons[BagArmorItemIndex].info.value.additionDmg ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg:
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg+ weapons[BagArmorItemIndex].info.value.additionDmg)
			else:
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg + weapons[BagArmorItemIndex].info.value.additionDmg)
			
		
		#把装备换到空背包
		if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
			$"装备页面/装备栏/status/伤害/value/arrow".visible = false
			if armorItemSelectIndex == 0:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon != null:
					if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == "梦澹":
						Global.gai = false					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name):
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name].number += 1
					else:
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name] = {
  						"info": ItemData.weapon.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name),
						"type": "weapon",
						"number": 1,
						"added": false
					}
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = null	
					$"装备页面/装备栏/items/button1/itemType/icon".texture = null
					$"装备页面/装备栏/items/button1/itemType/icon/itemName".text = ""
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()
			#如果选中的背包位子不是空的
		elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "":
			
			if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name != 	FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user:
				return
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
					
					if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "梦澹":
						Global.gai = true
					if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == "梦澹":
						Global.gai = false
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
		
					#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name):
			
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
							return
						else:
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name).number += 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()
					else:

						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name] = {
  						"info": ItemData.weapon.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon.name),
						"type": "weapon",
						"number": 1,
						"added": false
						}
						FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
						FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()						
				else:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
					for i in bagArmorItems.size():
						bagArmorItems[i].get_node("itemImage").texture = null
						bagArmorItems[i].get_node("itemImage/item").text = ""
						bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()
	if armorItemSelectIndex == 1:
		shoes = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "shoes":
				shoes.append(bagArmorItemsData[i])
		for i in shoes.size():
			bagArmorItems[i].get_node("itemImage").texture = load(shoes[i].info.icon )
			bagArmorItems[i].get_node("itemImage/item").text = shoes[i].info.name
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(shoes[i].number)
		if shoes.size() > BagArmorItemIndex and shoes[BagArmorItemIndex]:
			if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes != null:
				if shoes[BagArmorItemIndex].info.value.addPlayerSpeed >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed :
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed))
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed))

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed))
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed))
				

		#把装备换到空背包
		if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
			$"装备页面/装备栏/status/速度/value/arrow".visible = false
			if armorItemSelectIndex == 1:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes != null:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name):
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name].number += 1
					else:
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name] = {
  						"info": ItemData.shoes.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name),
						"type": "shoes",
						"number": 1,
						"added": false
					}
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = null	
					$"装备页面/装备栏/items/button2/itemType/icon".texture = null
					$"装备页面/装备栏/items/button2/itemType/icon/itemName".text = ""
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()							
			#如果选中的背包位子不是空的
		elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "":
	
			if canPress and  armorItemSelectIndex == 1:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button2/itemType/icon/itemName".text != "":
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
					print(11)
					#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name):
			
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
							return
						else:
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name).number += 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()							
					else:

						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name] = {
  						"info": ItemData.shoes.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.name),
						"type": "shoes",
						"number": 1,
						"added": false
						}
						FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
						FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()						
				else:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
					for i in bagArmorItems.size():
						bagArmorItems[i].get_node("itemImage").texture = null
						bagArmorItems[i].get_node("itemImage/item").text = ""
						bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""	
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()												
	if armorItemSelectIndex == 2:
		hats = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "hat" and bagArmorItemsData[i].info.user == FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex:
				hats.append(bagArmorItemsData[i])
		for i in hats.size():
			bagArmorItems[i].get_node("itemImage").texture = load(hats[i].info.icon )
			bagArmorItems[i].get_node("itemImage/item").text = hats[i].info.name
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(hats[i].number)
		if hats.size() > BagArmorItemIndex and hats[BagArmorItemIndex]:
			if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat != null:
				if hats[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense :
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense + hats[BagArmorItemIndex].info.value.addPhysicDefense)
				elif hats[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense  + hats[BagArmorItemIndex].info.value.addPhysicDefense)

				elif hats[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense+ hats[BagArmorItemIndex].info.value.addPhysicDefense)
			else:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + hats[BagArmorItemIndex].info.value.addPhysicDefense)
				
	
		#把装备换到空背包
		if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
			$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
			if  armorItemSelectIndex == 2:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat != null:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name):
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name].number += 1
					else:
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name] = {
  						"info": ItemData.hat.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name),
						"type": "hat",
						"number": 1,
						"added": false
					}
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = null	
					$"装备页面/装备栏/items/button3/itemType/icon".texture = null
					$"装备页面/装备栏/items/button3/itemType/icon/itemName".text = ""
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()							
			#如果选中的背包位子不是空的
		elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "":
			if canPress and  armorItemSelectIndex == 2:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex != 	FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user:
					return				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button3/itemType/icon/itemName".text != "":
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
		
					#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name):
			
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
							return
						else:
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name).number += 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()							
					else:

						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name] = {
  						"info": ItemData.hat.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat.name),
						"type": "hat",
						"number": 1,
						"added": false
						}
						FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
						FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()						
				else:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.hat = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
					for i in bagArmorItems.size():
						bagArmorItems[i].get_node("itemImage").texture = null
						bagArmorItems[i].get_node("itemImage/item").text = ""
						bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""						
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()			
	
	if armorItemSelectIndex == 3:
		cloths = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "cloth" and bagArmorItemsData[i].info.user == FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex or bagArmorItemsData[i].info.user == "all":
				cloths.append(bagArmorItemsData[i])
		for i in cloths.size():
			bagArmorItems[i].get_node("itemImage").texture = load(cloths[i].info.icon )
			bagArmorItems[i].get_node("itemImage/item").text = cloths[i].info.name
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(cloths[i].number)
			
			
			
		if cloths.size() > BagArmorItemIndex and cloths[BagArmorItemIndex]:
			if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth != null:
				if cloths[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense :
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense + cloths[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense + cloths[BagArmorItemIndex].info.value.addMagicDefense)
				
				elif cloths[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense  + cloths[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense  + cloths[BagArmorItemIndex].info.value.addMagicDefense)
				elif cloths[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense+ cloths[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense+ cloths[BagArmorItemIndex].info.value.addMagicDefense)				
			else:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + cloths[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense + cloths[BagArmorItemIndex].info.value.addMagicDefense)						
	
		#把装备换到空背包
		if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
			$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
			$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = false
			if  armorItemSelectIndex == 3:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth != null:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name):
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name].number += 1
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()							
					
					else:
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name] = {
  						"info": ItemData.cloth.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name),
						"type": "cloth",
						"number": 1,
						"added": false
					}
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = null	
					$"装备页面/装备栏/items/button4/itemType/icon".texture = null
					$"装备页面/装备栏/items/button4/itemType/icon/itemName".text = ""
					
			#如果选中的背包位子不是空的
		elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "":
			if canPress and  armorItemSelectIndex == 3:
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].sex != 	FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user and FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user != "all":
					print(123)
					return
				if $"装备页面/装备栏/items/button4/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
		
					#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name):
			
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
							return
						else:
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name).number += 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
							$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
							$"../subSound".play()
					else:
						$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
						$"../subSound".play()
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name] = {
  						"info": ItemData.cloth.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth.name),
						"type": "cloth",
						"number": 1,
						"added": false
						}
						FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
						FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
				
				else:
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.cloth = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
					for i in bagArmorItems.size():
						bagArmorItems[i].get_node("itemImage").texture = null
						bagArmorItems[i].get_node("itemImage/item").text = ""
						bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""	
	if armorItemSelectIndex == 4:
		accessories = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "accessories":
				accessories.append(bagArmorItemsData[i])
		for i in accessories.size():
		
			bagArmorItems[i].get_node("itemImage").texture = load(accessories[i].info.icon )
			bagArmorItems[i].get_node("itemImage/item").text = accessories[i].info.name
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ":     " + str(accessories[i].number)
		if accessories.size() > BagArmorItemIndex and accessories[BagArmorItemIndex]:
			if  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories != null:
				if accessories[BagArmorItemIndex].info.value.addPhysicDefense >  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense :
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(round(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed))							
			
			
			
			
				elif accessories[BagArmorItemIndex].info.value.addPhysicDefense <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)		
				
				
				
				
				elif accessories[BagArmorItemIndex].info.value.addPhysicDefense ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)		
				
			
			
			
			else:
					$"装备页面/装备栏/status/物理防御/value/arrow".visible = true
					$"装备页面/装备栏/status/物理防御/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)						
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
				
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)									
	
	
		#把装备换到空背包
		if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
			$"装备页面/装备栏/status/物理防御/value/arrow".visible = false
			$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = false
			$"装备页面/装备栏/status/伤害/value/arrow".visible = false
			$"装备页面/装备栏/status/速度/value/arrow".visible = false
			
			if  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()						
				if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories != null:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp -= FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addHp
					$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
					$"../subSound".play()				

					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name):
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name].number += 1
					else:
						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name] = {
  						"info": ItemData.accessories.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name),
						"type": "accessories",
						"number": 1,
						"added": false
					}
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = null	
					$"装备页面/装备栏/items/button5/itemType/icon".texture = null
					$"装备页面/装备栏/items/button5/itemType/icon/itemName".text = ""
					
			#如果选中的背包位子不是空的
		elif bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text != "":
			if FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user != "all" and FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].name != 	FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.user :
				return			
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true	
		
					#如果背包里已经有当前身上的装备了，那么检测是否和同一种装备切换，如果是的话就什么都不做，如果不是的话那么背包里和身上装备同名的数量+1，并且被切换的背包里的装备-1
					if FightScenePlayers.bagArmorItem.has(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name):
			
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name == FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.name:
							return
						else:
							FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
							FightScenePlayers.bagArmorItem.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name).number += 1
							FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
							for i in bagArmorItems.size():
								bagArmorItems[i].get_node("itemImage").texture = null
								bagArmorItems[i].get_node("itemImage/item").text = ""
								bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""
					else:

						FightScenePlayers.bagArmorItem[FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name] = {
  						"info": ItemData.accessories.get(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.name),
						"type": "accessories",
						"number": 1,
						"added": false
						}
						FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
						FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info	
				else:
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp += FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp
					
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.added = true
					FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).number -= 1
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories = FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info
					for i in bagArmorItems.size():
						bagArmorItems[i].get_node("itemImage").texture = null
						bagArmorItems[i].get_node("itemImage/item").text = ""
						bagArmorItems[i].get_node("itemImage/item/itemNumber").text = ""	

func decrypt(value):
	return value / Global.enKey
	


func _on_close_button_button_down():
	Global.menuOut = false
	$".".visible = false


func _on_back_button_button_down():
	if Global.menuOut and !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemPage:
		
		if Global.onFight == false:
			characterIndex = 0			
			if Global.onMagicPage == false:
				buttonIndex = 0 
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			Global.menuOut = false
			$".".visible = false

	if Global.onMenuSelectCharacter:
		Global.onMenuSelectCharacter = false
		get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
		characterIndex = 0
		get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		get_parent().get_node("subSound").play()		
		move_menuButton_to_top()	
	if Global.onItemPage:
		if !Global.onItemSelect and !Global.onMenuItemUsing:
			move_menuButton_to_top()
			itemTypeIndex = 0
			$"道具页面".visible = false
			Global.onItemPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
		if Global.onItemSelect:
			for i in bagMenuItems:
				i.queue_free()	
				$"道具页面/介绍/Label".text = ""
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()
			Global.onItemSelect = false			
	if Global.onMagicPage:
		get_node("系统信息").visible = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		get_parent().get_node("subSound").play()	
		Global.onMagicPage = false
		menuMagicIndex = 0
		get_node("法术页面").visible = false
		get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
		move_menuButton_to_top()
		for i in get_tree().get_nodes_in_group("menuMagic"):
			i.get_parent().queue_free()
		characterIndex = 0
	if Global.onArmorItemPage:			
		if  !onBagArmorItemSelect:
			move_menuButton_to_top()
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			Global.onArmorItemPage = false
			get_node("装备页面").visible = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			characterIndex = 0
			onBagArmorItemSelect = false
	if  onBagArmorItemSelect:
		onArmorItemSelect = true
		onBagArmorItemSelect = false
		get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		get_parent().get_node("subSound").play()	
		for arrow in arrows:
			arrow.visible = false
			arrow.modulate = "ffffff"
		for i in bagArmorItems.size():
			bagArmorItems[i].get_node("itemImage").texture = null
			bagArmorItems[i].get_node("itemImage/item").text = ""
			bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			bagArmorItems[i].self_modulate = "ffffff"
	if Global.onStatusPage:
			Global.onMenuSelectCharacter = false
			move_menuButton_to_top()
			$"状态页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			get_node("系统信息").visible = true
			Global.onStatusPage = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))			
			characterIndex = 0	
	if Global.onQuitMenu:
			move_menuButton_to_top()
			$"退出页面".visible = false
			Global.onQuitMenu = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
	if Global.onSkillPointPage:
			move_menuButton_to_top()
			$"加点页面".visible = false
			Global.onSkillPointPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))			
			characterIndex = 0
	if Global.onSavePage:
			move_menuButton_to_top()
			Global.onSavePage = false
			$"保存页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true	
	if Global.onLoadPage:
			move_menuButton_to_top()
			Global.onLoadPage = false
			$"读取页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true		


func _on_down_button_button_down():
	if !Global.noKeyboard:
		return
	if Global.menuOut and !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemPage:	
			if buttonIndex == buttons.size() - 1:
				buttonIndex = 0
				buttons[buttonIndex].grab_focus()
			else:
				buttonIndex += 1
				buttons[buttonIndex].grab_focus()
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	


func _on_up_button_button_down():
	if !Global.noKeyboard:
		return
	if Global.menuOut and !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemPage:
		if buttonIndex == 0:
			buttonIndex = buttons.size() - 1
			buttons[buttonIndex].grab_focus()
		else:
			buttonIndex -= 1
			buttons[buttonIndex].grab_focus()
		get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
		get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_node("subSound").play()	
	if Global.onMenuSelectCharacter:
		var style = get_theme_stylebox("StyleBoxFlat")
		style.bg_color = Color(1, 1, 1, 1)
		if characterIndex == 0:
			characterIndex = Global.onTeamPlayer.size() - 1
		else:
			characterIndex -= 1
		for i in playerStatus.size():
			playerStatus[i].self_modulate = "ffffff"				
		get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
		get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_node("subSound").play()	
	if Global.onItemPage:
		get_node("系统信息").visible = false
		get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_node("subSound").play()
		for i in bagMenuItems:
			i.queue_free()			
		if itemTypeIndex ==0:
			itemTypeIndex = menuItems.size()-1
		else:			
			itemTypeIndex -= 1
		if Global.onItemSelect:			
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
			if itemSelectIndex ==0:
				itemSelectIndex = bagMenuItems.size()-1
			else:			
				itemSelectIndex -= 1
	if Global.onMagicPage:
		get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_node("subSound").play()				
		if menuMagicIndex <= 2:
			return
		else:
			menuMagicIndex -= 3
		get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
	if Global.onArmorItemPage:
		if armorItemSelectIndex == 0:
			armorItemSelectIndex = 4
		else:
			armorItemSelectIndex -= 1
		$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
		$"../subSound".play()		
		if  onBagArmorItemSelect:
			if BagArmorItemIndex <= 2:
				return
			else:
				BagArmorItemIndex  -= 3
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
	if Global.onQuitMenu:			
		if Input.is_action_just_pressed("ui_up") and !Global.noKeyboard:		
			if quitIndex == 0:
				quitIndex = 1
			else:		
				quitIndex -= 1	
			
