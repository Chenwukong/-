extends AnimatedSprite2D


@export var playerSpeed : int = 0
@export var addPlayerSpeed : int = 0
var currPlayerSpeed = playerSpeed  + addPlayerSpeed
@export var delay_timer: Timer

@export var additionDmg : int = 0

@export var magicDefense : int = 0
var currMagicDefense
@export var addMagicDefense : int = 0
var onIce = false
var crit = "normal"
var disDamage 

@export var physicDefense : int = 0
var currPhysicDefense 
@export var addPhysicDefense :int = 0

@export var str : int = 0 
@export var addStr : int = 0 
var currStr = str + addStr



@export var abilityPower : int = 0
var addAbilityPower : int = 0
var currMagicDmg

@export var hp : int = 0
@export var currHp :int = 0
@export var addHp :int = 0
var totalHp = 0

@export var mp : int = 0
@export var currMp :int = 0
@export var addMp: int = 0
var totalMp = 0

@export var idle: String = ""
@export var defend: String = ""
@export var autoAttack: String = ""
@export var playerName = ""
@export var playerIndex = 0
@export var playerMagic = []
@export var playerPosition = Vector2(0,0)
@export var speedBar = 0
@export var autoAttackSound = ""
@export var attackOnEnemySound = ""
@export var alive = true
@export var playerAttackType = ""
@export var magicAutoAttack: String = ""
@export var sleep = 0
@export var playerAutoSound = ""

@export var onHealBuff = false
@export var onSpeedBuff = false
@export var onAttackBuff = false
@export var onMagicBuff = false
@export var onPhysicDefenseBuff = false
@export var onMagicDefenseBuff = false
@export var onPoisonDebuff = false
@export var onIceDebuff = false
@export var onSleepDebuff = false
@export var onMagicDisableDebuff = false
@export var onTireDebuff = false

var tempSpeed = 0
var tempStr = 0
var tempAbilityPower = 0
var tempPhysicDefense = 0
var tempMagicDefense = 0
var dmgRation = 1
var healBuffAmount = 0
var poisonDebuffAmount = 0
var 真身round = 6

var itemList = []
var magicPanel
var target 
var attackButton
var defenseButton
var magicButton
var itemButton
var canSelect = false
var monsters = []
var players = []
var targetPosition
var multiPosition
var attackWaitTimeOver = false #设置到目标后攻击要等的
var magicScene 
var canAttack = true
var aliveMonsters = []
var hitByCircle = false
var deltas

var round = 0
var currDelta
var controlType = ""
var magicControlType = ''
var itemControlType = ""
var haveGao = false

var digit_image_path = "res://数字/"
var digit_sprite
var castLastMagic = {"magicInfo":null}

var canDefense = true
var canMove = true

var buffs = []

var multiCanCulate = true
var critChance 

var commanButtonIndex = 0
func _ready():
	
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$battleCommends.visible = false
	if self.playerName == "时追云":
		#$".".z_index = 1
		if Global.haveGao:
			haveGao = true
		if Global.gai:
			idle = "时追云改idle"
			autoAttack = "时追云改autoAttack"
			self.play("时追云改idle")
			
		
		
	totalHp = decrypt(addHp) + hp
	totalMp = decrypt(addMp) + mp
	abilityPower = decrypt(abilityPower)

	
	alive = true
	magicScene = preload("res://Scene/magic_selection.tscn")
	attackButton = get_node("battleCommends/attackButton")
	magicButton = get_node("battleCommends/magicButton")
	defenseButton = get_node("battleCommends/defenseButton")
	itemButton = get_node("battleCommends/itemButton")
	
	hp = FightScenePlayers.fightScenePlayerData.get(playerName).hp + decrypt(FightScenePlayers.fightScenePlayerData.get(playerName).addHp)
	critChance =  FightScenePlayers.fightScenePlayerData.get(playerName).critChance + FightScenePlayers.fightScenePlayerData.get(playerName).addCritChance
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	
	currHp = FightScenePlayers.fightScenePlayerData.get(playerName).currHp
	currMp = FightScenePlayers.fightScenePlayerData.get(playerName).currMp

	var player_data = FightScenePlayers.fightScenePlayerData.get(playerName)

	# Check if 'item' key exists in player data
	if player_data and 'item' in player_data:
		var items = player_data['item']

	# Iterate through the items and update player's stats
		for item_type in items:
			var item = items[item_type]

	# Check if the item has a 'value' key and is a dictionary
			if item and 'value' in item and typeof(item['value']) == TYPE_DICTIONARY:
				for stat_key in item['value']:
					if stat_key in player_data:
	# Update player's stat by adding item's stat value
						player_data[stat_key] += item['value'][stat_key]

	currStr = str + decrypt(addStr)
	
	currMagicDmg = abilityPower + decrypt(addAbilityPower)
	
	
	currPlayerSpeed = decrypt(addPlayerSpeed) + playerSpeed
	currPhysicDefense = decrypt(addPhysicDefense) + physicDefense
	currMagicDefense = decrypt(addMagicDefense) + magicDefense
	
	if player_data.name == "时追云":				
		if haveGao:
			currStr += 100
			currPlayerSpeed += 70
			currPhysicDefense += 200
			currMagicDefense += 200
			totalHp += 500
			totalMp += 500
			hp += 500
			mp += 500
				
				
	FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData
	
	
	for i in FightScenePlayers.battleItem.keys():
		itemList.append(FightScenePlayers.battleItem.get(i))
	
	if FightScenePlayers.fightScenePlayerData.get(playerName).currHp > FightScenePlayers.fightScenePlayerData.get(playerName).hp:
		FightScenePlayers.fightScenePlayerData.get(playerName).currHp = FightScenePlayers.fightScenePlayerData.get(playerName).hp
	get_node("hpControl").visible = false
func _process(delta):

	if Global.onAttackingList.size()>0 and Global.onAttackingList[0] == "小二真身":
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
	if Global.currUsingMagic and Global.currUsingMagic.animationArea == "screen":
		for i in monsters:
			i.get_node("getHitEffect").visible = false
	if onIceDebuff:
		$contBuff.visible = true
		$contBuff.play("冰封")
	elif onTireDebuff:
		$contBuff.visible = true
		$contBuff.play("力竭")	
	elif onHealBuff:
		$contBuff.visible = true
		$contBuff.play("contHp")				
	else:
		$contBuff.visible = false
	currDelta = delta
	itemList = []
	for i in FightScenePlayers.battleItem.keys():
		itemList.append(FightScenePlayers.battleItem.get(i))
#	if playerName:
#		if currHp <= 0:
#			alive = false
#			get_node("Control").visible = false
#			self.play(playerName + "dead")
#			get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
#			get_tree().current_scene.get_node("oneTimeSound").play()
	if alive == false:
		$contBuff.visible = false
	
	Global.itemList = itemList
	
	if get_node("buffArea").is_playing() == false:
		get_node("buffArea").visible = false
	if Global.onAttackingList and playerName == Global.onAttackingList[0]:
#		var magic_names = []
#		for magic in playerMagic:
#			magic_names.append(magic["name"])
#
#		var names =  magic_names
#		for name in names:
#			if name == "高等炼体术":	
	
		playerMagic = playerMagic.filter(func(skill): 
		
			return skill.get("name", "") != "高等炼体术")
		Global.playerMagicList = playerMagic
		

	#在人物信息里面更新当前血量，方便之后的战斗获取
	FightScenePlayers.fightScenePlayerData.get(playerName).currHp = currHp
	FightScenePlayers.fightScenePlayerData.get(playerName).currMp = currMp
	get_node('Control/hpBar').max_value = totalHp
	get_node('Control/hpBar').value = currHp
	get_node('Control/manaBar').max_value = totalMp
	get_node('Control/manaBar').value = currMp

	
	if currHp >= totalHp and currHp != 0:
		get_node('Control/hpBar').value = hp
		currHp = totalHp

	if  Global.onAttackingList and Global.onAttackingList[0] == playerName:
		Global.currPlayerMagic = playerMagic

	#备战列表里没人就全部人增加黄条，到100就变为0并且自己加入备战列表
	if Global.onAttackingList.size() <= 0:
		if Global.onAttackPicking == false and Global.onAttacking == false and alive == true and Global.onMultiHit == 0 :
			speedBar += currPlayerSpeed * delta
			get_node("Control/speedBar").value = speedBar

	if speedBar >= 100:
		if name == "小二":
			if 真身round != 0:
				真身round -= 1
		speedBar = 0
		if onTireDebuff:
			pass
		else:
			Global.onAttackingList.append(playerName)
		for buff in buffs:
			get_node("contBuff").visible = true
			if "onHealBuff" in buff:
				buff["onHealBuff"] -= 1
				if buff["onHealBuff"] <= 0:
					buffs.erase(buff)					
			if "onAttackBuff" in buff:
				buff["onAttackBuff"] -= 1
				if buff["onAttackBuff"] <= 0:
					buffs.erase(buff)
			if "onMagicBuff" in buff:
				buff["onMagicBuff"] -= 1
				if buff["onMagicBuff"] <= 0:
					buffs.erase(buff)			
			if "onSpeedBuff" in buff:
				buff["onSpeedBuff"] -= 1
				if buff["onSpeedBuff"] <= 0:
					buffs.erase(buff)							
			if "onPhysicDefenseBuff" in buff:
				buff["onPhysicDefenseBuff"] -= 1
				if buff["onPhysicDefenseBuff"] <= 0:
					buffs.erase(buff)				
			if "onMagicDefenseBuff" in buff:
				buff["onMagicDefenseBuff"] -= 1
				if buff["onMagicDefenseBuff"] <= 0:
					buffs.erase(buff)						
			if "onSleepDebuff" in buff:
				buff["onSleepDebuff"] -= 1
				if buff["onSleepDebuff"] <= 0:
					buffs.erase(buff)	
			if "onIceDebuff" in buff:
				buff["onIceDebuff"] -= 1
				if buff["onIceDebuff"] <= 0:
					buffs.erase(buff)			
			if "onPoisonDebuff" in buff:
				buff["onPoisonDebuff"] -= 1
				if buff["onPoisonDebuff"] <= 0:
					buffs.erase(buff)
			if "onMagicDisableDebuff" in buff:
				buff["onMagicDisableDebuff"] -= 1
				if buff["onMagicDisableDebuff"] <=0:
					buffs.erase(buff)		
			if "onTireDebuff" in buff:
				buff["onTireDebuff"] -= 1
				if buff["onTireDebuff"] <=0:
					buffs.erase(buff)						
			
																														
		if onHealBuff:
			onHealBuff -= 1
			currHp += Global.healBuffAmount
			if onHealBuff <= 0:
				onHealBuff = false
		if onAttackBuff:
			onAttackBuff -= 1
			if onAttackBuff <= 0 :
				onAttackBuff = false
				currStr -= tempStr
				tempStr = 0
		if onMagicBuff:
			onMagicBuff -= 1
			if onMagicBuff <= 0 :
				onMagicBuff = false
				currMagicDmg = abilityPower	+ addAbilityPower			
		if onSpeedBuff:
			onSpeedBuff -= 1
			if onSpeedBuff <= 0 :
				onSpeedBuff = false
				currPlayerSpeed -= tempSpeed
				tempSpeed = 0
				if $contBuff.animation != "speed":
					pass
				else:
					$contBuff.visible = false
		if onPhysicDefenseBuff:
			onPhysicDefenseBuff -= 1
			if onPhysicDefenseBuff <= 0 : 
				onPhysicDefenseBuff = false
				currPhysicDefense -= tempPhysicDefense
				tempPhysicDefense = 0
		if onMagicDefenseBuff:
			onMagicDefenseBuff -= 1
			if onMagicDefenseBuff <= 0 :
				onMagicDefenseBuff = false
				currMagicDefense -= tempMagicDefense
				tempMagicDefense = 0
		if onIceDebuff:
			onIceDebuff -= 1
			if Global.onAttackingList.size()>0:
				Global.onAttackingList.erase(Global.onAttackingList[0])
			if onIceDebuff <= 0:
				onIceDebuff = false
				#todo
		if onSleepDebuff:
			onSleepDebuff -= 1
			if Global.onAttackingList.size()>0:
				Global.onAttackingList.erase(Global.onAttackingList[0])
			if onSleepDebuff <= 0:
				onSleepDebuff = false
		if onPoisonDebuff:	
			onPoisonDebuff -= 1
			currHp -= poisonDebuffAmount
			if onPoisonDebuff <= 0:
				onPoisonDebuff = false
		if onMagicDisableDebuff:	
			onMagicDisableDebuff -= 1
			currHp -= poisonDebuffAmount
			if onMagicDisableDebuff <= 0:
				onMagicDisableDebuff = false				
				if $contBuff.animation != "magicDisable":
					pass
				else:
					$contBuff.visible = false			
		if onTireDebuff:
			onTireDebuff -= 1
			if onTireDebuff <= 0:
				onTireDebuff = false		
					
						
	monsters = get_tree().get_nodes_in_group("monster")
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	
	for i in monsters:
		if i.alive == false:
			monsters.erase(i)

	#切换战斗按钮
	if Global.onAttackingList.size() > 0:
		if self.playerName == Global.onAttackingList[0] and $battleCommends.visible == true and canAttack and Global.onMultiHit == 0:	
			if Input.is_action_just_pressed("ui_down"):
				if Global.battleButtonIndex== 3:
					Global.battleButtonIndex = -1
		
				Global.battleButtonIndex += 1
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()				
			if Input.is_action_just_pressed("ui_up"):
				if Global.battleButtonIndex == 0:
					Global.battleButtonIndex = 4
				Global.battleButtonIndex -= 1
				
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()						
			if Input.is_action_pressed("alt") and Input.is_action_pressed("q") and !Global.noKeyboard:
				if castLastMagic.magicInfo == null:
					return
				if castLastMagic.magicInfo.name == "真身现世":
					return
				if castLastMagic.magicInfo:
					if currMp < castLastMagic.magicInfo.cost:
						return
											
					if castLastMagic.magicInfo.attackType == "multi":			
						cast_magic_multiple_times(delta, castLastMagic.magicInfo,castLastMagic.target, castLastMagic.type, 3)
						
					else:
						castMagic(delta, castLastMagic.magicInfo,castLastMagic.target, castLastMagic.type, true)
						print(castLastMagic.magicInfo,"//",castLastMagic.target,"//" ,castLastMagic.type)
					
	
	
		#选择普攻目标阶段
		if Global.onAttackPicking and Global.onAttackingList[0] == playerName:
			
			
			if monsters:
				if self.playerName != "朱雀":
					Global.target = monsters[Global.targetMonsterIdx]
			if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0") or Input.is_action_just_pressed("rightClick") ) or Input.is_action_pressed("rightClick"):
				get_parent().get_node("Panel").visible = true
				Global.onAttackPicking = false
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()			
			
			
			if Input.is_action_pressed("ui_accept")  and !Global.noKeyboard:
				if playerName == "朱雀":
					self.play(self.autoAttack)
					Global.onAttacking = true
					canAttack = false
					Global.onAttackPicking = false
					canSelect = false
					$canAttack.start()					
					
					
					
					return
				if Global.target or target and canAttack == true:
					attack(Global.target, "keyboard")
					if playerName != '姜韵' and playerName != "狐葬魂":
					
						moveCharacter(delta)    #重点，把移动和攻击分开，这样就算onAttacking = true 不能重复按之后也能移动
					canSelect = false
				else:
					return

					
	if Global.onMagicAttacking and Global.currUsingMagic and Global.currUsingMagic.attackType =="melee"  and  Global.onAttackingList[0] == playerName:

			get_parent().get_node("Panel").visible = true
			moveCharacter(delta)	
	if Global.onMagicAttacking and Global.currUsingMagic and Global.currUsingMagic.attackType =="multi" and Global.onAttackingList[0] == playerName:
			get_parent().get_node("Panel").visible = true
			moveMulti(delta)				

	if Global.onMagicAttacking and Global.currUsingMagic and Global.currPlayerMagic[Global.magicSelectIndex].attackType =="meleeDebuff" and Global.onAttackingList[0] == playerName :
		get_parent().get_node("Panel").visible = true
		moveCharacter(delta)	
		


	##查看是否在播放攻击动画,就是结束攻击动画没
	if self.is_playing() == false  and self.animation == autoAttack and (self.playerName != "姜韵" and self.playerName != "朱雀" and self.playerName != "狐葬魂"):

		$Control.visible = true
		position = playerPosition
		self.play(idle)
		Global.onAttackPicking = false
		Global.onAttacking = false
		Global.onHitEnemy = []
		get_node("contBuff").visible = true
		$canMove.start()

		if controlType == "mouse":
			if crit == "normal":
				if is_instance_valid(target):
					var damage_to_deduct = self.currStr  * float(target.physicDefense)/1000 
					if target.onIce:
						Global.dealtDmg = (self.currStr * 1.2 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2
					else:
						Global.dealtDmg =  (self.currStr * 1.2   - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg) ) * Global.damageReward1
						
					if target.currHp - round(Global.dealtDmg) <= 0:
						target.currHp = 0
					else:
						target.currHp -= round(Global.dealtDmg)
					#disDamage = display_damage(round(Global.dealtDmg),"normal")
			else:
				var damage_to_deduct = self.currStr * 1.2  * float(target.physicDefense)/1000   +  decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)
				if target.onIce:
					Global.dealtDmg = (self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2 
				else:
					Global.dealtDmg = ( self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1
				
				if target.currHp - round(Global.dealtDmg) <= 0:
					target.currHp = 0
				else:
					target.currHp -= round(Global.dealtDmg)
					#disDamage = display_damage(round(Global.dealtDmg),"crit")
			target.get_node("hpControl").visible = true
			if crit == "normal":
				disDamage = display_damage(round(Global.dealtDmg),"normal")
			else:
				disDamage = display_damage(round(Global.dealtDmg),"crit")
			target.get_node("hpControl").add_child(disDamage)
			target.get_node("hpAnimation").play("hpDrop")
			target.play(remove_numbers_from_string(target.name) + "idle")	
			target.get_node("getHitEffect").visible = false
			target.self_modulate = "#ffffff"
		elif controlType == "keyboard": 
			if !is_instance_valid(Global.target):
				return
			if Global.target.name == "敖阳" or Global.target.name == "时追云" or Global.target.name == "敖雨" or Global.target.name == "大海龟" or Global.target.name == "小二"  or Global.target.name == "姜韵"  or Global.target.name == "金甲"  or Global.target.name == "凌若昭":
				return   
			if crit == "normal":
				var damage_to_deduct = self.currStr  * float(Global.target.physicDefense)/1000  
				if Global.target.onIce:
					Global.dealtDmg = (self.currStr * 1.2  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2
					
				else:
		
					Global.dealtDmg = ( self.currStr * 1.2  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 
				
				if Global.target.canSee == false:
					Global.dealtDmg = 0
				if Global.target.currHp - round(Global.dealtDmg) <= 0:
					Global.target.currHp = 0
				else:
					Global.target.currHp -= round(Global.dealtDmg)
				
					
			else:
				var damage_to_deduct = self.currStr * 1.2  * float(Global.target.physicDefense)/1000  
				if Global.target.onIce:
					Global.dealtDmg = (self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2 
				else:
					Global.dealtDmg =  (self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1

				if Global.target.canSee == false:
					Global.dealtDmg = 0					
				if Global.target.currHp - round(Global.dealtDmg) <= 0:
					Global.target.currHp = 0
				else:
					Global.target.currHp -= round(Global.dealtDmg)
					
			Global.target.get_node("hpControl").visible = true
			if crit == "normal":
				disDamage = display_damage(round(Global.dealtDmg),"normal")
			else:
				disDamage = display_damage(round(Global.dealtDmg),"crit")
				
			Global.target.get_node("hpControl").add_child(disDamage)
			#Global.target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
			
			Global.target.get_node("hpAnimation").play("hpDrop")
			Global.target.get_node("getHitEffect").visible = false
			Global.target.play(remove_numbers_from_string(Global.target.name) + "idle")		
			
			Global.target.self_modulate = "#ffffff" 
		if Global.onMultiHit == 0:
			Global.onAttackingList.pop_front()
		get_node("Control/speedBar").value = speedBar	
		Global.target = null	
				
				
				
				
		target = null
		canAttack = false
		$canAttack.start()

		
		
	elif self.is_playing() == false and self.animation == autoAttack and (self.playerName == "姜韵" or self.playerName == "狐葬魂") :
	
		$Control.visible = true
		self.play(idle)
		Global.onAttackPicking = false
		Global.onAttacking = false
		Global.onHitEnemy = []
		get_node("contBuff").visible = true
		Global.target.get_node("getHitEffect").visible = false
		
		
		
		
		
		var crit = "normal"
		var disDamage 
		if randi_range(0,100) < critChance:
			crit = "crit"
		if controlType == "mouse" and is_instance_valid(target):
		#计算伤害
			if crit == "normal":
				var damage_to_deduct = self.currStr  * float(target.physicDefense)/1000 
				if target.onIce:
					Global.dealtDmg = (self.currStr * 1.2  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2
				else:
					Global.dealtDmg =  (self.currStr * 1.2  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 
					target.currHp -= round(Global.dealtDmg)
					
			else:
				var damage_to_deduct = self.currStr * 1.2  * float(target.physicDefense)/1000 
				if target.onIce:
					Global.dealtDmg = (self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 /2
				else:
					Global.dealtDmg =  (self.currStr * 1.8 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1 
					target.currHp -= round(Global.dealtDmg)
					
			if target.currHp <= 0 and Global.onAttackingList and Global.onAttackingList[0] == target.name: #重要：如果对方血量低于0就要移除出攻击列表
				Global.onAttackingList.pop_front()
			target.get_node("hpControl").visible = true
			#target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
			if crit == "normal":
				disDamage = display_damage(round(Global.dealtDmg),"normal")
			else:
				disDamage = display_damage(round(Global.dealtDmg),"crit")
				
			Global.target.get_node("hpControl").add_child(disDamage)
			target.get_node("hpAnimation").play("hpDrop")
			target.play(remove_numbers_from_string(target.name) + "idle")
			target.self_modulate = "#ffffff"
		else:
			Global.target.get_node("getHitEffect").visible = false
			if crit == "normal":
				var damage_to_deduct = self.currStr  * float(Global.target.physicDefense)/1000 
				if Global.target.onIce:
					Global.dealtDmg = (self.currStr  * 1.5  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))* Global.damageReward1 /2
				else:
					Global.dealtDmg =  (self.currStr  * 1.5  - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg)) * Global.damageReward1
			
					Global.target.currHp -= round(Global.dealtDmg)
			else:
				var damage_to_deduct = self.currStr  * 1.5  * float(Global.target.physicDefense)/1000 
				if Global.target.onIce:
					Global.dealtDmg = (self.currStr  * 3 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))* Global.damageReward1 /2
				else:
					Global.dealtDmg = ( self.currStr  * 3 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg )) *Global.damageReward1
					Global.target.currHp -= round(Global.dealtDmg)
			
			if Global.target.currHp <= 0 and Global.onAttackingList and Global.onAttackingList[0] == Global.target.name: #重要：如果对方血量低于0就要移除出攻击列表
		
				Global.onAttackingList.pop_front()
			if crit == "normal":
				disDamage = display_damage(round(Global.dealtDmg),"normal")
			else:
				disDamage = display_damage(round(Global.dealtDmg),"crit")
			Global.target.get_node("hpControl").visible = true
			Global.target.get_node("hpControl").add_child(disDamage)
			#Global.target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
			Global.target.get_node("hpAnimation").play("hpDrop")
	
			Global.target.play(remove_numbers_from_string(Global.target.name) + "idle")
			Global.target.self_modulate = "#ffffff"

		Global.onAttackingList.pop_front()
		get_node("Control/speedBar").value = speedBar
		Global.target = null
		target = null
		canAttack = false
		$canAttack.start()
	
	
	
	if self.is_playing() == false and self.animation == autoAttack and self.playerName == "朱雀":
		
		Global.allieTarget = players[Global.allieSelectIndex]
		Global.buffTarget.append(players[Global.allieSelectIndex])		
		get_parent().get_node("enemyInfo").visible = false
		get_parent().get_node("allyInfo").visible = true
		
		Global.target = players[Global.allieSelectIndex]
		target = Global.target		
		
		var healAmount = currMagicDmg * 3
		
		var disDamage = display_damage(round(healAmount),"heal")
		Global.target.get_node("hpControl").add_child(disDamage)	
		#buffTarget.get_node("hpControl/hpLabel").text = str(magic.value)
		Global.target.get_node("hpControl/hpLabel").modulate= "88ff00"
		Global.target.get_node("AnimationPlayer").play("hpControl")
		Global.target.currHp += healAmount

		$Control.visible = true
		self.play(idle)
		Global.onAttackPicking = false
		Global.onAttacking = false
		Global.onHitEnemy = []
		get_node("contBuff").visible = true
		Global.target.get_node("getHitEffect").visible = false
		Global.playsound("res://Audio/SE/107-Heal03.ogg")
		Global.onAttackingList.pop_front()
		get_node("Control/speedBar").value = speedBar
		Global.target = null
		target = null
		canAttack = false
		$canAttack.start()
		
		
		
	#法术施展完毕后
	if self.is_playing() == false and self.animation != (playerName + "idle") and self.animation!=(playerName + "hurt")  and self.animation!=(playerName + "defend") and self.animation!=("时追云改defend")   and Global.onAttackingList and self.playerName == Global.onAttackingList[0]:	
		if playerName == "朱雀":
			get_parent().get_node("朱雀影").visible = false		
		if playerName == "青龙":
			get_parent().get_node("青龙影").visible = false			
		
		if Global.currUsingMagic and Global.currUsingMagic.name == "真身现世":	
			get_parent().get_node("小二脸").visible = false
			get_parent().get_parent().get_node("黑边").visible = false
			playerMagic = FightScenePlayers.fightScenePlayerData['小二真身'].playerMagic

		
		multiCanCulate = true
		Global.battleButtonIndex = 0
		get_parent().get_node("screenMagic").visible = false
		get_node("contBuff").visible = true
		$Control.visible = true
		position = playerPosition
		self.play(idle)
		Global.onMagicAttackPicking = false
	
		Global.onMagicAttacking = false
		Global.magicSelectIndex = 0
		
		for buffTarget in Global.buffTarget:
			if is_instance_valid(buffTarget):
				buffTarget.get_node("getHitEffect").visible = false
				buffTarget.get_node("getHitEffect").modulate = "ffffff"	
		
		
		for target in Global.onHitEnemy:	
			if is_instance_valid(target):
				if target.canSee == false:
					Global.dealtDmg = 0						
				
				if target.onIce:
					target.currHp -= round(Global.dealtDmg * Global.damageReward1/2)
					#target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg/2))
				else:
					if Global.onMultiHit:
						if multiCanCulate:

							target.currHp -= round(Global.dealtDmg * Global.damageReward1)
							
							#target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg * Global.damageReward1))
							multiCanCulate = false
							Global.onMultiHit -= 1
							
					else:
						target.currHp -= round(Global.dealtDmg * Global.damageReward1)
						
						#target.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg * Global.damageReward1))
				
				target.get_node("hpControl").visible = true
			
				target.get_node("hpAnimation").play("hpDrop")
				target.self_modulate = "#ffffff"
				target.get_node("getHitEffect").visible = false
							
		if Global.onMultiHit == 0:
#			Global.canCalculateAfterMulti = false
#			$canCalculateAfterMulti.start()
			Global.onAttackingList.pop_front()
			get_node("Control/speedBar").value = speedBar
	
		
		if Global.currUsingMagic and Global.currUsingMagic.attackType == "multi":
			if is_instance_valid(target):
				if self.onTireDebuff or self.onTireDebuff:
					pass
				else:
					#target.get_node("debuff").visible = true
					#target.get_node("debuff").play(Global.currUsingMagic.name)
					self.onTireDebuff = Global.currUsingMagic.duration	
					self.buffs.append({"onTireDebuff":  Global.currUsingMagic.duration})	
		
		
		if Global.currUsingMagic and Global.currUsingMagic.attackType == "debuff":
			for i in Global.currUsingMagic.buffEffect:

				for target in Global.onHitEnemy:
					if i == "ice":
						var chance = Global.currUsingMagic.value + self.critChance - target.luck 
						if chance <= 5:
							chance = 5
						var random_value = randf() * 100						
						if is_instance_valid(target):
							if target.onIce or target.onSleep:
								pass
							elif random_value <= chance:
								target.get_node("debuff").visible = true
								target.get_node("debuff").play(Global.currUsingMagic.name)
								
								target.onIce = Global.currUsingMagic.duration
								target.buffs.append({"onIceDebuff":  Global.currUsingMagic.duration})
					if i == "sleep":
					
						var chance = Global.currUsingMagic.value + self.critChance - target.luck 
						var random_value = randf() * 100
						if chance <= 5:
							chance = 5						
						if is_instance_valid(target):
							if target.onSleep or target.onIce:
								pass
							elif random_value <= chance:
								target.get_node("debuff").visible = true
								target.get_node("debuff").play(Global.currUsingMagic.name)
								target.onSleep = Global.currUsingMagic.duration		
								target.buffs.append({"onSleepDebuff":  Global.currUsingMagic.duration})				
					if i == "poison":
						var chance = Global.currUsingMagic.value + self.critChance - target.luck 
						var random_value = randf() * 100
						if chance <= 5:
							chance = 5
						if is_instance_valid(target):
							if target.onPoison or target.onPoison:
								pass
							elif random_value <= chance:
								target.get_node("debuff").visible = true
								target.get_node("debuff").play(Global.currUsingMagic.name)
								target.onPoison = Global.currUsingMagic.duration	
								target.buffs.append({"onPoisonDebuff":  Global.currUsingMagic.duration})								
					if i == "magicDefenseDebuff":
						if is_instance_valid(target):
							if target.onMagicDefenseDebuff or target.onMagicDefenseDebuff:
								pass
							else:
#								target.get_node("debuff").visible = true
#								target.get_node("debuff").play(Global.currUsingMagic.name)
								target.onMagicDefenseDebuff = Global.currUsingMagic.duration	
								target.buffs.append({"onMagicDefenseDebuff":  Global.currUsingMagic.duration})		
			
					if i == "physicDefenseDebuff":
						
						if is_instance_valid(target):
							if target.onPhysicDefenseDebuff or target.onPhysicDefenseDebuff:
								pass
							else:
#								target.get_node("debuff").visible = true
#								target.get_node("debuff").play(Global.currUsingMagic.name)
								target.onPhysicDefenseDebuff = Global.currUsingMagic.duration
								target.buffs.append({"onPhysicDefenseDebuff":  Global.currUsingMagic.duration})	
								
#		if is_instance_valid(target):
#			for child in target.get_node("hpControl").get_children():
#				if child.name != "hpLabel":
#					child.queue_free()	
#
#		if is_instance_valid(Global.target):
#			for child in Global.target.get_node("hpControl").get_children():
#				if child.name != "hpLabel":
#					child.queue_free()								
								
		get_parent().get_node("magicName").visible = false
		get_parent().get_node("magicDescription").visible = false
		get_parent().get_node("magicSelection").visible = false
		if Global.onMultiHit == 0:
			Global.onHitEnemy = []
		Global.buffTarget = []
		Global.currPlayerMagic = []
		Global.currUsingMagic = null
		Global.target = null
		
		canAttack = false
		$canAttack.start()
		
#	if self.animation == playerName + "hurt":
#		self.play(playerName + "block")
	#用来解除defend动画	
	if self.animation == playerName + "defend" and self.is_playing() == false:

		Global.battleButtonIndex = 0
		#self.get_node("battleCommends").visible = true
		self.play(idle)
		if Global.onAttackingList:
			Global.onAttackingList.erase(Global.onAttackingList[0])
	elif animation == "时追云改defend" and Global.gai and self.is_playing() == false:
		self.play("时追云改idle")
		Global.onAttackingList.erase("时追云")
		Global.battleButtonIndex = 0
		if Global.onAttackingList:
			Global.onAttackingList.erase(Global.onAttackingList[0])		
	if $blockEffect.animation == "block" and $blockEffect.is_playing() == false:
		$blockEffect.play("default")
		#$blockEffect.visible = false
		
	
	#设置当前攻击的人为备战表第一个，如果第一个是自己，那就显示战斗按钮
	if Global.onAttackingList.size() > 0:
		Global.currAttacker = Global.onAttackingList[0]
		if Global.onAttackingList[0] == playerName and Global.onMagicSelectPicking == false and self.animation != playerName + "defend" and Global.onMagicAttacking == false and canAttack and Global.onMultiHit == 0:
			$battleCommends.visible = true
			#$battleCommends.set_process_input(true)
			
			#快捷攻击
			if Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_ALT) and !Global.noKeyboard and !Global.onMagicAttacking  and !Global.onMagicAttackPicking and !Global.onMagicSelectPicking and !Global.onMagicSelectPicking and !Global.onItemSelectPicking and !Global.onItemUsePicking and !Global.onItemUsing:
				if get_parent().get_parent().canPress:
					if Global.onAttackPicking == false and canAttack and Global.onAttackingList.size()>0 and (Global.onAttackingList[0] in Global.onTeamPlayer or Global.onAttackingList[0] in Global.onTeamPet):
							if canAttack:
								Global.battleButtonIndex = 0
							
								Global.onAttackPicking = true
								get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
								get_tree().current_scene.get_node("subSound").play()		
			#快捷法术
			if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_ALT) and !Global.noKeyboard:
				if get_parent().get_parent().canPress:
					if Global.onAttackingList:
						if Global.onMagicSelectPicking == false and Global.onMagicAttackPicking == false and Global.onMagicAttacking == false and self.playerName == Global.onAttackingList[0]:
								$battleCommends.visible = false
								Global.onMagicSelectPicking = true
								Global.magicSelectIndex = 0
								get_parent().get_node("magicDescription").visible = true
								get_parent().get_node("magicSelection").visible = true
								get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
								get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()							

								for i in playerMagic:
									magicScene = preload("res://Scene/magic_selection.tscn")
									var magicSceneInstance = magicScene.instantiate()
									magicSceneInstance.get_node("Button/name").text = i.name
									magicSceneInstance.get_node("Button/cost").text = str(i.cost)
									magicSceneInstance.get_node("Button/icon").texture = load(i.icon)
									if i.cost > currMp:
										magicSceneInstance.get_node("Button").modulate.a = 0.4
									get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)
			#快捷防御						
			if Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_ALT) and !Global.noKeyboard and !Global.onMagicAttacking  and !Global.onMagicAttackPicking and !Global.onMagicSelectPicking and !Global.onMagicSelectPicking and !Global.onItemSelectPicking and !Global.onItemUsePicking and !Global.onItemUsing and !Global.onAttackPicking :
				Global.battleButtonIndex = 0
				if canDefense:
					canDefense = false
					$canDefense.start()
					
					currHp += hp /7
					currMp += mp/7
					if currMp > mp + self.addMp:
						currMp = mp + self.addMp
					speedBar = 0
					$Control/speedBar.value = 0
					if playerName == "时追云" and Global.gai:
						self.play("时追云改defend")
					else:
						self.play(playerName + "defend")
					self.get_node("battleCommends").visible = false
					get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_tree().current_scene.get_node("subSound").play()				
			if Input.is_key_pressed(KEY_ALT) and Input.is_key_pressed(KEY_E) and !Global.noKeyboard and !Global.onMagicAttacking  and !Global.onMagicAttackPicking and !Global.onMagicSelectPicking and !Global.onMagicSelectPicking and !Global.onItemSelectPicking and !Global.onItemUsePicking and !Global.onItemUsing and !Global.onAttackPicking:
				Global.battleButtonIndex = 0
				
				if get_parent().get_parent().canPress:
					if Global.onAttackingList and itemList.size()>0:
						if Global.onItemSelectPicking == false and Global.onItemUsePicking == false and Global.onItemUsing == false and self.playerName == Global.onAttackingList[0]:
							
								$battleCommends.visible = false
								Global.onItemSelectPicking = true
								get_parent().get_node("magicDescription").visible = true
								get_parent().get_node("magicSelection").visible = true
								get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
								get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()				
								for i in itemList:
									magicScene = preload("res://Scene/itemButton.tscn")
									var magicSceneInstance = magicScene.instantiate()
									magicSceneInstance.get_node("Button/name").text = i.info.name
									magicSceneInstance.get_node("Button/amount").text = ""
									magicSceneInstance.get_node("Button/icon").texture = load(i.info.icon)
									get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)							
					
		else:
			$battleCommends.visible = false
			#$battleCommends.set_process_input(false)
		
	#在攻击，法术选择目标
	if Global.onAttackPicking or Global.onMagicAttackPicking  and Global.onAttackingList and self.playerName == Global.onAttackingList[0] :
		$battleCommends.visible = false
		
		get_parent().get_node("magicSelection").visible = false
		get_parent().get_node("magicDescription").visible = false
		if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0") or Input.is_action_just_pressed("rightClick") )   or Input.is_action_pressed("rightClick"):
			get_parent().get_node("Panel").visible = true
			Global.onMagicAttackPicking = false
			Global.onMagicSelectPicking = true
			get_parent().get_node("allyInfo").visible = false
			get_parent().get_node("magicSelection").visible = true
			get_parent().get_node("magicDescription").visible = true
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()						
	#在道具选择目标		
	if Global.onItemUsePicking:
		$battleCommends.visible = false
		
		get_parent().get_node("magicSelection").visible = false
		get_parent().get_node("magicDescription").visible = false
		if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0") or Input.is_action_just_pressed("rightClick") ):
			get_parent().get_node("Panel").visible = true
			get_parent().get_node("allyInfo").visible = false
			Global.onItemUsePicking = false
			Global.onItemSelectPicking = true
			get_parent().get_node("magicSelection").visible = true
			get_parent().get_node("magicDescription").visible = true
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()						
	#选择法术阶段高亮选中的按钮,当前在法术选择阶段
	if Global.onMagicSelectPicking:
		get_parent().get_node("Panel").visible = false
		magicPanel = get_tree().get_nodes_in_group("magic")
		
		for i in magicPanel:
			if i == magicPanel[Global.magicSelectIndex]:
				i.get_node("Button/name").modulate = "007cff"
			else:
				i.get_node("Button/name").modulate = "ffffff"
				
				
		if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0"))  or Input.is_action_pressed("rightClick"):
			get_parent().get_node("Panel").visible = true
			Global.onMagicSelectPicking = false
			Global.magicSelectIndex = 0
			get_parent().get_node("magicSelection").visible = false
			get_parent().get_node("magicDescription").visible = false	
			for i in magicPanel:
				i.queue_free()
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
			get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()					
	#当前在魔法选择阶段		
	if Global.onMagicSelectPicking and Global.onAttackingList.size() > 0 and playerName == Global.onAttackingList[0]: 
		Global.currUsingMagic = playerMagic[Global.magicSelectIndex]
		get_parent().get_node("magicDescription/Label").text = playerMagic[Global.magicSelectIndex].description
		
		if Global.currUsingMagic.name == "真身现世":
			
			get_parent().get_node("magicDescription/Label").text = "小二化作真身(还需再次行动 " + str(真身round) +" 回合)"	
		Global.target = players[Global.allieSelectIndex]
		target = Global.target
	
	#当前在道具选择阶段，并且使用的人是自己			
	if Global.onItemSelectPicking and playerName == Global.onAttackingList[0] and itemList.size()>0:
		if itemList.size() > Global.itemSelectIndex:
			Global.currUsingItem = itemList[Global.itemSelectIndex]
			get_parent().get_node("magicDescription/Label").text = itemList[Global.itemSelectIndex].info.description
			Global.target = players[Global.allieSelectIndex]
			#target = Global.target		
			#Global.currUsingItem = itemList[Global.itemSelectIndex]
			$battleCommends.visible = false
			get_parent().get_node("Panel").visible = false

			magicPanel = get_tree().get_nodes_in_group("magic")
			for i in magicPanel:
				if i == magicPanel[Global.itemSelectIndex]:
					i.get_node("Button/name").modulate = "007cff"
				else:
					i.get_node("Button/name").modulate = "ffffff"
				
				
		if (Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("x") or Input.is_action_just_pressed("0"))  or Input.is_action_pressed("rightClick") :
			
				get_parent().get_node("Panel").visible = true
				Global.onItemSelectPicking = false
				get_parent().get_node("magicSelection").visible = false
				get_parent().get_node("magicDescription").visible = false	
				for i in magicPanel:
					i.queue_free()
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
				get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()					
	#选择法术攻击对象
	if Global.onMagicAttackPicking and  Global.onMagicSelectPicking == false and Global.onAttackingList and self.playerName == Global.onAttackingList[0] :
		#如果法术不是buff，那就指向敌人
		
		get_parent().get_node("Panel").visible = true
		if Global.currPlayerMagic[Global.magicSelectIndex].attackType != "buff" and monsters.size()> Global.targetMonsterIdx:
			Global.target = monsters[Global.targetMonsterIdx]
			target = monsters[Global.targetMonsterIdx]
			targetPosition = Global.target.position
		#指向自己人
		else:
			get_parent().get_node("enemyInfo").visible = false
			get_parent().get_node("allyInfo").visible = true
			
			Global.target = players[Global.allieSelectIndex]
			target = Global.target

		if Input.is_action_just_pressed("ui_accept") and !Global.noKeyboard:			
			
		
			if playerMagic[Global.magicSelectIndex].attackType == "multi":
				multiPosition = targetPosition
				
				Global.onMultiHit = playerMagic[Global.magicSelectIndex].multiHitTimes 
				
				cast_magic_multiple_times(delta, playerMagic[Global.magicSelectIndex], Global.target, "keyboard", playerMagic[Global.magicSelectIndex].multiHitTimes )
			else:

				castMagic(delta, playerMagic[Global.magicSelectIndex], Global.target, "keyboard", false)
			Global.onAttackPicking = false
			Global.onMagicAttackPicking = false
			Global.onAttacking = false
		
	#选择道具使用对象	
	if Global.onItemUsePicking and  Global.onItemSelectPicking == false and Global.onAttackingList and self.playerName == Global.onAttackingList[0] and itemList.size() > 0:
		if Global.currUsingItem.info.effect == "hp":
			get_parent().get_node("allyInfo").visible = true
			
		#target = Global.target
		
			#get_node("AnimationPlayer").play("selectIndic")
		#Global.allieTarget = players[Global.allieSelectIndex]
		if Input.is_action_just_pressed("ui_accept") and !Global.noKeyboard:
			Global.target = players[Global.allieSelectIndex]

			useItem(Global.currUsingItem, Global.target, "keyboard") 	
			Global.onItemUsePicking = false
		
	##如果是当前在攻击的玩家，就设置选中战斗按钮们
	if playerName in Global.onAttackingList:
		if Global.onAttackingList[0] == playerName:
			if Global.battleButtonIndex == 0:
				attackButton.grab_focus()
			elif Global.battleButtonIndex == 1:
				magicButton.grab_focus()
			elif Global.battleButtonIndex == 2:
				defenseButton.grab_focus()
			elif Global.battleButtonIndex == 3:
				itemButton.grab_focus()
	
	##下面设置按钮选中的时候变绿色,并且设置按钮效果
	if attackButton.has_focus() and Global.onMultiHit == 0:
		attackButton.modulate = "blue"
		commanButtonIndex = 1
		magicButton.modulate = "#ffffff"
		defenseButton.modulate = "#ffffff"
		itemButton.modulate = "#ffffff"
		if get_parent().get_parent().canPress:
			if Global.onAttackPicking == false and canAttack and Global.onAttackingList.size()>0 and (Global.onAttackingList[0] in Global.onTeamPlayer or Global.onAttackingList[0] in Global.onTeamPet):
				if Global.onMagicSelectPicking or Global.onMagicAttackPicking:
					return
			
				if Global.noKeyboard:
					if Input.is_action_just_released("leftClick") and !Global.onMagicAttackPicking and !Global.onMagicAttacking and !Global.onItemUsePicking and !Global.onItemUsing: #重点 用pressed的话在按压过程中就触发代码了，所以按的同时会触发之后的判断条件，所以要改成released		
						if canAttack:
							
							Global.onAttackPicking = true
							get_parent().get_node("enemyInfo").visible = false
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()							
				elif Global.noMouse:
					if Input.is_action_just_released("ui_accept"): #重点 用pressed的话在按压过程中就触发代码了，所以按的同时会触发之后的判断条件，所以要改成released
					
						if canAttack:
							Global.onAttackPicking = true
							get_parent().get_node("enemyInfo").visible = false
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()								
	
	
	
	
	
	elif magicButton.has_focus() and Global.onMultiHit == 0:
		magicButton.modulate = "blue"
		commanButtonIndex = 2
		attackButton.modulate = "#ffffff"
		defenseButton.modulate = "#ffffff"
		itemButton.modulate = "#ffffff"
		
		if get_parent().get_parent().canPress:
			if Global.onAttackingList:
				if Global.onMagicSelectPicking == false and Global.onMagicAttackPicking == false and Global.onMagicAttacking == false and self.playerName == Global.onAttackingList[0]:
					if Global.noKeyboard:
						if Input.is_action_just_released("leftClick"):
							$battleCommends.visible = false
							Global.onMagicSelectPicking = true
							Global.magicSelectIndex = 0
							get_parent().get_node("magicDescription").visible = true
							get_parent().get_node("magicSelection").visible = true
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()							

							for i in playerMagic:
								magicScene = preload("res://Scene/magic_selection.tscn")
								var magicSceneInstance = magicScene.instantiate()
								
								magicSceneInstance.get_node("Button/name").text = i.name
								magicSceneInstance.get_node("Button/cost").text = str(i.cost)
								magicSceneInstance.get_node("Button/icon").texture = load(i.icon)
								if i.cost > currMp:
									magicSceneInstance.get_node("Button").modulate.a = 0.4
								get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)
					elif Global.noMouse:
						if Input.is_action_just_released("ui_accept"):
							$battleCommends.visible = false
							Global.onMagicSelectPicking = true
							Global.magicSelectIndex = 0
							get_parent().get_node("magicDescription").visible = true
							get_parent().get_node("magicSelection").visible = true
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
							get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()							

							for i in playerMagic:
								magicScene = preload("res://Scene/magic_selection.tscn")
								var magicSceneInstance = magicScene.instantiate()
								magicSceneInstance.get_node("Button/name").text = i.name
								magicSceneInstance.get_node("Button/cost").text = str(i.cost)
								magicSceneInstance.get_node("Button/icon").texture = load(i.icon)
								if i.cost > currMp:
									magicSceneInstance.get_node("Button").modulate.a = 0.4
								get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)
		
	elif defenseButton.has_focus() and Global.onMultiHit == 0:
		defenseButton.modulate = "blue"
		
		attackButton.modulate = "#ffffff"
		magicButton.modulate = "#ffffff"
		itemButton.modulate = "#ffffff"
		commanButtonIndex = 3
		if Global.noKeyboard and get_parent().get_parent().canPress:
			
			if Input.is_action_just_released("leftClick"):
				if canDefense:
					canDefense = false
					$canDefense.start()
					
					currHp += hp /7
					currMp += mp/7
					if currMp > mp + self.addMp:
						currMp = mp + self.addMp
					speedBar = 0
					$Control/speedBar.value = 0
					if playerName == "时追云" and Global.gai:
						self.play("时追云改defend")
					else:
						self.play(playerName + "defend")
					self.get_node("battleCommends").visible = false
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()
		elif Global.noMouse:
			if Input.is_action_just_released("ui_accept"):		
				if canDefense:
					canDefense = false
					$canDefense.start()
					
					currHp += hp /7
					currMp += mp/7
					if currMp > mp + self.addMp:
						currMp = mp + self.addMp
					speedBar = 0
					$Control/speedBar.value = 0
					if playerName == "时追云" and Global.gai:
						self.play("时追云改defend")
					else:
						self.play(playerName + "defend")
					self.get_node("battleCommends").visible = false
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()					
					
					
					
								
	elif itemButton.has_focus() and Global.onMultiHit == 0:
		itemButton.modulate = "blue"
		commanButtonIndex = 4
		attackButton.modulate = "#ffffff"
		magicButton.modulate = "#ffffff"
		defenseButton.modulate = "#ffffff"
	
		if get_parent().get_parent().canPress:
			if Global.noKeyboard:
				return
			if Global.onAttackingList and itemList.size()>0:
				if Global.onItemSelectPicking == false and Global.onItemUsePicking == false and Global.onItemUsing == false and self.playerName == Global.onAttackingList[0]:
					
					if (Input.is_action_just_released("ui_accept") or Input.is_action_just_released("leftClick")) :
						$battleCommends.visible = false
						Global.onItemSelectPicking = true
						get_parent().get_node("magicDescription").visible = true
						get_parent().get_node("magicSelection").visible = true
						get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
						get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()				
						for i in itemList:
							magicScene = preload("res://Scene/itemButton.tscn")
							#magicScene = preload("res://Scene/itemSelection.tscn")
							var magicSceneInstance = magicScene.instantiate()
							
							magicSceneInstance.get_node("Button/name").text = i.info.name
							magicSceneInstance.get_node("Button/amount").text = ""
							magicSceneInstance.get_node("Button/icon").texture = load(i.info.icon)
							get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)		
	#设置在最后保证选择结束后显示总血量ui
	if Global.onMagicAttackPicking == false and Global.onAttackPicking == false and Global.onMagicSelectPicking == false and Global.onItemSelectPicking == false and !Global.onItemUsePicking:
		get_parent().get_node("Panel").visible = true
		
		get_parent().get_node("allyInfo").visible = false
	if Global.onAttacking:
		get_parent().get_node("Panel").visible = true
		
	if Global.usingDart:
		useDarts()	
		
		
##普通攻击
func attack(target, type):
	if randi_range(0,100) < FightScenePlayers.fightScenePlayerData.get(playerName).critChance + FightScenePlayers.fightScenePlayerData.get(playerName).addCritChance :
		crit = "crit"
	for child in target.get_node("hpControl").get_children():
		if child.name != "hpLabel":
			child.queue_free()
	if playerName == "狐葬魂":
		Global.getnode("oneTimeSound").stream = load("res://Audio/SE/兵器-钝器.ogg")
		Global.getnode("oneTimeSound").play()
	controlType = type

	if Global.onAttacking == false and canAttack:
		
		get_node("contBuff").visible = false		
		#Global.target = monsters[Global.targetMonsterIdx]
		#target = monsters[Global.targetMonsterIdx]
		if Global.target:
			targetPosition = Global.target.position
		else:
			targetPosition = monsters[0].position
		
		get_node("playerSound").stream = load(autoAttackSound)
		get_node("playerSound").play()
		if playerAttackType == "melee": #todo:之后可以把这个改成攻击形式，远程近战
			$Control.visible = false
			Global.onHitEnemy.append(Global.target)
			Global.target.get_node('selectIndic').visible = false
			Global.currPhysicDmg = self.currStr
			Global.currHitType = "physical"
			Global.target.self_modulate = "#ef1354"
			Global.target.get_node("getHitEffect").visible = true
			Global.target.get_node("getHitEffect").play("autoAttack")
		else:
			$Control.visible = false
			target.get_node('getHitEffect').visible = true
			target.get_node('getHitEffect').play(playerName + "autoAttack")
			for i in monsters:
				i.get_node('selectIndic').visible = false
			
			Global.onHitEnemy.append(Global.target)
			Global.currPhysicDmg = self.currStr
			Global.currHitType = "physical"
			target.self_modulate = "#ef1354"
			$playerSound.stream = load("res://Audio/SE/女-中性-出手.ogg")
			$playerSound.play()
			target.get_node("playerSound").stream = load("res://Audio/SE/法术1.ogg")
			target.get_node("playerSound").play()
		
		self.play(self.autoAttack)
		Global.onAttacking = true
		canAttack = false
		$canAttack.start()


func castMagic(delta, magic, target, type, onLastMagic):
	
	
	if Global.haveQianJi and playerName != "小二" and playerName != "小二真身" and ("小二" in Global.onTeamPlayer or "小二真身" in Global.onTeamPlayer):
		FightScenePlayers.eraseMagic("小二",FightScenePlayers.fightScenePlayerData["小二"].playerMagic[FightScenePlayers.fightScenePlayerData["小二"].playerMagic.size()-1].name)
		FightScenePlayers.learnMagic("小二",magic.name)
		print(magic.name,111)
		FightScenePlayers.eraseMagic("小二真身",FightScenePlayers.fightScenePlayerData["小二真身"].playerMagic[FightScenePlayers.fightScenePlayerData["小二真身"].playerMagic.size()-1].name)
		FightScenePlayers.learnMagic("小二真身",magic.name)		
		for i in players:
			if i.playerName == "小二":
				i.playerMagic = FightScenePlayers.fightScenePlayerData["小二"].playerMagic 
			if i.playerName == "小二真身":
				i.playerMagic = FightScenePlayers.fightScenePlayerData["小二真身"].playerMagic 				
	
	
	
#	if !is_instance_valid(target):
#		target = monsters[0]
	
	if Global.onMultiHit <= 1:			
		for i in players:
			if i.name == Global.onAttackingList[0]:
				i.currMp -= magic.cost
	Global.dealtDmg = 0
	Global.target = target
	if magic.name == "六月飞雪":
		Global.onHitEnemy = []
	
	var critRan = randi_range(0,100)
	if critRan <= critChance :
		crit = "crit"	
		
	if playerName == "朱雀":
		get_parent().get_node("朱雀影").visible = true
		get_parent().get_node("朱雀影").play("法术")
	if playerName == "青龙":
		get_parent().get_node("青龙影").visible = true
		get_parent().get_node("青龙影").play("施法")		
		
		
	magicControlType = type
	if onLastMagic:
		if is_instance_valid(castLastMagic.target):
			Global.target = castLastMagic.target
		else:
			Global.target = monsters[0]
	
	if magic.name != "千机变":
		castLastMagic.magicInfo = magic
		castLastMagic.target = target
		castLastMagic.type =  type
		Global.lastMagic.magicInfo = magic
		Global.lastMagic.target = target	
		Global.lastMagic.type =  type
	
	
	if magic.has("magicInfo"):
		Global.currUsingMagic = magic.magicInfo
	
	else:
		
		Global.currUsingMagic = magic


	if !is_instance_valid(target):
		if monsters.size() <= 0:
			return
		target = monsters[0]

		Global.currUsingMagic = castLastMagic.magicInfo

	get_parent().get_node("Panel").visible = true
	if Global.onMagicAttacking == false:
		get_parent().get_node("magicDescription").visible = false
		get_node("contBuff").visible = false
		get_parent().get_node("magicSelection").visible = false
		get_parent().get_node("magicName").visible = true
		get_parent().get_node("magicName/ColorRect/Label").text = magic.name 
		for child  in get_parent().get_node("magicSelection/GridBoxContainer").get_children():
			child.queue_free()	
		
		if Global.onAttackingList.size()>0:
			if self.name == Global.onAttackingList[0]:
				if playerName == "时追云" and Global.gai:
					self.play("时追云改magic")
					
				else:
					self.play(playerName + "magic")
		else:
			for i in players:
				if i.name == Global.onAttackingList[0]:
					if i.playerName == "时追云" and Global.gai:
						i.play("时追云改magic")
					else:
						i.play(i.playerName + "magic")
		if magic.has("audio"):
			get_node("playerSound").stream = load(magic.audio)
			get_node("playerSound").play()
		
		if magic.has("animationArea"):
			if magic.animationArea == "screen":
				if is_instance_valid(Global.target):
					Global.target.get_node("getHitEffect").visible = false
					get_parent().get_node("screenMagic").visible = true
					get_parent().get_node("screenMagic").play(magic.name)
				
			
			elif magic.animationArea == "enemy":
				if magicControlType == "keyboard":
					if is_instance_valid(Global.target):
						Global.target.get_node("getHitEffect").visible = true
						if magic.name == "真身现世":
							Global.target.get_node("getHitEffect").visible = false
						
						Global.target.get_node("getHitEffect").play(magic.name)
				else:
					target.get_node("getHitEffect").visible = true
					target.get_node("getHitEffect").play(magic.name)
#		elif magic.animationArea == "allie":
#			target.get_node("getHitEffect").visible = true
#			target.get_node("getHitEffect").modulate = "ff0000"
#			target.get_node("getHitEffect").play(magic.name)	
		if magic.attackType == "range":
			if magic.name == "逆天破":
				Global.target.get_node("逆天破").visible = true
				Global.target.get_node("逆天破/AnimationPlayer").play("show")
			if magic.effectArea == "aoe":
				Global.onHitEnemy = []
				if magicControlType == "keyboard":
					Global.onHitEnemy.append(Global.target)
				
				elif magicControlType == "mouse":
					Global.onHitEnemy.append(target)
				if monsters.size() < magic.effectingNum:
					for i in monsters:
						if monsters.size() >= magic.effectingNum:
							break
						Global.onHitEnemy.append(i)

				else:		
					while Global.onHitEnemy.size() < magic.effectingNum:
						var ranTarget = monsters[randi_range(0, monsters.size() - 1)]
						if !Global.onHitEnemy.has(ranTarget):
							Global.onHitEnemy.append(ranTarget)
				remove_duplicates_in_place(Global.onHitEnemy)		
				for targets in Global.onHitEnemy:
					if is_instance_valid(targets):
						
						targets.get_node("getHitEffect").visible = true
						
						targets.get_node("getHitEffect").play(magic.name)
						targets.self_modulate = "#ef1354"
						targets.play(remove_numbers_from_string(target.name) + 'hurt')
					
						if magic.damageSource == "AP":
							var damage_to_deduct = currMagicDmg  * magic.value * float(targets.magicDefense)/1000 		
							Global.dealtDmg = round(( currMagicDmg * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)
							
							
						elif magic.damageSource == "AD":
							var damage_to_deduct = currStr  * magic.value * float(target.physicDefense)/1000 		
							Global.dealtDmg = round((currStr  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)							
						
						Global.dealtDmg *= checkIncreaseDmg(magic)
						var disDamage = display_damage(round(Global.dealtDmg),"normal")
						targets.get_node("hpControl").add_child(disDamage)
						

			elif magic.effectArea == "single":
				if onLastMagic:
					Global.target = castLastMagic.target 

				if magicControlType == "keyboard":
					Global.onHitEnemy.append(Global.target)
				elif magicControlType == "mouse":
					Global.onHitEnemy.append(target)
				for targets in Global.onHitEnemy:
					if !is_instance_valid(targets):
						Global.onHitEnemy.append(monsters[0])
				for targets in Global.onHitEnemy:
					if is_instance_valid(targets):
						targets.get_node("getHitEffect").visible = true
						
						targets.get_node("getHitEffect").play(magic.name)
						targets.self_modulate = "#ef1354"
						targets.play(remove_numbers_from_string(target.name) + 'hurt')
						

						if magic.damageSource == "AP":
							var damage_to_deduct = currMagicDmg  * magic.value * float(target.magicDefense)/1000 		
							Global.dealtDmg = round((currMagicDmg  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)
						elif magic.damageSource == "AD":
							var damage_to_deduct = self.currStr  * magic.value * float(target.physicDefense)/1000 		
							Global.dealtDmg = round((self.currStr  * magic.value - damage_to_deduct +decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)		
						
						if  magic.name == "初始之力":
							if targets.type == "魔":
								Global.dealtDmg = magic.value
							else:
								Global.dealtDmg = 500
						elif  magic.name == "抽丝断魂":
								Global.dealtDmg = magic.value

						Global.dealtDmg *= checkIncreaseDmg(magic)
						var disDamage = display_damage(round(Global.dealtDmg),"normal")
						
						targets.get_node("hpControl").visible = true
						targets.get_node("hpControl").add_child(disDamage)				
						targets.get_node("hpAnimation").play("hpDrop")

					
				
				
			
		elif magic.attackType == "melee":
			var damage_to_deduct
			$Control.visible = false
			
			Global.currPhysicDmg = self.currStr
			Global.currHitType = "physical"
			if playerName == "时追云" and Global.gai:
				self.play("时追云改magicAutoAttack")
			else:
				self.play(playerName + "magicAutoAttack")

			if magicControlType == "keyboard":
				Global.onHitEnemy.append(Global.target)
				
				if Global.target != null:
					if magic.name == "小二真身":
						return 
					targetPosition = Global.target.position
					
					Global.target.get_node("getHitEffect").visible = true
					Global.target.get_node("getHitEffect").play(magic.name)				
					Global.target.self_modulate = "#ef1354"
					Global.target.get_node('selectIndic').visible = false
					
					damage_to_deduct = self.currStr * magic.value * float(Global.target.physicDefense)/1000 
					Global.dealtDmg =  (self.currStr * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))* Global.damageReward1
					Global.dealtDmg *= checkIncreaseDmg(magic)
					var disDamage
					if crit == "crit":
						disDamage = display_damage(round(Global.dealtDmg * 1.5),"crit")
					else:
						disDamage = display_damage(round(Global.dealtDmg),"normal")
					Global.target.get_node("hpControl").add_child(disDamage)
					Global.target.get_node("hpControl/hpLabel").modulate= "88ff00"
					Global.target.get_node("AnimationPlayer").play("hpControl")	
				
			else:
				Global.onHitEnemy.append(target)
				targetPosition = target.position
				target.self_modulate = "#ef1354"
				target.get_node("getHitEffect").visible = true				
				target.get_node("getHitEffect").play(magic.name)
				
				target.get_node('selectIndic').visible = false				
				damage_to_deduct = self.currStr * magic.value * float(target.physicDefense)/1000 
				Global.dealtDmg =  (self.currStr  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))* Global.damageReward1
				
				Global.dealtDmg *= checkIncreaseDmg(magic)
				
				if crit == "crit":
					var disDamage = display_damage(round(Global.dealtDmg * 1.5),"crit")
				else:
					var disDamage = display_damage(round(Global.dealtDmg),"normal")
				target.get_node("hpControl").add_child(disDamage)
				target.get_node("hpControl/hpLabel").modulate= "88ff00"
				target.get_node("AnimationPlayer").play("hpControl")	
				
	
			if magic.effectArea == "single":  
				pass
			else:
				pass
		elif magic.attackType == "multi":

				var damage_to_deduct
				$Control.visible = false
				if Global.target:
					Global.target.get_node("getHitEffect").visible = true
					Global.target.get_node("getHitEffect").play(magic.name)		
				if target:
					target.get_node("getHitEffect").visible = true				
					target.get_node("getHitEffect").play(magic.name)
				Global.currPhysicDmg = self.currStr
				Global.currHitType = "physical"
				if playerName == "时追云" and Global.gai:
					self.play("时追云改magicAutoAttack")
				else:
					self.play(playerName + "magicAutoAttack")

				if magicControlType == "keyboard":
					
					Global.onHitEnemy.append(target)
				
					if Global.target != null:
						targetPosition = Global.target.position
						
						
						Global.target.get_node("getHitEffect").visible = true
						Global.target.get_node("getHitEffect").play(magic.name)				
						Global.target.self_modulate = "#ef1354"
						Global.target.get_node('selectIndic').visible = false
						
						if magic.damageSource == "AP":
							damage_to_deduct = currMagicDmg * magic.value * float(target.magicDefense)/1000 		
							Global.dealtDmg = round((currMagicDmg  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)
						elif magic.damageSource == "AD":
							damage_to_deduct = self.currStr  * magic.value * float(target.physicDefense)/1000 		
							Global.dealtDmg = round((self.currStr  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)	
						
						Global.dealtDmg *= checkIncreaseDmg(magic)
						
#						var disDamage = display_damage(round(Global.dealtDmg),"normal")
#						Global.target.get_node("hpControl").add_child(disDamage)
#						#Global.target.get_node("hpControl/hpLabel").modulate= "88ff00"
#						Global.target.get_node("AnimationPlayer").play("hpControl")	
			
				else:
					Global.onHitEnemy.append(target)
					targetPosition = target.position
					target.self_modulate = "#ef1354"
					target.get_node("getHitEffect").visible = true				
					target.get_node("getHitEffect").play(magic.name)
					target.get_node('selectIndic').visible = false				
					if magic.damageSource == "AP":
						damage_to_deduct = currMagicDmg  * magic.value * float(target.magicDefense)/1000 		
						Global.dealtDmg = round((currMagicDmg  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)
					elif magic.damageSource == "AD":
						damage_to_deduct = self.currStr  * magic.value * float(target.physicDefense)/1000 		
						Global.dealtDmg = round((self.currStr  * magic.value - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)	

					Global.dealtDmg *= checkIncreaseDmg(magic)
					var disDamage = display_damage(round(Global.dealtDmg),"normal")
					target.get_node("hpControl").add_child(disDamage)
					#target.get_node("hpControl/hpLabel").modulate= "88ff00"
					target.get_node("AnimationPlayer").play("hpControl")	
					
		
				if magic.effectArea == "single":  
					pass
				else:
					pass
		elif magic.attackType == "buff":

			Global.currUsingMagic = magic
			
			if magicControlType == "keyboard":
				Global.allieTarget = players[Global.allieSelectIndex]
	
				Global.buffTarget.append(players[Global.allieSelectIndex])
			else:
				Global.allieTarget = self
				Global.buffTarget.append(self)

			if magic.effectingNum > players.size():
				for i in players:
					if players.size() >= magic.effectingNum:
						break
					Global.buffTarget.append(i)
			else:		
				while Global.buffTarget.size() < magic.effectingNum:
					var ranTarget = players[randi_range(0, players.size() - 1)]
					if !Global.buffTarget.has(ranTarget):
						Global.buffTarget.append(ranTarget)	
			
			
			for i in magic.buffEffect:
				
				for buffTarget in Global.buffTarget:
					if i == "currHp":					
						if buffTarget.alive == true:
							var disDamage = display_damage(round(magic.value),"heal")
							buffTarget.get_node("hpControl").add_child(disDamage)	
							#buffTarget.get_node("hpControl/hpLabel").text = str(magic.value)
							buffTarget.get_node("hpControl/hpLabel").modulate= "88ff00"
							buffTarget.get_node("AnimationPlayer").play("hpControl")
							if magicControlType == "keyboard":
								buffTarget.set(i, buffTarget.get(i) + magic.value)
							elif magicControlType == "mouse":
								buffTarget.set(i, target.get(i) + magic.value)
							buffTarget.get_node("getHitEffect").modulate = "ff0000"	
							buffTarget.get_node("getHitEffect").visible = true
							buffTarget.get_node("getHitEffect").play(magic.name)
					if i == "currMp":					
						if buffTarget.alive == true:
							var disDamage = display_damage(round(magic.value),"heal")
							buffTarget.get_node("hpControl").add_child(disDamage)	
							#buffTarget.get_node("hpControl/hpLabel").text = str(magic.value)
							buffTarget.get_node("hpControl/hpLabel").modulate= "blue"
							buffTarget.get_node("AnimationPlayer").play("hpControl")
							if magicControlType == "keyboard":
								buffTarget.set(i, buffTarget.get(i) + magic.value)
							elif magicControlType == "mouse":
								
								buffTarget.set(i, buffTarget.get(i) + magic.value)
							if buffTarget.currMp > buffTarget.mp + buffTarget.addMp:
								buffTarget.currMp = 	buffTarget.mp + buffTarget.addMp
								
							buffTarget.get_node("getHitEffect").modulate = "ff0000"	
							buffTarget.get_node("getHitEffect").visible = true
							buffTarget.get_node("getHitEffect").play(magic.name)					
					
					
					if i == "currPlayerSpeed":
						if buffTarget.onSpeedBuff:
							buffTarget.get_node("buffArea").visible = true
							buffTarget.get_node("buffArea").play("currPlayerSpeed")
						
						else:
							if buffTarget.alive == true:
								
								buffTarget.onSpeedBuff = magic.duration	
								for x in buffTarget.buffs:
									pass
								buffTarget.buffs.append({"onSpeedBuff": buffTarget.onSpeedBuff})
								buffTarget.tempSpeed = magic.value
								buffTarget.currPlayerSpeed += buffTarget.tempSpeed
								
								buffTarget.get_node("buffArea").visible = true
								buffTarget.get_node("buffArea").play("currPlayerSpeed")
								buffTarget.get_node("contBuff").visible = true
								buffTarget.get_node("contBuff").play("speed")
			
					if i == "contHp":
						
						var disDamage = display_damage(round(magic.value),"heal")
						buffTarget.get_node("hpControl").add_child(disDamage)	
						#buffTarget.get_node("hpControl/hpLabel").text = str(magic.value)
						buffTarget.get_node("hpControl/hpLabel").modulate= "88ff00"
						buffTarget.get_node("AnimationPlayer").play("hpControl")
						buffTarget.currHp += magic.value
						buffTarget.get_node("getHitEffect").visible = true
						buffTarget.get_node("getHitEffect").play(magic.name)						
						
						
						if buffTarget.onHealBuff:
							buffTarget.get_node("buffArea").visible = true
							buffTarget.get_node("buffArea").play("contHp")
						
						else:
							if buffTarget.alive == true:
								
								buffTarget.onHealBuff = magic.duration	
								for x in buffTarget.buffs:
									pass
								Global.healBuffAmount = magic.value
								buffTarget.buffs.append({"onHealBuff": buffTarget.onHealBuff})
								buffTarget.set("hp", buffTarget.get("hp") + magic.value)
								
								buffTarget.get_node("buffArea").visible = true
								buffTarget.get_node("buffArea").play("contHp")
								buffTarget.get_node("contBuff").visible = true
								buffTarget.get_node("contBuff").play("contHp")								
				
					if i == "currStr":
						if buffTarget.onAttackBuff:
							pass
						else:
							if buffTarget.alive == true:
								buffTarget.onAttackBuff = magic.duration
								buffTarget.buffs.append({"onAttackBuff": buffTarget.onAttackBuff})
								buffTarget.tempStr = magic.value
								buffTarget.currStr += buffTarget.tempStr
								buffTarget.get_node("buffArea").visible = true
								buffTarget.get_node("buffArea").play("currAttackDmg")					
								
								
					if i == "currMagicDmg":
						if buffTarget.onMagicBuff:
							pass
						else:
							if buffTarget.alive == true:
								buffTarget.onMagicBuff = magic.duration
								buffTarget.buffs.append({"onMagicBuff": buffTarget.onMagicBuff})
								buffTarget.set(i, buffTarget.get(i) + magic.value)			
					if i == "currPhysicDefense":
						if buffTarget.onPhysicDefenseBuff:
							pass
						else:
							if buffTarget.alive == true:
								buffTarget.onPhysicDefenseBuff = magic.duration
								
								buffTarget.buffs.append({"onPhysicDefenseBuff": buffTarget.onPhysicDefenseBuff})
								buffTarget.tempPhysicDefense = magic.value
								buffTarget.currPhysicDefense += buffTarget.tempPhysicDefense
								
					if i == "currMagicDefense":
						if buffTarget.onMagicDefenseBuff:
							pass
						else:
							if buffTarget.alive == true:
								buffTarget.onMagicDefenseBuff = magic.duration
								buffTarget.buffs.append({"onMagicDefenseBuff": buffTarget.onMagicDefenseBuff})
								buffTarget.tempMagicDefense = magic.value
								buffTarget.currMagicDefense += buffTarget.tempMagicDefense		
								buffTarget.get_node("buffArea").visible = true
								buffTarget.get_node("buffArea").play("currMagicDefense")								
								
					if i == "alive":
						if buffTarget.alive == true:
							pass
						else:
							buffTarget.alive = true		
							buffTarget.currHp = 300	
							buffTarget.play(buffTarget.playerName + "idle")
							buffTarget.get_node("Control").visible = true
															
					buffTarget.get_node('selectIndic').visible = true
			
					for p in players:
						if p.name == Global.onAttackingList[0]:
							if p.name == "时追云" and Global.gai:
								p.play("时追云改magic")
							else:
								p.play(p.name + "magic")
					
					#self.play(playerName + "法术")
					#buffTarget.set(i, target.get(i) + magic.value)
					
			
			pass
		elif magic.attackType == "debuff":
			Global.currUsingMagic = magic
			if magicControlType == "keyboard":
				Global.onHitEnemy.append(Global.target)
			else:
				Global.onHitEnemy.append(target)
			if monsters.size() < magic.effectingNum:
				for i in monsters:
					if monsters.size() >= magic.effectingNum:
							break
					Global.onHitEnemy.append(i)
			else:		
				while Global.onHitEnemy.size() < magic.effectingNum:
					var ranTarget = monsters[randi_range(0, monsters.size() - 1)]
					if !Global.onHitEnemy.has(ranTarget):
						Global.onHitEnemy.append(ranTarget)
			
			#self.play(playerName + "法术")
			
			for i in magic.buffEffect:
				for targets in Global.onHitEnemy:
					if targets:
						
						if i == "ice":
								Global.dealtDmg = 0
								targets.get_node("getHitEffect").visible = true
								targets.get_node("getHitEffect").play(magic.name)
					
						if i == "sleep":
								Global.dealtDmg = 0
								targets.get_node("getHitEffect").visible = true
								targets.get_node("getHitEffect").play(magic.name)
						if i == "physicDefenseDebuff":
								Global.dealtDmg = 0
								targets.get_node("getHitEffect").visible = true
								targets.get_node("getHitEffect").play(magic.name)									
								
								
		elif magic.attackType == "special":
			if magic.name == "火域":
				get_node("火域").visible = true
			
			if magic.name == "千机变":
				if Global.lastMagic.magicInfo != null:
					if Global.lastMagic.magicInfo.name == "千机变" or Global.lastMagic.magicInfo.name == "万符归元"  or Global.lastMagic.magicInfo.name == "真身现世" or Global.lastMagic.magicInfo.name == "横扫千军":
						pass
					elif Global.lastMagic.magicInfo.name == "横扫千军":
						Global.lastMagic.magicInfo.value * 0.7
						cast_magic_multiple_times(delta, Global.lastMagic.magicInfo, Global.lastMagic.target, Global.lastMagic.type,3)
					else:
						
						castMagic(delta, Global.lastMagic.magicInfo,Global.lastMagic.target, Global.lastMagic.type, false)
				else:
					pass
			if magic.name == "开阳":
				
				get_parent().get_parent().get_node("Sun").visible = true
				Global.currUsingMagic = magic
				if magicControlType == "keyboard":
					Global.onHitEnemy.append(Global.target)
				else:
					Global.onHitEnemy.append(target)
				if monsters.size() < magic.effectingNum:
					for i in monsters:
						i.modulate.a = 1
						i.get_node("getHitEffect").visible = true
						i.get_node("getHitEffect").play("开阳")
						if monsters.size() >= magic.effectingNum:
								break
						Global.onHitEnemy.append(i)
				else:		
					while Global.onHitEnemy.size() < magic.effectingNum:
						var ranTarget = monsters[randi_range(0, monsters.size() - 1)]
						if !Global.onHitEnemy.has(ranTarget):
							Global.onHitEnemy.append(ranTarget)
				for targets in Global.onHitEnemy:
					if targets:
						targets.canSee = true
			if magic.name == "真身现世":
				Global.onAttackingList[0] = "小二真身"
				
				self.name = "小二真身"
				self.playerName = "小二真身"
				self.idle = "小二真身idle"
				self.autoAttack = "小二真身autoAttack"		
				Global.onTeamPlayer.erase("小二")
				Global.onTeamPlayer.append("小二真身")			
				Global.onXiaoErZhenShen = true
				# 将此脚本附加到主场景的根节点
				var power = 60
				var is_shaking := false
				var original_offset := Vector2.ZERO
			
				if is_shaking:
					return  # 防止重复震动
				
				var viewport = get_viewport()
				original_offset = viewport.canvas_transform.origin
				is_shaking = true
				
				var tween = create_tween()
				tween.set_loops(roundi(2 / 0.1))  # 每 0.1 秒震动一次
				
				# 定义震动动画
				tween.tween_callback(func():
					var offset = Vector2(
						randf_range(-power, power),
						randf_range(-power, power))
					viewport.canvas_transform.origin = original_offset + offset
				).set_delay(0.0)
				
				tween.tween_callback(func():
					viewport.canvas_transform.origin = original_offset
				).set_delay(0.05)  # 0.05 秒后复位
				
				# 震动结束后恢复状态
				tween.tween_callback(func():
					viewport.canvas_transform.origin = original_offset
					is_shaking = false
				)
				
				tween.play()

				# 调用方式

				viewport.canvas_transform.origin = original_offset  # 恢复.
				$AudioStreamPlayer2D.stream = load("res://Audio/SE/猛兽2.ogg")
				$AudioStreamPlayer2D.play()						
				var 真身数据 = FightScenePlayers.get_真身数据()
				get_parent().get_node("小二脸").visible = true		
				get_parent().get_node("AnimationPlayer").play("moveFace")
				self.get_node("changeEffect").visible = true
				self.get_node("changeEffect").play()
				get_tree().current_scene.get_node("battleBgm").stream = load("res://Audio/BGM/BGM  修羅界  天地劫手遊 X 軒轅劍 天之痕.mp3")
				get_tree().current_scene.get_node("battleBgm").play()
				get_parent().get_parent().get_node("黑边").visible = true
				currPlayerSpeed = 真身数据.playerSpeed	
				currPhysicDefense = 真身数据.physicDefense
				currMagicDefense = 真身数据.magicDefense
				currStr = 真身数据.str
				critChance = 真身数据.critChance
				currMagicDmg = 真身数据.abilityPower
				totalHp = 真身数据.hp
				totalMp = 真身数据.mp
				self.autoAttackSound = 真身数据.autoAttackSound

			
						
						
			self.play(playerName + "法术")
		Global.onMagicAttackPicking = false
		Global.onMagicSelectPicking = false

		Global.onMagicAttacking = true

		if crit == "crit":
			Global.dealtDmg *= 1.5
			
	
	for i in FightScenePlayers.fightScenePlayerData.get(self.name).playerMagic:
		
		if i.name == Global.currUsingMagic.name and i.has("needExp"):
			i.currExp += 1
#	for child in target.get_node("hpControl").get_children():
#		if child.name != "hpLabel":
#			child.queue_free()	
	if Global.onMultiHit:
		if crit == "normal":
			disDamage = display_damage(round(Global.dealtDmg),"normal")
		else:
			disDamage = display_damage(round(Global.dealtDmg),"crit")
		target.get_node("hpControl").add_child(disDamage)
		target.get_node("hpAnimation").play("hpDrop")
		target.play(remove_numbers_from_string(target.name) + "idle")		
		
			
func useItem(item, target, type):
	get_parent().get_parent().canPress = false
	get_parent().get_parent().get_node("canPressTimer").start()
	itemControlType = type
	Global.currUsingItemPlayer = self
	#Global.currUsingItem  = item
	Global.itemControlType = type
	FightScenePlayers.battleItem.get(Global.currUsingItem.info.name).number -=1
	if FightScenePlayers.battleItem.get(Global.currUsingItem.info.name).number < 1:
		for child  in get_parent().get_node("magicSelection/GridBoxContainer").get_children():
			if child.get_node("Button/name").text == Global.currUsingItem.info.name:
				child.queue_free()
		FightScenePlayers.battleItem.erase((Global.currUsingItem.info.name))
		Global.itemSelectIndex = 0
		if itemList.size() <= 0:
			pass


	get_parent().get_node("Panel").visible = true
	if Global.onItemUsing == false:
		get_parent().get_node("magicDescription").visible = false
		get_node("contBuff").visible = false
		get_parent().get_node("magicSelection").visible = false
		get_parent().get_node("magicName/ColorRect/Label").text = item.info.name
		for child  in get_parent().get_node("magicSelection/GridBoxContainer").get_children():
			child.queue_free()	

			
			
				
		#self.play(playerName + "magic")
#		get_node("playerSound").stream = load(item.audio)
#		get_node("playerSound").play()	

		if Global.currUsingItem.info.effect == "mp":
			
			if itemControlType == "keyboard":
				Global.target.currMp += Global.currUsingItem.info.value
				
				#Global.target.get_node("hpControl/hpLabel").text = str(Global.currUsingItem.info.value)
				var disDamage = display_damage(round(Global.currUsingItem.info.value),"heal")
				Global.target.get_node("hpControl").add_child(disDamage)
				Global.target.get_node("hpControl/hpLabel").modulate= "blue"
				Global.target.get_node("AnimationPlayer").play("hpControl")
			else:
				target.currMp += Global.currUsingItem.info.value
				var disDamage = display_damage(round(Global.currUsingItem.info.value),"heal")
				Global.target.get_node("hpControl").add_child(disDamage)
				target.get_node("hpControl/hpLabel").modulate= "blue"
				target.get_node("AnimationPlayer").play("hpControl")				
			self.get_node("playerSound").stream = load(item.info.audio)
			self.get_node("playerSound").play()			
		if Global.currUsingItem.info.effect == "hp":
			
			if itemControlType == "keyboard":
				Global.target.currHp += Global.currUsingItem.info.value
				
				#Global.target.get_node("hpControl/hpLabel").text = str(Global.currUsingItem.info.value)
				var disDamage = display_damage(round(Global.currUsingItem.info.value),"heal")
				Global.target.get_node("hpControl").add_child(disDamage)
				Global.target.get_node("hpControl/hpLabel").modulate= "88ff00"
				Global.target.get_node("AnimationPlayer").play("hpControl")
			else:
				target.currHp += Global.currUsingItem.info.value
				var disDamage = display_damage(round(Global.currUsingItem.info.value),"heal")
				Global.target.get_node("hpControl").add_child(disDamage)
				target.get_node("hpControl/hpLabel").modulate= "88ff00"
				target.get_node("AnimationPlayer").play("hpControl")				
			self.get_node("playerSound").stream = load(item.info.audio)
			self.get_node("playerSound").play()	
			
			
		if Global.currUsingItem.info.effect == "damage" and Global.onItemUsing == false:
			Global.onItemUsing = true
			var instance = preload("res://Scene/dart.tscn").instantiate()
			instance.position = self.position + Vector2(0, -20)
			get_parent().add_child(instance)
			$playerSound.stream = preload("res://Audio/SE/100-Attack12.ogg")
			$playerSound.play()
			if Global.itemControlType == "keyboard":
				Global.target = monsters[Global.targetMonsterIdx]
				Global.target.play(remove_numbers_from_string(Global.target.name) + "hurt")
				Global.target.self_modulate = "#ef1354"
				Global.usingDart = true
			elif Global.itemControlType == "mouse":
				#target = monsters[Global.targetMonsterIdx]
				
				target.play(remove_numbers_from_string(Global.target.name) + "hurt")
				target.self_modulate = "#ef1354"
				Global.usingDart = true		
		Global.onAttackingList.pop_front()
		Global.battleButtonIndex = 0
		
func useDarts():

	get_parent().get_parent().useDart(itemControlType,target, currDelta)
	
	
func moveCharacter(delta):

	var moveSpeed = 30
	if canMove:
		var newPosition = position.lerp(targetPosition, moveSpeed * 0.03)
		
		position.x = newPosition.x
		position.y = newPosition.y  
		if self.playerName == "时追云":
			position.x = newPosition.x - 25
			position.y = newPosition.y - 25		
		
func moveMulti(delta):

	if playerName == "狐葬魂":
		return
	var moveSpeed = 30

	
	if canMove:
		if is_instance_valid(Global.target):
			multiPosition = Global.target.position
		else:
			Global.target = monsters[0]
		
		var newPosition = position.lerp(multiPosition, moveSpeed * 0.03)
		
		position.x = newPosition.x
		position.y = newPosition.y  
		
		
func remove_numbers_from_string(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not char.is_valid_int():
			result += char
	return result



func _on_attack_wait_time_timeout():
	attackWaitTimeOver = true


func _on_can_attack_timeout():
	canAttack = true


func _on_attack_button_button_down():
	#Global.onAttackPicking = true
	#canSelect = false
	#$canSelect.start()
	#attackButton.grab_focus()
	Global.battleButtonIndex = 0

func _on_magic_button_button_down():
	Global.battleButtonIndex = 1

func _on_defense_button_button_down():
	Global.battleButtonIndex = 2
	

func _on_item_button_button_down():
	
	
	Global.battleButtonIndex = 3
	if itemList.size() <= 0:
		return
	if Global.noKeyboard:
		get_parent().get_parent().canPress = false
		get_parent().get_parent().get_node("canPressTimer").start()
		$battleCommends.visible = false
		Global.onItemSelectPicking = true
		get_parent().get_node("magicDescription").visible = true
		get_parent().get_node("magicSelection").visible = true
		get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
		get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()				
		for i in itemList:
			magicScene = preload("res://Scene/itemButton.tscn")
			#magicScene = preload("res://Scene/itemSelection.tscn")
			var magicSceneInstance = magicScene.instantiate()

			magicSceneInstance.get_node("Button/name").text = i.info.name
			magicSceneInstance.get_node("Button/amount").text = ""
			magicSceneInstance.get_node("Button/icon").texture = load(i.info.icon)
			get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)	
func _on_can_select_timeout():
	canSelect = true


func _on_button_button_down():
	if Global.onMultiHit !=0:
		return
	if Global.onItemUsePicking:
		if Global.currUsingItem.info.effect  == "hp":
			useItem(Global.currUsingItem, self, "mouse")
			Global.onItemUsePicking = false
			itemControlType = "mouse"
		else:
			return
	elif Global.onMagicAttackPicking:
		if Global.currUsingMagic.attackType != "buff":
			return
		castMagic(currDelta ,Global.currUsingMagic, self, "mouse",false)
		
func display_damage(damage, type):
#	if is_instance_valid(target):
#		for child in target.get_node("hpControl").get_children():
#			if child.name != "hpLabel":
#				child.queue_free()	
#
#	if is_instance_valid(Global.target):
#		for child in Global.target.get_node("hpControl").get_children():
#			if child.name != "hpLabel":
#				child.queue_free()
				
	
			
	var damage_str = str(damage)
	var offset_x = 0
	var damage_node = Node2D.new()
	
	for digit in damage_str:
		digit_sprite = Sprite2D.new()
		if type == "normal":
			digit_sprite.texture = load(digit_image_path + "23-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(0.6, 0.6)
			
		elif type == "crit":
		
			digit_sprite.texture = load(digit_image_path + "22-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(0.6, 0.6)
			offset_x += 0
		elif type == "heal":
			digit_sprite.texture = load(digit_image_path + "21-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(0.6, 0.6)
		digit_sprite.position.x = offset_x
		damage_node.add_child(digit_sprite)
		offset_x += digit_sprite.texture.get_width()-10# Adjust this value as needed
	return damage_node


func _on_can_defense_timeout():
	canDefense = true



func _on_can_move_timeout():
	canMove = true

func removeNumber():
	
	var child = $hpControl.get_children()
	for i in child:
		if i.name != "hpLabel":
			i.queue_free()


func _on_button_mouse_entered():
	if Global.onMultiHit >0:
		return
	Global.target = self
	for i in players:
		i.get_node("selectIndic").visible = false	
	
	self.get_node("selectIndic").visible = true
	self.get_node("AnimationPlayer").play("selectIndic")
	get_parent().get_node("allyInfo/allyName").text = players[Global.allieSelectIndex].name
	get_parent().get_node("allyInfo/hpBar").max_value = players[Global.allieSelectIndex].totalHp
	
	get_parent().get_node("allyInfo/hpBar").value = players[Global.allieSelectIndex].currHp
	
	get_parent().get_node("allyInfo/hpBar/Label2").text = str(players[Global.allieSelectIndex].currHp) + "/" + str(players[Global.allieSelectIndex].totalHp)
	
	get_parent().get_node("allyInfo/manaBar").max_value = players[Global.allieSelectIndex].totalMp
	get_parent().get_node("allyInfo/manaBar").value = players[Global.allieSelectIndex].currMp
	get_parent().get_node("allyInfo/manaBar/Label2").text = str(players[Global.allieSelectIndex].currMp) + "/" + str(players[Global.allieSelectIndex].totalMp)	
	
	
	
	for i in players.size():
		if players[i] == self:
			Global.allieSelectIndex = i
	self.self_modulate = "98ffff"
	


func _on_button_mouse_exited():
	self.self_modulate = "ffffff"
func checkIncreaseDmg(magic):
	for i in Global.onHitEnemy:
		if is_instance_valid(i):
			if i.name == "时追云" or i.name == "姜韵" or i.name == "敖雨" or i.name == "敖阳" or i.name == "大海龟" or i.name == "小二" or i.name == "金甲" or i.name == "凌若昭":
				return 1
			elif i.type == "龙" and magic.name == "斩龙决":
						
				return 5
			elif i.type == "鬼" and magic.name == "破暗":
				return 3.5
				
			else:
				return 1

				
				
				
				
func cast_magic_multiple_times(delta, magic, target, input_type, times):

	
	
	Global.onMultiHit = times
	Global.canCalculateAfterMulti = false

	for i in range(times):
		if  monsters.size() <= 0:
			return
		
#		if !is_instance_valid(target):
#			target = monsters[0]
#			if Global.onMultiHit:
#				Global.onMultiHit -= 1
#
		castMagic(delta, magic, target, input_type,false)
		
		delay_timer.wait_time = 2 # Delay time in seconds
		delay_timer.one_shot = true
		delay_timer.start()
		await delay_timer.timeout
		if !is_instance_valid(target) and monsters.size()>0:
			target = monsters[0]		


func _on_can_calculate_after_multi_timeout():
	Global.canCalculateAfterMulti = true
func decrypt(value):
	return value / Global.enKey
func 朱雀auto():
	self.play(self.autoAttack)
	Global.onAttacking = true
	canAttack = false
	Global.onAttackPicking = false
	canSelect = false
	$canAttack.start()		


func _on_area_2d_area_entered(area):
	
	var target = area.get_parent()
	if target.is_in_group("monster") and get_node("火域").visible and !target.hitByCircle:
	
		var damage_to_deduct = currMagicDmg  * 2 * float(target.magicDefense)/1000 		
		target.currHp -= round(( currMagicDmg * 2 - damage_to_deduct + decrypt(FightScenePlayers.fightScenePlayerData.get(self.name).additionDmg))*Global.damageReward1)		
		target.get_node("circleTime").start()
		target.hitByCircle = true
		target.get_node("灼烧").play()
		if target.currHp <= 0:
			Global.onAttackingList.erase(target.name)
			Global.onAttacking = false
			get_node("getHitEffect").visible = false
			


func _on_can_attack_after_multi_timeout():
	canAttack = true
func roll_dice_with_luck(luck: int) -> int:
	# 保证 luck 范围在 0~100
	luck = clamp(luck, 0, 100)

	# 使用带偏向的指数插值：0 趋近 0，100 趋近 1
	# 可调节 power 参数控制倾斜程度（越大越陡）
	var power = 4
	var bias = pow(float(luck) / 100.0, power)

	# 生成一个偏斜的随机数，0~1 之间
	var r = randf()
	var skewed = lerp(r, 1.0, bias)

	# 转换为 1~6 点
	return clamp(int(floor(skewed * 6.0)) + 1, 1, 6) 
func remove_duplicates_in_place(arr: Array):
	var i = 0
	while i < arr.size():
		if arr.count(arr[i]) > 1:
			arr.remove_at(i)
		else:
			i += 1
