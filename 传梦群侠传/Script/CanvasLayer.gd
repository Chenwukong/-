extends CanvasLayer
var saveSlots
var loadSlots
var hintOut =  false
var armorItemButton
var bagArmorItems
var sceneName
var mapTexture 
var buyAmount = 0
var audio_players = []
var all_nodes 
var firstCheck = false
var values
var toSix = false
var cost = 0
var frames = []
var deltas
var time_since_last_frame_change = 0
var current_frame = 0
var player 
var noMouse = false
func get_all_audio_stream_player2D():
	var audio_players = []
	var all_nodes = get_tree().current_scene.get_children()

	for node in all_nodes:
		if node is AudioStreamPlayer2D:
			audio_players.append(node)

	return audio_players

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	
	
	player = get_tree().current_scene.get_node("player")
	renderMsg()
	all_nodes = get_all_audio_stream_player2D()
	if sceneName == "方寸山迷境":
		$currState.visible = true

	$position/mapName.text = get_tree().current_scene.name
	saveSlots = get_tree().get_nodes_in_group("saveSlot")
	loadSlots = get_tree().get_nodes_in_group("loadSlot")
	armorItemButton = get_tree().get_nodes_in_group("armorItemButton")
	bagArmorItems = get_tree().get_nodes_in_group("bagArmorItem")
	sceneName = get_tree().current_scene.name
	
	if sceneName == "东海湾":
		mapTexture = "res://panoramas2/东海湾全景.jpg"
	elif sceneName == "建邺城":
		mapTexture ="res://Panoramas/建业左.jpg"
	elif sceneName == "建邺城右":
		mapTexture = "res://Panoramas/建业右.jpg"	
	elif sceneName == "江南野外":
		mapTexture  = "res://panoramas2/江南野外.jpg"
	else:
		mapTexture = ""	

	$map.texture = load(mapTexture)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltas = delta
	$"宠物列表/技能名字/Label".text = SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).petMagic.description
	$violencePoint/TextureProgressBar/Label.text = str(Global.violencePoint) + "%"
	$violencePoint/TextureProgressBar.value = Global.violencePoint
	if sceneName == "方寸山迷境":
		$currState.visible = true	
	if !Global.musicOn:
		for i in all_nodes:
			i.volume_db = -80
	else:
		if !toSix:
			toSix = true
			for i in all_nodes:
				i.volume_db = 6
	if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0")):
		$"宠物列表".visible = false
		$"制作人列表".visible = false
		$"其他梦单".visible = false
		$map.visible = false
		get_tree().current_scene.get_node("player").canMove = true

	if Global.onTeamSmallPet.size()>0:	
		$"宠物列表/饱食度/Label".text = str(SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].hungry)
		$"宠物列表/伤害/Label".text = str(SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].str)
		$"宠物列表/怒气/Label".text = str(SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].rage)
		$"宠物列表/灵力/Label".text = str(SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].abilityPower)
		$"宠物列表/Label".text = "X " + str(FightScenePlayers.petFoodBall)
		
		$"宠物列表/饱食度/Label".text = str(SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].hungry)
		$"宠物列表/1bf2bc55/Label".text = "X " + str(FightScenePlayers.petFood)
	
	if Global.onPhone:
		$phoneButtons.visible = true
		$"../player".get_node("RayCast2D").enabled = false
		$"../player".get_node("RayCast2D2").enabled = false
	else:
		$"../player".get_node("RayCast2D").enabled = true
		$"../player".get_node("RayCast2D2").enabled = false
		$phoneButtons.visible = false	
	$questHint/Label2.text = Global.questHint
	if Global.systemMsg.size() > 4:
		Global.systemMsg.pop_front()
		var msgs = get_tree().get_nodes_in_group("msgText")
		for i in msgs:
			i.queue_free()
		renderMsg()	

func renderMsg():
	var msgs = get_tree().get_nodes_in_group("msgText")
	for i in msgs:
		i.queue_free()	
	for msg in Global.systemMsg:
		var msgText = Label.new()
		msgText.text = msg
		msgText.add_to_group("msgText")
		msgText.add_theme_font_size_override("font_size", 16)
		msgText.size = Vector2(1, 4)
		get_node("VBoxContainer").add_child(msgText)	



func _on_hint_button_mouse_entered():
	$hintButton.play("mouseEnter")
	$hintButton/Label.visible = true
	Global.onButton = true
func _on_hint_button_mouse_exited():
	$hintButton.play("default")
	$hintButton/Label.visible = false
	Global.onButton = false

func _on_hint_button_button_down():
	$hintButton.play("click")
	if !hintOut:
		hintOut = true
		$questHint.visible = true
	else:
		hintOut = false
		$questHint.visible = false
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()		
func _on_hint_button_button_up():
	$hintButton.play("default")




func _on_warn_timer_timeout():
	pass # Replace with function body.







func _on_button_mouse_entered():
	$"宠物".play("mouseEnter")
	$"宠物/Label".visible = true
	Global.onButton = true

func _on_button_mouse_exited():
	$"宠物".play("default")
	$"宠物/Label".visible = false
	Global.onButton = false


	
	
func _on_button_button_up():
	$"宠物".play("default")




func _on_close_button_button_down():
	
	Global.onPet = false
	$宠物列表.visible = false
	$msgBox.visible = true
	$position.visible = true
	$menutButton.visible = true			
	get_tree().current_scene.get_node("player").canMove = true
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()

func _on_伤害button_button_down():
	if FightScenePlayers.petFoodBall == 0:
		return
	FightScenePlayers.petFoodBall -= 1
	SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].str += 7
	

func _on_怒气button_button_down():
	if FightScenePlayers.petFoodBall == 0:
		return
	FightScenePlayers.petFoodBall -= 1
	SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].rage += 0.5
	

func _on_灵力button_button_down():
	if FightScenePlayers.petFoodBall == 0:
		return
	FightScenePlayers.petFoodBall -= 1
	SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].abilityPower += 7
	



func _on_author_button_mouse_entered():
	$"制作人/Label".visible = true
	$"制作人".play("mouseEnter")
	Global.onMouse = false

func _on_author_button_mouse_exited():
	$"制作人".play("default")	
	$"制作人/Label".visible = false
	Global.onMouse = true

func _on_author_button_button_down():
	$"制作人".play("click")
	if $"制作人列表".visible:
		$"制作人列表".visible = false
		get_tree().current_scene.get_node("player").canMove = true
	else:
		get_tree().current_scene.get_node("player").canMove = false
		$"制作人列表".visible = true
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	
	
func _on_author_button_button_up():
	$"制作人".play("default")	


func _on_texture_button_button_down():
	get_tree().current_scene.get_node("player").canMove = true
	$"制作人列表".visible = false




func _on_friend_button_button_down():
	$"好友".play("click")
	if $"其他梦单".visible:
		get_tree().current_scene.get_node("player").canMove = true
		$"其他梦单".visible = false
	else:
		$"其他梦单".visible = true
		get_tree().current_scene.get_node("player").canMove = false
	
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	
		
func _on_friend_button_button_up():
	$"好友".play("default")

func _on_friend_button_mouse_entered():
	$"好友/Label".visible = true
	$"好友".play("mouseEnter")

	if Global.noMouse:
		noMouse = true
		Global.noMouse = false
func _on_friend_button_mouse_exited():
	$"好友/Label".visible = false
	$"好友".play("default")
	if noMouse:
		Global.noMouse = true

func _on_梦单close_button_button_down():
	$"其他梦单".visible = false
	get_tree().current_scene.get_node("player").canMove = true


func _on_music_button_button_down():
	$"音乐".play("click")
	if Global.musicOn:
		Global.musicOn = false
		$"音乐".play("muted")
	else:
		toSix = false
		$"音乐".play("default")
		Global.musicOn = true


#func _on_music_button_button_up():
#	$"音乐"

func _on_music_button_mouse_entered():
	$"音乐/音乐".visible = true
	$"音乐".play("moustEnter")
	
func _on_music_button_mouse_exited():
	$"音乐/音乐".visible = false
	if Global.musicOn:
		$"音乐".play("default")
	else:
		$"音乐".play("muted")


func _on_system_button_button_down():
		$system.play("click")
		$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
		$AudioStreamPlayer2D.play()	
		Global.onButton = false
		if $shadow:
			$shadow.visible= false
		$".".visible = false
		get_tree().current_scene.onMap = false	
		#$player.get_node("Camera2D").zoom = Vector2(1.1, 1.1)
		$map.visible = false
		get_tree().current_scene.get_node("menuControl/menuAnimationPlayer").play("menuCallOut")
		Global.menuOut = true
		
		get_tree().current_scene.get_node("menuControl").visible = true

func _on_system_button_button_up():
	$system.play("default")

func _on_menut_button_button_down():
	
	$".".visible = false
	get_tree().current_scene.get_node("menuControl/menuAnimationPlayer").play("menuCallOut")
	Global.saveIndex = 0
	Global.menuOut = true
	get_tree().current_scene.get_node("menuControl/menuControl/保存页面").visible = true	
	get_tree().current_scene.get_node("menuControl").visible = true
	Global.onSavePage = true
	for i in saveSlots.size():
		var savePath = "user://saveFile"+str(i)
		
		var file = FileAccess.open(savePath, FileAccess.READ)

		if file and file.file_exists(savePath):
			var data = file.get_var()	
			saveSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
			saveSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)	
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	





func format_times(seconds):
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var second = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, second]


func _on_load_button_button_down():
	$".".visible = false
	get_tree().current_scene.get_node("menuControl/menuAnimationPlayer").play("menuCallOut")
	Global.saveIndex = 0
	Global.menuOut = true
	Global.onLoadPage = true
	get_tree().current_scene.get_node("menuControl/menuControl/读取页面").visible = true	
	get_tree().current_scene.get_node("menuControl").visible = true
	for i in loadSlots.size():
		
		var savePath = "user://saveFile"+str(i)
		var file = FileAccess.open(savePath, FileAccess.READ)
		
		if file and file.file_exists(savePath):
			var data = file.get_var()	
			loadSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
			loadSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	

	
	
	


func _on_weapon_button_button_down():
	$".".visible = false
	var characterIndex = 0
	get_tree().current_scene.get_node("menuControl/menuAnimationPlayer").play("menuCallOut")
	Global.onArmorItemPage = true
	Global.menuOut = true
	get_tree().current_scene.get_node("menuControl/menuControl/装备页面").visible = true	
	get_tree().current_scene.get_node("menuControl").visible = true	
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	
	get_tree().current_scene.get_node("menuControl/menuControl/装备页面/装备栏/status/name/").text = Global.onTeamPlayer[characterIndex]
	Global.onArmorItemPage = true
	get_tree().current_scene.get_node("menuControl/menuControl").armorItemSelectIndex = 0
	get_tree().current_scene.get_node("menuControl/menuControl").onArmorItemSelect = true
	for i in bagArmorItems.size():
		bagArmorItems[i].get_node("itemImage").texture = null
		bagArmorItems[i].get_node("itemImage/item").text = ""
		bagArmorItems[i].get_node("itemImage/item/itemNumber").text =  ""
		bagArmorItems[i].self_modulate = "ffffff"	
	
	


func _on_load_button_mouse_entered():
	$loadButton/Label.visible = true


func _on_load_button_mouse_exited():
	$loadButton/Label.visible = false


func _on_weapon_button_mouse_entered():
	$weaponButton.play("mouseEnter")
	$weaponButton/Label.visible = true


func _on_weapon_button_mouse_exited():
	$weaponButton.play("default")
	$weaponButton/Label.visible = false





func _on_item_button_button_down():
	$".".visible = false
	get_tree().current_scene.get_node("menuControl/menuAnimationPlayer").play("menuCallOut")
	get_tree().current_scene.get_node("menuControl/menuControl").buttonIndex = 0
	get_tree().current_scene.get_node("menuControl/menuControl").move_道具页面_to_top()
	Global.menuOut = true
	Global.onItemPage = true
	get_tree().current_scene.get_node("menuControl/menuControl/道具页面").visible = true
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()		

func _on_item_button_mouse_entered():
	$"物品/Label".visible = true


func _on_item_button_mouse_exited():
	$"物品/Label".visible = false




func _on_map_button_mouse_entered():
	$"地图/Label".visible = true


func _on_map_button_mouse_exited():
	$"地图/Label".visible = false
	


func _on_map_button_button_down():
	
	
	
	if !$map.visible:
		var mapName = get_tree().current_scene.name
		if is_instance_valid(get_node("map/"+mapName)):
			get_node("map/"+mapName).visible =true
			get_tree().current_scene.onMap = true
			$map.visible = true
			get_tree().current_scene.get_node("player").canMove = false
	else:
		get_tree().current_scene.get_node("player").canMove = true
		get_tree().current_scene.onMap = false
		$map.visible = false
		var mapName = get_tree().current_scene.name
		if is_instance_valid(get_node("map/"+mapName)):
			get_node("map/"+mapName).visible = false
		


func _on_map_small_button_button_down():
	get_tree().current_scene.get_node("player").canMove = true
	get_tree().current_scene.onMap = false
	$map.visible = false
	var mapName = get_tree().current_scene.name
	if is_instance_valid(get_node("map/"+mapName)):
		get_node("map/"+mapName).visible = false


func _on_shop_button_button_down():
	buyAmount = 0
	$"宠物食物商店/buyAmount".text = str(buyAmount)
	if !$"宠物食物商店".visible:
		$"宠物食物商店".visible = true
		get_tree().current_scene.get_node("player").canMove = false
	else:
		$"宠物食物商店".visible = false
		get_tree().current_scene.get_node("player").canMove = true
		
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()	

func _on_shop_button_button_up():
	pass # Replace with function body.


func _on_shop_button_mouse_entered():
	$"交易/Label".visible = true



func _on_shop_button_mouse_exited():
	$"交易/Label".visible = false


func _on_灵宠商店button_button_down():
	$"宠物食物商店".visible = false
	get_tree().current_scene.get_node("player").canMove = true


func _on_add_button_button_down():
	buyAmount += 1
	$"宠物食物商店/buyAmount".text = str(buyAmount)
	$"宠物食物商店/AnimatedSprite2D2".play("click")
	cost = buyAmount * 100
	if cost >= FightScenePlayers.golds:
		return
	$"宠物食物商店/cost".text = str(cost)

func _on_add_button_button_up():
	$"宠物食物商店/AnimatedSprite2D2".play("default")



func _on_min_button_button_down():
	if buyAmount == 0:
		return
	buyAmount -= 1
	$"宠物食物商店/buyAmount".text = str(buyAmount)
	$"宠物食物商店/AnimatedSprite2D3".play("click")
	cost = buyAmount * 100
	$"宠物食物商店/cost".text = str(cost)


func _on_min_button_button_up():
	$"宠物食物商店/AnimatedSprite2D3".play("default")


func _on_饱食button_button_down():
	if FightScenePlayers.petFood == 0:
		return
	FightScenePlayers.petFood -= 1
	SmallPetData.currSmallPetData[Global.onTeamSmallPet[0]].hungry += 10



func compare_dictionaries(dict1: Dictionary, dict2: Dictionary) -> Dictionary:
	var differences = {}
	
	# 遍历第一个字典
	for key in dict1.keys():
		if not dict2.has(key):
			differences[key] = {"status": "missing in dict2", "value": dict1[key]}
		elif dict1[key] != dict2[key]:
			differences[key] = {"status": "different", "value_in_dict1": dict1[key], "value_in_dict2": dict2[key]}
	
	# 遍历第二个字典，查找只存在于 dict2 中的键
	for key in dict2.keys():
		if not dict1.has(key):
			differences[key] = {"status": "missing in dict1", "value": dict2[key]}
	
	return differences
func countDown(value):
	$countDown.visible = true
	$countDownTimer.start()  # 启动倒计时
	var minutes = value / 60  # 计算分钟数
	var seconds = value % 60  # 计算剩余秒数
	# 使用字符串格式化显示 "分钟:秒"，确保秒数为两位数
	$countDown.text = str(minutes) + ":" + str("%02d" % seconds)
	values = value
func _on_count_down_timer_timeout():
	values -= 1
	var minutes = values / 60  # 计算分钟数
	var seconds = values % 60  # 计算剩余秒数
	# 使用字符串格式化显示 "分钟:秒"，确保秒数为两位数
	$countDown.text = str(minutes) + ":" + str("%02d" % seconds)	
	if values == 0 and Global.countDownOn:
		get_tree().change_scene_to_file("res://Scene/failScene.tscn")


func _on_buy_button_button_down():
	FightScenePlayers.golds -= cost * Global.enKey
	FightScenePlayers.petFood += buyAmount
	buyAmount = 0
	cost = 0
	$"宠物食物商店/buyAmount".text = str(buyAmount)
	$"宠物食物商店/cost".text = str(cost)




#func _on_右上_mouse_entered():
#	Global.onPhoneButton = true
#
#
#func _on_右上_mouse_exited():
#	Global.onPhoneButton = false
	

func _on_右上_button_down():
	player.onArrowButton = true
	player.onUp = true
	player.canMouseMove = false
	player.onArrowButton = true
	player.speed = 200
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(player.position.x /10)) + "   " + "y: " + str(int(player.position.y/10)))
	
	player.velocity = Vector2(0, 0)
	player.velocity.y -= 0.00000000001
	player.velocity.x += 0.00000000001

	player.get_node("RayCast2D").rotation_degrees = 0
	player.raycast.target_position = Vector2(player.velocity.x * 25, player.velocity.y * 25 )
	
	player.raycast2.rotation_degrees = 0
	player.raycast2.target_position = Vector2(player.velocity.x * 35, player.velocity.y * 35 )			
	
	frames =  [
			preload("res://main character/tile008.png"),
			preload("res://main character/tile009.png"),
			preload("res://main character/tile010.png"),
			preload("res://main character/tile011.png"),
		  ]	
	if player.canMove and !player.collide and Global.menuOut == false:
		update_animation(deltas)
	player.velocity = player.velocity.normalized() * player.speed
	

	if player.canMove and !player.collide and Global.menuOut == false:
		player.move_and_slide()









func update_animation(delta):
	if delta:
		time_since_last_frame_change += delta
	if time_since_last_frame_change >= 0.01:
		time_since_last_frame_change = 0
		# Change to the next frame
		if player.velocity.length_squared() > 0:
			current_frame = (current_frame + 1) % frames.size()
		player.get_node("Sprite2D").texture = frames[current_frame]
		


func _on_右下_button_down():
	player.onArrowButton = true
	player.onRight = true
	player.canMouseMove = false
	player.onArrowButton = true
	player.speed = 200
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(player.position.x /10)) + "   " + "y: " + str(int(player.position.y/10)))
	
	player.velocity = Vector2(0, 0)
	player.velocity.y += 1
	player.velocity.x += 1

	player.get_node("RayCast2D").rotation_degrees = 0
	player.raycast.target_position = Vector2(player.velocity.x * 25, player.velocity.y * 25 )
	
	player.raycast2.rotation_degrees = 0
	player.raycast2.target_position = Vector2(player.velocity.x * 35, player.velocity.y * 35 )			
	
	frames =  [
			preload("res://main character/tile000.png"),
			preload("res://main character/tile001.png"),
			preload("res://main character/tile002.png"),
			preload("res://main character/tile003.png"),
		  ]
	if player.canMove and !player.collide and Global.menuOut == false:
		update_animation(deltas)
	player.velocity = player.velocity.normalized() * player.speed
	

	if player.canMove and !player.collide and Global.menuOut == false:
		player.move_and_slide()



func _on_左下_button_down():
	player.onArrowButton = true
	player.onDown = true
	player.canMouseMove = false
	player.onArrowButton = true
	player.speed = 200
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(player.position.x /10)) + "   " + "y: " + str(int(player.position.y/10)))
	
	player.velocity = Vector2(0, 0)
	player.velocity.y += 1
	player.velocity.x -= 1

	player.get_node("RayCast2D").rotation_degrees = 0
	player.raycast.target_position = Vector2(player.velocity.x * 25, player.velocity.y * 25 )
	
	player.raycast2.rotation_degrees = 0
	player.raycast2.target_position = Vector2(player.velocity.x * 35, player.velocity.y * 35 )			
	frames =  [
			preload("res://main character/tile004.png"),
			preload("res://main character/tile005.png"),
			preload("res://main character/tile006.png"),
			preload("res://main character/tile007.png"),
		  ]
	if player.canMove and !player.collide and Global.menuOut == false:
		update_animation(deltas)
	player.velocity = player.velocity.normalized() * player.speed
	

	if player.canMove and !player.collide and Global.menuOut == false:
		player.move_and_slide()
		
		
		


func _on_左上_button_down():
	player.onArrowButton = true
	player.onLeft = true
	player.canMouseMove = false
	player.onArrowButton = true
	player.speed = 200
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(player.position.x /10)) + "   " + "y: " + str(int(player.position.y/10)))
	
	player.velocity = Vector2(0, 0)
	player.velocity.y += 1
	player.velocity.x -= 1

	player.get_node("RayCast2D").rotation_degrees = 0
	player.raycast.target_position = Vector2(player.velocity.x * 25, player.velocity.y * 25 )
	
	player.raycast2.rotation_degrees = 0
	player.raycast2.target_position = Vector2(player.velocity.x * 35, player.velocity.y * 35 )			
	frames =  [
			preload("res://main character/tile012.png"),
			preload("res://main character/tile013.png"),
			preload("res://main character/tile014.png"),
			preload("res://main character/tile015.png"),
		  ]	
	if player.canMove and !player.collide and Global.menuOut == false:
		update_animation(deltas)
	player.velocity = player.velocity.normalized() * player.speed
	

	if player.canMove and !player.collide and Global.menuOut == false:
		player.move_and_slide()


func _on_右上_mouse_entered():
	player.onArrowButton = true
	
func _on_右上_mouse_exited():
	player.onArrowButton = false
	player.onUp = false
	player.speed = 200


func _on_右上_pressed():
	player.onArrowButton = true
	player.onUp = true
	player.canMouseMove = false
	player.onArrowButton = true
	player.speed = 200
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(player.position.x /10)) + "   " + "y: " + str(int(player.position.y/10)))
	
	player.velocity = Vector2(0, 0)
	player.velocity.y -= 0.00000000001
	player.velocity.x += 0.00000000001

	player.get_node("RayCast2D").rotation_degrees = 0
	player.raycast.target_position = Vector2(player.velocity.x * 25, player.velocity.y * 25 )
	
	player.raycast2.rotation_degrees = 0
	player.raycast2.target_position = Vector2(player.velocity.x * 35, player.velocity.y * 35 )			
	
	frames =  [
			preload("res://main character/tile008.png"),
			preload("res://main character/tile009.png"),
			preload("res://main character/tile010.png"),
			preload("res://main character/tile011.png"),
		  ]	
	if player.canMove and !player.collide and Global.menuOut == false:
		update_animation(deltas)
	player.velocity = player.velocity.normalized() * player.speed
	

	if player.canMove and !player.collide and Global.menuOut == false:
		player.move_and_slide()


func _on_坐标button_button_down():
	get_tree().current_scene.get_node("player").position = get_tree().current_scene.playerPosition
func _on_hash_timer_timeout():
	pass
	
func _on_button_button_down():
	if Global.onTeamSmallPet.size() == 0:
		return
	Global.onPet = true
	$msgBox.visible = false
	$map.visible = false
	$position.visible = false
	$menutButton.visible = false
	$questHint.visible = false
	
	
	$"宠物".play("click")
	$"宠物列表".visible = true
	get_tree().current_scene.get_node("player").canMove = false
	$AudioStreamPlayer2D.stream = load("res://Audio/SE/002-System02.ogg")
	$AudioStreamPlayer2D.play()
	
	$"宠物列表/petDescription".text = SmallPetData.oriSmallPetData.get(Global.onTeamSmallPet[0]).description
	$"宠物列表/petAnimation".play(Global.onTeamSmallPet[0])
	$"宠物列表/petName".text = Global.onTeamSmallPet[0]
	$"宠物列表/技能名字".text = SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).petMagic.name
	$"宠物列表/饱食度/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).hungry)
	$"宠物列表/灵力/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).abilityPower)
	$"宠物列表/怒气/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).rage)
	$"宠物列表/伤害/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).str)
	$"宠物列表/技能名字/Label".text = SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).petMagic.description

func _on_pet_right_button_button_down():
	for i in Global.smallPets.size():
		if Global.onTeamSmallPet[0] == Global.smallPets[i]:
			# 找到当前宠物位置，将其替换为下一个宠物
			Global.onTeamSmallPet.erase(Global.onTeamSmallPet[0])
			
			# 获取下一个宠物的位置，使用取余来循环回到开头
			var next_index = (i + 1) % Global.smallPets.size()
			Global.onTeamSmallPet.append(Global.smallPets[next_index])
			$"宠物列表/petDescription".text = SmallPetData.oriSmallPetData.get(Global.onTeamSmallPet[0]).description
			$"宠物列表/petAnimation".play(Global.onTeamSmallPet[0])
			$"宠物列表/petName".text = Global.onTeamSmallPet[0]
			$"宠物列表/技能名字".text = SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).petMagic.name
			$"宠物列表/饱食度/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).hungry)
			$"宠物列表/灵力/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).abilityPower)
			$"宠物列表/怒气/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).rage)
			$"宠物列表/伤害/Label".text = str(SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).str)
			$"宠物列表/技能名字/Label".text = SmallPetData.currSmallPetData.get(Global.onTeamSmallPet[0]).petMagic.description
			$AnimationPlayer.play("changePet")
			$AudioStreamPlayer2D2.play()
			break  # 找到后立即退出循环

