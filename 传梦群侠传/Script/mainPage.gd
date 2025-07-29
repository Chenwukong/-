extends VideoStreamPlayer

var video_player
var custom_cursor_image = preload("res://Icons/001-weapon01.png")
var cursor_frames = []
var current_frame = 0
var frame_rate = 0.1 # Time in seconds for each frame
var cursor_scale = Vector2(0, 0)
var onLoadPage = false
var menuLoadSlots 
var mapPlayer
var turnDark

var canFull = true
var onFull = false
var buttonIndex = 0

var canPress = true
func update_cursor():
	# Set the current frame as the cursor
	Input.set_custom_mouse_cursor(cursor_frames[int(current_frame)], 0, cursor_scale)
	menuLoadSlots = get_tree().get_nodes_in_group("menuLoadSlots")
func _ready():
	$".".stream = load("res://mainPageBack.ogv")
	$".".play()
	cursor_frames.append(preload("res://Icons/5-1.png"))
	
	update_cursor()
	for i in menuLoadSlots.size():
		
		var savePath = "user://saveFile"+str(i)
		var file = FileAccess.open(savePath, FileAccess.READ)
		
		if file and file.file_exists(savePath):
			buttonIndex = 2


			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gpu_name = RenderingServer.get_video_adapter_name()
	
	mapPlayer = get_tree().get_nodes_in_group("mapPlayer")
	current_frame += delta / frame_rate
	if current_frame >= cursor_frames.size():
		current_frame = 0 # Loop back to the first frame
	update_cursor()	
	if Input.is_action_just_pressed("ui_accept") and !onLoadPage:
		canPress = false
		$canPress.start()
		
		if buttonIndex == 0:
			$Button.emit_signal("pressed")
		elif buttonIndex == 2:
			$Button3.emit_signal("pressed")
		else:
			$Button2.emit_signal("pressed")
		
	if turnDark and $".".modulate.r > 0:
		
		$".".modulate.r -= 0.02
		$".".modulate.g -= 0.02
		$".".modulate.b -= 0.02
	if buttonIndex == 0:	
		$Cloud/Label.modulate = "yellow"
		$Cloud2/Label.modulate = "000000"	
		$Cloud3/Label.modulate = "000000"	
	if buttonIndex == 2:	
		$Cloud/Label.modulate = "000000"
		$Cloud2/Label.modulate = "000000"			
		$Cloud3/Label.modulate = "yellow"		
	if buttonIndex == 1:	
		$Cloud/Label.modulate = "000000"
		$Cloud2/Label.modulate = "yellow"		
		$Cloud3/Label.modulate = "000000"
	if Input.is_action_just_pressed("ui_left"):
		if buttonIndex == 0:
			buttonIndex = 1
		elif buttonIndex == 1:
			buttonIndex = 2
		elif buttonIndex == 2:
			buttonIndex = 0
		$subSound.stream = load("res://Audio/SE/001-System01.ogg")
		$subSound.play()		
	if Input.is_action_just_pressed("ui_right"):
		if buttonIndex == 0:
			buttonIndex = 2
		elif buttonIndex == 1:
			buttonIndex = 0
		elif buttonIndex == 2:
			buttonIndex = 1		
		$subSound.stream = load("res://Audio/SE/001-System01.ogg")
		$subSound.play()		
		
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
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	if onLoadPage:
		if Input.is_action_just_pressed("esc"):
			onLoadPage = false
			$"读取页面".visible = false
			$subSound.stream = load("res://Audio/SE/003-System03.ogg")
			$subSound.play()		
			#get_node("系统信息").visible = true			
		if Input.is_action_just_pressed("ui_down"):
			if Global.saveIndex == 3:
				Global.saveIndex = 0
			else:
				Global.saveIndex += 1	

			$subSound.stream = load("res://Audio/SE/001-System01.ogg")
			$subSound.play()
		if Input.is_action_just_pressed("ui_up"):	
			if Global.saveIndex == 0:
				Global.saveIndex = 3
			else:
				Global.saveIndex -= 1
	
			$subSound.stream = load("res://Audio/SE/001-System01.ogg")
			$subSound.play()				
		if Input.is_action_just_pressed("ui_accept") and canPress:
			var savePath = "user://saveFile"+str(Global.saveIndex)
			var file = FileAccess.open(savePath, FileAccess.READ)
			
			if file and file.file_exists(savePath):

				var data = file.get_var()	
				menuLoadSlots[Global.saveIndex].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
				menuLoadSlots[Global.saveIndex].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)
				menuLoadSlots[Global.saveIndex].get_node("systemTime").text = data.formatDate			
			
			
			
				$".".modulate.r = 0
				$".".modulate.g = 0
				$".".modulate.b = 0
				$loadGame.start()

				$subSound.stream = load("res://Audio/SE/008-System08.ogg")
				$subSound.play()		
		
		for i in menuLoadSlots:
			
			if i.name == menuLoadSlots[Global.saveIndex].name:
				i.self_modulate = "0000ff"	
			else:
				i.self_modulate = "ffffff94"			


func _on_finished():
	play()

func loadGame():

	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	Global.menuOut = false
	Global.onSavePage = false
	Global.onLoadPage = false
	
	var data
	if file:
		data = file.get_var()		
		FightScenePlayers.datas = data.FightScenePlayers
		FightScenePlayers.loadData()
	
		Global.saveData = data.Global
		if mapPlayer:
			mapPlayer[0].queue_free()
		
		Global.loadData()
		get_tree().change_scene_to_file("res://Scene/"+Global.currScene+".tscn")
		Global.load = true
	
func _on_button_mouse_entered():
	$Cloud.scale = Vector2(0.2,0.2)
	$subSound.stream = load("res://Audio/SE/001-System01.ogg")
	$subSound.play()

	
	
func _on_button_mouse_exited():
	$Cloud.scale = Vector2(0.153,0.153)


func _on_button_2_mouse_entered():
	$Cloud2.scale = Vector2(0.2,0.2)
	$subSound.stream = load("res://Audio/SE/001-System01.ogg")
	$subSound.play()
func _on_button_2_mouse_exited():
	$Cloud2.scale = Vector2(0.153,0.153)
	

#读取存档
func _on_button_3_mouse_entered():
	$Cloud3.scale = Vector2(0.2,0.2)
	$subSound.stream = load("res://Audio/SE/001-System01.ogg")
	$subSound.play()
	
func _on_button_3_mouse_exited():
	$Cloud3.scale = Vector2(0.153,0.153)


func _on_button_2_pressed():
	get_tree().quit()


func _on_button_3_pressed():
	$"读取页面".visible = true
	Global.saveIndex = 0
	$subSound.stream = load("res://Audio/SE/002-System02.ogg")
	$subSound.play()	
	onLoadPage = true
	for i in menuLoadSlots.size():
		
		var savePath = "user://saveFile"+str(i)
		var file = FileAccess.open(savePath, FileAccess.READ)
		
		if file and file.file_exists(savePath):
			buttonIndex = 2

			var data = file.get_var()	
			menuLoadSlots[i].get_node("playedTime").text = str(format_times(data.FightScenePlayers.seconds))	
			menuLoadSlots[i].get_node("chapter").text = "章节" + str(data.Global.current_chapter_id)
			menuLoadSlots[i].get_node("systemTime").text = data.formatDate


func _on_video_stream_player_2_finished():
	$"读取页面/VideoStreamPlayer2".play()
	
func format_times(seconds):
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var second = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, second]
	
func _on_add_child_timeout():
	var instance = preload("res://Scene/player.tscn").instantiate()
	instance.name = "player"
	instance.position = Global.mapPlayerPos
	$".".add_child(instance)
	


func _on_load_game_timeout():
	loadGame()


func _on_can_full_timer_timeout():
	canFull = true

func _on_load_button_2_pressed():

	Global.saveIndex = 1
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:
		turnDark = true
		$loadGame.start()
		$subSound.stream = load("res://Audio/SE/008-System08.ogg")
		$subSound.play()		

func _on_load_button_3_pressed():

	Global.saveIndex = 2
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:		
		
		turnDark = true
		$loadGame.start()

		$subSound.stream = load("res://Audio/SE/008-System08.ogg")
		$subSound.play()		
func _on_load_button_4_pressed():

	Global.saveIndex = 3
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:				
		turnDark = true
		$loadGame.start()

		$subSound.stream = load("res://Audio/SE/008-System08.ogg")
		$subSound.play()		


func _on_load_button_1_button_down():
	Global.saveIndex = 0
	var savePath = "user://saveFile"+str(Global.saveIndex)
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:				
		
		turnDark = true

		$loadGame.start()

		$subSound.stream = load("res://Audio/SE/008-System08.ogg")
		$subSound.play()		




func _on_can_press_timeout():
	canPress = true


func _on_open_scene_animation_finished(anim_name):
	Global.resetGlobal()
	Global.resetPlayer()
	get_tree().change_scene_to_file("res://Scene/"+"新手村"+".tscn")


func _on_button_button_down():
	print("")



func _on_button_pressed():
	$openScene.play("openScene")
	$AudioStreamPlayer2D.stream = load("res://Audio/BGM/欢乐家园.mp3")
	$AudioStreamPlayer2D.play()
	$title.visible = false
	$author.visible = false
	$qq.visible = false
	$Cloud.visible = false
	$Cloud2.visible = false
	$Cloud3.visible = false
	$Button.visible = false
	$Button2.visible = false
	$Button3.visible = false
	FightScenePlayers.fightScenePlayerData = FightScenePlayers.fightScenePlayerData2
	Global.current_chapter_id = 1
	Global.onTeamPlayer = []
	Global.onTeamPlayer.append("时追云")
	Global.onTeamPet = []
	Global.onTeamSmallPet = []
	FightScenePlayers.golds = 0
	$"版权申明".visible = true
	$"游戏申明".visible = true
