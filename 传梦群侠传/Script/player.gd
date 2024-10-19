extends CharacterBody2D

var speed = 1000
var current_frame = 0
var time_since_last_frame_change = 0
var canMove = true
var frames = []
const arrival_threshold = 20
@onready var agent = $NavigationAgent2Ds
var target = null
var canMouseMove = false
var deltas
var directions = "up"
var loop_count = 0
var time_played_seconds = 0
var timer = Timer.new()

var raycast 
var raycast2 
var collide = false
var onArrowButton = false
var onUp = false
var onLeft = false
var onDown = false
var onRight = false
func _ready():
	canMouseMove = true
	raycast = $RayCast2D3
	raycast2 =  $RayCast2D2
	if Global.load == true:
		if self:
			self.position = Global.mapPlayerPos
	canMove = false
	$readyMove.start()
func _on_play_time_timeout():

	time_played_seconds = FightScenePlayers.seconds
	time_played_seconds += 1
	FightScenePlayers.seconds = time_played_seconds

func _process(delta):
	if Global.onTalk:
		if Global.playerDirection == "":
			return
		else:
			$AnimatedSprite2D.play(Global.playerDirection)
	if !Global.onTalk:
		agent = $NavigationAgent2Ds
		Global.load = false
		Global.mapPlayerPos = self.position

		#chapter 1 男主开场对话鱼叟
		if Global.currScene == "东海湾" and Global.autoDialogue.chapter1.get("男主开头说话").trigger == false:
			DialogueManager.show_chat(load("res://Dialogue/main.dialogue"),"男主开头说话")	
			Global.autoDialogue.chapter1.get("男主开头说话").trigger = true

		if Global.atNight and Global.haveLantern:
			$PointLight2D.energy = 0.52
		else:
			$PointLight2D.energy = 0


		if raycast2.is_colliding():
			collide = true
			if raycast2.get_collider().get_parent().is_in_group("standNpc"):
				collide = false
		else:
			collide = false
		if raycast.is_colliding():
			if raycast.get_collider().get_parent().is_in_group("standNpc"):
				collide = true
		
		if !$effect.is_playing():
			$effect.visible = false

		deltas = delta
		if Global.menuOut:
			target = null
			velocity = Vector2(0,0)

		if velocity == Vector2(0,0):
			if is_instance_valid($"../AnimationPlayer"):
				if !$"../AnimationPlayer".is_playing():
					current_frame = 0
					if frames.size() != 0:
						$Sprite2D.texture = frames[current_frame]
		#velocity = Vector2(0,0)		
		
		if canMouseMove  and !Global.onTalk and canMove  and target and global_position.distance_to(target) > arrival_threshold:
			var direction = (agent.get_next_path_position() - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			if get_parent().onFight == false and get_parent().canEnterFight == true and !Global.menuOut and Global.dangerScene.get(get_tree().current_scene.name):
				get_parent().check_enter_fight_scene()
				Global.onFight = get_parent().onFight
		if target and global_position.distance_to(target) == arrival_threshold:
			pass
		
		
	#	elif Input.is_action_pressed("ui_down") == false and Input.is_action_pressed("ui_up") == false and Input.is_action_pressed("ui_left") == false and Input.is_action_pressed("ui_right") == false:
	#		velocity = Vector2.ZERO 

		if velocity != Vector2.ZERO:
			$AnimatedSprite2D.play(directions)
		else:
			$Sprite2D.visible = true
			$AnimatedSprite2D.visible = false
			$AnimatedSprite2D.stop()

		
		if Input.is_action_pressed("leftClick")  and !Global.onTalk and !Global.onButton and !onArrowButton :
			var mouse_pos = get_global_mouse_position()  # Get the global mouse position
			var char_pos = position  # Get the character's position
			var vector_to_mouse = mouse_pos - char_pos
			var angle_in_radians = atan2(vector_to_mouse.y, vector_to_mouse.x)
			var angle_in_degrees = rad_to_deg(angle_in_radians)
			#$RayCast2D.rotation_degrees = angle_in_degrees - 100
			#raycast2.rotation_degrees = angle_in_degrees - 100
			if canMove:
				loop_count = 0
				canMouseMove = true
				target = get_global_mouse_position()
				agent.target_position = target
				

				# Calculate the vector from the character to the mouse

				if -90 <= angle_in_degrees and angle_in_degrees <= 0:
					$Sprite2D.visible = false
					$AnimatedSprite2D.visible = true
					#$AnimatedSprite2D.play("up")
					frames =  [
							preload("res://main character/tile008.png"),
							preload("res://main character/tile009.png"),
							preload("res://main character/tile010.png"),
							preload("res://main character/tile011.png"),
						  ]	
					directions = "up"
				if -180 <= angle_in_degrees and angle_in_degrees <= -90:
					$Sprite2D.visible = false
					$AnimatedSprite2D.visible = true
					frames =  [
								preload("res://main character/tile012.png"),
								preload("res://main character/tile013.png"),
								preload("res://main character/tile014.png"),
								preload("res://main character/tile015.png"),
							  ]	
					#update_animation(deltas)	
				
					directions = "left"
				if 90 <= angle_in_degrees and angle_in_degrees <= 180:	
					$Sprite2D.visible = false
					$AnimatedSprite2D.visible = true
					frames =  [
							preload("res://main character/tile004.png"),
							preload("res://main character/tile005.png"),
							preload("res://main character/tile006.png"),
							preload("res://main character/tile007.png"),
						  ]	
					#update_animation(deltas)
					
					directions = "down"		
				if 0 <= angle_in_degrees and angle_in_degrees <= 90:	
					$Sprite2D.visible = false
					$AnimatedSprite2D.visible = true	
					frames =  [
							preload("res://main character/tile000.png"),
							preload("res://main character/tile001.png"),
							preload("res://main character/tile002.png"),
							preload("res://main character/tile003.png"),
						  ]
					
					directions = "right"
		if Input.is_action_just_pressed("leftClick"):
			if !onDown and !onUp and !onLeft and !onRight:
				onArrowButton = false
				speed = 200
			
func _input(event):
	if !event.is_pressed():
		onLeft = false
		onUp = false
		onDown = false
		onRight = false
func _physics_process(delta):
	# Reset velocity to zero before processing new input
	if !Global.onTalk:
		var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
		xyPos.text = str("x: " + str(int(self.position.x /10)) + "   " + "y: " + str(int(self.position.y/10)))
		
		velocity = Vector2(0, 0)
		if onUp:
			_on_右上_button_down()
		elif onLeft:
			_on_左上_button_down()
		elif onDown:
			_on_左下_button_down()	
		elif onRight:
			_on_右下_button_down()	
			
			#velocity = Vector2(0, 0)
			
		if Input.is_action_pressed("ui_down") and !Global.onTalk:
			canMouseMove = false
			velocity.y += 1
			velocity.x -= 1
			$RayCast2D.rotation_degrees = 0
			
			
			raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
			
			raycast2.rotation_degrees = 0
			raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )
			frames =  [
					preload("res://main character/tile004.png"),
					preload("res://main character/tile005.png"),
					preload("res://main character/tile006.png"),
					preload("res://main character/tile007.png"),
				  ]
			if canMove and !collide and Global.menuOut == false:	
				update_animation(delta)
		elif Input.is_action_pressed("ui_up") and !Global.onTalk:
			canMouseMove = false
			velocity.y -= 1
			velocity.x += 1
			$RayCast2D.rotation_degrees = 0
			raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
			
			raycast2.rotation_degrees = 0
			raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
			
			frames =  [
					preload("res://main character/tile008.png"),
					preload("res://main character/tile009.png"),
					preload("res://main character/tile010.png"),
					preload("res://main character/tile011.png"),
				  ]	
			if canMove and !collide and Global.menuOut == false:
				update_animation(delta)
		elif Input.is_action_pressed("ui_left") and !Global.onTalk:
			canMouseMove = false
			$RayCast2D.enabled = true
		
			velocity.x -= 1
			velocity.y -= 1
			$RayCast2D.rotation_degrees = 0
			raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
			
			raycast2.rotation_degrees = 0
			raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
			frames =  [
					preload("res://main character/tile012.png"),
					preload("res://main character/tile013.png"),
					preload("res://main character/tile014.png"),
					preload("res://main character/tile015.png"),
				  ]	
			if canMove and !collide and Global.menuOut == false:
				update_animation(delta)
		elif Input.is_action_pressed("ui_right") and !Global.onTalk:
			canMouseMove = false
			velocity.x += 1
			velocity.y += 1
			$RayCast2D.rotation_degrees = 0
			raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
			
			raycast2.rotation_degrees = 0
			raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
			
			frames =  [
					preload("res://main character/tile000.png"),
					preload("res://main character/tile001.png"),
					preload("res://main character/tile002.png"),
					preload("res://main character/tile003.png"),
				  ]
			if canMove and !collide and Global.menuOut == false:	
				update_animation(delta)
				

		velocity = velocity.normalized() * speed


		if canMove and !collide and Global.menuOut == false:
			move_and_slide()
		

func player():
	pass

func update_animation(delta):

	if delta:
		time_since_last_frame_change += delta
	if time_since_last_frame_change >= 0.15:
		time_since_last_frame_change = 0
		# Change to the next frame
		if velocity.length_squared() > 0:
			current_frame = (current_frame + 1) % frames.size()
		$Sprite2D.texture = frames[current_frame]
		

func _on_animated_sprite_2d_animation_looped():
	loop_count += 1
	if loop_count >= 3:
		$AnimatedSprite2D.stop()


func _on_animated_sprite_2d_animation_finished():

	loop_count += 1
	if loop_count >= 3:
		$AnimatedSprite2D.stop()


func _on_animated_sprite_2d_sprite_frames_changed():
	pass


func _on_animated_sprite_2d_frame_changed():
	loop_count += 1
	if loop_count >= 12:
		$AnimatedSprite2D.stop()
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept") and !Global.onFight and !Global.menuOut and !get_parent().onShop:	
	
		if raycast.is_colliding():	
			if raycast.get_collider().get_parent().is_in_group("standNpc") and raycast.get_collider().get_parent().npcName != "":#and Global.npcs.has(raycast.get_collider().get_parent().npcName):
				if raycast.get_collider().get_parent().talked:
				
					return				
			
				if raycast.get_collider().get_parent().name == "小师弟"  or raycast.get_collider().get_parent().name == "小师弟2" or raycast.get_collider().get_parent().name == "小师弟3":
					raycast.get_collider().get_parent().talked = true
				if raycast.get_collider().get_parent().audio != "":
					get_parent().get_node("npcAudio").stream = load(raycast.get_collider().get_parent().newStream)
					get_parent().get_node("npcAudio").play()
				var npc = Global.npcs[raycast.get_collider().get_parent().npcName]
				var dialogue_index = npc["current_dialogue_index"]	
				var dialogue_entry
				if dialogue_index != npc["dialogues"].size():
					dialogue_entry = npc["dialogues"][dialogue_index]
				
					DialogueManager.show_chat(load("res://Dialogue/"+str(dialogue_entry.chapter)+".dialogue"),get_npc_dialogue(raycast.get_collider().get_parent().npcName))
				else:
					
					DialogueManager.show_chat(load("res://Dialogue/1.dialogue"),get_npc_dialogue(raycast.get_collider().get_parent().npcName))
				var direction = global_position - raycast.get_collider().get_parent().global_position
				var angle_deg = rad_to_deg(direction.angle())  # 获取角度并转换为度数
				angle_deg = fmod(angle_deg + 360, 360)  # 标准化到0到360度
				#raycast.get_collider().get_parent().rotation = deg_to_rad(angle_deg)  # 转换回弧度来设置旋转				
				if Input.is_action_just_pressed("ui_accept"):
					if angle_deg >= 0 and angle_deg<= 90:
						raycast.get_collider().get_parent().play("右下")
					elif angle_deg > 90 and angle_deg <= 180:
						raycast.get_collider().get_parent().play("左下")
					elif angle_deg > 180 and angle_deg <= 270:	
						raycast.get_collider().get_parent().play("左上")
					elif angle_deg > 270 and angle_deg <= 360:	
						raycast.get_collider().get_parent().play("右上")						
				raycast.get_collider().get_parent()
				if raycast.get_collider().get_parent().itemSale.size() > 0:
					Global.currShopItem = raycast.get_collider().get_parent().itemSale
			

						
func get_npc_dialogue(npc_id):
	if !Global.npcs.has(npc_id):
		return
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

#剧情一段时间后推进
#func _on_timer_timeout():
#	var npc = Global.npcs["鱼叟"]
#	var dialogue_index = npc["current_dialogue_index"]
#	var dialogue_entry = npc["dialogues"][dialogue_index]
#	dialogue_entry["unlocked"] = true
	



func _on_area_2d_area_entered(area):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "npcBody":
		velocity = Vector2(0,0)
	if body.get_parent().name == "黑山" and body.get_parent().onChase == true:
		Global.npcs.get("黑山")["current_dialogue_index"] = 0
		get_tree().change_scene_to_file("res://Scene/"+"方寸山"+".tscn")
			

func _on_右上_button_down():
	onArrowButton = true
	onUp = true
	canMouseMove = false
	onArrowButton = true
	speed = 100
	var xyPos = get_parent().get_node("CanvasLayer/position/xyLabel")
	xyPos.text = str("x: " + str(int(self.position.x /10)) + "   " + "y: " + str(int(self.position.y/10)))
	
	velocity = Vector2(0, 0)
	velocity.y -= 0.00000000001
	velocity.x += 0.00000000001

	$RayCast2D.rotation_degrees = 0
	raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
	
	raycast2.rotation_degrees = 0
	raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
	
	frames =  [
			preload("res://main character/tile008.png"),
			preload("res://main character/tile009.png"),
			preload("res://main character/tile010.png"),
			preload("res://main character/tile011.png"),
		  ]	
	if canMove and !collide and Global.menuOut == false:
		update_animation(deltas)
	velocity = velocity.normalized() * speed
	

	if canMove and !collide and Global.menuOut == false:
		move_and_slide()



func _on_右上_mouse_entered():
	onArrowButton = true
func _on_右上_mouse_exited():
	onArrowButton = false
	onUp = false
	speed = 200

func _on_左上_button_down():
	onArrowButton = true
	onLeft = true
	canMouseMove = false
	onArrowButton = true
	speed = 100
	velocity.y -= 0.00000000001
	velocity.x -= 0.00000000001
	$RayCast2D.rotation_degrees = 0
	raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
	
	raycast2.rotation_degrees = 0
	raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
	frames =  [
			preload("res://main character/tile012.png"),
			preload("res://main character/tile013.png"),
			preload("res://main character/tile014.png"),
			preload("res://main character/tile015.png"),
		  ]	
	if canMove and !collide and Global.menuOut == false:
		update_animation(deltas)
	velocity = velocity.normalized() * speed
	

	if canMove and !collide and Global.menuOut == false:
		move_and_slide()



func _on_左上_mouse_entered():
	onArrowButton = true


func _on_左上_mouse_exited():
	onArrowButton = false
	onLeft = false
	speed = 200


func _on_左下_button_down():
	onArrowButton = true
	onDown = true
	canMouseMove = false
	onArrowButton = true
	speed = 100
	velocity.y += 1
	velocity.x -= 1
	$RayCast2D.rotation_degrees = 0
	
	
	raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
	
	raycast2.rotation_degrees = 0
	raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )
	frames =  [
			preload("res://main character/tile004.png"),
			preload("res://main character/tile005.png"),
			preload("res://main character/tile006.png"),
			preload("res://main character/tile007.png"),
		  ]
	if canMove and !collide and Global.menuOut == false:
		update_animation(deltas)
	velocity = velocity.normalized() * speed
	

	if canMove and !collide and Global.menuOut == false:
		move_and_slide()



func _on_右下_button_down():
	onArrowButton = true
	onRight = true
	canMouseMove = false
	onArrowButton = true
	speed = 100
	velocity.x += 1
	velocity.y += 1
	$RayCast2D.rotation_degrees = 0
	raycast.target_position = Vector2(velocity.x * 25, velocity.y * 25 )
	
	raycast2.rotation_degrees = 0
	raycast2.target_position = Vector2(velocity.x * 35, velocity.y * 35 )			
	
	frames =  [
			preload("res://main character/tile000.png"),
			preload("res://main character/tile001.png"),
			preload("res://main character/tile002.png"),
			preload("res://main character/tile003.png"),
		  ]
	if canMove and !collide and Global.menuOut == false:
		update_animation(deltas)
	velocity = velocity.normalized() * speed
	

	if canMove and !collide and Global.menuOut == false:
		move_and_slide()



func _on_ready_move_timeout():
	canMove = true

