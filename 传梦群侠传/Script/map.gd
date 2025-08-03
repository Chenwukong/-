extends Node2D

var FIGHT_SCENE_TRIGGER_PROBABILITY = 700
@export var baseChance = 0
var canEnterFight = false
@export var onFight = false
var monsters
var canFull = true
var httpStatus
var onFull = false
var circleGroup
var custom_cursor_image = preload("res://Icons/001-weapon01.png")
var cursor_frames = []
var current_frame = 0
var frame_rate = 0.1 # Time in seconds for each frame
var cursor_scale = Vector2(0, 0)
var onMap = false
var onShop
var haveUi = true
var npcs
var blackAlready = false
var rooms = ["李善人家1","李善人家2","建邺布店","建邺药店", "时追云家","新手村", "回春堂", "长安酒店", "大唐官府大厅",]
var shopButtonIndex = 0
var shopButtons
var onItemPicking
var onItemPicked

var onSellPicking
var onSaleItemPicked
var itemIndex2 

var playerPosition
var shopItems
var itemIndex = 0
var canPress = true
var addMode = 1
var canAdd = true
var onBuy = false
var onSale = false
var confirmButtonIndex = 0
var http
signal httpNameReady()
var supabase_url := "https://qcrkhgmmvgpkamgadvxy.supabase.co"
var api_key := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjcmtoZ21tdmdwa2FtZ2Fkdnh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5MDMwNjEsImV4cCI6MjA2NDQ3OTA2MX0.pM3AZQkOz2xGvcVcfLJtTmCxn4y-nKrjKTSzhcyj-9E"

@export var shader = load("res://shader/shake.tres")

func update_cursor():
	# Set the current frame as the cursor
	Input.set_custom_mouse_cursor(cursor_frames[int(current_frame)], 0, cursor_scale)
func is_in_same_big_scene(scene_a: String, scene_b: String) -> bool:
	
	for big_scene in Global.sameBigScene:
		var sub_scenes = Global.sameBigScene[big_scene]
		if scene_a in sub_scenes and scene_b in sub_scenes:
			
			return true
	return false


func _ready():
	
	if not has_node("http"):
		var httpRequest = HTTPRequest.new()
		httpRequest.name = "http"
		add_child(httpRequest)
		
	http = $http
	http.request_completed.connect(_on_http_request_completed)
	connect("httpNameReady", Callable($CanvasLayer, "onHttpNameReady"))
	#-------------------------------------------------------------------------shader
	if not has_node("oneTimeSound"):
		var audio_player = AudioStreamPlayer.new()
		audio_player.name = "oneTimeSound"
		add_child(audio_player)
	else:
		print("节点已存在")
	if not has_node("messageLayer"):
		var messageLayer = load("res://Scene/messageLayer.tscn")
		var audio_player = messageLayer.instantiate()
		audio_player.name = "messageLayer"
		add_child(audio_player)
	else:
		print("节点已存在")
	
	var streamer = $AudioStreamPlayer2D
	if not streamer.is_connected("finished", Callable(self, "_on_audio_finished")):
		streamer.connect("finished", Callable(self, "_on_audio_finished"))
		
	$AudioStreamPlayer2D.autoplay = true
	$AudioStreamPlayer2D.play()
	if is_in_same_big_scene(get_tree().current_scene.name, Global.prevScene):
		$AudioStreamPlayer2D.seek(Global.bgmTimer + 0.1)	


	if get_tree().current_scene.name == "长寿村":
		$"CanvasLayer/长寿村过场图".visible = true
		
	#DisplayServer.window_set_title("传梦之路：第一章《浮生难安》")
	
	playerPosition = get_node("player").position
	if Global.onTalk:
		Global.menuOut = false
	if Global.onPhone:
		var phoneButtons = get_tree().get_nodes_in_group("phoneButton")
		for i in phoneButtons:
			i.visible = true
	if Global.npcs["system"].current_dialogue_index > 7:
		if get_tree().current_scene.name == "建邺城右" or get_tree().current_scene.name == "建邺城":
			get_tree().current_scene.get_node("AudioStreamPlayer2D").stream = load("res://Audio/BGM/鬼城.mp3")
			get_tree().current_scene.get_node("AudioStreamPlayer2D").play()
	$enterFightCd.start()
	cursor_frames.append(preload("res://Icons/5-1.png"))
	cursor_frames.append(preload("res://Icons/5-2.png"))
	cursor_frames.append(preload("res://Icons/5-3.png"))
	cursor_frames.append(preload("res://Icons/5-4.png"))
	cursor_frames.append(preload("res://Icons/5-5.png"))
	cursor_frames.append(preload("res://Icons/5-6.png"))
	cursor_frames.append(preload("res://Icons/5-7.png"))
	cursor_frames.append(preload("res://Icons/5-8.png"))
	cursor_frames.append(preload("res://Icons/5-9.png"))
	#cursor_frames.append(preload("res://Icons/5-10.png"))
	#cursor_frames.append(preload("res://Icons/5-11.png"))
	npcs = get_tree().get_nodes_in_group("standNpc")
	shopButtons = get_tree().get_nodes_in_group("shopButton")
	shopItems = get_tree().get_nodes_in_group("shopItem")
	update_cursor()
	set_process(true)
	$".".modulate.r = 0
	$".".modulate.g = 0
	$".".modulate.b = 0
	if Global.npcs.get("姜韵").dialogues[1].trigger == true and get_tree().current_scene.name == "时追云家":
		$nightBgm.stream = load("res://Audio/BGS/SWD5 音效-深夜.mp3")
	if Global.dial : 

		var chapter = get_chapter()
		var npc = Global.npcs[Global.dial]
		var dialogue_index = npc.current_dialogue_index
		var dialogue_entry = npc["dialogues"][dialogue_index]
		
		DialogueManager.show_chat(load("res://Dialogue/"+str(dialogue_entry.chapter)+".dialogue"),get_npc_dialogue(Global.dial))		
		
		#DialogueManager.show_chat(load("res://Dialogue/"+ str(chapter)+ ".dialogue"),get_npc_dialogue(Global.dial))

func _process(delta):


	if Global.onTalk:
		Global.menuOut = false
	
	if has_node("backgroundSoundEffect"):
		if $backgroundSoundEffect.is_playing() == false:
			$backgroundSoundEffect.play()
	if name == "方寸山迷境":
		modulate = "#989898"
	if Global.atDark:
		modulate = "#292929"
		
	if !Global.onFight:
		if has_node("battleBgm"):
			$battleBgm.stop()
#	else:
#		if !Global.onHurry:
#			$AudioStreamPlayer2D.play()
		
		
	if Global.mcVisible == false:
		get_tree().current_scene.get_node("player").visible = false
	if Input.is_action_just_pressed("r") and !Global.onFight and !Global.onTalk and !Global.menuOut:
		if Global.onHurry:
			return
		get_node("player").position = playerPosition
		#get_tree().change_scene_to_file("res://Scene/"+get_tree().current_scene.name+".tscn")
	
	var questItem = get_tree().get_nodes_in_group("questItem")

#$ProgressBar.value +1
	if Global.questItem.get("佛手"):
		if Global.questItem.get("佛手").number >= 4:
			Global.npcs.get("管家").dialogues[1].unlocked = true
			var foShou = get_tree().get_nodes_in_group("questItem")
			for i in foShou:
				if i.itemName == "佛手":
					i.visible = false
				
	shopItems = get_tree().get_nodes_in_group("shopItem")
	if onShop:
		shopButtons[0].focus_mode = Control.FOCUS_ALL
		shopButtons[1].focus_mode = Control.FOCUS_ALL
		if !onBuy and !onSale and !Global.noKeyboard:
			$shop/Panel/buyButton.visible = false
			
		if confirmButtonIndex == 0:
			$shop/Panel/buyButton/cancel.modulate = "red"
			$shop/Panel/buyButton/buy.modulate = "000000"
		else:
			$shop/Panel/buyButton/buy.modulate = "green"
			$shop/Panel/buyButton/cancel.modulate = "000000"		
				
	if onShop and canPress:
		if shopItems.size()>0:
			if itemIndex == null:
				itemIndex = 0
			
			$shop/Panel/description.text = shopItems[itemIndex].description 
		
		get_node("player").canMove = false
		$shop/Panel/shopTop/golds.text = str(decrypt(FightScenePlayers.golds))
		
		if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) and !onItemPicked and !onBuy and !onSaleItemPicked and !onSale:
			onBuy = false
			onSale = false	
			$shop/Panel/buyButton.visible = false			
			$shop/Panel/description.text = ""
			$subSound.stream = load("res://Audio/SE/003-System03.ogg")
			$subSound.play()
			if onItemPicking or onSellPicking:
				onItemPicking = false
				onSellPicking = false
				itemIndex = 0
				itemIndex2 = itemIndex
				for i in shopItems:
					i.queue_free()				
				
			
			else:
				onShop = false
				$shop.visible = false
				get_node("player").canMove = true
				canPress = false
				$canPress.start()
		if !onItemPicking and !onItemPicked and !onBuy and !onSale and !onSaleItemPicked and !onSellPicking:
			
			if Input.is_action_just_pressed("ui_right"):
				if shopButtonIndex == 0:
					shopButtonIndex += 1
				else:
					shopButtonIndex = 0	
			if Input.is_action_just_pressed("ui_left"):
				if shopButtonIndex == 1:
					shopButtonIndex -= 1
				else:
					shopButtonIndex = 1		
			if shopButtonIndex == 0 and !Global.noKeyboard:
				shopButtons[0].grab_focus()
				if Input.is_action_just_pressed("ui_accept") and !onItemPicking and !Global.noKeyboard:
					onItemPicking = true
					canPress = false
					$canPress.start()
					$subSound.stream = load("res://Audio/SE/002-System02.ogg")
					$subSound.play()
					for x in shopItems:
						x.queue_free()	
					for i in Global.currShopItem.size():				
						var instance = load("res://Scene/shopItem.tscn").instantiate()
						instance.name = Global.currShopItem[i]
						instance.get_node("itemName").text = Global.currShopItem[i]
						instance.add_to_group("shopItem")
						for battleConsume in ItemData.battleConsume:
							if Global.currShopItem[i] == battleConsume:
								instance.get_node("golds").text = str(ItemData.battleConsume.get(battleConsume).gold)
								instance.gold = ItemData.battleConsume.get(battleConsume).gold
								instance.texture = load(ItemData.battleConsume.get(battleConsume).picture)
								instance.description = ItemData.battleConsume.get(battleConsume).description
						for consume in ItemData.consume:
							if Global.currShopItem[i] == consume:
								instance.get_node("golds").text = str(ItemData.consume.get(consume).gold)
								instance.gold = ItemData.consume.get(consume).gold
								instance.texture = load(ItemData.consume.get(consume).picture)
								instance.description = ItemData.consume.get(consume).description							
						for weapon in ItemData.weapon:
							if Global.currShopItem[i] == weapon:

								instance.get_node("golds").text = str(ItemData.weapon.get(weapon).gold)
								instance.gold = ItemData.weapon.get(weapon).gold
								instance.texture = load(ItemData.weapon.get(weapon).picture)
								instance.description = ItemData.weapon.get(weapon).description
						for hat in ItemData.hat:
							if Global.currShopItem[i] == hat:
								instance.get_node("golds").text = str(ItemData.hat.get(hat).gold)
								instance.gold = ItemData.hat.get(hat).gold
								instance.texture = load(ItemData.hat.get(hat).picture)	
								instance.description = 	ItemData.hat.get(hat).description	
						for accessories in ItemData.accessories:
							if Global.currShopItem[i] == accessories:
								instance.get_node("golds").text = str(ItemData.accessories.get(accessories).gold	)	
								instance.gold = ItemData.accessories.get(accessories).gold
								instance.texture = load(ItemData.accessories.get(accessories).picture)	
								instance.description = ItemData.accessories.get(accessories).description		
						for cloth in ItemData.cloth:
							if Global.currShopItem[i] == cloth:
								instance.get_node("golds").text = str(ItemData.cloth.get(cloth).gold)	
								instance.gold = ItemData.cloth.get(cloth).gold
								instance.texture = load(ItemData.cloth.get(cloth).picture)	
								instance.description = ItemData.cloth.get(cloth).description						
						for shoes in ItemData.shoes:
							if Global.currShopItem[i] == shoes:
								instance.get_node("golds").text = str(ItemData.shoes.get(shoes).gold)	
								instance.gold = ItemData.shoes.get(shoes).gold
								instance.texture = load(ItemData.shoes.get(shoes).picture)	
								instance.description = ItemData.shoes.get(shoes).description						

						$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
						shopItems = get_tree().get_nodes_in_group("shopItem")
#
			else:
				if !Global.noKeyboard:
					shopButtons[1].grab_focus()
#
				if Input.is_action_just_pressed("ui_accept") and !onSellPicking and !Global.noKeyboard:
#					for x in shopItems:
#						x.queue_free()													
					onSellPicking = true			
					canPress = false
					$canPress.start()
					$subSound.stream = load("res://Audio/SE/002-System02.ogg")
					$subSound.play()
					for i in FightScenePlayers.bagArmorItem:
						if FightScenePlayers.bagArmorItem[i].info.key == false:
							var instance = load("res://Scene/shopItem.tscn").instantiate()
							instance.name = i
							instance.get_node("itemName").text = i
							instance.get_node("itemNum").visible = true
							instance.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem[i].number)
							instance.texture = load(FightScenePlayers.bagArmorItem[i].info.picture)	
							instance.get_node("golds").text = str(FightScenePlayers.bagArmorItem[i].info.gold * 0.7)	
							instance.gold = FightScenePlayers.bagArmorItem[i].info.gold * 0.7
							$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
							shopItems = get_tree().get_nodes_in_group("shopItem")					
								
		if onItemPicking:
			onSale = false
			onBuy = false
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE
				#$shop/Panel/buyButton.visible = false
			if Input.is_action_just_pressed("ui_down") and !onItemPicked:
				if itemIndex == shopItems.size() - 1:
					itemIndex = 0
				else:
					itemIndex += 1		
				shopItems[itemIndex].get_node("Button").grab_focus()	
				$shop/Panel/description.text = shopItems[itemIndex].description
				itemIndex2 = itemIndex
				
			if Input.is_action_just_pressed("ui_up") and !onItemPicked:
				if itemIndex == 0:
					itemIndex = shopItems.size() - 1
				else:
					itemIndex -= 1							
				shopItems[itemIndex].get_node("Button").grab_focus()
				$shop/Panel/description.text = shopItems[itemIndex].description				
				itemIndex2 = itemIndex				
			for i in shopItems:
				if i.name == shopItems[itemIndex].name:
					i.get_node("Label2").modulate = "0000002c"
				else:
					i.get_node("Label2").modulate = "ffffff2c"
			if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
				if decrypt(FightScenePlayers.golds) < shopItems[itemIndex].gold:
					$subSound.stream = load("res://Audio/SE/002-System02.ogg")
					$subSound.play()							
					return 
				shopItems[itemIndex].get_node("Control").visible = true
				onItemPicked = true
				onItemPicking = false

				$canPress.start()
				canPress = false
				$subSound.stream = load("res://Audio/SE/002-System02.ogg")
				$subSound.play()				
				#onItemPicking = false	
				
				
		if onSellPicking and shopItems.size() == 0:
			onSellPicking = false		
		if onSellPicking and shopItems.size()>0  :
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE
			if Input.is_action_just_pressed("ui_down") and !onSaleItemPicked:
				if itemIndex == shopItems.size() - 1:
					itemIndex = 0
				else:
					itemIndex += 1		
				shopItems[itemIndex].get_node("Button").grab_focus()	
				for x in shopItems.size():
					if shopItems[x] == self:
						itemIndex = x
					else:
						shopItems[x].get_node("Control").visible = false	
				itemIndex2 = itemIndex							
			if Input.is_action_just_pressed("ui_up") and !onSaleItemPicked:
				if itemIndex == 0:
					itemIndex = shopItems.size() - 1
				else:
					itemIndex -= 1							
				for x in shopItems.size():
					if shopItems[x] == self:
						itemIndex = x
					else:
						shopItems[x].get_node("Control").visible = false								
				shopItems[itemIndex].get_node("Button").grab_focus()		
				itemIndex2 = itemIndex
												
			for i in shopItems: 
				if i.name == shopItems[itemIndex].name:
					i.get_node("Label2").modulate = "0000002c"
				else:
					i.get_node("Label2").modulate = "ffffff2c"
					
					
			if Input.is_action_just_pressed("ui_accept") and canPress and shopItems.size() > 0 and !Global.noKeyboard:
				
				shopItems[itemIndex].get_node("Control").visible = true
				onSaleItemPicked = true
				onSellPicking = false
				$canPress.start()
				canPress = false				
				$subSound.stream = load("res://Audio/SE/002-System02.ogg")
				$subSound.play()				
				
				
		if onItemPicked and shopButtonIndex == 0 :
			onSale = false
			onBuy = false
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE
			#$shop/Panel/buyButton.visible = false
			if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) :	
				$shop/Panel/buyButton.visible = false	
				onBuy = false
				onSale = false
				onItemPicked = false
				onItemPicking = true
				
				shopItems[itemIndex].get_node("Control").visible = false
				shopItems[itemIndex].buyAmount = 1
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
				$subSound.stream = load("res://Audio/SE/008-System08.ogg")
				$subSound.play()	
			if Input.is_action_pressed("ui_up") and canAdd:
				if (shopItems[itemIndex].buyAmount + 10) * shopItems[itemIndex].gold >  decrypt(FightScenePlayers.golds):
					var canUseGold = decrypt(FightScenePlayers.golds) - shopItems[itemIndex].buyAmount * shopItems[itemIndex].gold
					var canBuyAmount = canUseGold / shopItems[itemIndex].gold
					shopItems[itemIndex].buyAmount += int(floor(canBuyAmount))
			
				else:
					shopItems[itemIndex].buyAmount += 10
					
					
					
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)	
				canAdd = false	
				$addNumTimer.start()
			if Input.is_action_pressed("ui_down") and canAdd:
				if shopItems[itemIndex].buyAmount - 10 < 1:
					shopItems[itemIndex].buyAmount = 1
				else:
					shopItems[itemIndex].buyAmount -= 10		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()				
			if Input.is_action_pressed("ui_right") and canAdd:
				if (shopItems[itemIndex].buyAmount + 1) * shopItems[itemIndex].gold >  decrypt(FightScenePlayers.golds):
					return
				else:
					shopItems[itemIndex].buyAmount += 1		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()						
			if Input.is_action_pressed("ui_left") and canAdd:
				if shopItems[itemIndex].buyAmount - 1 < 1:
					shopItems[itemIndex].buyAmount = 1
				else:
					shopItems[itemIndex].buyAmount -= 1		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()	
			if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
				onBuy = true
				onItemPicked = false
				itemIndex = itemIndex2
				$shop/Panel/buyButton.visible = true
				canPress = false
				$canPress.start()				
				$shop/Panel/buyButton/buy.grab_focus()
				$shop/Panel/buyButton/buy.modulate = "ffffff"
				$shop/Panel/buyButton/cancel.modulate = "000000"				
				confirmButtonIndex = 1
				$subSound.stream = load("res://Audio/SE/002-System02.ogg")
				$subSound.play()			
		if onSaleItemPicked and shopButtonIndex == 1:	
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE			
			if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) :	
				$shop/Panel/buyButton.visible = false	
				onBuy = false
				onSale = false	
				onSaleItemPicked = false
				onSellPicking = true
				if shopItems.size() == 0:
					return
				shopItems[itemIndex].get_node("Control").visible = false
				shopItems[itemIndex].buyAmount = 1
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
			if Input.is_action_pressed("ui_up") and canAdd:
				if shopItems[itemIndex].buyAmount + 10 > FightScenePlayers.bagArmorItem[shopItems[itemIndex].name].number:
					shopItems[itemIndex].buyAmount = FightScenePlayers.bagArmorItem[shopItems[itemIndex].name].number
				else:
					shopItems[itemIndex].buyAmount += 10
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)	
				canAdd = false	
				$addNumTimer.start()
			if Input.is_action_pressed("ui_down") and canAdd:
				if shopItems[itemIndex].buyAmount - 10 < 1:
					shopItems[itemIndex].buyAmount = 1
				else:
					shopItems[itemIndex].buyAmount -= 10		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()				
			if Input.is_action_pressed("ui_right") and canAdd:
				if shopItems[itemIndex].buyAmount + 10 > FightScenePlayers.bagArmorItem[shopItems[itemIndex].name].number:
					shopItems[itemIndex].buyAmount = FightScenePlayers.bagArmorItem[shopItems[itemIndex].name].number
				else:
					shopItems[itemIndex].buyAmount += 1		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()						
			if Input.is_action_pressed("ui_left") and canAdd:
				if shopItems[itemIndex].buyAmount - 1 < 1:
					shopItems[itemIndex].buyAmount = 1
				else:
					shopItems[itemIndex].buyAmount -= 1		
				shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold * shopItems[itemIndex].buyAmount)
				canAdd = false	
				$addNumTimer.start()	
			if Input.is_action_pressed("ui_accept") and canPress and !Global.noKeyboard:
				onSale = true
				onSaleItemPicked = false
				$shop/Panel/buyButton.visible = true
				canPress = false
			
				$canPress.start()				
				$shop/Panel/buyButton/buy.grab_focus()
				$shop/Panel/buyButton/buy.modulate = "ffffff"
				$shop/Panel/buyButton/cancel.modulate = "000000"				
				confirmButtonIndex = 1			
				$subSound.stream = load("res://Audio/SE/002-System02.ogg")
				$subSound.play()							
		if onBuy:
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE
			if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) :
				onBuy = false
				onItemPicked = true
				onItemPicking = false	
				shopItems[itemIndex].get_node("Control").visible = false
				$shop/Panel/buyButton.visible = false 
				canPress = false
				$canPress.start()
			if Input.is_action_just_pressed("ui_right"):
				if confirmButtonIndex == 1:
					confirmButtonIndex = 0
					$shop/Panel/buyButton/cancel.grab_focus()
					$shop/Panel/buyButton/cancel.modulate = "ffffff"
					$shop/Panel/buyButton/buy.modulate = "000000"
				elif confirmButtonIndex == 0:
					confirmButtonIndex = 1
					$shop/Panel/buyButton/buy.grab_focus()
					$shop/Panel/buyButton/buy.modulate = "ffffff"
					$shop/Panel/buyButton/cancel.modulate = "000000"
			if Input.is_action_just_pressed("ui_left"):
				print(333)
				if confirmButtonIndex == 0:
					confirmButtonIndex = 1
					$shop/Panel/buyButton/buy.grab_focus()		
					$shop/Panel/buyButton/buy.modulate = "ffffff"	
					$shop/Panel/buyButton/cancel.modulate = "000000"		
				elif confirmButtonIndex == 1:
					confirmButtonIndex = 0		
					$shop/Panel/buyButton/cancel.grab_focus()	
					$shop/Panel/buyButton/cancel.modulate = "ffffff"
					$shop/Panel/buyButton/buy.modulate = "000000"
				#询问确认购买
			if Input.is_action_pressed("ui_accept") and canPress and !Global.noKeyboard:
				if confirmButtonIndex == 0:
					onBuy = false
					onItemPicked = false
					onItemPicking = true	
					$shop/Panel/buyButton.visible = false 	
				
					shopItems[itemIndex].get_node("Control").visible = false
					$subSound.stream = load("res://Audio/SE/003-System03.ogg")
					$subSound.play()					
				if confirmButtonIndex == 1:	
					$subSound.stream = load("res://Audio/SE/005-System05.ogg")
					$subSound.play()						
					onBuy = false
					onItemPicked = false
					onItemPicking = true		
	
					$shop/Panel/buyButton.visible = false
					FightScenePlayers.golds = (decrypt(FightScenePlayers.golds) -int(shopItems[itemIndex].get_node("golds").text)) * Global.enKey
					shopItems[itemIndex].get_node("Control").visible = false
					shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
					if FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name):
						FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number += shopItems[itemIndex].buyAmount
						
					else:
						for i in ItemData.hat:
							if shopItems[itemIndex].name == i:
								FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
									"info": ItemData.hat.get(shopItems[itemIndex].name),
									"type": "hat",
									"number": shopItems[itemIndex].buyAmount,
									"added": false		
								}
						
						for i in ItemData.weapon:
							if shopItems[itemIndex].name == i:
								FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
									"info": ItemData.weapon.get(shopItems[itemIndex].name),
									"type": "weapon",
									"number": shopItems[itemIndex].buyAmount ,
									"added": false		
								}								
						for i in ItemData.accessories:
							if shopItems[itemIndex].name == i:
								FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
									"info": ItemData.accessories.get(shopItems[itemIndex].name),
									"type": "accessories",
									"number": shopItems[itemIndex].buyAmount ,
									"added": false		
								}											
						for i in ItemData.shoes:
							if shopItems[itemIndex].name == i:
								FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
									"info": ItemData.shoes.get(shopItems[itemIndex].name),
									"type": "shoes",
									"number": shopItems[itemIndex].buyAmount ,
									"added": false		
								}											
						for i in ItemData.cloth:
							if shopItems[itemIndex].name == i:
								FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
									"info": ItemData.cloth.get(shopItems[itemIndex].name),
									"type": "cloth",
									"number": shopItems[itemIndex].buyAmount ,
									"added": false		
								}									
	
	
		if onSale:
			shopButtons[0].focus_mode = Control.FOCUS_NONE
			shopButtons[1].focus_mode = Control.FOCUS_NONE
			if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) :
				onSale = false
				onSaleItemPicked = true	
				shopItems[itemIndex].get_node("Control").visible = false
				$shop/Panel/buyButton.visible = false 
			if Input.is_action_just_pressed("ui_right"):
				if confirmButtonIndex == 1:
					confirmButtonIndex = 0
					$shop/Panel/buyButton/cancel.grab_focus()
					$shop/Panel/buyButton/cancel.modulate = "ffffff"
					$shop/Panel/buyButton/buy.modulate = "000000"
				elif confirmButtonIndex == 0:
					confirmButtonIndex = 1
					$shop/Panel/buyButton/buy.grab_focus()
					$shop/Panel/buyButton/buy.modulate = "ffffff"
					$shop/Panel/buyButton/cancel.modulate = "000000"
			if Input.is_action_just_pressed("ui_left"):
				if confirmButtonIndex == 0:
					confirmButtonIndex = 1
					$shop/Panel/buyButton/buy.grab_focus()		
					$shop/Panel/buyButton/buy.modulate = "ffffff"	
					$shop/Panel/buyButton/cancel.modulate = "000000"		
				elif confirmButtonIndex == 1:
					confirmButtonIndex = 0		
					$shop/Panel/buyButton/cancel.grab_focus()	
					$shop/Panel/buyButton/cancel.modulate = "ffffff"
					$shop/Panel/buyButton/buy.modulate = "000000"
				#询问确认售卖					
			if Input.is_action_just_pressed("ui_accept") and canPress and !Global.noKeyboard:
				if confirmButtonIndex == 1:
					if shopItems.size() == 0:
						return
					
					$subSound.stream = load("res://Audio/SE/006-System06.ogg")
					$subSound.play()	
					onSellPicking = true
					onSale = false		
					canPress = false										
					$canPress.start()
					
					$shop/Panel/buyButton.visible = false
					FightScenePlayers.golds = (decrypt(FightScenePlayers.golds) + int(shopItems[itemIndex].get_node("golds").text) )* Global.enKey
					FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number -= shopItems[itemIndex].buyAmount				
					shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
					shopItems[itemIndex].buyAmount = 1
					if FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number > 0:
						shopItems[itemIndex].get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number)	
						shopItems[itemIndex].get_node("Control").visible = false				
					else:
						if itemIndex > 0:	
							itemIndex -= 1
						else:
							itemIndex = 0
						itemIndex2 = itemIndex
					for i in shopItems:
						if FightScenePlayers.bagArmorItem.get(i.name):
							pass
						else:
							i.queue_free()
							
					shopItems[itemIndex].get_node("Button").grab_focus()
					
					
				else:
					$subSound.stream = load("res://Audio/SE/003-System03.ogg")
					$subSound.play()										
					onSaleItemPicked = true
					onSale = false			
					
					$shop/Panel/buyButton.visible = false
					canPress = false										
					$canPress.start()					
					
	if onShop and shopButtonIndex == 1:
		for i in shopItems:
			if FightScenePlayers.bagArmorItem.get(i.name):
				pass
			else:
				i.queue_free()														
	if $".".modulate.r < 1 and blackAlready == false:
		$".".modulate.r += 0.02
		$".".modulate.g += 0.02
		$".".modulate.b += 0.02
	if $".".modulate.r >= 1:
		blackAlready = true	

	# Update the frame based on the frame rate
	current_frame += delta / frame_rate
	if current_frame >= cursor_frames.size():
		current_frame = 0 # Loop back to the first frame
	update_cursor()	
	
	if get_tree().current_scene.name != "北俱战场":
		var dialogue = get_parent().get_node("DialogueManager")
	if Global.onTalk and !Global.showBlack:
		$CanvasLayer2.visible = false
	
	if Global.onTalk and Global.showBlack:
		$CanvasLayer.visible = false
		$CanvasLayer2.visible = true
		
		
		
	elif Global.haveUi and !Global.onTalk and !Global.menuOut and !Global.onFight and !onShop:
	
		if get_tree().current_scene.name == "仙缘洞天":
			return
		$CanvasLayer.visible = true
		$CanvasLayer2.visible = false
	if Input.is_action_just_pressed("tab") and !onMap:
		if Global.haveUi:
			Global.haveUi = false
			
			get_node("CanvasLayer").visible = false
		else:
			Global.haveUi = true
			if get_tree().current_scene.name == "仙缘洞天":
				return			
			get_node("CanvasLayer").visible = true
	
		
	if Global.menuOut:
		circleGroup = get_tree().get_nodes_in_group("circle")
		if circleGroup:
			for i in circleGroup:
				i.queue_free()
	if onFight == false and Global.menuOut == false and Input.is_action_just_pressed("leftClick") and !Global.onButton and !Global.onUi:
		$circleTimer.stop()
		$circleTimer.start()
		circleGroup = get_tree().get_nodes_in_group("circle")
		if circleGroup:
			for i in circleGroup:
				i.queue_free()
		
		var pos = get_global_mouse_position()
		var sprite = Sprite2D.new()
		sprite.name = "circle"
		sprite.add_to_group("circle")
		sprite.texture = preload("res://梦魂Animation/circle.png")
		sprite.position = pos
		sprite.scale.x = 0.08
		sprite.scale.y = 0.04
		self.add_child(sprite)
		
	if Input.is_action_pressed("ui_accept") and Input.is_action_pressed("alt") and onFull == false and canFull:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		onFull = true
		canFull = false
		$canFullTimer.start()
	elif Input.is_action_pressed("ui_accept") and Input.is_action_pressed("alt") and onFull == true and canFull:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		onFull = false
		canFull = false
		$canFullTimer.start()
	
	if Input.is_action_just_pressed("m"):
		if onMap == false:
			get_node("CanvasLayer/map").visible = true
			get_node("CanvasLayer/position").visible = false
			onMap = true
		else:
			get_node("CanvasLayer/map").visible = false
			get_node("CanvasLayer/position").visible = true
			onMap = false
	
	
	
	if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")) and Global.menuOut == false and !get_node("battleField") and !onShop and canPress and !Global.onTalk and !Global.onFight:
		if !Global.canMenu:
			Global.showMsg("当前无法打开菜单！")
			return
		if Global.onPet:
			$CanvasLayer/宠物列表.visible = false
			$CanvasLayer/msgBox.visible = true
			$CanvasLayer/position.visible = true
			$CanvasLayer/menutButton.visible = true			
			Global.onPet = false
			$player.canMove = true
			return
#		if get_tree().current_scene.name == "新手村":
#			return
#		if Global.currScene in rooms:
#			$CanvasLayer/warn.visible = true
#			$CanvasLayer/warnTimer.start()
#			return	
		Global.onButton = false
		if $shadow:
			$shadow.visible= false
		get_node("CanvasLayer").visible = false
		onMap = false	
		#$player.get_node("Camera2D").zoom = Vector2(1.1, 1.1)
		get_node("CanvasLayer/map").visible = false
		$menuControl/menuAnimationPlayer.play("menuCallOut")
		Global.menuOut = true
		
		$menuControl.visible = true
		
		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
		$subSound.play()
		for player_name in FightScenePlayers.fightScenePlayerData:
			var player = FightScenePlayers.fightScenePlayerData[player_name]
			for i in Global.onTeamPlayer.size():
				var playerStatus = get_parent().get_node("menuControl/status/Player" + str(i + 1))
			

				if player["currHp"] <= 0:
					FightScenePlayers.fightScenePlayerData[player_name].alive = true
					FightScenePlayers.fightScenePlayerData[player_name].currHp = player["hp"]/10
			
	elif (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0"))  and Global.menuOut and !Global.onMenuSelectCharacter  and !Global.onStatusPage and !Global.onMagicPage and !Global.onQuitMenu and !Global.onArmorItemPage  and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage and !Global.onItemSelect and !Global.onItemPage:
		if $shadow:
			$shadow.visible= true
		get_node("CanvasLayer").visible = true
		Global.haveUi = true
		$menuControl/menuAnimationPlayer.play("menuClose")
		Global.menuOut = false
		Global.onButton = false
		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
		$subSound.play()
	
#		if Global.currScene in rooms:
#			$player.get_node("Camera2D").zoom = Vector2(1.7, 1.7)

		
		
		
		
#	elif Input.is_action_just_pressed("rightClick") and Global.menuOut == false and !get_node("battleField"):
#		if $shadow:
#			$shadow.visible= false
#		get_node("CanvasLayer").visible = false
#		$menuAnimationPlayer.play("menuCallOut")
#		Global.menuOut = !Global.menuOut
#		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
#		$subSound.play()
#		for player_name in FightScenePlayers.fightScenePlayerData:
#			var player = FightScenePlayers.fightScenePlayerData[player_name]
#			for i in Global.onTeamPlayer.size():
#				var playerStatus = get_parent().get_node("menuControl/status/Player" + str(i + 1))
#
#				if player["currHp"] <= 0:
#					FightScenePlayers.fightScenePlayerData[player_name].alive = true
#					FightScenePlayers.fightScenePlayerData[player_name].currHp = player["hp"]/10
#
#	elif Input.is_action_just_pressed("rightClick") and Global.menuOut == true and Global.onMenuSelectCharacter == false and Global.onMagicPage == false:
#		if $shadow:
#			$shadow.visible= true
#		get_node("CanvasLayer").visible = true
#		haveUi = true
#		$menuAnimationPlayer.play("menuClose")
#		Global.menuOut = !Global.menuOut
#		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
#		$subSound.play()		
#
	
	monsters = get_tree().get_nodes_in_group("monster")
#	if is_instance_valid(get_node("player")):
#		Global.currPlayerPos = get_node("player/Camera2D").get_screen_center_position()
	
#	if $AudioStreamPlayer2D.is_playing() == false:
#		$AudioStreamPlayer2D.play()
#	if 	$nightBgm.is_playing() == false and Global.atNight:
		#$nightBgm.play()
	if Global.atNight:	
			for light in get_tree().get_nodes_in_group("nightLight"):
				light.energy = 1.1
			
			if Global.currScene != "时追云家":
				if has_node("DirectionalLight2D"):
					$DirectionalLight2D.energy = 4.7

	else:
			if has_node("DirectionalLight2D"):
				$DirectionalLight2D.energy = 0
			for light in get_tree().get_nodes_in_group("nightLight"):
				light.energy = 0				
		
#	if has_node("battleField"):
#		var battleField = get_node("battleField/battleFieldPicture")
#		battleField.global_position = Global.currPlayerPos
		#battleField.scale.x = 1.64
		#battleField.scale.y = 1.64
	if Global.finishingBattle == true:
		Global.finishingBattle = false
		if !Global.canLose:
			$BattleReward/BattleReward/CanvasLayer.visible = true	
			$battleRewardGone.start()
	#$menuControl.global_position = Global.currPlayerPos
	
	if is_instance_valid($player):

#		if $player.velocity == Vector2(0, 0):
#			$enterFightCd.paused = true
#		else:
#			$enterFightCd.paused = false
		if $player.velocity != Vector2(0, 0) and !onFight and !Global.onFight and canEnterFight == true and !Global.menuOut and Global.dangerScene.get(get_tree().current_scene.name) and !Global.onTalk:
			#bossFight("奔霸","res://Audio/SE/SWD 战斗开始.mp3" )

			check_enter_fight_scene()
	Global.onFight = onFight

func check_enter_fight_scene():
	if Global.onTalk:
		return
	var randomNum = randi_range(Global.baseChance,FIGHT_SCENE_TRIGGER_PROBABILITY)
	
	if is_instance_valid($player):
		if randomNum == 1:
			var instance = preload("res://Scene/battleField.tscn").instantiate()	
			
			$shadow.visible = false
			get_node("CanvasLayer").visible = false
			get_node("AudioStreamPlayer2D").stream_paused = true
			$enterFightSound.stream = load("res://Audio/SE/SWD 战斗开始.mp3")
			$enterFightSound.play()		
			instance.set_name('battleField')		
			$battleFieldLayer.add_child(instance)
							
			onFight = true
			canEnterFight = false
			$player.visible = false
			$player.canMove = false
			Global.battleButtonIndex = 0 #重置按钮index
			$player.target = null
			circleGroup = get_tree().get_nodes_in_group("circle")
			if circleGroup:
				for i in circleGroup:
					i.queue_free()		
					
func bossFight(boss, bossBgm,dialogue = null):
	var instance = preload("res://Scene/battleField.tscn").instantiate()
	$shadow.visible = false
	Global.onFight = true
	get_node("CanvasLayer").visible = false
	if !Global.onHurry:
		get_node("AudioStreamPlayer2D").volume_db = -80
	$enterFightSound.stream = load("res://Audio/SE/SWD 战斗开始.mp3")
	$enterFightSound.play()
	instance.set_name('battleField')
	instance.boss = true
	instance.bossName = boss
	instance.bossBgm = bossBgm
	instance.dialogue = dialogue
	$battleFieldLayer.add_child(instance)
	onFight = true
	
	canEnterFight = false
	$player.visible = false
	$player.canMove = false
	Global.battleButtonIndex = 0 #重置按钮index
	$player.target = null
	circleGroup = get_tree().get_nodes_in_group("circle")
	if circleGroup:
		for i in circleGroup:
			i.queue_free()						
func touchFight():
	var instance = preload("res://Scene/battleField.tscn").instantiate()
	$shadow.visible = false

	if !Global.onHurry:
		get_node("AudioStreamPlayer2D").volume_db = -80
	
		
	$enterFightSound.stream = load("res://Audio/SE/SWD 战斗开始.mp3")
	$enterFightSound.play()
	instance.set_name('battleField')
	$battleFieldLayer.add_child(instance)
	onFight = true
	Global.onFight = true
	$CanvasLayer.visible = false
	canEnterFight = false
	$player.visible = false
	$player.canMove = false
	Global.battleButtonIndex = 0 #重置按钮index
	$player.target = null
	circleGroup = get_tree().get_nodes_in_group("circle")
	if circleGroup:
		for i in circleGroup:
			i.queue_free()
			
func _on_enter_fight_cd_timeout():
	canEnterFight = true


func _on_can_full_timer_timeout():
	canFull = true


func _on_battle_reward_gone_timeout():
	$BattleReward/BattleReward/CanvasLayer.visible = false



func _on_circle_timer_timeout():
	circleGroup = get_tree().get_nodes_in_group("circle")
	if circleGroup:
		for i in circleGroup:
			i.queue_free()


func _on_texture_button_mouse_entered():
	get_node("CanvasLayer/position").scale = Vector2(1.2, 1.2)
	$player.canMove = false

func _on_texture_button_mouse_exited():
	get_node("CanvasLayer/position").scale = Vector2(1, 1)
	$player.canMove = true
func _on_texture_button_focus_entered():

	pass
func _on_texture_button_button_down():
	if !onMap:
		get_node("CanvasLayer/map").visible = true
		onMap = true
	else:
		get_node("CanvasLayer/map").visible = false
		onMap = false

		
func _on_texture_button_pressed():
	pass

func _on_audio_stream_player_2d_finished():
	pass



func _on_video_stream_player_finished():
	pass # Replace with function body.


func _on_position_mouse_entered():
	pass # Replace with function body.


func _on_position_mouse_exited():
	pass # Replace with function body.


func _on_chicken_timer_timeout():
	Global.passNight()
	
func popShop():
	if !get_parent().get_node("ExampleBalloon"):
		$shop.visible = true
		onShop = true
		canPress = false
		$canPress.start()
		get_tree().current_scene.get_node("CanvasLayer").visible = false

func _on_button_pressed():
	if onItemPicking:
		return
	for x in shopItems:
		x.queue_free()	
	if !onItemPicking:
		canPress = false
		$canPress.start()
		$subSound.stream = load("res://Audio/SE/002-System02.ogg")
		$subSound.play()
		for i in Global.currShopItem.size():
		
			var instance = load("res://Scene/shopItem.tscn").instantiate()
			instance.name = Global.currShopItem[i]
			instance.get_node("itemName").text = Global.currShopItem[i]
			instance.add_to_group("shopItem")
			for battleConsume in ItemData.battleConsume:
				if Global.currShopItem[i] == battleConsume:
					instance.get_node("golds").text = str(ItemData.battleConsume.get(battleConsume).gold)
					instance.gold = ItemData.battleConsume.get(battleConsume).gold
					instance.texture = load(ItemData.battleConsume.get(battleConsume).picture)
					instance.description = ItemData.battleConsume.get(battleConsume).description
			for consume in ItemData.consume:
				if Global.currShopItem[i] == consume:
					instance.get_node("golds").text = str(ItemData.consume.get(consume).gold)
					instance.gold = ItemData.consume.get(consume).gold
					instance.texture = load(ItemData.consume.get(consume).picture)
					instance.description = ItemData.consume.get(consume).description						
					
			for weapon in ItemData.weapon:
				if Global.currShopItem[i] == weapon:
				
					instance.get_node("golds").text = str(ItemData.weapon.get(weapon).gold)
					instance.gold = ItemData.weapon.get(weapon).gold
					instance.texture = load(ItemData.weapon.get(weapon).picture)
					instance.description = ItemData.weapon.get(weapon).description
			for hat in ItemData.hat:
				if Global.currShopItem[i] == hat:
					instance.get_node("golds").text = str(ItemData.hat.get(hat).gold)
					instance.gold = ItemData.hat.get(hat).gold
					instance.texture = load(ItemData.hat.get(hat).picture)		
					instance.description =  ItemData.hat.get(hat).description
										
			for accessories in ItemData.accessories:
				if Global.currShopItem[i] == accessories:
					instance.get_node("golds").text = str(ItemData.accessories.get(accessories).gold	)	
					instance.gold = ItemData.accessories.get(accessories).gold
					instance.texture = load(ItemData.accessories.get(accessories).picture)	
					instance.description = 	ItemData.accessories.get(accessories).description					
			for cloth in ItemData.cloth:
				if Global.currShopItem[i] == cloth:
					instance.get_node("golds").text = str(ItemData.cloth.get(cloth).gold)	
					instance.gold = ItemData.cloth.get(cloth).gold
					instance.texture = load(ItemData.cloth.get(cloth).picture)		
					instance.description = ItemData.cloth.get(cloth).description						
			for shoes in ItemData.shoes:
				if Global.currShopItem[i] == shoes:
					instance.get_node("golds").text = str(ItemData.shoes.get(shoes).gold)	
					instance.gold = ItemData.shoes.get(shoes).gold
					instance.texture = load(ItemData.shoes.get(shoes).picture)								
					instance.description =  ItemData.shoes.get(shoes).description
			$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
			shopItems = get_tree().get_nodes_in_group("shopItem")	

	shopButtonIndex = 0
	onItemPicking = true
	onSellPicking = false	
	itemIndex = 0
	itemIndex2 = itemIndex
func _on_button_2_pressed():
	itemIndex = 0
	itemIndex2 = itemIndex
	if onSellPicking:
		return
	shopButtonIndex = 1
	shopButtons[1].grab_focus()

		
#	for x in shopItems:

#		x.queue_free()	
#	shopItems = []
#	shopItems = get_tree().get_nodes_in_group("shopItem")
					
	if !onSellPicking:								
		canPress = false
		$canPress.start()
		
		for i in FightScenePlayers.bagArmorItem:
		
			if FightScenePlayers.bagArmorItem[i].info.key == false:
				var instance = load("res://Scene/shopItem.tscn").instantiate()
				instance.name = i
				instance.get_node("itemName").text = i
				instance.get_node("itemNum").visible = true
				instance.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem[i].number)
				instance.texture = load(FightScenePlayers.bagArmorItem[i].info.picture)	
				instance.get_node("golds").text = str(FightScenePlayers.bagArmorItem[i].info.gold * 0.7)	
				instance.gold = FightScenePlayers.bagArmorItem[i].info.gold * 0.7
				$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
				#shopItems = get_tree().get_nodes_in_group("shopItem")				
	onSellPicking = true
	onItemPicking = false	
	itemIndex = 0
	itemIndex2 = itemIndex
func _on_can_press_timeout():
	canPress = true

func _on_add_num_timer_timeout():
	canAdd = true


#func _on_dialogue_timer_timeout():
#
#	var chapter = get_chapter()
#
#	DialogueManager.show_chat(load("res://Dialogue/"+str(chapter)+".dialogue"),get_npc_dialogue(Global.dial))	
	
func get_chapter():
	var npc = Global.npcs[Global.dial]
	var dialogue_index = npc["current_dialogue_index"]		
	var chapter = npc["dialogues"][dialogue_index].chapter
	return chapter
	
	
func get_npc_dialogue(npc_id):
	
	var npc = Global.npcs[npc_id]
	var dialogue_index = npc["current_dialogue_index"]
	
	if npc["dialogues"].size() > dialogue_index:
		
		var dialogue_entry = npc["dialogues"][dialogue_index]

		if dialogue_entry["unlocked"] and dialogue_entry["chapter"] :
			update_npc_dialogue_index(npc_id)
		
			if npc["dialogues"][dialogue_index].bgm != null:
			
				get_tree().current_scene.get_node("AudioStreamPlayer2D").stream = load(npc["dialogues"][dialogue_index].bgm)
				get_tree().current_scene.get_node("AudioStreamPlayer2D").play()
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


func _on_cancel_pressed():
	
	if onBuy or onItemPicked or onItemPicking:
		
		shopItems[itemIndex].get_node("Control").visible = false
		onBuy = false
		onItemPicked = true		
		
		$shop/Panel/buyButton.visible = false 	
	if onSale or onSaleItemPicked or onSellPicking:
		shopItems[itemIndex].get_node("Control").visible = false
		onSale = false
		onSaleItemPicked = true		
		$shop/Panel/buyButton.visible = false 





func _on_warn_timer_timeout():
	$CanvasLayer/warn.visible = false


func _on_menut_button_pressed():
#	if Global.currScene in rooms:
#		$CanvasLayer/warn.visible = true
#		$CanvasLayer/warnTimer.start()
#		return	
		
	if $shadow:
		$shadow.visible= false
	get_node("CanvasLayer").visible = false
	onMap = false	
	$player.get_node("Camera2D").zoom = Vector2(1.1, 1.1)
	get_node("CanvasLayer/map").visible = false
	$menuAnimationPlayer.play("menuCallOut")
	Global.menuOut = true

	$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
	$subSound.play()
	for player_name in FightScenePlayers.fightScenePlayerData:
		var player = FightScenePlayers.fightScenePlayerData[player_name]
		for i in Global.onTeamPlayer.size():
			var playerStatus = get_parent().get_node("menuControl/status/Player" + str(i + 1))
		

			if player["currHp"] <= 0:
				FightScenePlayers.fightScenePlayerData[player_name].alive = true
				FightScenePlayers.fightScenePlayerData[player_name].currHp = player["hp"]/10


func _on_close_button_pressed():
	if !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage:
		if $shadow:
			$shadow.visible= true
		get_node("CanvasLayer").visible = true
		Global.haveUi = true
		$menuAnimationPlayer.play("menuClose")
		Global.menuOut = false

		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
		$subSound.play()


#func _on_back_button_pressed():
#	if Global.onMenuSelectCharacter:
#		Global.onMenuSelectCharacter = false
#		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
#		$menuControl.characterIndex = 0
#		get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		get_node("subSound").play()
#	if Global.onMagicPage:
#		$menuControl.get_node("系统信息").visible = true
#		get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		get_node("subSound").play()	
#		Global.onMagicPage = false
#		$menuControl.menuMagicIndex = 0
#		$menuControl.get_node("法术页面").visible = false
#		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
#
#		for i in get_tree().get_nodes_in_group("menuMagic"):
#			i.get_parent().queue_free()
#			$menuControl.characterIndex = 0
#	if Global.onSavePage:
#		Global.onSavePage = false
#		$menuControl.get_node("保存页面").visible = false
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()		
#		$menuControl.get_node("系统信息").visible = true	
#	if Global.onLoadPage:
#		Global.onLoadPage = false
#		$menuControl.get_node("读取页面").visible = false
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()		
#		$menuControl.get_node("系统信息").visible = true		
#	if Global.onStatusPage:
#		$"menuControl/状态页面".visible = false
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()	
#		$menuControl.get_node("系统信息").visible = true
#		Global.onStatusPage = false
#	if Global.onQuitMenu:
#		$"menuControl/退出页面".visible = false
#		Global.onQuitMenu = false
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()		
#	if Global.onArmorItemPage and !$menuControl.onBagArmorItemSelect:
#		$menuControl.get_node("系统信息").visible = true
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()	
#		Global.onArmorItemPage = false
#		$menuControl.get_node("装备页面").visible = false
#		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
#		$menuControl.characterIndex = 0
#		$menuControl.onBagArmorItemSelect = false
#	if $menuControl.onBagArmorItemSelect:
#		$menuControl.onArmorItemSelect = true
#		$menuControl.onBagArmorItemSelect = false
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()	
#		for arrow in $menuControl.arrows:
#			arrow.visible = false
#			arrow.modulate = "ffffff"
#		for i in $menuControl.bagArmorItems.size():
#			$menuControl.bagArmorItems[i].get_node("itemImage").texture = null
#			$menuControl.bagArmorItems[i].get_node("itemImage/item").text = ""
#			$menuControl.bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
#			$menuControl.bagArmorItems[i].self_modulate = "ffffff"		
#	if Global.onSkillPointPage:
#		$"menuControl/加点页面".visible = false
#		Global.onSkillPointPage = false
#		$menuControl.get_node("系统信息").visible = true
#		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
#		$menuControl.get_parent().get_node("subSound").play()	
#		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))		



func _on_道具_button_down():
	pass # Replace with function body.


func _on_back_button_button_down():
	if Global.onMenuSelectCharacter:
		Global.onMenuSelectCharacter = false
		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
		$menuControl.characterIndex = 0
		get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		get_node("subSound").play()
		$menuControl.move_menuButton_to_top()
	if Global.onMagicPage:
		$menuControl.get_node("系统信息").visible = true
		get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		get_node("subSound").play()	
		Global.onMagicPage = false
		$menuControl.menuMagicIndex = 0
		$menuControl.get_node("法术页面").visible = false
		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
		$menuControl.move_menuButton_to_top()
		for i in get_tree().get_nodes_in_group("menuMagic"):
			i.get_parent().queue_free()
			$menuControl.characterIndex = 0
	if Global.onSavePage:
		$menuControl.move_menuButton_to_top()
		Global.onSavePage = false
		$menuControl.get_node("保存页面").visible = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()		
		$menuControl.get_node("系统信息").visible = true	
	if Global.onLoadPage:
		$menuControl.move_menuButton_to_top()
		Global.onLoadPage = false
		$menuControl.get_node("读取页面").visible = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()		
		$menuControl.get_node("系统信息").visible = true		
	if Global.onStatusPage:
		$menuControl.move_menuButton_to_top()
		$"menuControl/状态页面".visible = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()	
		$menuControl.get_node("系统信息").visible = true
		Global.onStatusPage = false
	if Global.onQuitMenu:
		$menuControl.move_menuButton_to_top()
		$"menuControl/退出页面".visible = false
		Global.onQuitMenu = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()		
	if Global.onArmorItemPage and !$menuControl.onBagArmorItemSelect:
		$menuControl.move_menuButton_to_top()
		$menuControl.get_node("系统信息").visible = true
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()	
		Global.onArmorItemPage = false
		$menuControl.get_node("装备页面").visible = false
		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))
		$menuControl.characterIndex = 0
		$menuControl.onBagArmorItemSelect = false
	if $menuControl.onBagArmorItemSelect:
		$menuControl.onArmorItemSelect = true
		$menuControl.onBagArmorItemSelect = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()	
		for arrow in $menuControl.arrows:
			arrow.visible = false
			arrow.modulate = "ffffff"
		for i in $menuControl.bagArmorItems.size():
			$menuControl.bagArmorItems[i].get_node("itemImage").texture = null
			$menuControl.bagArmorItems[i].get_node("itemImage/item").text = ""
			$menuControl.bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
			$menuControl.bagArmorItems[i].self_modulate = "ffffff"		
	if Global.onSkillPointPage:
		$menuControl.move_menuButton_to_top()
		$"menuControl/加点页面".visible = false
		Global.onSkillPointPage = false
		$menuControl.get_node("系统信息").visible = true
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()	
		$menuControl.get_node("menuButton/menuButtonPlayer").play("menuButtonFlash" + str($menuControl.buttonIndex + 1))		
	if Global.onItemIndexSelect:
		$"menuControl/道具页面".visible = false
		Global.onItemPage = false
		$menuControl.get_node("系统信息").visible = true
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()				
	if Global.onItemPage and !Global.onItemSelect and !Global.onMenuItemUsing:
			$menuControl.move_menuButton_to_top()
			$menuControl.itemTypeIndex = 0
			$"menuControl/道具页面".visible = false
			Global.onItemPage = false
			$"menuControl/系统信息".visible = true
			$subSound.stream = load("res://Audio/SE/003-System03.ogg")
			$subSound.play()
	if Global.onItemSelect and !Global.onMenuItemUsing:
		Global.onItemSelect = false
		Global.onMenuItemUsing = false
		var items = $"menuControl/道具页面/物品/ScrollContainer/VBoxContainer".get_children()
		for i in items:
			i.queue_free()
		
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()
	if Global.onMenuItemUsing :
		Global.onItemSelect = true
		Global.onMenuItemUsing = false
		$"menuControl/道具页面/角色表".visible = false
		$menuControl.get_parent().get_node("subSound").stream = load("res://Audio/SE/003-System03.ogg")
		$menuControl.get_parent().get_node("subSound").play()		
					
func _on_close_button_button_down():
	Global.onButton = false
	if !Global.onMenuSelectCharacter and !Global.onMagicPage  and !Global.onStatusPage and !Global.onArmorItemPage and !Global.onQuitMenu and !Global.onStatusPage and !Global.onSkillPointPage and !Global.onSavePage and !Global.onLoadPage  and !Global.onItemPage and !Global.onItemSelect :
		if $shadow:
			$shadow.visible= true
		get_node("CanvasLayer").visible = true
		Global.haveUi = true
		$menuAnimationPlayer.play("menuClose")
		Global.menuOut = false

		$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
		$subSound.play()



func _on_menut_button_button_down():
	$CanvasLayer/menutButton/Label2.visible = false
#	if Global.currScene in rooms:
#		$CanvasLayer/warn.visible = true
#		$CanvasLayer/warnTimer.start()
#		return	
		
	if $shadow:
		$shadow.visible= false
	get_node("CanvasLayer").visible = false
	onMap = false	
	$player.get_node("Camera2D").zoom = Vector2(1.1, 1.1)
	get_node("CanvasLayer/map").visible = false
	$menuAnimationPlayer.play("menuCallOut")
	Global.menuOut = true

	$subSound.stream = load("res://Audio/SE/046-Book01.ogg")
	$subSound.play()
	for player_name in FightScenePlayers.fightScenePlayerData:
		var player = FightScenePlayers.fightScenePlayerData[player_name]
		for i in Global.onTeamPlayer.size():
			var playerStatus = get_parent().get_node("menuControl/status/Player" + str(i + 1))
			if player["currHp"] <= 0:
				FightScenePlayers.fightScenePlayerData[player_name].alive = true
				FightScenePlayers.fightScenePlayerData[player_name].currHp = player["hp"]/10


func _on_button_button_down():
	onSale = false
	onBuy = false
	print(1233)
	$shop/Panel/buyButton.visible = false
	$shop/Panel/description.text = ""
	if onItemPicking:
		return
	for x in shopItems:
		x.queue_free()	
	onSaleItemPicked = false
	onSale = false
	onSellPicking = false
	if !onItemPicking:
		canPress = false
		$canPress.start()
		$subSound.stream = load("res://Audio/SE/002-System02.ogg")
		$subSound.play()
		for i in Global.currShopItem.size():
		
			var instance = load("res://Scene/shopItem.tscn").instantiate()
			instance.name = Global.currShopItem[i]
			instance.get_node("itemName").text = Global.currShopItem[i]
			instance.add_to_group("shopItem")
			for battleConsume in ItemData.battleConsume:
				if Global.currShopItem[i] == battleConsume:
					instance.get_node("golds").text = str(ItemData.battleConsume.get(battleConsume).gold)
					instance.gold = ItemData.battleConsume.get(battleConsume).gold
					instance.texture = load(ItemData.battleConsume.get(battleConsume).picture)
					instance.description = ItemData.battleConsume.get(battleConsume).description
			for consume in ItemData.consume:
				if Global.currShopItem[i] == consume:
					instance.get_node("golds").text = str(ItemData.consume.get(consume).gold)
					instance.gold = ItemData.consume.get(consume).gold
					instance.texture = load(ItemData.consume.get(consume).picture)
					instance.description = ItemData.consume.get(consume).description						
					
			for weapon in ItemData.weapon:
				if Global.currShopItem[i] == weapon:
				
					instance.get_node("golds").text = str(ItemData.weapon.get(weapon).gold)
					instance.gold = ItemData.weapon.get(weapon).gold
					instance.texture = load(ItemData.weapon.get(weapon).picture)
					instance.description = ItemData.weapon.get(weapon).description
			for hat in ItemData.hat:
				if Global.currShopItem[i] == hat:
					instance.get_node("golds").text = str(ItemData.hat.get(hat).gold)
					instance.gold = ItemData.hat.get(hat).gold
					instance.texture = load(ItemData.hat.get(hat).picture)		
					instance.description =  ItemData.hat.get(hat).description
										
			for accessories in ItemData.accessories:
				if Global.currShopItem[i] == accessories:
					instance.get_node("golds").text = str(ItemData.accessories.get(accessories).gold	)	
					instance.gold = ItemData.accessories.get(accessories).gold
					instance.texture = load(ItemData.accessories.get(accessories).picture)	
					instance.description = 	ItemData.accessories.get(accessories).description					
			for cloth in ItemData.cloth:
				if Global.currShopItem[i] == cloth:
					instance.get_node("golds").text = str(ItemData.cloth.get(cloth).gold)	
					instance.gold = ItemData.cloth.get(cloth).gold
					instance.texture = load(ItemData.cloth.get(cloth).picture)		
					instance.description = ItemData.cloth.get(cloth).description						
			for shoes in ItemData.shoes:
				if Global.currShopItem[i] == shoes:
					instance.get_node("golds").text = str(ItemData.shoes.get(shoes).gold)	
					instance.gold = ItemData.shoes.get(shoes).gold
					instance.texture = load(ItemData.shoes.get(shoes).picture)								
					instance.description =  ItemData.shoes.get(shoes).description
			$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
			shopItems = get_tree().get_nodes_in_group("shopItem")	
	shopButtons[0].grab_focus()
	shopButtonIndex = 0
	onItemPicking = true
	onSellPicking = false	
	itemIndex = 0
	itemIndex2 = itemIndex

func _on_button_2_button_down():
	
	$shop/Panel/buyButton.visible = false
	onSale = false
	onBuy = false
	$shop/Panel/description.text = ""
	itemIndex = 0
	itemIndex2 = itemIndex
	if onSellPicking:
		return
	shopButtonIndex = 1
	
	$subSound.stream = load("res://Audio/SE/002-System02.ogg")
	$subSound.play()
	shopButtons[1].grab_focus()
	onBuy = false
	onItemPicked = false
	onItemPicking = false
#	for x in shopItems:
#		x.queue_free()	
#	shopItems = []
#	shopItems = get_tree().get_nodes_in_group("shopItem")
					
	if !onSellPicking:								
		canPress = false
		$canPress.start()
		
		for i in FightScenePlayers.bagArmorItem:
		
			if FightScenePlayers.bagArmorItem[i].info.key == false:
				var instance = load("res://Scene/shopItem.tscn").instantiate()
				instance.name = i
				instance.get_node("itemName").text = i
				instance.get_node("itemNum").visible = true
				instance.get_node("itemNum").text = str(FightScenePlayers.bagArmorItem[i].number)
				instance.texture = load(FightScenePlayers.bagArmorItem[i].info.picture)	
				instance.get_node("golds").text = str(FightScenePlayers.bagArmorItem[i].info.gold * 0.7)	
				instance.gold = FightScenePlayers.bagArmorItem[i].info.gold * 0.7
				$shop/Panel/itemLeft/ScrollContainer/VBoxContainer.add_child(instance)
				#shopItems = get_tree().get_nodes_in_group("shopItem")				
	onSellPicking = true
	onItemPicking = false	
	itemIndex = 0
	itemIndex2 = itemIndex

func _on_cancel_button_down():
	
	if onBuy or onItemPicked or onItemPicking:
		onBuy = false
		onItemPicked = true		
		shopItems[itemIndex].get_node("Control").visible = false
		$shop/Panel/buyButton.visible = false 	
	if onSale or onSaleItemPicked or onSellPicking:
		shopItems[itemIndex].get_node("Control").visible = false
		onSale = false
		onSaleItemPicked = true		
		$shop/Panel/buyButton.visible = false 
	canPress = false
	$canPress.start()

func _on_buy_button_down():
	if onBuy or onItemPicked or onItemPicking:

		$subSound.stream = load("res://Audio/SE/005-System05.ogg")
		$subSound.play()						
		onBuy = false
		
		$shop/Panel/buyButton.visible = false
		FightScenePlayers.golds =  (decrypt(FightScenePlayers.golds) - int(shopItems[itemIndex].get_node("golds").text)) * Global.enKey
		Global.showMsg("购买到"+ shopItems[itemIndex].name)
		onItemPicked = false
		onItemPicking = true
		canPress = false
		$canPress.start()
		shopItems[itemIndex].get_node("Control").visible = false
		shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
		if FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name):
			FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number += shopItems[itemIndex].buyAmount
			
		else:
			for i in ItemData.hat:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
						"info": ItemData.hat.get(shopItems[itemIndex].name),
						"type": "hat",
						"number": shopItems[itemIndex].buyAmount,
						"added": false		
					}
			
			for i in ItemData.weapon:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
						"info": ItemData.weapon.get(shopItems[itemIndex].name),
						"type": "weapon",
						"number": shopItems[itemIndex].buyAmount ,
						"added": false		
					}								
			for i in ItemData.accessories:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
						"info": ItemData.accessories.get(shopItems[itemIndex].name),
						"type": "accessories",
						"number": shopItems[itemIndex].buyAmount ,
						"added": false		
					}											
			for i in ItemData.shoes:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
						"info": ItemData.shoes.get(shopItems[itemIndex].name),
						"type": "shoes",
						"number": shopItems[itemIndex].buyAmount ,
						"added": false		
					}											
			for i in ItemData.cloth:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.bagArmorItem[shopItems[itemIndex].name] = {
						"info": ItemData.cloth.get(shopItems[itemIndex].name),
						"type": "cloth",
						"number": shopItems[itemIndex].buyAmount ,
						"added": false		
					}
		if FightScenePlayers.consumeItem.get(shopItems[itemIndex].name):
			FightScenePlayers.consumeItem.get(shopItems[itemIndex].name).number += shopItems[itemIndex].buyAmount					
		else:
			for i in ItemData.consume:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.consumeItem[shopItems[itemIndex].name] = {
						"info": ItemData.consume.get(shopItems[itemIndex].name),
						"number": shopItems[itemIndex].buyAmount ,
					}							
		if FightScenePlayers.battleItem.get(shopItems[itemIndex].name):
			FightScenePlayers.battleItem.get(shopItems[itemIndex].name).number += shopItems[itemIndex].buyAmount					
		else:
			for i in ItemData.battleConsume:
				if shopItems[itemIndex].name == i:
					FightScenePlayers.battleItem[shopItems[itemIndex].name] = {
						"info": ItemData.battleConsume.get(shopItems[itemIndex].name),
						"number": shopItems[itemIndex].buyAmount ,
					}			
		shopItems[itemIndex].buyAmount = 1																	
	if onSale or onSaleItemPicked:
		if shopItems.size() == 0:
			return

		$subSound.stream = load("res://Audio/SE/006-System06.ogg")
		$subSound.play()	
		onSellPicking = true
		onSale = false		
		canPress = false										
		$canPress.start()
		$shop/Panel/buyButton.visible = false
		
		FightScenePlayers.golds += int(shopItems[itemIndex].get_node("golds").text) * Global.enKey
		FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number -= shopItems[itemIndex].buyAmount				
		shopItems[itemIndex].get_node("golds").text = str(shopItems[itemIndex].gold)
		shopItems[itemIndex].buyAmount = 1
		if FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number > 0:
			shopItems[itemIndex].get_node("itemNum").text = str(FightScenePlayers.bagArmorItem.get(shopItems[itemIndex].name).number)	
			shopItems[itemIndex].get_node("Control").visible = false				
		else:
			if itemIndex > 0:	
				itemIndex -= 1
			else:
				itemIndex = 0
			itemIndex2 = itemIndex
		for i in shopItems:
			if FightScenePlayers.bagArmorItem.get(i.name):
				pass
			else:
				i.queue_free()
				
		shopItems[itemIndex].get_node("Button").grab_focus()
			


func _on_close_button_down():
	get_tree().current_scene.get_node("CanvasLayer").visible = true
	$shop.visible = false
	onBuy = false
	onSale = false
	onItemPicked = false
	onItemPicking = false
	onSaleItemPicked = false
	onSellPicking = false
	onShop = false
	Global.onButton = false
	get_node("player").canMove = true
	$subSound.stream = load("res://Audio/SE/003-System03.ogg")
	$subSound.play()
	




func _on_右上_pressed():
	pass # Replace with function body.


func _on_右上_button_down():
	pass # Replace with function body.




func _on_cloud_timer_timeout():
	pass # Replace with function body.


func getJinGuBang():
	$"建业左".texture = load("res://panoramas2/龙宫无棒全景.png")
	$AnimationPlayer.play("shake")
	$shadow.texture = load("res://panoramas2/龙宫无棒全景_2.png")


func _on_hash_timer_timeout():
	FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)

func decrypt(value):
	return value/Global.enKey

func healAll():
	FightScenePlayers.fightScenePlayerData.get("时追云").currHp = FightScenePlayers.fightScenePlayerData.get("时追云").hp + decrypt(FightScenePlayers.fightScenePlayerData.get("时追云").addHp)
	FightScenePlayers.fightScenePlayerData.get("时追云").currMp = + FightScenePlayers.fightScenePlayerData.get("时追云").addMp +FightScenePlayers.fightScenePlayerData.get("时追云").mp
		
	FightScenePlayers.fightScenePlayerData.get("小二").currHp = FightScenePlayers.fightScenePlayerData.get("小二").hp + decrypt(FightScenePlayers.fightScenePlayerData.get("小二").addHp)
	FightScenePlayers.fightScenePlayerData.get("小二").currMp = FightScenePlayers.fightScenePlayerData.get("小二").addMp + FightScenePlayers.fightScenePlayerData.get("小二").mp
	
	
	FightScenePlayers.fightScenePlayerData.get("凌若昭").currHp = FightScenePlayers.fightScenePlayerData.get("凌若昭").hp + decrypt(FightScenePlayers.fightScenePlayerData.get("凌若昭").addHp)
	FightScenePlayers.fightScenePlayerData.get("凌若昭").currMp = FightScenePlayers.fightScenePlayerData.get("凌若昭").addMp + FightScenePlayers.fightScenePlayerData.get("凌若昭").mp	
	
	FightScenePlayers.fightScenePlayerData.get("姜韵").currHp = FightScenePlayers.fightScenePlayerData.get("姜韵").hp + decrypt(FightScenePlayers.fightScenePlayerData.get("姜韵").addHp)
	FightScenePlayers.fightScenePlayerData.get("姜韵").currMp = FightScenePlayers.fightScenePlayerData.get("姜韵").addMp + FightScenePlayers.fightScenePlayerData.get("姜韵").mp		
	
	
	
		
func showMsg(value):
	get_tree().current_scene.get_node("CanvasLayer/importantMsg/Panel/ImportantMsg").text = value
	get_node("CanvasLayer/importantMsg").visible = true
func playStep():
	for i in $Node.get_children():
		i.play()

func add_shader():
	$"建业左".material = shader
func remove_shader():
	$"建业左".material = null  # Clears the shader, reverting to default appearance


func _on_area_2d_area_entered(area):

	if area.name == "playerTouch":
		$CharacterBody2D/enterFightTimer.start()


func snowStorm():
	$ColorRect.material.set_shader_parameter("wind_speed", 40)
	$ColorRect.material.set_shader_parameter("snow_speed", 20)
	$ColorRect.material.set_shader_parameter("direction", 1)
	

func _on_timer_2_timeout():
	$"CanvasLayer/长寿村过场图".visible = false


func _on_ghosted_timer_timeout():
	Global.getnode("StaticBody2D/CollisionPolygon2D").disabled = false
	Global.getnode("StaticBody2D/CollisionPolygon2D2").disabled = false
	Global.getnode("player").position = Vector2(476,363)


func _on_黑龙吼_animation_finished():
	Global.getnode("张若嫣").play("右上")
	Global.getnode("黑龙吼").visible = false
	Global.getnode("黑龙王").visible = true


func _on_speed_timer_timeout():
	$player.speed = 300


func _on_魔尊_animation_looped():
	if Global.getnode("魔尊").animation == "攻击右上":
		$soundTimer.start()
		Global.getnode("ColorRect").visible = true
		Global.getnode("AnimationPlayer2").play("冲击波")

func _on_sound_timer_timeout():
	Global.playsound("res://Audio/SE/048-Explosion01.ogg")


func _on_audio_finished():
	$AudioStreamPlayer2D.play()
	Global.bgmTimer = 0


func _on_id_text_submitted(new_text):
	if $CanvasLayer3/id.text.length() > 6:
		$CanvasLayer3/Label.visible = true
		$CanvasLayer3/Label.text = "字太多了！"
		return
	var text = Global.getnode("CanvasLayer3/id").text
	check_if_id_exists(text)


func _on_发送_button_down():
	if $CanvasLayer3/id.text.length() > 6:
		$CanvasLayer3/Label.visible = true
		$CanvasLayer3/Label.text = "字太多了！"
		return
	var text = Global.getnode("CanvasLayer3/id").text
	check_if_id_exists(text)



func send_id(name: String, message: String) -> void:
	httpStatus = "sendId"
	var url = supabase_url + "/rest/v1/shareDream"
	var headers = [
		"Content-Type: application/json",
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key
	]
	var id = ""
	var body = {
		"name": name,
		"message": message,
		"readed": false,
		#"id": id
	}
	var json_body = JSON.stringify(body)

	var err = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		print("请求发送失败，错误码：", err)


func get_all_ids():
	var url = supabase_url + "/rest/v1/shareDream?select=name"
	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]
	var err = http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("❌ 获取 ID 请求发送失败，错误码：", err)
	else:
		print("📡 请求已发送，等待返回")

func check_if_id_exists(player_id: String):
	# 对 player_id 进行 URI 编码
	httpStatus = "checkId"
	var encoded_id = player_id.uri_encode()
	var url = supabase_url + "/rest/v1/shareDream?name=eq." + encoded_id
	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]
	var err = http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("检查 ID 请求发送失败，错误码：", err)
	else:
		print("📡 检查 ID 请求已发送，等待返回")


func _on_发送2_button_down():

	if $CanvasLayer3/message.text.length() > 170:
		$CanvasLayer3/Label.visible = true
		$CanvasLayer3/Label.text = "字太多了！"
		return
	$"CanvasLayer3/发送2".visible = false
	$CanvasLayer3/Label.visible = false
	$CanvasLayer3/message.visible = false
	send_id(Global.getnode("CanvasLayer3/id").text,Global.getnode("CanvasLayer3/message").text)
	DialogueManager.show_chat(load("res://Dialogue/"+str(12)+".dialogue"),get_npc_dialogue("结局"))	


func _on_message_text_submitted(new_text):
	if $CanvasLayer3/message.text.length() > 170:
		$CanvasLayer3/Label.visible = true
		$CanvasLayer3/Label.text = "字太多了！"
		return
	$"CanvasLayer3/发送2".visible = false
	$CanvasLayer3/Label.visible = false
	$CanvasLayer3/message.visible = false
	send_id(Global.getnode("CanvasLayer3/id").text,Global.getnode("CanvasLayer3/message").text)
	DialogueManager.show_chat(load("res://Dialogue/"+str(12)+".dialogue"),get_npc_dialogue("结局"))	



func fetch_first_unread() -> void:
	var url = supabase_url + "/rest/v1/shareDream?readed=eq.false&order=id.asc&limit=1&select=id,name,message"

	httpStatus = "fetchFirstUnread"
	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]

	# 正确使用 HTTPClient.METHOD_GET 整数常量
	var err = http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("❌ 获取未读消息请求失败，错误码：", err)
	else:
		print("📡 获取未读消息请求已发送")
func _on_http_request_completed(result, response_code, headers, body):
	print("返回状态码: ", response_code)
	var response_text = body.get_string_from_utf8()
	print("响应内容: ", response_text)
	
	if response_code == 200:
		if httpStatus == "checkOld":
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data and data.size() > 0:
				var current = data[0]["playerNum"]
				update_player_num(current + 1)
		if httpStatus == "fetchName":
			var json = JSON.parse_string(body.get_string_from_utf8())
			if json:
				Global.names = []
				for entry in json:
					Global.names.append(entry["name"])
				emit_signal("httpNameReady")
			else:
				print("解析失败")
		
		if httpStatus == "checkId":

			if response_text != "[]":
				Global.getnode("CanvasLayer3/Label").visible = true
				Global.getnode("CanvasLayer3/Label").text = "已有此id，请换一个"
			else:
				Global.getnode("CanvasLayer3/id").visible = false
				$"CanvasLayer3/发送".visible = false
				$CanvasLayer3/Label.visible = false
				$CanvasLayer3/message.visible = true
				$"CanvasLayer3/发送2".visible = true
		
		elif httpStatus == "fetchFirstUnread":
			var json = JSON.new()
			var err = json.parse(response_text)
			if err == OK:
				var data = json.get_data()
				if data.size() > 0:
					var record = data[0]

					Global.helperName = record["name"]
					Global.helperMsg = record["message"]
					# 标记为已读，发PATCH请求更新
					var update_url = supabase_url + "/rest/v1/shareDream?id=eq." + str(record["id"])
					var update_headers = [
						"Content-Type: application/json",
						"apikey: " + api_key,
						"Authorization: Bearer " + api_key,
						"Prefer: return=representation"
					]
					var update_body = {"readed": true}
					var jsons = JSON.new()
					var json_body = jsons.stringify(update_body)
										
					httpStatus = "markRead"
					var err2 = http.request(update_url, update_headers, HTTPClient.METHOD_PATCH, json_body)
					if err2 != OK:
						print("标记已读请求失败，错误码：", err2)
				else:
					print("没有未读消息")
			else:
				print("解析失败")
	
	elif response_code == 201:
		if httpStatus == "sendId":
			print("发送信息成功")

	elif response_code == 204:
		if httpStatus == "markRead":
			print("成功标记消息为已读")

	else:
		print("发生错误！状态码:", response_code)

func get_current_player_num():
	httpStatus = "checkOld"
	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]

	var url = supabase_url + "/rest/v1/player_count?select=playerNum&id=eq.1"  # 假设主键是 id=1
	var err = http.request(url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		print("Failed to send GET request")


func update_player_num(new_value: int):
	
	var url = supabase_url + "/rest/v1/player_count?id=eq.1"
	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]

	var body = {
		"playerNum": new_value
	}
	var json_body = JSON.stringify(body)
	var err = http.request(url, headers, HTTPClient.METHOD_PATCH, json_body)

	if err != OK:
		print("更新玩家数量失败")
const CONFIG_PATH := "user://player_data.cfg"

func is_new_player() -> bool:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)

	if err == OK:
		return false  # 有配置文件，不是新玩家
	else:
		# 创建文件标记首次运行
		config.set_value("player", "first_launch", false)
		config.save(CONFIG_PATH)
		return true  # 没有配置文件，是新玩家
func fetch_all_names():
	httpStatus = "fetchName"
	var url = supabase_url + "/rest/v1/shareDream?select=name"

	var headers = [
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key,
		"Accept: application/json"
	]
	var err = http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("获取全部名字失败")


func _on_enter_fight_timer_timeout():
	$CharacterBody2D.position = Vector2(-3281,5605)	
	bossFight("怨蛛","res://Audio/BGM/战斗-生肖2.ogg",null)
