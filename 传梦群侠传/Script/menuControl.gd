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
	bagMenuItems = get_tree().get_nodes_in_group("bagMenuItem")
	for i in Global.onTeamPlayer.size():
		playerStatus[i].visible = true

	mapPlayer = get_tree().get_nodes_in_group("mapPlayer")
	if Global.menuOut:
		buttons[buttonIndex].grab_focus()
	get_node("系统信息/银两/goldValue").text = str(FightScenePlayers.golds)
	get_node("系统信息/游戏时间/playTimeValue").text = str(format_time(FightScenePlayers.seconds))	
	menuMagic = get_tree().get_nodes_in_group("menuMagic")
	
	for i in buttons:
		if i.name != buttons[buttonIndex].name:
			i.flat = true
		else:
			i.flat = false	

	
	if Global.menuOut and !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemPage:
		
		if Global.onFight == false and Input.is_action_just_pressed("ui_down"):
			if buttonIndex == buttons.size() - 1:
				buttonIndex = 0
				buttons[buttonIndex].grab_focus()
			else:
				buttonIndex += 1
				buttons[buttonIndex].grab_focus()
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
		if Global.onFight == false and Input.is_action_just_pressed("ui_up"):
			if buttonIndex == 0:
				buttonIndex = buttons.size() - 1
				buttons[buttonIndex].grab_focus()
			else:
				buttonIndex -= 1
				buttons[buttonIndex].grab_focus()
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
		if Global.onFight == false and Input.is_action_just_pressed("esc"):
			characterIndex = 0
#			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#			get_parent().get_node("subSound").play()				
			if Global.onMagicPage == false:
				buttonIndex = 0 
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			
		for i in Global.onTeamPlayer.size():
			var player = get_node("status/Player" + str(i + 1))
			player.get_node("characterIcon").texture = load(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].icon)
			
			player.get_node("expText/expValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].exp)+ "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].needExp)
			
			player.get_node("name").text = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].name
			player.get_node("levelText/levelValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].level)
			
			player.get_node("hpText/hpBar").max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].hp + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addHp
			player.get_node("hpText/hpBar").value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currHp
			player.get_node("hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currHp)+ "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].hp + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].addHp)
			
			player.get_node("mpText/mpBar").max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].mp
			player.get_node("mpText/mpBar").value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currMp
			player.get_node("mpText/mpBar/mpValue").text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].currMp)+ "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[i]].mp)
		
		for i in playerStatus.size():
			for x in playerStatus:
				if playerStatus[i].name != playerStatus[characterIndex].name:
					x.self_modulate = "#ffffff"
	
		if buttons[buttonIndex].name == "道具":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onItemPage == false:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	
				Global.onItemPage = true
				$"道具页面".visible = true
				canPress = false
				$"../canPress".start()
				
		if buttons[buttonIndex].name == "法术":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onMagicPage == false:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	
		if buttons[buttonIndex].name == "装备":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and Global.onArmorItemPage == false:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))		
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "状态":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onStatusPage:
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))	
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "保存冒险":
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onSavePage:
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
			if Global.onFight == false and Input.is_action_just_released("ui_accept") and !Global.onLoadPage and Global.menuOut:
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
			if Global.onFight == false and Input.is_action_just_released("ui_accept"):
				get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))	
				Global.onMenuSelectCharacter = true
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
		if buttons[buttonIndex].name == "返回现实":
			if !Global.onFight and Input.is_action_just_released("ui_accept") and !Global.onQuitMenu:
				Global.onQuitMenu = true
				$"退出页面".visible = true	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()	

	if Global.onMenuSelectCharacter:
		if Input.is_action_just_pressed("ui_down"):
			if characterIndex == Global.onTeamPlayer.size() - 1:
				characterIndex = 0
			else:
				characterIndex += 1
			get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()	
			for i in playerStatus.size():
				playerStatus[i].self_modulate = "ffffff"
						
		if Input.is_action_just_pressed("ui_up"):
			if characterIndex == 0:
				characterIndex = Global.onTeamPlayer.size() - 1
			else:
				characterIndex -= 1
			for i in playerStatus.size():
				playerStatus[i].self_modulate = "ffffff"				
			get_node("menuButton/menuButtonPlayer").play("PlayerFlash" + str(characterIndex + 1))
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress:
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
				

		if Input.is_action_just_pressed("esc"):
			Global.onMenuSelectCharacter = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			characterIndex = 0
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			move_menuButton_to_top()
	if Global.onItemPage:
		get_node("系统信息").visible = false
		if Input.is_action_just_pressed("ui_up") and !Global.onItemSelect and !Global.onMenuItemUsing:
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
			for i in bagMenuItems:
				i.queue_free()			
			if itemTypeIndex ==0:
				itemTypeIndex = menuItems.size()-1
			else:			
				itemTypeIndex -= 1
		if Input.is_action_just_pressed("ui_down") and !Global.onItemSelect and !Global.onMenuItemUsing:
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
			for i in bagMenuItems:
				i.queue_free()
			if itemTypeIndex == menuItems.size()-1:
				itemTypeIndex = 0
			else:			
				itemTypeIndex += 1
		if Input.is_action_just_pressed("esc") and !Global.onItemSelect and !Global.onMenuItemUsing:
			move_menuButton_to_top()
			itemTypeIndex = 0
			$"道具页面".visible = false
			Global.onItemPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()				
		for i in menuItems.size():
			if menuItems[i].name == menuItems[itemTypeIndex].name:
				menuItems[i].modulate = "00ffff"			
			else:
				menuItems[i].modulate =  "ffffff"
		if Input.is_action_just_pressed("ui_accept") and !Global.onItemSelect and !Global.onMenuItemUsing and canPress:	
			print(31333)	 
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
				
				
			if Input.is_action_just_pressed("ui_accept") and !Global.onMenuItemUsing and canPress:
				
				canPress = false
				$"../canPress".start()
				if Global.onMenuItemUsing:
					return 
				Global.itemPlayerIndex = 0
				Global.itemPlayers = []

				if bagMenuItems[itemSelectIndex].get_node("itemName").text in FightScenePlayers.consumeItem:
					Global.onItemSelect = false
					Global.onMenuItemUsing = true
					$"道具页面/角色表".visible = true
				if bagMenuItems[itemSelectIndex].get_node("itemName").text in FightScenePlayers.keyItem:
					if FightScenePlayers.keyItem.get(bagMenuItems[itemSelectIndex].get_node("itemName").text).info.effect != null:
						Global.onItemSelect = false
						Global.onMenuItemUsing = true
						$"道具页面/角色表".visible = true
						print(123)			
				Global.currMenuItem = bagMenuItems[itemSelectIndex].get_node("itemName").text
				
				$"../subSound".stream = load("res://Audio/SE/002-System02.ogg")
				$"../subSound".play()					
			if Input.is_action_just_pressed("ui_up") and !Global.onMenuItemUsing:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()
				if itemSelectIndex ==0:
					itemSelectIndex = bagMenuItems.size()-1
				else:			
					itemSelectIndex -= 1
					
			if Input.is_action_just_pressed("ui_down") and !Global.onMenuItemUsing:
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()
				if itemSelectIndex == bagMenuItems.size()-1:
					itemSelectIndex = 0
				else:			
					itemSelectIndex += 1	
			if Input.is_action_just_pressed("esc"):
				for i in bagMenuItems:
					i.queue_free()	
					$"道具页面/介绍/Label".text = ""
				get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
				get_parent().get_node("subSound").play()
				Global.onItemSelect = false			
			if bagMenuItems.size()>0:				
				for i in bagMenuItems:
					if i == bagMenuItems[itemSelectIndex]:
						i.get_node("itemName").modulate = "00ffff"
					else:
						i.get_node("itemName").modulate = "ffffff"
		if Global.onMenuItemUsing:
			if Input.is_action_just_pressed("ui_accept") and canPress:
				$"道具页面/角色表".useItem()
	
	
	if Global.onMagicPage:
		get_node("系统信息").visible = false
		if menuMagic.size() > 0:
			for i in menuMagic:
				if i != menuMagic[menuMagicIndex]:
					i.get_node("name").modulate = "white"
			menuMagic[menuMagicIndex].get_node("name").modulate = "yellow"
		
			
			if Input.is_action_just_pressed("ui_up"):
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()				
				if menuMagicIndex <= 2:
					return
				else:
					menuMagicIndex -= 3
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
	
			if Input.is_action_just_pressed("ui_down"):
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
			if Input.is_action_just_pressed("ui_left"):
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
				if menuMagicIndex == 0:
					return
				menuMagicIndex -= 1
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
			if Input.is_action_just_pressed("ui_right"):
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
				if menuMagicIndex == menuMagic.size() - 1:
					return
				menuMagicIndex += 1
				get_node("法术页面/技能介绍/description").text = "[" + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerMagic[menuMagicIndex].description + "]"
			if Input.is_action_just_pressed("esc"):
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
		$"装备页面/装备栏/status/伤害/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg)
		$"装备页面/装备栏/status/物理防御/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense)
		$"装备页面/装备栏/status/魔法抗性/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense)
		$"装备页面/装备栏/status/速度/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed)
		if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon:
			print(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item)
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
			if Input.is_action_just_pressed("ui_down"):
				if armorItemSelectIndex == 4:
					armorItemSelectIndex = 0
				else:
					armorItemSelectIndex += 1
				$"../subSound".stream = load("res://Audio/SE/001-System01.ogg")
				$"../subSound".play()			
			if Input.is_action_just_pressed("ui_up"):
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
		
		
				
		if Input.is_action_just_released("esc") and !onBagArmorItemSelect:
			move_menuButton_to_top()
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			Global.onArmorItemPage = false
			get_node("装备页面").visible = false
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))
			characterIndex = 0
			onBagArmorItemSelect = false
	
		if onArmorItemSelect and Input.is_action_just_released("ui_accept") and canPress:
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
					i.self_modulate = "00ffff"
				else:
					i.self_modulate = "ffffff"
			if armorItemSelectIndex == 0:
				weapons = []
				for i in bagArmorItemsData:
					if bagArmorItemsData[i].type == "weapon":
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
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 0:
						if FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.weapon != null:
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
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 0:
						#如果选中的背包位子不是空的，并且武器不是空的
						if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
						elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

						elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
					else:
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
						
			
				#把装备换到空背包
				if bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text == "":
					$"装备页面/装备栏/status/速度/value/arrow".visible = false
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 1:
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
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 1:
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
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 2:
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
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 2:
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
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 3:
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
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 3:
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
							$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
							
							$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
							$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
							
							$"装备页面/装备栏/status/伤害/value/arrow".visible = true
							$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
							
							$"装备页面/装备栏/status/速度/value/arrow".visible = true
							$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
							$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
					
					
					
					
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
					
					if Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 4:
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
					
					if canPress and Input.is_action_just_released("ui_accept") and armorItemSelectIndex == 4:
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
					
					
	
			

			if Input.is_action_just_released("esc"):
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
			if Input.is_action_just_pressed("ui_up"):
				if BagArmorItemIndex <= 2:
					return
				else:
					BagArmorItemIndex  -= 3
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()						
			if Input.is_action_just_pressed("ui_down"):
				if BagArmorItemIndex  > 8:
					return
				else:
					BagArmorItemIndex  += 3	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left"):
				if BagArmorItemIndex  == 0:
					return
				BagArmorItemIndex  -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
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
		$"状态页面/Panel/exp/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].exp)
		$"状态页面/Panel/next/value".text =  str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].needExp - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].exp)
		$"状态页面/Panel/hpText/hpBar".max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].hp + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp
		$"状态页面/Panel/hpText/hpBar".value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currHp
		$"状态页面/Panel/hpText/hpBar/hpValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currHp) + "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].hp +FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addHp)
		$"状态页面/Panel/mpText/mpBar".max_value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].mp
		$"状态页面/Panel/mpText/mpBar".value = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currMp
		$"状态页面/Panel/mpText/mpBar/mpValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].currMp) + "/" + str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].mp)
		$"状态页面/Panel/addDmgLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg) 
		$"状态页面/Panel/physicDefenseLabel/value".text =  str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].physicDefense + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense)
		$"状态页面/Panel/magicDefenseLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].magicDefense + FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense)
		$"状态页面/Panel/strengthLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].str)
		$"状态页面/Panel/critLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].critChance) + "%"
		$"状态页面/Panel/speedLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].playerSpeed)
		$"状态页面/Panel/magicLabel/value".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].abilityPower)
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
		if Input.is_action_just_pressed("esc"):
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
		if Input.is_action_just_pressed("esc"):
			move_menuButton_to_top()
			$"退出页面".visible = false
			Global.onQuitMenu = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()				
			
		if Input.is_action_just_pressed("ui_down"):
			if quitIndex == 1:
				quitIndex = 0
			else:		
				quitIndex += 1
		if Input.is_action_just_pressed("ui_up"):		
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
		if Input.is_action_just_pressed("ui_accept"):
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
		$"加点页面/属性区/最大气血/最大气血数字".text = str(currPlayer.hp + currPlayer.addHp) 
		$"加点页面/属性区/最大仙能/最大仙能数字".text = str(currPlayer.mp +  + currPlayer.addMp)
		
		$"加点页面/属性区/格挡概率/value".text = str(currPlayer.blockChance) + " => "
		$"加点页面/属性区/格挡概率/value/changedValue".text = str(currPlayer.blockChance)
		
		$"加点页面/属性区/力量/value".text = str(currPlayer.str + currPlayer.addStr) + " => "
		$"加点页面/属性区/力量/value/changedValue".text = str(currPlayer.str + currPlayer.addStr) 
		
		$"加点页面/属性区/暴击/value".text = str(currPlayer.critChance + currPlayer.addCritChance) + " => "
		$"加点页面/属性区/暴击/value/changedValue".text = str(currPlayer.critChance + currPlayer.addCritChance)
		
		$"加点页面/属性区/敏捷/value".text = str(currPlayer.playerSpeed + currPlayer.addPlayerSpeed) + " => "
		$"加点页面/属性区/敏捷/value/changedValue".text = str(currPlayer.playerSpeed + currPlayer.addPlayerSpeed)
		
		$"加点页面/属性区/仙力/value".text = str(currPlayer.abilityPower + currPlayer.addAbilityPower) + " => "
		$"加点页面/属性区/仙力/value/changedValue".text = str(currPlayer.abilityPower + currPlayer.addAbilityPower)
		$"加点页面/属性区/角色名".text = currPlayer.name
		$"加点页面/属性区/等级/等级数字".text = str(currPlayer.level)
		$"加点页面/属性区/剩余加点/value".text = str(currPlayer.potential)
		

		for i in skillButtons: 
			if i.name == skillButtons[skillIndex].name:
				i.get_node("加点文本").modulate = "00ffff"
			else:
				i.get_node("加点文本").modulate = "ffffff"
		if Input.is_action_just_pressed("esc"):
			move_menuButton_to_top()
			$"加点页面".visible = false
			Global.onSkillPointPage = false
			get_node("系统信息").visible = true
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()	
			get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str(buttonIndex + 1))			
			characterIndex = 0
		if Input.is_action_just_pressed("ui_down"):
			if skillIndex == 6:
				skillIndex = 0
			else:		
				skillIndex += 1
		if Input.is_action_just_pressed("ui_up"):		
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
			$"加点页面/介绍区/Label".text = "最大敏捷0.6点"
			$"加点页面/介绍区/Label2".text = ""					
		if skillIndex == 4:
			$"加点页面/介绍区/Label".text = "仙力1点"
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
					
		if Input.is_action_just_pressed("ui_accept") and canPress:
			if skillIndex == 0 and currPlayer.potential > 0:
				currPlayer.potential -= 1
				pointOnHp += 1
				$"加点页面/属性区/最大气血/最大气血数字".modulate = 	"ff0000"
				$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = true
				$"加点页面/属性区/最大气血/最大气血数字/increaseValue".text = "(+ " + str(pointOnHp * 7) + ")"
#				if pointOnHp >0:
#					$"加点页面/属性区/物理防御/value/changedValue".modulate = "ff0000"
#				$"加点页面/属性区/物理防御/value/changedValue"
#				$"加点页面/属性区/物理防御/value/changedValue/increaseValue".visible = true
#				$"加点页面/属性区/物理防御/value/changedValue/increaseValue"	.text = "(+ " + str(pointOnHp * 1) + ")"
			elif skillIndex == 1 and currPlayer.potential > 0:
				pointOnStr += 1
				currPlayer.potential -= 1
				if pointOnStr >0:
					$"加点页面/属性区/力量/value/changedValue".modulate = "ff0000"
				$"加点页面/属性区/力量/value/changedValue"	
				$"加点页面/属性区/力量/value/changedValue/increaseValue".text = "(+ " + str(pointOnStr * 1) + ")"
				$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = true
			elif skillIndex == 2 and currPlayer.potential > 0:
				pointOnLuck += 1
				currPlayer.potential -= 1
				if pointOnLuck >0:
					$"加点页面/属性区/暴击/value/changedValue".modulate = "ff0000"				
					$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ff0000"	
				$"加点页面/属性区/格挡概率/value/changedValue"
				$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".text = "(+ " + str(pointOnLuck * 0.25) + ")"	
										
				$"加点页面/属性区/暴击/value/changedValue"
				$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/暴击/value/changedValue/increaseValue".text = "(+ " + str(pointOnLuck * 0.25) + ")"	
			elif skillIndex == 3 and currPlayer.potential > 0:	
				pointOnSpeed += 0.6
				currPlayer.potential -= 1
				if pointOnSpeed  >0:
					$"加点页面/属性区/敏捷/value/changedValue".modulate = "ff0000"					
				$"加点页面/属性区/敏捷/value/changedValue"	
				$"加点页面/属性区/敏捷/value/changedValue/increaseValue".text = "(+ " + str(pointOnSpeed * 0.6) + ")"
				$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = true
			elif skillIndex == 4 and currPlayer.potential > 0:	
				pointOnMagic += 1
				currPlayer.potential -= 1
				if pointOnMagic >0:
					$"加点页面/属性区/仙力/value/changedValue".modulate = "ff0000"				
					$"加点页面/属性区/最大仙能/最大仙能数字".modulate = "ff0000"
					
				$"加点页面/属性区/仙力/value/changedValue"
				$"加点页面/属性区/仙力/value/changedValue/increaseValue".text = "(+ " + str(pointOnMagic * 1) + ")"
				$"加点页面/属性区/仙力/value/changedValue/increaseValue".visible = true
				$"加点页面/属性区/最大仙能/最大仙能数字"
				$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".text = "(+ " + str(pointOnMagic * 7) + ")"
				$"加点页面/属性区/最大仙能/最大仙能数字/increaseValue".visible = true
				
			elif skillIndex == 5:	
				if pointOnHp > 0:
					currPlayer.addHp += pointOnHp * 7
					currPlayer.addPhysicDefense += pointOnHp * 1
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
					currPlayer.blockChance += pointOnLuck * 0.25
					$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false
					$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"		
					$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = false
				if pointOnSpeed > 0 :
					currPlayer.addPlayerSpeed += pointOnSpeed 
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
				
				
				currPlayer.potential += pointOnLuck + pointOnHp +pointOnSpeed + pointOnMagic + pointOnStr
						
				pointOnLuck= 0
				pointOnHp= 0
				pointOnSpeed= 0
				pointOnMagic= 0
				pointOnStr = 0				
	if Global.onSavePage:
		if Input.is_action_just_pressed("esc"):
			move_menuButton_to_top()
			Global.onSavePage = false
			$"保存页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true			
		if Input.is_action_just_pressed("ui_down"):
			if Global.saveIndex == 3:
				Global.saveIndex = 0
			else:
				Global.saveIndex += 1	

			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
		if Input.is_action_just_pressed("ui_up"):	
			if Global.saveIndex == 0:
				Global.saveIndex = 3
			else:
				Global.saveIndex -= 1
	
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress:
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
		if Input.is_action_just_pressed("esc"):
			move_menuButton_to_top()
			Global.onLoadPage = false
			$"读取页面".visible = false
			get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
			get_parent().get_node("subSound").play()		
			get_node("系统信息").visible = true			
		if Input.is_action_just_pressed("ui_down"):
			if Global.saveIndex == 3:
				Global.saveIndex = 0
			else:
				Global.saveIndex += 1	

			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()
		if Input.is_action_just_pressed("ui_up"):	
			if Global.saveIndex == 0:
				Global.saveIndex = 3
			else:
				Global.saveIndex -= 1
	
			get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_node("subSound").play()				
		if Input.is_action_just_pressed("ui_accept") and canPress:
			
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

	FightScenePlayers.datas = data.FightScenePlayers
	FightScenePlayers.loadData()
	
	
	Global.saveData = data.Global
	if mapPlayer:
		mapPlayer[0].queue_free()
	
	Global.loadData()
	Global.load = true
	$"../addChild".start()
	$"..".modulate = "000000"
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
	buttonIndex = 0
	move_道具页面_to_top()
	if !Global.onFight and Global.onItemPage == false:
		canPress = false
		$"../canPress".start()		
		get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_node("subSound").play()	
		Global.onItemPage = true
		$"道具页面".visible = true

func _on_法术_button_down():
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
	if !Global.onMenuSelectCharacter and !Global.onSavePage:
		buttonIndex = 4
		move()
		print(321)
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
	skillIndex = 0
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		currPlayer.potential -= 1
		pointOnHp += 1
		$"加点页面/属性区/最大气血/最大气血数字".modulate = 	"ff0000"
		$"加点页面/属性区/最大气血/最大气血数字/increaseValue".visible = true
		$"加点页面/属性区/最大气血/最大气血数字/increaseValue".text = "(+ " + str(pointOnHp * 7) + ")"

	
	
	
func _on_力量加点_button_down():
	skillIndex = 1
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnStr += 1
		currPlayer.potential -= 1
		if pointOnStr >0:
			$"加点页面/属性区/力量/value/changedValue".modulate = "ff0000"
		$"加点页面/属性区/力量/value/changedValue"	
		$"加点页面/属性区/力量/value/changedValue/increaseValue".text = "(+ " + str(pointOnStr * 1) + ")"
		$"加点页面/属性区/力量/value/changedValue/increaseValue".visible = true

func _on_气运加点_button_down():
	skillIndex = 2
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnLuck += 1
		currPlayer.potential -= 1
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
	skillIndex = 3
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnSpeed += 1
		currPlayer.potential -= 1
		if pointOnSpeed  >0:
			$"加点页面/属性区/敏捷/value/changedValue".modulate = "ff0000"					
		$"加点页面/属性区/敏捷/value/changedValue"	
		$"加点页面/属性区/敏捷/value/changedValue/increaseValue".text = "(+ " + str(pointOnSpeed * 1.0) + ")"
		$"加点页面/属性区/敏捷/value/changedValue/increaseValue".visible = true

func _on_仙力加点_button_down():
	skillIndex = 4
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if currPlayer.potential > 0:
		pointOnMagic += 1
		currPlayer.potential -= 1
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
	skillIndex = 5
	var currPlayer = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]]
	if pointOnHp > 0:
		currPlayer.addHp += pointOnHp * 7
		currPlayer.addPhysicDefense += pointOnHp * 1
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
		currPlayer.blockChance += pointOnLuck * 0.25
		$"加点页面/属性区/暴击/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/暴击/value/changedValue/increaseValue".visible = false
		$"加点页面/属性区/格挡概率/value/changedValue".modulate = "ffffff"		
		$"加点页面/属性区/格挡概率/value/changedValue/increaseValue".visible = false
	if pointOnSpeed > 0 :
		currPlayer.addPlayerSpeed += pointOnSpeed 
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

func _on_重置按钮_button_down():
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
	
	
	currPlayer.potential += pointOnLuck + pointOnHp +pointOnSpeed + pointOnMagic + pointOnStr
			
	pointOnLuck= 0
	pointOnHp= 0
	pointOnSpeed= 0
	pointOnMagic= 0
	pointOnStr = 0	


func _on_save_0_button_button_down():

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
	BagArmorItemIndex = 0
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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
					
					

func _on_bag_button_2_button_down():
	BagArmorItemIndex = 1
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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

func _on_bag_button_3_button_down():
	BagArmorItemIndex = 2
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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

func _on_bag_button_4_button_down():
	BagArmorItemIndex = 3
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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









func _on_bag_button_5_button_down():
	BagArmorItemIndex = 4
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_6_button_down():
	BagArmorItemIndex = 5
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_7_button_down():
	BagArmorItemIndex = 6
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_8_button_down():
	BagArmorItemIndex = 7
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_9_button_down():
	BagArmorItemIndex = 8
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_10_button_down():
	BagArmorItemIndex = 9
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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





func _on_bag_button_11_button_down():
	BagArmorItemIndex = 10
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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


func _on_bag_button_12_button_down():
	BagArmorItemIndex = 11
	if armorItemSelectIndex == 0:
		weapons = []
		for i in bagArmorItemsData:
			if bagArmorItemsData[i].type == "weapon":
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
			if canPress and armorItemSelectIndex == 0:
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button1/itemType/icon/itemName".text != "":
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
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed <  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "red"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed  + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)

				elif shoes[BagArmorItemIndex].info.value.addPlayerSpeed ==  FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "ffffff"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.shoes.value.addPlayerSpeed+ shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
			else:
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed + shoes[BagArmorItemIndex].info.value.addPlayerSpeed)
				
	
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
					$"装备页面/装备栏/status/物理防御/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + accessories[BagArmorItemIndex].info.value.addPhysicDefense)
					
					$"装备页面/装备栏/status/魔法抗性/value/arrow".visible = true
					$"装备页面/装备栏/status/魔法抗性/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/魔法抗性/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + accessories[BagArmorItemIndex].info.value.addMagicDefense)
					
					$"装备页面/装备栏/status/伤害/value/arrow".visible = true
					$"装备页面/装备栏/status/伤害/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/伤害/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + accessories[BagArmorItemIndex].info.value.additionDmg)					
					
					$"装备页面/装备栏/status/速度/value/arrow".visible = true
					$"装备页面/装备栏/status/速度/value/arrow".modulate = "green"
					$"装备页面/装备栏/status/速度/value/arrow/changedValue".text = str(FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + accessories[BagArmorItemIndex].info.value.addPlayerSpeed)							
			
			
			
			
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
			if canPress and  armorItemSelectIndex == 4:
				$"../subSound".stream = load("res://Audio/SE/interface003.ogg")
				$"../subSound".play()				
				#如果选中的背包位子不是空的，并且武器不是空的
				if $"装备页面/装备栏/items/button5/itemType/icon/itemName".text != "":
					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPhysicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPhysicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPhysicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addMagicDefense - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addMagicDefense + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addMagicDefense
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].additionDmg- FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.additionDmg + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.additionDmg
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addPlayerSpeed					
					FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed = FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].addPlayerSpeed - FightScenePlayers.fightScenePlayerData[Global.onTeamPlayer[characterIndex]].item.accessories.value.addPlayerSpeed + FightScenePlayers.bagArmorItem.get(bagArmorItems[BagArmorItemIndex].get_node("itemImage/item").text).info.value.addHp				
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

