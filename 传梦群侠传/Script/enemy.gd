extends AnimatedSprite2D

# Export variables to associate custom attributes with each monster instance
@export var speed : int = 0
@export var magicDefense : int = 0
@export var physicDefense : int = 0
@export var attackDmg : int = 0
@export var magicDmg : int = 0
@export var hp : int = 0
var currHp = 0
@export var idle: String = ""
@export var monsterName = ""
@export var monsterIndex = 0
@export var speedBar = 0
@export var monsterPosition = Vector2(0, 0)
@export var alive = true
@export var exp = 0
@export var monsterMagicList = []

var gold = 0
var target
var onIce = false
var onSleep = false
var players = []
var dead = false

var oriMonsterName 
var monsters
#var selectedTarget = false

func _ready():
	oriMonsterName = monsterName
	monsterName = remove_numbers_from_string(monsterName)
	
	target = Global.target
	
	if Global.atNight:
		hp *= 2
		exp *= 2
		gold *= 2
	currHp = hp
		
var gotHit = false
var randi = 0
var magicRandi = 0

var fightScenePlayer
var currPlayer
var deltas
var itemList = []

func _process(delta):

	if Global.canBlock and self.hp > 0:
		if Input.is_action_just_pressed("ui_accept"):
			Global.blocked = true
			Global.canBlock = false
			get_tree().current_scene.get_node("battleField/battleFieldPicture/blockButton").visible = false
			get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/兵器-钝器.ogg")
			get_tree().current_scene.get_node("subSound").play()
			Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "block")			
			Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
			Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false						
			Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
			Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").visible = true
			Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").play("block")
#	if onIce:
#		if Global.dealtDmg != 0:
#			Global.dealtDmg /= 2

	monsters = get_tree().get_nodes_in_group("monster")
	for i in FightScenePlayers.battleItem.keys():
		itemList.append(FightScenePlayers.battleItem.get(i))
	deltas = delta
	if players.size() == 0:
		players = get_tree().get_nodes_in_group("fightScenePlayers")
	
	if Global.onAttackingList.size() <= 0:
		if Global.onAttackPicking == false and Global.onAttacking == false and Global.onMagicAttackPicking == false and Global.onMagicAttacking == false and Global.onMagicSelectPicking == false:
			speedBar += speed * delta

#	if onIce:
#		$debuff.play("冰封")
	
#	if Global.monsterTarget:
#		print(alivePlayers[Global.monsterTarget].get_node("getHitEffect").is_playing() == false)
		
	if speedBar >= 100:
		speedBar = 0
		
		if onIce:
			onIce -= 1
			if onIce <= 0:
				onIce = false
				$debuff.visible = false
				$playerSound.stream = load("res://Audio/SE/ice-hit-ground-01.wav")
				$playerSound.play()
		elif onSleep:
			onSleep -= 1
			if onSleep <= 0:
				onSleep = false
				$debuff.visible = false
				$playerSound.stream = load("res://Audio/SE/warn.ogg")
				$playerSound.play()			
		else:		
			Global.onAttackingList.append(name)
	
		
	#检测当前onAttackingList的是不是自己，是的话就触发选择玩家攻击	
	if Global.onAttackingList.size() > 0 and Global.canEnemyHit:
		if !Global.onHitEnemy and monsterName and alive and Global.onAttackingList[0] != name:
			self.play(monsterName + "idle")
		if name == Global.onAttackingList[0] and alive and Global.selectedTarget == false and Global.onItemUsing == false :
			
			randi = randi_range(0,1)
			
			magicRandi = randi_range(0, monsterMagicList.size()-1)
			selectTarget(delta, randi, magicRandi)
			
		elif name == Global.onAttackingList[0] and Global.selectedTarget == false:
			Global.onAttackingList.pop_front()

	#结束攻击后恢复原状
		if Global.monsterTarget != null and Global.onAttackingList[0] == name and randi == 0:

			moveCharacter(delta)
			
			if self.animation == monsterName + "autoAttack" and self.is_playing() == false:
				
				if Global.monsterTarget >= 0 and Global.monsterTarget < Global.alivePlayers.size():
					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
					Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")		
				Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
				self.play(monsterName + "idle")
				Global.onAttackingList.pop_front()
				Global.onAttacking = false

				
				var damage_to_deduct = self.attackDmg  * float(Global.alivePlayers[Global.monsterTarget].currPhysicDefense)/ float(1000)
				Global.dealtDmg =  self.attackDmg - damage_to_deduct
				if Global.blocked:
					Global.dealtDmg /= 2
				Global.blocked = false
				Global.canBlock = false
				get_tree().current_scene.get_node("battleField/battleFieldPicture/blockButton").visible = false
				Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)
				
				Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
				Global.alivePlayers[Global.monsterTarget].get_node("hpControl").visible = true
				Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
				
				if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false				
					
				Global.monsterTarget = null
				position = monsterPosition
				Global.selectedTarget = false
				Global.canEnemyHit = false
				
				$"攻击间隔".start()				
					
				
		elif Global.monsterTarget != null or Global.onHitPlayer.size()>0 and Global.onAttackingList[0] == name and randi == 1 and monsterMagicList.size() > 0:
			if monsterMagicList.size() > 0 and monsterMagicList[magicRandi].effectArea == "single":
				
				if Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").animation == monsterMagicList[magicRandi].name and Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").is_playing() == false:
					
					if monsterMagicList[magicRandi].effectArea == "single" and Global.monsterTarget >= 0 and Global.monsterTarget < Global.alivePlayers.size():

						Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").stop()
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "hurt")
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
						var damage_to_deduct = self.magicDmg  *  monsterMagicList[randi_range(0, magicRandi)].damage * float(Global.alivePlayers[Global.monsterTarget].currMagicDefense)/ float(1000)
						Global.dealtDmg =  self.magicDmg *  monsterMagicList[magicRandi].damage - damage_to_deduct
						
						Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)		
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
						Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")
						self.play(monsterName + "idle")
						Global.onAttackingList.pop_front()
						Global.onAttacking = false
						
						Global.monsterTarget = null
						position = monsterPosition
						Global.selectedTarget = false					
						Global.onHitPlayer = []
						Global.canEnemyHit = false
						$"攻击间隔".start()
			elif monsterMagicList.size() > 0 and  monsterMagicList[magicRandi].effectArea == "aoe":		
				if Global.onHitPlayer.size()>0 and Global.onHitPlayer[0].get_node("getHitEffect").animation == monsterMagicList[magicRandi].name and Global.onHitPlayer[0].get_node("getHitEffect").is_playing() == false:
				
					for i in Global.onHitPlayer:
						i.self_modulate = "#ffffff"
						i.get_node("AnimationPlayer").stop()
						#i.play(i.playerName + "hurt")
						i.get_node("hpControl/hpLabel").modulate = "c80038"
						i.get_node("AnimationPlayer").play("hpControl")
				
						var damage_to_deduct = self.magicDmg  *  monsterMagicList[randi_range(0, magicRandi)].damage * float(i.currMagicDefense)/ float(1000)
						Global.dealtDmg =  self.magicDmg *  monsterMagicList[magicRandi].damage - damage_to_deduct
						
						i.currHp -= round(Global.dealtDmg)		
						i.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
						i.get_node('Control/hpBar').value = i.currHp
						i.get_node("getHitEffect").stop()
						i.get_node("getHitEffect").visible = false
						i.play(i.playerName + "idle")
						self.play(monsterName + "idle")
						Global.onAttackingList.pop_front()
						Global.onAttacking = false
						
						Global.monsterTarget = null
						position = monsterPosition
						Global.selectedTarget = false					
						Global.onHitPlayer = []
						Global.canEnemyHit = false
						$"攻击间隔".start()
	##给远程写的，如果是被打的目标就受伤动画，打完恢复idle
	if Global.onHitEnemy.has(self):
		self.play(monsterName + "hurt")
	
	
	#有怪物之后，血量少于0就触发死亡动画
	if monsterName:
		if currHp <= 0 and gotHit == false:
			#get_node("Button").queue_free()
			currHp = 0
			Global.targetMonsterIdx = 0 
			alive = false
			$deadSound.play()
			$deadAnimationPlayer.play("deadAnimation")
			$deadTimer.start()  # Start the timer only once when hp is less than or equal to 0
			self.self_modulate = "#ef1354"
			self.get_node("hpAnimation").play("hpDrop")
			self.play(monsterName + "hurt")
			gotHit = true  # Set gotHit to true to prevent starting the timer multiple times
			
func remove_numbers_from_string(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not char.is_valid_int():
			result += char
	return result

func _on_area_2d_area_entered(area):
	if area.is_in_group("player") and Global.onHitEnemy.has(self):
		self.play(monsterName + "hurt")
#	if area.is_in_group("dart"): #and Global.target == self:
#
#		if Global.itemControlType == "keyboard" and  Global.target == self:
#	
#			currHp -= Global.currUsingItem.info.value
#			$hpControl/hpLabel.text = str(Global.currUsingItem.info.value)
#			$hpControl.visible = true
#			$hpAnimation.play("hpDrop")
#			get_parent().get_node("Dart").call_deferred("queue_free")
#			Global.usingDart = false
#			self_modulate = "#ffffff"
#		elif Global.itemControlType == "mouse" and  Global.currPlayer.target == self:
#		
#			currHp -= Global.currUsingItem.info.value
#			$hpControl/hpLabel.text = str(Global.currUsingItem.info.value)
#			$hpControl.visible = true
#			$hpAnimation.play("hpDrop")
#			get_parent().get_node("Dart").call_deferred("queue_free")
#			Global.usingDart = false
#			self_modulate = "#ffffff"
func _on_dead_timer_timeout():
	self.call_deferred("queue_free")

func selectTarget(delta, randi, magicRandi):
	if players.size() != 0:
		for i in players:
			if i.alive == false:	
				Global.alivePlayers.erase(i)		
			elif i.alive == true and Global.alivePlayers.has(i) == false:
				Global.alivePlayers.append(i)		
	if players.size() ==0:
		return		
	if randi == 0 and Global.alivePlayers.size()>0:
		$effectSound.stream = load("res://Audio/SE/打击1.ogg")
		$effectSound.play()
		Global.monsterTarget = randi_range(0, Global.alivePlayers.size() - 1)
		var blockChance = FightScenePlayers.fightScenePlayerData.get(Global.alivePlayers[Global.monsterTarget].name).blockChance
		if randi_range(0,100) <= blockChance:
			Global.canBlock = true
			get_tree().current_scene.get_node("battleField/battleFieldPicture/blockButton").visible = true
				
		
		
		Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").stop()
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
		Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].name + "hurt")
		Global.alivePlayers[Global.monsterTarget].self_modulate = "#ef1354"
		Global.onAttacking = true
		Global.selectedTarget = true
		self.play(monsterName + "autoAttack")
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = true
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play("monsterAutoAttack")
		if !Global.blocked:
			Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "hurt")
		Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
		Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")

#		Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
#		Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
		
	else:#使用法术
		$effectSound.stream = load(monsterMagicList[magicRandi].audio)
		$effectSound.play()
		if monsterMagicList[magicRandi].effectArea == "aoe":
#			Global.monsterTarget = randi_range(0, alivePlayers.size() - 1)
#			Global.onHitPlayer.append(alivePlayers[Global.monsterTarget])
			if Global.alivePlayers.size() < monsterMagicList[magicRandi].effectingNum:
				for i in Global.alivePlayers:
					if Global.alivePlayers.size() >=  monsterMagicList[magicRandi].effectingNum:
						break
					Global.onHitPlayer.append(i)
				
			else:		
				
				while Global.onHitPlayer.size() <  monsterMagicList[magicRandi].effectingNum:
					var ranTarget = Global.alivePlayers[randi_range(0, Global.alivePlayers.size() - 1)]
				
					if !Global.onHitPlayer.has(ranTarget):
						Global.onHitPlayer.append(ranTarget)
			for onHitPlayer in Global.onHitPlayer:
				onHitPlayer.get_node("getHitEffect").visible = false
				onHitPlayer.play(onHitPlayer.name + "hurt")
				onHitPlayer.self_modulate = "#ef1354"
				onHitPlayer.get_node("getHitEffect").visible = true
				onHitPlayer.get_node("getHitEffect").play(monsterMagicList[magicRandi].name)		
			Global.onAttacking = true
			Global.selectedTarget = true 	
			self.play(monsterName + "magic")
		else:
			if Global.alivePlayers.size()>0:			
				Global.monsterTarget = randi_range(0, Global.alivePlayers.size() - 1)

			
				Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
				Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].name + "hurt")
				Global.alivePlayers[Global.monsterTarget].self_modulate = "#ef1354"
				Global.onAttacking = true
				Global.selectedTarget = true
				self.play(monsterName + "magic")
				Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = true
				Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play(monsterMagicList[magicRandi].name)
#		alivePlayers[Global.monsterTarget].play(alivePlayers[Global.monsterTarget].playerName + "hurt")
#		alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
#		alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
#		var damage_to_deduct = self.magicDmg  *  monsterMagicList[randi_range(0, monsterMagicList.size() - 1)].damage * float(alivePlayers[Global.monsterTarget].currMagicDefense)/ float(1000)
#		Global.dealtDmg =  self.magicDmg *  monsterMagicList[0].damage - damage_to_deduct
#
#		alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)		
#		alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
#		alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = alivePlayers[Global.monsterTarget].currHp
	
func moveCharacter(delta):
	var moveSpeed = 15 
	var newPosition = position.lerp(Vector2(Global.alivePlayers[Global.monsterTarget].position.x-60, Global.alivePlayers[Global.monsterTarget].position.y-60)  , moveSpeed * delta)
	position.x = newPosition.x 
	position.y = newPosition.y 




func _on_button_button_down():
	Global.target = self
	
	if monsters.size() > 0 and Global.onAttackPicking and Global.currPlayer.canAttack == true:

		#Global.currPlayer.targetPosition = self.position
		attacks()
	
		if Global.currPlayer.name != "姜韵":
			move()
			
	if monsters and Global.onMagicAttackPicking:
		Global.currPlayer.castMagic(deltas, Global.currPlayerMagic[Global.magicSelectIndex],self, "mouse") 	
		Global.onMagicAttackPicking = false
		
	if monsters and Global.onItemUsePicking:
		#Global.itemSelectIndex = 1
		Global.currPlayer.useItem(Global.currUsingItem, self , "mouse") 
		Global.currPlayer.target = self	
		Global.onItemUsePicking= false
func attacks():
	Global.currPlayer.target = self
	Global.currPlayer.attack(self, "mouse")
func move():
	Global.currPlayer.moveCharacter(deltas * 4.9)
	

func _on_button_mouse_entered():
	if Global.onAttackPicking:
		$".".modulate = "c7c7c7"
	
	


func _on_hp_animation_animation_finished(anim_name):
	if anim_name == "hpDrop":
		for child in get_node("hpControl").get_children():
			if child.name != "hpLabel":
				child.queue_free()


func _on_攻击间隔_timeout():
	Global.canEnemyHit = true


func _on_button_mouse_exited():
	$".".modulate = "ffffff"
