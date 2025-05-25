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
@export var onHealBuff = false
@export var onSpeedBuff = false
@export var onAttackBuff = false
@export var onMagicBuff = false
@export var onPhysicDefenseBuff = false
@export var onMagicDefenseBuff = false
@export var onPoisonDebuff = false
@export var onIceDebuff = false
@export var onSleepDebuff = false
@export var type = ""
@export var luck = 0
@export var autoAttackSound = ""
var posi = "middle"
var digit_sprite
var digit_image_path = "res://数字/"
var healBuffAmount = 0
var poisonDebuffAmount = 0
var gold = 0
var target
var onIce = false
var onSleep = false
var players = []
var dead = false
var canAttack = false
@export var delay_timer: Timer
var oriMonsterName 
var monsters
#var selectedTarget = false
var buffs = []
var treeHealed = false
var onMagicDefenseDebuff = false
var onPhysicDefenseDebuff = false
var canAttackTimerStarted = false
var canSee = true
var round = 1
var magicInfo
var autoPlayed
var monsterAndMagic ={"巨蛙":{"name":"水漫金山","round":3}, 
						"奔霸":{"name":"水满金山","round":4}, 
						"大鹏":{"name":"奔雷","round":3}, 
						"鹰孽大王":{"name":"天火陨石","round":4}
						,"堕逝":{"name":"风雨雷电","round":4}
						,"黑山":{"name":"硝爆","round":4}
						,"鬼将军":{"name":"血傀","round":4}						
						,"鬼帝":{"name":"血傀","round":2}
						
						}
var bigMagics ={
	"水漫金山":{
		"name": "水漫金山",
		"damage": 1.2,
		"attackType": "range",
		"effectingNum":8,
		"animationArea": "enemy",
		"audio": "res://Audio/SE/法术12.ogg",
	},
	"水满金山":{
		"name": "水满金山",
		"damage": 2,
		"attackType": "range",
		"effectingNum":8,
		"animationArea": "enemy",
		"audio": "res://Audio/SE/法术12.ogg",
	},	
	
	
	"奔雷":{
		"name": "奔雷",
		"attackType": "range",
		"damage": 1.6, 
		"cost": 50,
		"description": "群体法术",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术3.ogg"
	},
	"天火陨石":{
		"name": "天火陨石",
		"attackType": "range",
		"damage": 1.8, 
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/142-Burst02.ogg"
	},
	"风雨雷电":{
		"name": "风雨雷电",
		"attackType": "range",
		"damage": 1.6, 
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/风 (2).wav"
	},
	"硝爆":{
		"name": "硝爆",
		"attackType": "range",
		"damage": 3.5, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/049-Explosion02.ogg"
	},	
	"血傀":{
		"name": "血傀",
		"attackType": "range",
		"damage": 1000, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/140-Darkness03.ogg"
	},	
}
@export var shader_material: ShaderMaterial


func _ready(): 

	if type == "鬼":
		canSee = false

	oriMonsterName = monsterName
	monsterName = remove_numbers_from_string(monsterName)
	
	if monsterName == "怨蛛":
		self.scale.x = -1
		self.modulate = "red"
	target = Global.target
	currHp = hp
	
	if monsterAndMagic.get(monsterName) != null:
		magicInfo = bigMagics.get(monsterAndMagic.get(monsterName).name)		
		round = monsterAndMagic.get(monsterName).round 
		
	if monsterName in Global.isBoss:
		get_parent().get_node("roundCountDown").visible = true
		get_parent().get_node("roundCountDown").text = str(round)
	
var gotHit = false
var randi = 0
var magicRandi = 0

var fightScenePlayer
var currPlayer
var deltas
var itemList = []





func _process(delta):
	
	if canSee == false:
		Global.dealtDmg = 0
		self.modulate.a = 0.2
	else:
		self.modulate.a = 1
		
		
	if onMagicDefenseDebuff:
		magicDefense = magicDefense * 0.3
	if onPhysicDefenseDebuff:
		physicDefense = physicDefense * 0.3
	
	if self.name == "千年树0":
		self.scale.x = 2
		self.scale.y = 2
	if self.name == "金翅大鹏0":
		self.scale.x = 1.2
		self.scale.y = 1.2		
		
	if Global.canBlock and self.hp > 0:
		if Input.is_action_just_pressed("ui_accept"):
			Global.blocked = true
			Global.canBlock = false
			get_tree().current_scene.get_node("battleFieldLayer/battleField/battleFieldPicture/blockButton").visible = false
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
		if Global.onAttackPicking == false and Global.onMultiHit == 0 and Global.onAttacking == false and Global.onMagicAttackPicking == false and Global.onMagicAttacking == false and Global.onMagicSelectPicking == false:
			speedBar += speed * delta

#	if onIce:
#		$debuff.play("冰封")
#	if onPhysicDefenseDebuff:
#		$debuff.play("破甲")	
#	if Global.monsterTarget:

		

	if speedBar >= 100:
		if monsterName in Global.isBoss and !self.onIce:
			round -= 1
			get_parent().get_node("roundCountDown").text = str(round)
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
		for buff in buffs:
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
			if "onMagicDefenseDebuff" in buff:
				buff["onMagicDefenseDebuff"] -= 1
				if buff["onMagicDefenseDebuff"] <= 0:
					buffs.erase(buff)		
			if "onPhysicDefenseDebuff" in buff:
				buff["onPhysicDefenseDebuff"] -= 1
				if buff["onPhysicDefenseDebuff"] <= 0:
					buffs.erase(buff)							
																																		
		if onHealBuff:
			onHealBuff -= 1
			currHp += healBuffAmount
			if onHealBuff <= 0:
				onHealBuff = false

		if onPoisonDebuff:	
			onPoisonDebuff -= 1
			currHp -= poisonDebuffAmount
			FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)
			if onPoisonDebuff <= 0:
				onPoisonDebuff = false
		if onMagicDefenseDebuff:
			onMagicDefenseDebuff -= 1
			if onMagicDefenseDebuff == 0:
				onMagicDefenseDebuff = false
		if onPhysicDefenseDebuff:
			onPhysicDefenseDebuff -= 1
			if onPhysicDefenseDebuff == 0:
				onPhysicDefenseDebuff = false						
		
	#检测当前onAttackingList的是不是自己，是的话就触发选择玩家攻击	
	if Global.onAttackingList.size() > 0 and Global.canEnemyHit:
		if monsterName and self.currHp <= 0 and !dead:
			dead = true
			currHp = 0
			Global.targetMonsterIdx = 0 
			alive = false
			var deadSound = randi_range(0,1)
			if deadSound == 0:
				$deadSound.stream = load("res://Audio/SE/012-System12.ogg")
			else:
				$deadSound.stream = load("res://Audio/SE/小妖-倒地.ogg")
			$deadSound.play()
			
			$deadAnimationPlayer.play("deadAnimation")
			$deadTimer.start()  # Start the timer only once when hp is less than or equal to 0
			self.self_modulate = "#ef1354"
			self.get_node("hpAnimation").play("hpDrop")
			self.play(monsterName + "hurt")
			gotHit = true 
			return
		if !Global.onHitEnemy and monsterName and alive and Global.onAttackingList[0] != name:
			self.play(monsterName + "idle")
		if name == Global.onAttackingList[0] and alive and Global.selectedTarget == false and Global.onItemUsing == false :
			if monsterMagicList.size() > 0:
				randi = randi_range(0,1)
				if self.round == 0:
					randi = 2
			else:
				randi = 0
			treeHealed = false
			
			if !canAttackTimerStarted:
				canAttackTimerStarted = true
				$canAttack.start()
			
			if Global.canAttack:

				magicRandi = randi_range(0, monsterMagicList.size()-1)
				selectTarget(delta, randi, magicRandi)
				get_tree().current_scene.get_node("subSound").stream = load("")
				get_tree().current_scene.get_node("subSound").play()
		elif name == Global.onAttackingList[0] and Global.selectedTarget == false:
			Global.onAttackingList.pop_front()

	#结束攻击后恢复原状,计算伤害
		if Global.monsterTarget != null and Global.onAttackingList[0] == name and randi == 0:
			playAutoSound()		
			if self.name == "千年树0" and treeHealed == false:
			
				treeHealed = true
				self.currHp += 100
				$hpControl.visible = true
				var disDamage = display_damage(50,"heal")
				get_node("hpControl").add_child(disDamage)
				get_node("hpControl/hpLabel").modulate= "88ff00"
				get_node("hpAnimation").play("hpDrop")
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

				autoPlayed = false
				var damage_to_deduct = self.attackDmg  * float(Global.alivePlayers[Global.monsterTarget].currPhysicDefense)/ float(1000)
				Global.dealtDmg =  self.attackDmg - damage_to_deduct
		
				
				
				if Global.blocked:
					Global.dealtDmg /= 2
				Global.blocked = false
				Global.canBlock = false
				get_tree().current_scene.get_node("battleFieldLayer/battleField/battleFieldPicture/blockButton").visible = false
				
				Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)
				if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
					Global.alivePlayers[Global.monsterTarget].alive = false
					Global.alivePlayers[Global.monsterTarget].get_node("Control").visible = false
					Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "dead")
					get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
					get_tree().current_scene.get_node("oneTimeSound").play()								
				
				
				
				Global.wait = true
				$waitTimer.start()
				FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)
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
			if monsterMagicList.size()>0 and monsterMagicList[magicRandi].attackType == "range":
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

							
							
							FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)
							Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
							Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")
							if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
								
								Global.alivePlayers[Global.monsterTarget].alive = false
								Global.alivePlayers[Global.monsterTarget].get_node("Control").visible = false
								Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "dead")
							
								get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
								get_tree().current_scene.get_node("oneTimeSound").play()							
							
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
							i.play(i.playerName + "idle")
							FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)	
							if i.currHp <= 0:
							
								i.alive = false
								i.get_node("Control").visible = false
								
								i.play(i.playerName + "dead")
							
								get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
								get_tree().current_scene.get_node("oneTimeSound").play()									
							
							i.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
							i.get_node('Control/hpBar').value = i.currHp
							i.get_node("getHitEffect").stop()
							i.get_node("getHitEffect").visible = false
							
							self.play(monsterName + "idle")
							Global.onAttackingList.pop_front()
							Global.onAttacking = false
							
							Global.monsterTarget = null
							position = monsterPosition
							Global.selectedTarget = false					
							Global.onHitPlayer = []
							Global.canEnemyHit = false
							$"攻击间隔".start()
						
			elif monsterMagicList.size()> 0 and monsterMagicList[magicRandi].attackType == "melee":
				moveCharacter(delta)			
				if Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").animation == "monsterAutoAttack" and Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").is_playing() == false:
				
					if monsterMagicList[magicRandi].effectArea == "single" and Global.monsterTarget >= 0 and Global.monsterTarget < Global.alivePlayers.size():
						
						Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").stop()
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "hurt")
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
						var damage_to_deduct = self.magicDmg  *  monsterMagicList[randi_range(0, magicRandi)].damage * float(Global.alivePlayers[Global.monsterTarget].currMagicDefense)/ float(1000)
						Global.dealtDmg =  self.magicDmg *  monsterMagicList[magicRandi].damage - damage_to_deduct
						
						Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)	
						FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)	
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
						Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")
						if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
						
							Global.alivePlayers[Global.monsterTarget].alive = false
							Global.alivePlayers[Global.monsterTarget].get_node("Control").visible = false
							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "dead")
							
							get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
							get_tree().current_scene.get_node("oneTimeSound").play()								
						
						
						self.play(monsterName + "idle")
						Global.onAttackingList.pop_front()
						Global.onAttacking = false
						
						Global.monsterTarget = null
						position = monsterPosition
						Global.selectedTarget = false					
						Global.onHitPlayer = []
						Global.canEnemyHit = false
						$"攻击间隔".start()						
	
			elif monsterMagicList.size()>0 and monsterMagicList[magicRandi].attackType == "debuff":
				if Global.onHitPlayer.size()>0 and Global.onHitPlayer[0].get_node("getHitEffect").animation == monsterMagicList[magicRandi].name and Global.onHitPlayer[0].get_node("getHitEffect").is_playing() == false:
					for i in Global.onHitPlayer:
						if monsterMagicList[magicRandi].debuffType == "ice":
							i.onIceDebuff = monsterMagicList[magicRandi].duration
						i.self_modulate = "#ffffff"
						i.get_node("AnimationPlayer").stop()
						#i.play(i.playerName + "hurt")
						i.get_node("hpControl/hpLabel").modulate = "c80038"
						i.get_node("AnimationPlayer").play("hpControl")

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


		elif Global.monsterTarget != null or Global.onHitPlayer.size()>0 and Global.onAttackingList[0] == name and randi == 2:
			if monsterMagicList.size()>0 and magicInfo.attackType == "range":
				if monsterMagicList.size() > 0 and magicInfo.effectingNum == 1:
					if Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").animation == magicInfo.name and Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").is_playing() == false:
					
						if magicInfo.effectingNum == 1 and Global.monsterTarget >= 0 and Global.monsterTarget < Global.alivePlayers.size():
							
							Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
							Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").stop()
							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "hurt")
							Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
							Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
							var damage_to_deduct =  magicInfo.damage * self.magicDmg * float(Global.alivePlayers[Global.monsterTarget].currMagicDefense)/ float(1000)
							Global.dealtDmg =   magicInfo.damage * self.magicDmg - damage_to_deduct
							
							Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)		

							
							
							FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)
							Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
							Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")
							if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
					
								Global.alivePlayers[Global.monsterTarget].alive = false
								Global.alivePlayers[Global.monsterTarget].get_node("Control").visible = false
								Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "dead")
						
								get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
								get_tree().current_scene.get_node("oneTimeSound").play()							
							
							self.play(monsterName + "idle")
							Global.onAttackingList.pop_front()
							Global.onAttacking = false
							
							Global.monsterTarget = null
							position = monsterPosition
							Global.selectedTarget = false					
							Global.onHitPlayer = []
							Global.canEnemyHit = false
							$"攻击间隔".start()
				

							
				elif monsterMagicList.size() > 0 and  magicInfo.effectingNum > 1:		
					if Global.onHitPlayer.size()>0 and Global.onHitPlayer[0].get_node("getHitEffect").animation == magicInfo.name and Global.onHitPlayer[0].get_node("getHitEffect").is_playing() == false:
					
						for i in Global.onHitPlayer:
							i.self_modulate = "#ffffff"
							i.get_node("AnimationPlayer").stop()
							#i.play(i.playerName + "hurt")
							i.get_node("hpControl/hpLabel").modulate = "c80038"
							i.get_node("AnimationPlayer").play("hpControl")
					
							var damage_to_deduct = magicInfo.damage * self.magicDmg * float(i.currMagicDefense)/ float(1000)
							Global.dealtDmg =  magicInfo.damage * self.magicDmg - damage_to_deduct
							
							i.currHp -= round(Global.dealtDmg)	
							i.play(i.playerName + "idle")
							FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)	
							if i.currHp <= 0:
							
								i.alive = false
								i.get_node("Control").visible = false
								
								i.play(i.playerName + "dead")
							
								get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
								get_tree().current_scene.get_node("oneTimeSound").play()									
							
							i.get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
							i.get_node('Control/hpBar').value = i.currHp
							i.get_node("getHitEffect").stop()
							i.get_node("getHitEffect").visible = false
							
							self.play(monsterName + "idle")
							Global.onAttackingList.pop_front()
							Global.onAttacking = false
							
							Global.monsterTarget = null
							position = monsterPosition
							Global.selectedTarget = false					
							Global.onHitPlayer = []
							Global.canEnemyHit = false
							$"攻击间隔".start()
						
			elif monsterMagicList.size()> 0 and magicInfo.attackType == "melee":
				moveCharacter(delta)			

				if Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").animation == "monsterAutoAttack" and Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").is_playing() == false:
				
					if magicInfo.effectingNum == 1 and Global.monsterTarget >= 0 and Global.monsterTarget < Global.alivePlayers.size():
						
						Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").stop()
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "hurt")
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").modulate = "c80038"
						Global.alivePlayers[Global.monsterTarget].get_node("AnimationPlayer").play("hpControl")
						var damage_to_deduct =  magicInfo.damage  * self.magicDmg * float(Global.alivePlayers[Global.monsterTarget].currMagicDefense)/ float(1000)
						Global.dealtDmg =   magicInfo.damage  * self.magicDmg - damage_to_deduct
						
						Global.alivePlayers[Global.monsterTarget].currHp -= round(Global.dealtDmg)	
						FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)	
						Global.alivePlayers[Global.monsterTarget].get_node("hpControl/hpLabel").text = str(round(Global.dealtDmg))
						Global.alivePlayers[Global.monsterTarget].get_node('Control/hpBar').value = Global.alivePlayers[Global.monsterTarget].currHp
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
						Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "idle")
						if Global.alivePlayers[Global.monsterTarget].currHp <= 0:
						
							Global.alivePlayers[Global.monsterTarget].alive = false
							Global.alivePlayers[Global.monsterTarget].get_node("Control").visible = false
							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "dead")
						
							get_tree().current_scene.get_node("oneTimeSound").stream = load("res://Audio/SE/011-System11.ogg")
							get_tree().current_scene.get_node("oneTimeSound").play()								
						
						
						self.play(monsterName + "idle")
						Global.onAttackingList.pop_front()
						Global.onAttacking = false
						
						Global.monsterTarget = null
						position = monsterPosition
						Global.selectedTarget = false					
						Global.onHitPlayer = []
						Global.canEnemyHit = false
						$"攻击间隔".start()						
	
			elif monsterMagicList.size()>0 and monsterMagicList[magicRandi].attackType == "debuff":
				pass
				
				
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
			var deadSound = randi_range(0,1)
			if deadSound == 0:
				$deadSound.stream = load("res://Audio/SE/011-System12.ogg")
			else:
				$deadSound.stream = load("res://Audio/SE/小妖-倒地.ogg")
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
		
		var blockChance = FightScenePlayers.fightScenePlayerData.get(Global.alivePlayers[Global.monsterTarget].name).blockChance +  FightScenePlayers.fightScenePlayerData.get(Global.alivePlayers[Global.monsterTarget].name).addBlockChance
		if randi_range(0,100) <= blockChance:
			Global.canBlock = true
			get_tree().current_scene.get_node("battleFieldLayer/battleField/battleFieldPicture/blockButton").visible = true
				
		
		
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

		
	elif randi == 1 and Global.alivePlayers.size()>0:#使用法术
		if monsterMagicList.size()>0:

			$effectSound.stream = load(monsterMagicList[magicRandi].audio)
			$effectSound.play()
		if monsterMagicList.size()>0 and monsterMagicList[magicRandi].effectArea == "aoe":
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
		#单体法术
		else: 
#			if monsterMagicList[magicRandi].magicType == "multiHit":
##		
##				if Global.monsterTarget:
##					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play(monsterMagicList[magicRandi])
#				Global.onMultiHit = 2
#				for x in range(2):			
#					Global.onMultiHit -= 1
#					delay_timer.wait_time = 4 # Delay time in seconds
#					delay_timer.one_shot = true
#					delay_timer.start()
#					await delay_timer.timeout
#
#					if Global.alivePlayers.size()>0:			
#						Global.monsterTarget = randi_range(0, Global.alivePlayers.size() - 1)
#						
#						for i in range(monsterMagicList[magicRandi].hitNum):			
#							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
#							Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].name + "hurt")
#							Global.alivePlayers[Global.monsterTarget].self_modulate = "#ef1354"
#							Global.onAttacking = true
#							Global.selectedTarget = true
#							self.play(monsterName + "magic")
#							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = true
#							Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play(monsterMagicList[magicRandi].name)
			if 2 == 2:
				if Global.alivePlayers.size()>0 and self.currHp > 0:			
					Global.monsterTarget = randi_range(0, Global.alivePlayers.size() - 1)
					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false
					Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].name + "hurt")
					Global.alivePlayers[Global.monsterTarget].self_modulate = "#ef1354"
					Global.onAttacking = true
					Global.selectedTarget = true
					
					Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = true
					if monsterMagicList[magicRandi].attackType == "melee":
						self.play(monsterName + "magicAutoAttack")
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play("monsterAutoAttack")
					elif monsterMagicList[magicRandi].attackType == "range" or monsterMagicList[magicRandi].attackType == "debuff":
						self.play(monsterName + "magic")
						Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").play(monsterMagicList[magicRandi].name)
						
	elif randi == 2 and Global.alivePlayers.size()>0:		
		useBigMagic()			


func moveCharacter(delta):
	if self.name == "青龙0":
		return
	var moveSpeed = 15 
	var newPosition = position.lerp(Vector2(Global.alivePlayers[Global.monsterTarget].position.x-60, Global.alivePlayers[Global.monsterTarget].position.y-60)  , moveSpeed * delta)
	position.x = newPosition.x 
	position.y = newPosition.y 




func _on_button_button_down():
	if !Global.noKeyboard:
		return
	Global.target = self

	if monsters.size() > 0 and Global.onAttackPicking and Global.currPlayer.canAttack == true:
		if Global.currPlayer.name == "朱雀":
			return

		#Global.currPlayer.targetPosition = self.position
		attacks()

		if Global.currPlayer.name != "姜韵":
			move()

	if monsters and Global.onMagicAttackPicking:

		if Global.currUsingMagic.attackType == "multi":

			Global.currPlayer.cast_magic_multiple_times(deltas, Global.currUsingMagic, Global.target, "keyboard", 3 )

		else:
			Global.currPlayer.castMagic(deltas, Global.currPlayerMagic[Global.magicSelectIndex],self, "mouse",false) 	
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
	if Global.onMultiHit >0:
		return
	if Global.onAttackPicking:
		$".".modulate = "c7c7c7"
		Global.target = self
		Global.targetMonsterIdx = 0
		for i in monsters.size():
			if monsters[i] == self:
				Global.targetMonsterIdx = i


func _on_hp_animation_animation_finished(anim_name):
	if anim_name == "hpDrop":
		for child in get_node("hpControl").get_children():
			if child.name != "hpLabel":
				child.queue_free()


func _on_攻击间隔_timeout():
	Global.canEnemyHit = true


func _on_button_mouse_exited():
	$".".modulate = "ffffff"

func display_damage(damage, type):
	var damage_str = str(damage)
	var offset_x = 0
	var damage_node = Node2D.new()
	
	for digit in damage_str:
		digit_sprite = Sprite2D.new()
		if type == "normal":
			digit_sprite.texture = load(digit_image_path + "23-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(1.5, 1.5)
			offset_x +=  10
		elif type == "crit":
			digit_sprite.texture = load(digit_image_path + "22-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(0.6, 0.6)
			offset_x -=  20
		elif type == "heal":
			digit_sprite.texture = load(digit_image_path + "21-" + str(int(digit) + 1) + ".png")
			digit_sprite.scale = Vector2(1.7, 1.7)
			offset_x +=  12
		digit_sprite.position.x = offset_x
		damage_node.add_child(digit_sprite)
		offset_x += digit_sprite.texture.get_width()# Adjust this value as needed
	return damage_node


func _on_wait_timer_timeout():
	Global.wait = false





func _on_can_attack_timeout():
	canAttackTimerStarted = false
	Global.canAttack = true



func useBigMagic():

	round = monsterAndMagic.get(monsterName).round
	get_parent().get_node("roundCountDown").text = str(round)
	get_parent().get_parent().get_node("bigMagicTimer").start()
	self.play(monsterName + "bigMagic")
	get_parent().get_node("bigMagic").visible = true
	get_parent().get_node("bigMagic/Label").text = magicInfo.name
	get_parent().get_node("bigMagic/bossHead").texture = load("res://portrait/"+monsterName+".png")
	
	$bigMagicSound.stream = load("res://Audio/SE/017-Jump03.ogg")
	$bigMagicSound.play()
	$effectSound.stream = load(magicInfo.audio)
	$effectSound.play()
	
	
	if magicInfo.attackType == "range":
		if magicInfo.effectingNum > 1:
			if Global.alivePlayers.size() < magicInfo.effectingNum:
				for i in Global.alivePlayers:
					if Global.alivePlayers.size() >=  magicInfo.effectingNum:
						break
					Global.onHitPlayer.append(i)
				
			else:		
				
				while Global.onHitPlayer.size() <  magicInfo.effectingNum:
					var ranTarget = Global.alivePlayers[randi_range(0, Global.alivePlayers.size() - 1)]
				
					if !Global.onHitPlayer.has(ranTarget):
						Global.onHitPlayer.append(ranTarget)
			for onHitPlayer in Global.onHitPlayer:
				onHitPlayer.get_node("getHitEffect").visible = false
				onHitPlayer.play(onHitPlayer.name + "hurt")
				onHitPlayer.self_modulate = "#ef1354"
				onHitPlayer.get_node("getHitEffect").visible = true
				onHitPlayer.get_node("getHitEffect").play(magicInfo.name)		
			Global.onAttacking = true
			Global.selectedTarget = true			


func playAutoSound():
	if !autoPlayed:
		$autoAttackSound.stream = load(autoAttackSound)
		$autoAttackSound.play()	
		autoPlayed = true
