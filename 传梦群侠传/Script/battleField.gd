extends Node

var currSceneMonstersName = []
var currSceneMonstersData

var enemyScene  # 用来获取enemy的scene，目的是用来实例化enemy
var fightScenePlayerScene

var monsterIdx = Global.monsterIdx #获取怪物的index，根据这个锁定目标
var playerIdx = Global.playerIdx

var fightScenePlayerData = []
var triggerQueueFree = false
var monsters #获取已经实例化的怪物
var players

var randomBgmIndex 
var magicPanel
var currPlayer
var deadTrigger = false
var manaAdded = false
var totalExp = 0
var totalGold = 0
var totalHp = 0
var randiTrans
var boss = false
var bossName = null
var bossBgm = ""
var selectedMonsters 
var currBgm = ""
var dialogue = null
var canPress = true
var sceneName 
var rewardAdded = false
var dialogued = false
var fightTime = 0
func areAllPlayersDead() -> bool:
	for player in players:
		if player.alive:
			return false
	# If the loop completes without finding any living player, return true
	return true
var preValue = 0

var shader_material: ShaderMaterial

var deltas
func _ready(): 
	
	shader_material = $battleFieldPicture/lastHit.material as ShaderMaterial
	shader_material.set("play_once", false)
	
	dialogued = false
	
	
	totalExp = 0
	$battleFieldPicture/Panel.position = Vector2(-402,-300) 
	
	showLastHit()
	get_tree().current_scene.get_node("CanvasLayer2").visible = false
	sceneName =  get_tree().current_scene.name
	if sceneName == "东海湾" or  sceneName == "小树林":
		$battleFieldPicture.texture = load("res://Battlebacks/东海湾.jpg")
	elif sceneName == "黑暗空间":
		$battleFieldPicture.texture = load("res://panoramas2/蜈蚣精.jpg")
	elif sceneName == "小西天":
		$battleFieldPicture.texture = load("res://Battlebacks/黄沙.jpg")
	else:
		$battleFieldPicture.texture = load ("res://Battlebacks/W99HX7R)91UPJ_XET%6Z3XL_tmb.png")
		#$battleFieldPicture.texture = load ("res://Battlebacks/战斗覆盖.png")
	
	get_tree().current_scene.get_node("CanvasLayer2").visible = false
	get_node("battleFieldPicture/trans").value = 100
	#get_node("battleFieldPicture/trans").visible = true
	Global.canEnemyHit = true
	Global.onHitEnemy = []
	Global.lost = false
	Global.onFight = true
	Global.selectedTarget = false
	Global.target = null
	Global.onAttacking = false
	Global.monsterTarget = null
	Global.onAttackPicking = false
	
	randiTrans = randi_range(0,9)
	
	# Load the Character2D scene
	enemyScene = preload("res://Scene/enemy.tscn")
	fightScenePlayerScene = preload("res://Scene/fightScenePlayer.tscn")


	if boss == true:
		instantiateBoss()
	else:
		instantiateMonster()

	
	
	instantiatePlayers()
	monsters = get_tree().get_nodes_in_group("monster")
	for i in monsters:
		totalExp += i.exp
		totalGold += i.gold
		totalHp += i.hp
	if monsters[0].name == "天道": 
		$fightTime.start()
		
		
	$battleFieldPicture/Panel/ProgressBar.max_value = totalHp
	
	#FightScenePlayers.update_players_with_item_stats()
	#随机
	
	$bgmTimer.start()
	randomBgmIndex = randi() % Global.bgmList.size()
#	get_parent().get_node("AudioStreamPlayer2D").stream = load(Global.bgmList[randomIndex])
#	get_parent().get_node("AudioStreamPlayer2D").stream.loop
#	get_parent().get_node("AudioStreamPlayer2D").play()
	
func _process(delta):
	deltas = delta
	get_tree().current_scene.get_node("player").canMove = false
	#var players = get_tree().get_nodes_in_group("fightScenePlayer")
	if !Global.onAttacking or Global.onMagicAttacking:
		preValue = getCurrTotalHp()
	var increment = $battleFieldPicture/Panel/ProgressBar.value - preValue
	var increment_percentage = (increment /$battleFieldPicture/Panel/ProgressBar.max_value ) * 100
	if Global.onBoss:
		if increment_percentage >= 15:
			$AnimationPlayer.play("shake")
	
	if Global.onHurry:

		get_parent().get_parent().get_node("battleBgm").volume_db = -80
	else:
		get_parent().get_parent().get_node("battleBgm").volume_db = 5
	
	
	if Global.onAttackingList.size() > 0:
		if Global.onAttackingList[0] in Global.onTeamPlayer or Global.onAttackingList[0] in Global.onTeamPet:
			if currPlayer:
				$battleFieldPicture/currPlayer.visible = true
				$battleFieldPicture/currPlayer/Panel/currPlayerName.text = Global.onAttackingList[0]
				$battleFieldPicture/allyInfo/hpBar/Label2.text = str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currHp) + "/" + str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addHp)

			
				$battleFieldPicture/currPlayer/Panel/background/hpBar/Label2.text = str(currPlayer.currHp) + "/"  + str(currPlayer.totalHp)
				#$battleFieldPicture/currPlayer/Panel/background/hpBar.max_value = FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addHp
				$battleFieldPicture/currPlayer/Panel/background/hpBar.max_value = currPlayer.totalHp
				$battleFieldPicture/currPlayer/Panel/background/manaBar/Label2.text = str(currPlayer.currMp) + "/"+str(currPlayer.totalMp)	
				$battleFieldPicture/currPlayer/Panel/background/manaBar.max_value = currPlayer.totalMp
				
					
				decrease_value_over_time_player(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currMp, 0.07, "mp")
				decrease_value_over_time_player(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currHp, 0.07, "hp")

				
					
				$battleFieldPicture/currPlayer/Panel/head.texture = load(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).icon)
			var children = $battleFieldPicture/currPlayer/Panel/background/buffs.get_children()
			for i in children:
				i.visible = false
			for i in players:
				if i.name == Global.onAttackingList[0]:
				
					for index in i.buffs.size():					
						get_node("battleFieldPicture/currPlayer/Panel/background/buffs/buff"+str(index+1)).visible = true
						var icon
						if i.buffs[index].keys()[0] == "onAttackBuff":
							icon = "res://Icons/317.png"
						elif i.buffs[index].keys()[0] == "onSpeedBuff":
							icon = "res://Icons/645.png"
						elif i.buffs[index].keys()[0] == "onMagicDefenseBuff":
							icon = "res://Icons/641.png"
						elif i.buffs[index].keys()[0] == "onPhysicDefenseBuff":
							icon = "res://Icons/307.png"
						elif i.buffs[index].keys()[0] == "onMagicBuff":
							icon = "res://Icons/311.png"
						elif i.buffs[index].keys()[0] == "onHealBuff":
							icon = "res://Icons/631.png"									
						elif i.buffs[index].keys()[0] == "onPoisonDebuff":
							icon = "res://Icons/319.png"
						elif i.buffs[index].keys()[0] == "onSleepDebuff":
							icon = "res://Icons/320.png"
						elif i.buffs[index].keys()[0] == "onIceDebuff":
							icon = "res://Icons/621.png"
						elif i.buffs[index].keys()[0] == "onSpeedDebuff":
							icon = 	"res://Icons/633.png"
						elif i.buffs[index].keys()[0] == "onMagicDisableDebuff":
							icon = 	"res://Icons/305.png"											
						elif i.buffs[index].keys()[0] == "onTireDebuff":
							icon = 	"res://Icons/629.png"													
						get_node("battleFieldPicture/currPlayer/Panel/background/buffs/buff"+str(index+1)).texture = load(icon)	
					
		else:
			$battleFieldPicture/currPlayer.visible = false
	else:
		$battleFieldPicture/currPlayer.visible = false

			
			
	if get_parent().get_parent().has_node("DirectionalLight2D"):
		get_parent().get_parent().get_node("DirectionalLight2D").energy = 0	

	if get_tree().current_scene.name == "东海湾" or get_tree().current_scene.name == "建邺北":
		$battleFieldPicture/trans.texture_progress = load("res://Trans/0623C906.jpg")
	if get_tree().current_scene.name == "方寸山":
			$battleFieldPicture/trans.texture_progress = load("res://Battlebacks/bj4.jpg")
	
	
	
	if randiTrans == 0:
		get_node("battleFieldPicture/trans").set_fill_mode(0)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.8
		get_node("battleFieldPicture/trans").value -= 1 
	elif randiTrans == 1:
		get_node("battleFieldPicture/trans").set_fill_mode(1)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.8 
		get_node("battleFieldPicture/trans").value -= 1
	elif randiTrans == 2:
		get_node("battleFieldPicture/trans").set_fill_mode(2)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1
	elif randiTrans == 3:
		get_node("battleFieldPicture/trans").set_fill_mode(3)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 4:
		get_node("battleFieldPicture/trans").set_fill_mode(4)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.8
		get_node("battleFieldPicture/trans").value -= 1	
	elif randiTrans == 5:
		get_node("battleFieldPicture/trans").set_fill_mode(5)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 6:
		get_node("battleFieldPicture/trans").set_fill_mode(6)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1
	elif randiTrans == 7:
		get_node("battleFieldPicture/trans").set_fill_mode(7)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 8:
		get_node("battleFieldPicture/trans").set_fill_mode(8)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.8
		get_node("battleFieldPicture/trans").value -= 1		
	elif randiTrans == 9:
		get_node("battleFieldPicture/trans").self_modulate.a -= 0.01	
	if get_node("battleFieldPicture/trans").value == 0:
		get_node("battleFieldPicture/trans").visible = false
		
	monsters = get_tree().get_nodes_in_group("monster")
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	
		
	
	decrease_value_over_time(getCurrTotalHp(),0.17)
	$battleFieldPicture/Panel/ProgressBar/Label.text = str(ceil(($battleFieldPicture/Panel/ProgressBar.value / $battleFieldPicture/Panel/ProgressBar.max_value) * 100)) + "%"

	
	
	
	#$battleFieldPicture/Panel/ProgressBar.value = getCurrTotalHp()
	
	$battleFieldPicture/enemyInfo.visible = false

	if Global.onAttackPicking or Global.onMagicAttackPicking:
		if Global.target and monsters:
			$battleFieldPicture/enemyInfo.visible = true
		
			$battleFieldPicture/enemyInfo/enemyName.text = str(monsters[Global.targetMonsterIdx].level) # remove_numbers_from_string(monsters[Global.targetMonsterIdx].name)
			$battleFieldPicture/enemyInfo/hpBar.max_value = monsters[Global.targetMonsterIdx].hp 
			$battleFieldPicture/enemyInfo/hpBar.value = monsters[Global.targetMonsterIdx].currHp
			$battleFieldPicture/enemyInfo/speedBar.value = monsters[Global.targetMonsterIdx].speedBar
			var enemyBuffSlot =  $battleFieldPicture/enemyInfo/buffs.get_children()
			for x in enemyBuffSlot:
				x.visible = false
				
			if is_instance_valid(Global.target) and Global.target.buffs: 
				for index in Global.target.buffs.size():	
					var i = Global.target
					
					get_node("battleFieldPicture/enemyInfo/buffs/buff"+str(index+1)).visible = true	
					
					var icon = ""
					if i.buffs[index].keys()[0] == "onAttackBuff":
						icon = "res://Icons/317.png"
					elif i.buffs[index].keys()[0] == "onSpeedBuff":
						icon = "res://Icons/645.png"
					elif i.buffs[index].keys()[0] == "onMagicDefenseBuff":
						icon = "res://Icons/641.png"
					elif i.buffs[index].keys()[0] == "onPhysicDefenseBuff":
						icon = "res://Icons/307.png"
					elif i.buffs[index].keys()[0] == "onMagicBuff":
						icon = "res://Icons/311.png"
					elif i.buffs[index].keys()[0] == "onHealBuff":
						icon = "res://Icons/631.png"									
					elif i.buffs[index].keys()[0] == "onPoisonDebuff":
						icon = "res://Icons/319.png"
					elif i.buffs[index].keys()[0] == "onSleepDebuff":
						icon = "res://Icons/320.png"
					elif i.buffs[index].keys()[0] == "onIceDebuff":
						icon = "res://Icons/621.png"
					elif i.buffs[index].keys()[0] == "onSpeedDebuff":
						icon = 	"res://Icons/633.png"
					elif i.buffs[index].keys()[0] == "onMagicDisableDebuff":
						icon = 	"res://Icons/305.png"											
					elif i.buffs[index].keys()[0] == "onTireDebuff":
						icon = 	"res://Icons/629.png"									
					
					
										
					get_node("battleFieldPicture/enemyInfo/buffs/buff"+str(index+1)).texture = load(icon)		
					
					
						
		$battleFieldPicture/allyInfo/allyName.text = players[Global.allieSelectIndex].name
		$battleFieldPicture/allyInfo/hpBar.max_value = players[Global.allieSelectIndex].totalHp
		
		$battleFieldPicture/allyInfo/hpBar.value = players[Global.allieSelectIndex].currHp
		$battleFieldPicture/allyInfo/hpBar/Label2.text = str(players[Global.allieSelectIndex].currHp) + "/" + str(players[Global.allieSelectIndex].totalHp)
	
		$battleFieldPicture/allyInfo/manaBar.max_value = players[Global.allieSelectIndex].totalMp
		$battleFieldPicture/allyInfo/manaBar.value = players[Global.allieSelectIndex].currMp
		$battleFieldPicture/allyInfo/manaBar/Label2.text = str(players[Global.allieSelectIndex].currMp) + "/" + str(players[Global.allieSelectIndex].totalMp)
		
		var allyBuffSlot =  $battleFieldPicture/allyInfo/buffs.get_children()
		for buff in players[Global.allieSelectIndex].buffs:
			pass

	if Global.onAttacking:
		$battleFieldPicture/enemyInfo.visible = false	
	if Global.onItemUsePicking:
		if Global.currUsingItem.info.effect == "damage":
			$battleFieldPicture/enemyInfo.visible = true
			$battleFieldPicture/enemyInfo/enemyName.text = str(monsters[Global.targetMonsterIdx].level) #remove_numbers_from_string(monsters[Global.targetMonsterIdx].name)
			$battleFieldPicture/enemyInfo/hpBar.max_value = monsters[Global.targetMonsterIdx].hp 
			$battleFieldPicture/enemyInfo/hpBar.value = monsters[Global.targetMonsterIdx].currHp
			$battleFieldPicture/enemyInfo/speedBar.value = monsters[Global.targetMonsterIdx].speedBar
			var enemyBuffSlot =  $battleFieldPicture/enemyInfo/buffs.get_children()
			for x in enemyBuffSlot:
				x.visible = false

			for index in Global.target.buffs.size():	
				var i = Global.target
				get_node("battleFieldPicture/enemyInfo/buffs/buff"+str(index+1)).visible = true	
				
				var icon = ""
				if i.buffs[index].keys()[0] == "onAttackBuff":
					icon = "res://Icons/317.png"
				elif i.buffs[index].keys()[0] == "onSpeedBuff":
					icon = "res://Icons/645.png"
				elif i.buffs[index].keys()[0] == "onMagicDefenseBuff":
					icon = "res://Icons/641.png"
				elif i.buffs[index].keys()[0] == "onPhysicDefenseBuff":
					icon = "res://Icons/307.png"
				elif i.buffs[index].keys()[0] == "onMagicBuff":
					icon = "res://Icons/311.png"
				elif i.buffs[index].keys()[0] == "onHealBuff":
					icon = "res://Icons/631.png"									
				elif i.buffs[index].keys()[0] == "onPoisonDebuff":
					icon = "res://Icons/319.png"
				elif i.buffs[index].keys()[0] == "onSleepDebuff":
					icon = "res://Icons/320.png"
				elif i.buffs[index].keys()[0] == "onIceDebuff":
					icon = "res://Icons/621.png"
				elif i.buffs[index].keys()[0] == "onSpeedDebuff":
					icon = 	"res://Icons/633.png"
				elif i.buffs[index].keys()[0] == "onMagicDisableDebuff":
					icon = 	"res://Icons/305.png"											
				elif i.buffs[index].keys()[0] == "onTireDebuff":
					icon = 	"res://Icons/629.png"													
									
									
				get_node("battleFieldPicture/enemyInfo/buffs/buff"+str(index+1)).texture = load(icon)				
		else:
			$battleFieldPicture/allyInfo/allyName.text = players[Global.allieSelectIndex].name
			$battleFieldPicture/allyInfo/hpBar.max_value = players[Global.allieSelectIndex].hp
			$battleFieldPicture/allyInfo/hpBar.value = players[Global.allieSelectIndex].currHp
			$battleFieldPicture/allyInfo/hpBar/Label2.text = str(players[Global.allieSelectIndex].currHp) + "/" + str(players[Global.allieSelectIndex].hp)
		
			$battleFieldPicture/allyInfo/manaBar.max_value = players[Global.allieSelectIndex].mp
			$battleFieldPicture/allyInfo/manaBar.value = players[Global.allieSelectIndex].currMp
			$battleFieldPicture/allyInfo/manaBar/Label2.text = str(players[Global.allieSelectIndex].currMp) + "/" + str(players[Global.allieSelectIndex].mp)	
			var allyBuffSlot =  $battleFieldPicture/allyInfo/buffs.get_children()
			for x in allyBuffSlot:
				x.visible = false
			for index in players[Global.allieSelectIndex].buffs.size():	
				var i = players[Global.allieSelectIndex]
				get_node("battleFieldPicture/allyInfo/buffs/buff"+str(index+1)).visible = true	
			
				var icon
				if i.buffs[index].keys()[0] == "onAttackBuff":
					icon = "res://Icons/317.png"
				elif i.buffs[index].keys()[0] == "onSpeedBuff":
					icon = "res://Icons/645.png"
				elif i.buffs[index].keys()[0] == "onMagicDefenseBuff":
					icon = "res://Icons/641.png"
				elif i.buffs[index].keys()[0] == "onPhysicDefenseBuff":
					icon = "res://Icons/307.png"
				elif i.buffs[index].keys()[0] == "onMagicBuff":
					icon = "res://Icons/311.png"
				elif i.buffs[index].keys()[0] == "onHealBuff":
					icon = "res://Icons/631.png"									
				elif i.buffs[index].keys()[0] == "onPoisonDebuff":
					icon = "res://Icons/319.png"
				elif i.buffs[index].keys()[0] == "onSleepDebuff":
					icon = "res://Icons/320.png"
				elif i.buffs[index].keys()[0] == "onIceDebuff":
					icon = "res://Icons/621.png"
				elif i.buffs[index].keys()[0] == "onSpeedDebuff":
					icon = 	"res://Icons/633.png"
				elif i.buffs[index].keys()[0] == "onMagicDisableDebuff":
					icon = 	"res://Icons/305.png"											
				elif i.buffs[index].keys()[0] == "onTireDebuff":
					icon = 	"res://Icons/629.png"													
										
				get_node("battleFieldPicture/allyInfo/buffs/buff"+str(index+1)).texture = load(icon)	
			for buff in players[Global.allieSelectIndex].buffs:
				pass
	if Global.onAttackingList:
		for i in players:
			if i.name == Global.onAttackingList[0]:
				currPlayer = i
			
	if areAllPlayersDead() and !deadTrigger:
		Global.onBoss = false
		for player in players:
			if player["currHp"] <= 0:
				FightScenePlayers.fightScenePlayerData[player.name].alive = true
				FightScenePlayers.fightScenePlayerData[player.name].currHp = player["hp"]/10
		if Global.canLose:
			for i in players:
				if i.currHp <= 0:
					i.alive = true
					i.currHp = (i.hp + i.addHp )/7
				
				
				
			Global.lost = true
			get_parent().get_parent().get_node("player").visible = true
			get_parent().get_parent().get_node("player").canMove = true
			get_parent().get_parent().get_node("enterFightCd").start()
			get_parent().get_parent().onFight = false
			Global.monsterIdx = -1
			Global.onAttackingList = []
			Global.finishingBattle = true
			Global.alivePlayers = []
			
			Global.onAttackPicking = false
			Global.onMagicAttackPicking = false
			Global.onItemUsePicking = false
			Global.onAttacking = false
			Global.onMagicAttacking = false
			Global.onItemUsing = false
			Global.selectedTarget = false
			Global.onHitPlayer = []
			Global.killedAmount += selectedMonsters.size()
			if Global.atNight:
				get_parent().get_parent().get_node("DirectionalLight2D").energy = 4.7	
			else:
				if !Global.onHurry:
					get_parent().get_parent().get_node("AudioStreamPlayer2D").volume_db = 4
				elif Global.onHurry:
					get_parent().get_parent().get_node("AudioStreamPlayer2D").volume_db = 4.5			
			get_parent().get_parent().get_node("battleBgm").stop()
			Global.onMultiHit = 0
			Global.target = null
			Global.monsterTarget = null
			Global.currAttacker = ""
			Global.onAttackPicking = false
			queue_free()
			Global.onXiaoErZhenShen = false
			
			if Global.onXiaoErZhenShen:
				Global.onTeamPlayer.erase("小二真身")
				Global.onTeamPlayer.append("小二")
			
			totalExp = 0
			FightScenePlayers.hashTable = FightScenePlayers.fightScenePlayerData.duplicate(true)
			if dialogue:
				var npc = Global.npcs[dialogue]
				var dialogue_index = npc["current_dialogue_index"]
				var dialogue_entry = npc["dialogues"][dialogue_index]
				
				var chapterNum = dialogue_entry.chapter
				DialogueManager.show_chat(load("res://Dialogue/"+str(chapterNum)+".dialogue"),get_npc_dialogue(dialogue))
			get_parent().get_parent().get_node("shadow").visible = true
			get_parent().get_parent().get_node("CanvasLayer").visible = true
			get_parent().get_parent().get_node("battleBgm").stop()
			if !Global.onHurry:
				get_parent().get_parent().get_node("AudioStreamPlayer2D").stream_paused = false				
		else:		
			deadTrigger = true

			$deadTimer.start()
			
		
	#循环播放随机战斗背景音乐
	if get_parent().get_parent().get_node("battleBgm").is_playing() == false and currBgm != "":
		get_parent().get_parent().get_node("battleBgm").stream = load(currBgm)
		get_parent().get_parent().get_node("battleBgm").play()
	
	#如果怪物等于0就摧毁战斗场景并且让一切恢复成战斗之前
	if monsters.size() <= 0:	
		
		setFightTime()
		if !manaAdded:	
			manaAdded = true
			Global.onFight = false
			for i in players:
				
				var addMpAmount = (i.mp + decrypt(i.addMp)) /7
				
				i.currHp += (i.hp + decrypt(i.addHp) )/7
				i.currMp += addMpAmount 
				
				if i.currHp > i.hp:
					i.currHp = i.hp
					
						
	#			if i.currMp > i.mp:
	#				i.currMp = i.mp

				if i.haveGao == true:
				
					if i.currHp > i.hp - 500:
						i.currHp = i.hp - 500
						
							
					if i.currMp > i.mp - 500:
						i.currMp = i.mp - 500					

				if i.currMp > i.mp+ decrypt(i.addMp):
					i.currMp = i.mp+ decrypt(i.addMp)
				
				
				
				
				if i.currHp <= 0:
					i.alive = true
					i.currHp = (i.hp + decrypt(i.addHp) )/7
			
		get_parent().get_parent().get_node("player").visible = true
		get_parent().get_parent().get_node("player").canMove = true
		get_parent().get_parent().get_node("enterFightCd").start()
		get_parent().get_parent().onFight = false
		Global.monsterIdx = -1
		Global.onAttackingList = []

		Global.finishingBattle = true
		Global.alivePlayers = []
		
		if Global.onXiaoErZhenShen:
			Global.onXiaoErZhenShen = false
			Global.onTeamPlayer.erase("小二真身")
			Global.onTeamPlayer.append("小二")
		
		
		Global.onAttackPicking = false
		Global.onMagicAttackPicking = false
		Global.onItemUsePicking = false
		Global.onAttacking = false
		Global.onMagicAttacking = false
		Global.onItemUsing = false
		Global.selectedTarget = false
		Global.onHitPlayer = []
		Global.killedAmount += selectedMonsters.size()
		if Global.atNight and get_parent().get_parent().has_node("DirectionalLight2D") :
			get_parent().get_parent().get_node("DirectionalLight2D").energy = 4.7	
			get_parent().get_parent().get_node("AudioStreamPlayer2D").volume_db = 4.5	
		else:
			if !Global.onHurry:
				get_parent().get_parent().get_node("AudioStreamPlayer2D").volume_db = 3
			elif Global.onHurry:
				get_parent().get_parent().get_node("AudioStreamPlayer2D").volume_db = 4.5		
		Global.onMultiHit = 0
		Global.currAttacker = ""
		
		
#		if dialogue and !dialogued:
#			dialogued = true
#			DialogueManager.show_chat(load("res://Dialogue/"+str(Global.current_chapter_id)+".dialogue"),get_npc_dialogue(dialogue))
		if dialogue and !dialogued:
			dialogued = true
			var npc = Global.npcs[dialogue]
			var dialogue_index = npc["current_dialogue_index"]
			var dialogue_entry = npc["dialogues"][dialogue_index]
			
			var chapterNum = dialogue_entry.chapter
		
			DialogueManager.show_chat(load("res://Dialogue/"+str(chapterNum)+".dialogue"),get_npc_dialogue(dialogue))
	
		get_parent().get_parent().get_node("shadow").visible = true
		get_parent().get_parent().get_node("CanvasLayer").visible = true
		#战后结算经验和金币
		
		get_parent().get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").visible = false
		get_parent().get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp").visible = true
		get_parent().get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold").visible = true
		get_parent().get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp/expValue").text = str(totalExp)
		get_parent().get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold/goldValue").text = str(totalGold)
		
		
		
		
		get_tree().current_scene.get_node("CanvasLayer").renderMsg()
		
		FightScenePlayers.golds += totalGold * Global.enKey
		
		if !rewardAdded:
			rewardAdded = true	
			for player_name in FightScenePlayers.fightScenePlayerData:
				if player_name in Global.onTeamPlayer or player_name in Global.onTeamPet:
					var player = FightScenePlayers.fightScenePlayerData[player_name]
					if player['level'] >= Global.maxLevel:
						return
					player["exp"] += totalExp * Global.enKey

		get_parent().get_parent().get_node("battleBgm").stop()
		if !Global.onHurry:
			get_parent().get_parent().get_node("AudioStreamPlayer2D").stream_paused = false
		for i in Global.onTeamPet:
			for player in players:
				if player.name == i:
					player.currHp = FightScenePlayers.fightScenePlayerData.get(i).hp
					player.currMp = FightScenePlayers.fightScenePlayerData.get(i).mp
			FightScenePlayers.fightScenePlayerData.get(i).currHp = 	FightScenePlayers.fightScenePlayerData.get(i).hp
			FightScenePlayers.fightScenePlayerData.get(i).currMp = 	FightScenePlayers.fightScenePlayerData.get(i).mp	

		if Global.onBoss:
			
			queue_free()
			totalExp = 0
			Global.onBoss = false		
			return
		if !triggerQueueFree and !Global.onBoss:
			play_effect_once()
			get_parent().get_parent().get_node("subSound").stream = load("res://Audio/ME/胜利.wav")
			get_parent().get_parent().get_node("subSound").play()
			$AnimationPlayer.play("lastHit")
			triggerQueueFree = true
			$queueFree.start()	
			Global.systemMsg.append("全队获得了 " + str(totalExp) + " 经验 "+ "和 "+ str(totalGold) + " 银两")
			
			
			
#		var rand = randi_range(0, 2)
#		if rand >= 1 :
#			get_parent().get_node("AudioStreamPlayer2D").stream = load("res://Audio/BGM/东海湾.mp3")
#		else:
#			get_parent().get_node("AudioStreamPlayer2D").stream = load("res://Audio/BGM/#流波山海岛.ogg")
#			get_parent().get_node("AudioStreamPlayer2D").play()

	if Global.onMagicAttackPicking:
		
		#if Global.currPlayerMagic.size()>0:
		if Global.currUsingMagic.attackType != "buff":
			Global.target = monsters[Global.targetMonsterIdx]  
			if Input.is_action_just_pressed("ui_left"):
				if Global.targetMonsterIdx == monsters.size() - 1:
					Global.targetMonsterIdx = 0
				else:
					Global.targetMonsterIdx += 1
				Global.target = monsters[Global.targetMonsterIdx]
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.targetMonsterIdx == 0:
					Global.targetMonsterIdx = monsters.size() - 1
				else:
					Global.targetMonsterIdx -= 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()					
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Input.is_action_just_pressed("ui_right"):
				if Global.allieSelectIndex == players.size() - 1:
					Global.allieSelectIndex = 0
				else:
					Global.allieSelectIndex += 1
				Global.target = players[Global.allieSelectIndex]
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()	
			if Input.is_action_just_pressed("ui_left"):
				if Global.allieSelectIndex == 0:
					return
				Global.allieSelectIndex -= 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()					
	elif Global.onAttackPicking:
			#Global.target = monsters[Global.targetMonsterIdx] 
			if Global.onAttackingList[0] == "朱雀":
				
				
				
				Global.target = players[Global.allieSelectIndex] 
				for i in players:
					i.get_node("selectIndic").visible = false
				Global.target.get_node("selectIndic").visible = true
				Global.target.get_node("AnimationPlayer").play("selectIndic")					
				
				
				
				currPlayer.get_parent().get_node("enemyInfo").visible = false
				currPlayer.get_parent().get_node("allyInfo").visible = true
				
				if Input.is_action_just_pressed("ui_right"):
					if Global.allieSelectIndex == players.size() - 1:
						Global.allieSelectIndex = 0
					else:
						Global.allieSelectIndex += 1
					Global.target = players[Global.allieSelectIndex]
					get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
					get_parent().get_parent().get_node("subSound").play()	
				if Input.is_action_just_pressed("ui_left"):
					if Global.allieSelectIndex == 0:
						return
					Global.allieSelectIndex -= 1
					get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
					get_parent().get_parent().get_node("subSound").play()
					
				return
			if Input.is_action_just_pressed("ui_left"):
				if Global.targetMonsterIdx == monsters.size() - 1:
					Global.targetMonsterIdx = 0
				else:
					Global.targetMonsterIdx += 1
				Global.target = monsters[Global.targetMonsterIdx]
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
			
				if Global.targetMonsterIdx == 0:
					Global.targetMonsterIdx = monsters.size() - 1
				else:
					Global.targetMonsterIdx -= 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_parent().get_node("subSound").play()						
	
	#道具用在谁身上				
	if Global.onItemUsePicking:
		#if Global.currPlayerMagic.size()>0:
		if Global.currUsingItem.info.effect == "damage":
			Global.target = monsters[Global.targetMonsterIdx]  
			if Input.is_action_just_pressed("ui_left"):
				if Global.targetMonsterIdx == monsters.size() - 1:
					Global.targetMonsterIdx = 0
				else:
					Global.targetMonsterIdx += 1
				Global.target = monsters[Global.targetMonsterIdx]
			if Input.is_action_just_pressed("ui_right"):
				if Global.targetMonsterIdx == 0:
					Global.targetMonsterIdx = monsters.size() - 1
				else:
					Global.targetMonsterIdx -= 1
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Input.is_action_just_pressed("ui_right"):
				if Global.allieSelectIndex == players.size() - 1:
					Global.allieSelectIndex = 0
				else:
					Global.allieSelectIndex += 1
				Global.target = players[Global.allieSelectIndex]
			if Input.is_action_just_pressed("ui_left"):
				if Global.allieSelectIndex == 0:
					return
				Global.allieSelectIndex -= 1
			
			
			
	if Global.onAttackingList:
		if Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false :
			magicPanel = get_tree().get_nodes_in_group("magic")
			if Input.is_action_just_pressed("ui_up"):
				if Global.magicSelectIndex <= 1:
					return
				else:
					Global.magicSelectIndex -= 3	
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()						
					
			if Input.is_action_just_pressed("ui_down"):
				if Global.magicSelectIndex >= magicPanel.size() - 3:
					return
				else:
					Global.magicSelectIndex += 3	
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left"):
				if Global.magicSelectIndex == 0:
					return
				Global.magicSelectIndex -= 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.magicSelectIndex == Global.currPlayerMagic.size() - 1:
					return
				Global.magicSelectIndex += 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()				
			

			
			if Input.is_action_just_released("ui_accept"):
				if Global.playerMagicList[Global.magicSelectIndex].name == "高等炼体术":
					return
				if Global.playerMagicList[Global.magicSelectIndex].name == "真身现世" and currPlayer.真身round != 0:	
					return	
				if Global.playerMagicList[Global.magicSelectIndex].cost > currPlayer.currMp:
					$systemSound.stream = load("res://Audio/SE/humandie2 (5).ogg")
					$systemSound.play()
					return		
				else:
					get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_parent().get_node("subSound").play()	
								
					Global.onMagicSelectPicking = false
					Global.onMagicAttackPicking = true					
		elif Global.onItemSelectPicking == true and Global.onItemUsePicking == false :
			magicPanel = get_tree().get_nodes_in_group("magic")
			if Input.is_action_just_pressed("ui_up"):
				if Global.itemSelectIndex <= 1:
					return
				else:
					Global.itemSelectIndex -= 2	
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()						
			if Input.is_action_just_pressed("ui_down"):
				if Global.itemSelectIndex >= Global.itemList.size() - 2:
					return
				else:
					Global.itemSelectIndex += 2	
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left"):
				if Global.itemSelectIndex == 0:
					return
				Global.itemSelectIndex -= 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.itemSelectIndex == Global.itemList.size() - 1:
					return
				Global.itemSelectIndex += 1
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_parent().get_node("subSound").play()				
			

			
			if Input.is_action_just_released("ui_accept"):
				Global.onItemSelectPicking = false
				Global.onItemUsePicking = true					
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_parent().get_node("subSound").play()				
			
			
			#magicPanel[2].get_node("Button").grab_focus()
			
		
	#让全部场景中的怪物被定位攻击目标时显示指针
	for i in monsters:
			if !Global.onAttacking and	Global.target == i and Global.onAttackPicking and i.animation != remove_numbers_from_string(i.name + "hurt"):
				i.get_node("selectIndic").visible = true
				i.material = i.shader_material
			elif !Global.onMagicAttacking and Global.target == i and Global.onMagicAttackPicking and i.animation != remove_numbers_from_string(i.name + "hurt") and Global.currPlayerMagic[Global.magicSelectIndex].attackType != "buff":
				i.get_node("selectIndic").visible = true
				
			elif Global.target == i and Global.onItemUsePicking and i.animation != remove_numbers_from_string(i.name + "hurt"):
				i.get_node("selectIndic").visible = true
		
			else:
				i.get_node("selectIndic").visible = false
				i.material = null
				
	for i in players:
		if Global.target == i and Global.onMagicAttackPicking and Global.currPlayerMagic[Global.magicSelectIndex].attackType == "buff":
			i.get_node("selectIndic").visible = true
			i.get_node("AnimationPlayer").play("selectIndic")			 
		elif Global.target == i and Global.onItemUsePicking:
			i.get_node("selectIndic").visible = true
			i.get_node("AnimationPlayer").play("selectIndic")			
		else:
			i.get_node("selectIndic").visible = false
			




func callMonster():
	return MonsterData.get_monsters_by_level(Global.currScene)
func callBoss():
	return MonsterData.getBoss(bossName)
func setMonsterName():
	for i in currSceneMonstersData:
		currSceneMonstersName.append(i)

func instantiateMonster():
	currSceneMonstersData = callMonster()
	setMonsterName()
	
	# Determine the number of monsters to select based on the level
	var numMonstersToSelect = 8  # Default value for higher levels
	
	# Array of scene names for easy levels
	var easyLevels = Global.easyLevels
	
	# Check if the current scene is in the array of easy levels
	#if Global.currScene in easyLevels:
	numMonstersToSelect = randi_range(Global.dangerScene.get(get_tree().current_scene.name)-2, Global.dangerScene.get(get_tree().current_scene.name))  # Select 3 to 5 monsters for easy levels

	#已被选中加入战斗的怪物，以numMonsterToSelect的随机数加入相应数量的已选中怪物
	selectedMonsters = []
	while selectedMonsters.size() < numMonstersToSelect: #and currSceneMonstersName.size() > 0:
		var randomIndex = randi_range(0, currSceneMonstersName.size() - 1)
		var monsterName = currSceneMonstersName[randomIndex]
		selectedMonsters.append(currSceneMonstersData[monsterName])
	
	# Create instances of Character2D for selected monsters
	for monsterData in selectedMonsters:
		var enemySceneInstance = enemyScene.instantiate()
		enemySceneInstance.add_to_group("monster")
		# Set properties for the character instance
		enemySceneInstance.level = monsterData.level
		enemySceneInstance.speed = monsterData.speed
		enemySceneInstance.magicDefense = monsterData.magicDefense
		enemySceneInstance.type = monsterData.type
		enemySceneInstance.physicDefense = monsterData.physicDefense
		enemySceneInstance.attackDmg = monsterData.attackDmg
		enemySceneInstance.magicDmg = monsterData.magicDmg 
		enemySceneInstance.hp = monsterData.hp
		enemySceneInstance.idle = monsterData.idle
		enemySceneInstance.monsterName = monsterData.name
		enemySceneInstance.monsterMagicList = monsterData.monsterMagicList
		enemySceneInstance.exp = monsterData.exp
		enemySceneInstance.gold = monsterData.gold
		enemySceneInstance.luck = monsterData.luck
		enemySceneInstance.monsterIndex = monsterIdx + 1
		enemySceneInstance.set_name(enemySceneInstance.monsterName + str(monsterIdx + 1))
		
		monsterIdx += 1

		var posX
		var posY
		var 倾斜度 = 35
		
		if monsterIdx < 4:
			# Front row positions with a slight slant
			posX = (monsterIdx + 1) * -50 + 50# Adjust the offset based on your preference
			posY = (monsterIdx + 1) * 倾斜度 - 130
		else:
			# Back row positions with a slight slant
			posX = (monsterIdx - 3) * -50 + 25
			posY = (monsterIdx - 3) * 倾斜度 - 200
	

		if selectedMonsters.size() == 1: 
			posX = $bossPos.position.x
			posY = $bossPos.position.y		
	
			if selectedMonsters[0].name == "鬼帝0":
				posX = -120
				posY = -40


			if selectedMonsters[0].name == "青龙0":
				posX = -200
				posY = -200
		# Set the position of the character instance
		enemySceneInstance.position.x = posX
		enemySceneInstance.position.y = posY
		enemySceneInstance.monsterPosition = enemySceneInstance.position
		# Add the character instance to the scene hierarchy
		$battleFieldPicture.add_child(enemySceneInstance)

		# Play the idle animation
		enemySceneInstance.play(enemySceneInstance.idle)
	
func instantiateBoss():
	currSceneMonstersData = callBoss()
	setMonsterName()
	Global.onBoss = true
	# Determine the number of monsters to select based on the level
	var numMonstersToSelect = currSceneMonstersData.size() # Default value for higher levels
	
	#已被选中加入战斗的怪物，以numMonsterToSelect的随机数加入相应数量的已选中怪物
	selectedMonsters = []
#	while selectedMonsters.size() < numMonstersToSelect: #and currSceneMonstersName.size() > 0:
#		var randomIndex = randi_range(0, currSceneMonstersName.size() - 1)
#		var monsterName = currSceneMonstersName[randomIndex]
#		selectedMonsters.append(currSceneMonstersData[monsterName])
	
	for i in currSceneMonstersData:
		selectedMonsters.append(currSceneMonstersData.get(i))
	
	
	
	# Create instances of Character2D for selected monsters
	for monsterData in selectedMonsters:
		var enemySceneInstance = enemyScene.instantiate()
		enemySceneInstance.add_to_group("monster")
		# Set properties for the character instance
		enemySceneInstance.speed = monsterData.speed
		enemySceneInstance.magicDefense = monsterData.magicDefense
		enemySceneInstance.physicDefense = monsterData.physicDefense
		enemySceneInstance.attackDmg = monsterData.attackDmg
		enemySceneInstance.magicDmg = monsterData.magicDmg
		enemySceneInstance.type = monsterData.type
		enemySceneInstance.hp = monsterData.hp
		enemySceneInstance.idle = monsterData.idle
		enemySceneInstance.monsterName = monsterData.name
		enemySceneInstance.monsterMagicList = monsterData.monsterMagicList
		enemySceneInstance.exp = monsterData.exp
		enemySceneInstance.gold = monsterData.gold
		enemySceneInstance.autoAttackSound = monsterData.autoAttackSound
		
		enemySceneInstance.monsterIndex = monsterIdx + 1
		enemySceneInstance.set_name(enemySceneInstance.monsterName + str(monsterIdx + 1))
		
		monsterIdx += 1

		var posX
		var posY
		var 倾斜度 = 35
		
		if monsterIdx < 4:
			# Front row positions with a slight slant
			posX = (monsterIdx + 1) * -50 + 50# Adjust the offset based on your preference
			posY = (monsterIdx + 1) * 倾斜度 - 130
		else:
			# Back row positions with a slight slant
			posX = (monsterIdx - 3) * -50 + 25
			posY = (monsterIdx - 3) * 倾斜度 - 200
		if selectedMonsters.size() == 1: 
			posX = $bossPos.position.x
			posY = $bossPos.position.y		
			
			if selectedMonsters[0].name == "鬼帝":
				posX = -120
				posY = -40


			elif selectedMonsters[0].name == "青龙":
				posX = -200
				posY = -200			
			else:
				posX = $bossPos.position.x
				posY = $bossPos.position.y
			
			
			
			
		# Set the position of the character instance
		enemySceneInstance.position.x = posX
		enemySceneInstance.position.y = posY
		enemySceneInstance.monsterPosition = enemySceneInstance.position
		
		if enemySceneInstance.monsterName == "妖皇":
			enemySceneInstance.monsterPosition = Vector2(-200,-130)
			enemySceneInstance.position.x = -200
			enemySceneInstance.position.y = -130
		if enemySceneInstance.monsterName == "魔尊":	
			enemySceneInstance.monsterPosition = Vector2(-90,-230)	
			enemySceneInstance.position.x = -90
			enemySceneInstance.position.y = -230
		if enemySceneInstance.monsterName == "天道":	
			enemySceneInstance.monsterPosition = Vector2(-200,-160)	
			enemySceneInstance.position.x = -200
			enemySceneInstance.position.y = -160			
			
			
		# Add the character instance to the scene hierarchy
		$battleFieldPicture.add_child(enemySceneInstance)

		# Play the idle animation
		enemySceneInstance.play(enemySceneInstance.idle)
				
func instantiatePlayers():
	fightScenePlayerData = FightScenePlayers.callFightScenePlayerData()              
	var zindex = $battleFieldPicture.z_index + 10
	for i in fightScenePlayerData:
		var fightScenePlayerSceneInstance = fightScenePlayerScene.instantiate()
		
		fightScenePlayerSceneInstance.z_index = zindex
		zindex -= 1
		fightScenePlayerSceneInstance.add_to_group("fightScenePlayers")
		fightScenePlayerSceneInstance.idle = i.idle
		
		fightScenePlayerSceneInstance.autoAttack = i.autoAttack
		fightScenePlayerSceneInstance.magicAutoAttack = i.magicAutoAttack
		fightScenePlayerSceneInstance.playerName = i.name
		fightScenePlayerSceneInstance.playerAttackType = i.playerAttackType
		
		
		fightScenePlayerSceneInstance.hp = i.hp
		fightScenePlayerSceneInstance.mp = i.mp
		fightScenePlayerSceneInstance.addHp = i.addHp
		fightScenePlayerSceneInstance.addMp = i.addMp	
		
		fightScenePlayerSceneInstance.playerSpeed = i.playerSpeed
		fightScenePlayerSceneInstance.playerMagic = i.playerMagic
		
		fightScenePlayerSceneInstance.str = i.str
		fightScenePlayerSceneInstance.addStr = i.addStr
		

		
		fightScenePlayerSceneInstance.abilityPower = i.abilityPower
		fightScenePlayerSceneInstance.addAbilityPower = i.addAbilityPower
		
		
		fightScenePlayerSceneInstance.autoAttackSound = i.autoAttackSound
		fightScenePlayerSceneInstance.attackOnEnemySound = i.attackOnEnemySound
		
		fightScenePlayerSceneInstance.physicDefense = i.physicDefense 
		fightScenePlayerSceneInstance.magicDefense = i.magicDefense 
		fightScenePlayerSceneInstance.additionDmg = i.additionDmg
		fightScenePlayerSceneInstance.addMagicDefense = i.addMagicDefense
		fightScenePlayerSceneInstance.addPhysicDefense = i.addPhysicDefense
		fightScenePlayerSceneInstance.addPlayerSpeed = i.addPlayerSpeed
		

		
		var rightDmg = i.additionDmg
		var rightAddMagicDefense = i.addMagicDefense
		var rightAddPhyicDefense = i.addPhysicDefense
		var rightAddPlayerSpeed = i.addPlayerSpeed
		var rightAddHp = i.addHp
		
		$battleFieldPicture.add_child(fightScenePlayerSceneInstance)	
		FightScenePlayers.fightScenePlayerData.get(i.name).additionDmg =rightDmg
		FightScenePlayers.fightScenePlayerData.get(i.name).addMagicDefense =rightAddMagicDefense 
		FightScenePlayers.fightScenePlayerData.get(i.name).addPhysicDefense =rightAddPhyicDefense
		FightScenePlayers.fightScenePlayerData.get(i.name).addPlayerSpeed =rightAddPlayerSpeed
		FightScenePlayers.fightScenePlayerData.get(i.name).addHp= rightAddHp
		fightScenePlayerSceneInstance.play(fightScenePlayerSceneInstance.idle)
		fightScenePlayerSceneInstance.set_name(i.name)
		playerIdx += 1
	
		var posX
		var posY
		var 倾斜度 = 35
		
		if playerIdx < 4:
			# Front row positions with a slight slant
			posX = -(playerIdx) * -50 - 20
			posY = -(playerIdx) * 倾斜度 + 150
		else:
			# Back row positions with a slight slant
			posX = (playerIdx) * -50 + 300
			posY = (playerIdx) * 倾斜度 -170
	
		fightScenePlayerSceneInstance.position.x = posX
		fightScenePlayerSceneInstance.position.y = posY
		fightScenePlayerSceneInstance.playerPosition = fightScenePlayerSceneInstance.position
		
#func changeTurn():
	if(Global.onAttackingList.size() > 0):
		if Global.onAttackingList[0] == Global.currAttacker:
			Global.onAttackingList.pop_front()
			Global.battleButtonIndex = 0

func getCurrTotalHp():
	
	var currValue = 0 
	for i in monsters:
		if is_instance_valid(i):	
			currValue += i.currHp
	return currValue
		

func remove_numbers_from_string(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not char.is_valid_int():
			result += char
	return result
	
func useDart(type, target, delta):
	
		var moveSpeed = 30
		Global.target = monsters[Global.targetMonsterIdx]
		
		var targetPosition 
		#var target = monsters[Global.targetMonsterIdx]
		if type == "keyboard":
	
			targetPosition = Global.target.position
			var newPosition = get_node("battleFieldPicture/Dart").position.lerp(targetPosition, moveSpeed * delta)
			get_node("battleFieldPicture/Dart").position.x = newPosition.x
			get_node("battleFieldPicture/Dart").position.y = newPosition.y
		elif type == "mouse" and is_instance_valid(target):
			targetPosition = target.position
		
			var newPosition = get_node("battleFieldPicture/Dart").position.lerp(targetPosition, moveSpeed * delta)

			get_node("battleFieldPicture/Dart").position.x = newPosition.x
			get_node("battleFieldPicture/Dart").position.y = newPosition.y

		


func _on_bgm_timer_timeout():
	
	get_parent().get_parent().get_node("battleBgm").volume_db = 5
	if Global.onHurry:
		get_parent().get_parent().get_node("battleBgm").volume_db = -80
#
		
	if boss == false:
		get_parent().get_parent().get_node("battleBgm").stream = load(Global.bgmList[randomBgmIndex])
		currBgm = Global.bgmList[randomBgmIndex]
	else:
		if bossBgm == null:
			return
		get_parent().get_parent().get_node("battleBgm").stream = load(bossBgm)
		currBgm = bossBgm
	
	if !Global.onHurry:
		if get_parent().get_parent().get_node("battleBgm").stream:	
			get_parent().get_parent().get_node("battleBgm").stream.loop
			get_parent().get_parent().get_node("battleBgm").play()


func _on_dead_timer_timeout():
	get_tree().change_scene_to_file("res://Scene/failScene.tscn")
func get_npc_dialogue(npc_id):
	
	if Global.npcs.has(npc_id):
		var npc = Global.npcs[npc_id]
		var dialogue_index = npc["current_dialogue_index"]
		
		if npc["dialogues"].size() > dialogue_index:
			var dialogue_entry = npc["dialogues"][dialogue_index]
			
			if dialogue_entry["unlocked"]:
				
				update_npc_dialogue_index(npc_id)
				if npc["dialogues"][dialogue_index].bgm != null:
					
					self.get_parent().get_parent().get_node("AudioStreamPlayer2D").stream = load(npc["dialogues"][dialogue_index].bgm)
					self.get_parent().get_parent().get_node("AudioStreamPlayer2D").play()
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


#func _on_button_pressed():

#	if Global.onItemSelectPicking:
#		Global.onItemSelectPicking = false
#		get_node("battleFieldPicture/Panel").visible = true
#		Global.onItemSelectPicking = false
#		get_node("battleFieldPicture/magicSelection").visible = false
#		get_node("battleFieldPicture/magicDescription").visible = false	
#		for i in magicPanel:
#			i.queue_free()
#		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
#		get_parent().get_parent().get_node("subSound").play()	


func _on_button_button_down():
	
	if !Global.noKeyboard:
		return

	if Global.onAttackPicking:
		
		canPress = false
		$canPressTimer.start()
		Global.onAttackPicking = false
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_parent().get_node("subSound").play()			
	if Global.onMagicSelectPicking:
		canPress = false
		$canPressTimer.start()
		
		get_node("battleFieldPicture/Panel").visible = true
		Global.onMagicSelectPicking = false
		Global.magicSelectIndex = 0
		get_node("battleFieldPicture/magicSelection").visible = false
		get_node("battleFieldPicture/magicDescription").visible = false	
		for i in magicPanel:
			i.queue_free()
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_parent().get_node("subSound").play()
	if Global.onMagicAttackPicking:
		$battleFieldPicture/allyInfo.visible = false
		
		canPress = false
		$canPressTimer.start()		
		Global.onMagicAttackPicking = false
		Global.onMagicSelectPicking = true
		get_node("battleFieldPicture/magicSelection").visible = true
		get_node("battleFieldPicture/magicDescription").visible = true
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_parent().get_node("subSound").play()			
		
						
	if Global.onItemSelectPicking:
		canPress = false
		$canPressTimer.start()
		Global.onItemSelectPicking = false
		get_node("battleFieldPicture/Panel").visible = true
		Global.onItemSelectPicking = false
		get_node("battleFieldPicture/magicSelection").visible = false
		get_node("battleFieldPicture/magicDescription").visible = false	
		for i in magicPanel:
			i.queue_free()
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_parent().get_node("subSound").play()	
	if Global.onItemUsePicking:
		$battleFieldPicture/allyInfo.visible = false
		
		get_node("battleFieldPicture/Panel").visible = true
		Global.onItemUsePicking = false
		Global.onItemSelectPicking = true
		get_node("battleFieldPicture/magicSelection").visible = true
		get_node("battleFieldPicture/magicDescription").visible = true
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_parent().get_node("subSound").play()			

func _on_can_press_timer_timeout():
	canPress = true


#func _on_button_pressed():
#	if Global.canBlock:
#		Global.blocked = true
#		Global.canBlock = false
#		get_tree().current_scene.get_node("battleField/battleFieldPicture/blockButton").visible = false
#		get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/兵器-钝器.ogg")
#		get_tree().current_scene.get_node("subSound").play()
#		Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "block")			
#		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
#		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false						
#		Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
#		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").play("block")
#		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").visible = true


func _on_block_button_button_down():
	if !Global.noKeyboard:
		return
	if Global.canBlock:
		Global.blocked = true
		Global.canBlock = false
		get_tree().current_scene.get_node("battleFieldLayer/battleField/battleFieldPicture/blockButton").visible = false
		#get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/兵器-钝器.ogg")
		get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/097-Attack09.ogg")
		get_tree().current_scene.get_node("subSound").play()
		Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "block")			
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false						
		Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").play("block")
		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").visible = true



func decrease_value_over_time(target_value: float, duration: float):
	var initial_value = $battleFieldPicture/Panel/ProgressBar.value
	
	var time_passed = 0.0
	while time_passed < duration:
		time_passed += get_process_delta_time()
		var progress = time_passed / duration
		$battleFieldPicture/Panel/ProgressBar.value = lerp(initial_value, target_value, progress)
		await get_tree().create_timer(0.01).timeout  # Adjust the delay for smoothness
	$battleFieldPicture/Panel/ProgressBar.value = target_value  # Ensure the value reaches exactly the target value
	
func decrease_value_over_time_player(target_value: float, duration: float, type):
	var initial_value
	if type == "hp":
		initial_value = $battleFieldPicture/currPlayer/Panel/background/hpBar.value
	else:
		initial_value = $battleFieldPicture/currPlayer/Panel/background/manaBar.value
	var time_passed = 0.0
	while time_passed < duration:
		time_passed += get_process_delta_time()
		var progress = time_passed / duration
		if type == "hp":
			$battleFieldPicture/currPlayer/Panel/background/hpBar.value = lerp(initial_value, target_value, progress)
		else:
			$battleFieldPicture/currPlayer/Panel/background/manaBar.value = lerp(initial_value, target_value, progress)
		await get_tree().create_timer(0.01).timeout  # Adjust the delay for smoothness
		
	if type == "hp":
		$battleFieldPicture/currPlayer/Panel/background/hpBar.value	= target_value
	else:
		$battleFieldPicture/currPlayer/Panel/background/manaBar.value	= target_value	

 
func decrypt(value):
	return value/Global.enKey


func _on_big_magic_timer_timeout():
	$battleFieldPicture/bigMagic.visible = false

func showLastHit():
	pass


func _on_queue_free_timeout():
	Global.onAttackPicking = false
	queue_free()
	totalExp = 0

			

func play_effect_once():
	if shader_material == null:
		return

	shader_material.set("play_once", true)
	await get_tree().create_timer(1.0).timeout
	shader_material.set("play_once", false)


func _on_up_button_button_down():
	if !Global.noKeyboard:
		return
	var onBattleCommend = false
	for i in players:
		if i.get_node("battleCommends").visible:
			onBattleCommend = true
			
	if onBattleCommend:
		if Global.battleButtonIndex == 0:
			Global.battleButtonIndex = 4
		Global.battleButtonIndex -= 1
		
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_parent().get_node("subSound").play()		
		
	elif Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false:
		magicPanel = get_tree().get_nodes_in_group("magic")
		if Input.is_action_just_pressed("ui_up"):
			if Global.magicSelectIndex <= 1:
				return
			else:
				Global.magicSelectIndex -= 3	
			get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
			get_parent().get_parent().get_node("subSound").play()						


func _on_down_button_button_down():
	if !Global.noKeyboard:
		return
	var onBattleCommend = false
	for i in players:
		if i.get_node("battleCommends").visible:
			onBattleCommend = true
	if onBattleCommend:
		if Global.battleButtonIndex== 3:
			Global.battleButtonIndex = -1

		Global.battleButtonIndex += 1
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_parent().get_node("subSound").play()				
	elif Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false:
		magicPanel = get_tree().get_nodes_in_group("magic")
		if Global.magicSelectIndex >= magicPanel.size() - 3:
			return
		else:
			Global.magicSelectIndex += 3	
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_parent().get_node("subSound").play()	


#			if Input.is_action_just_pressed("ui_left"):
#				if Global.magicSelectIndex == 0:
#					return
#				Global.magicSelectIndex -= 1
#				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
#				get_parent().get_parent().get_node("subSound").play()					
#			if Input.is_action_just_pressed("ui_right"):
#				if Global.magicSelectIndex == Global.currPlayerMagic.size() - 1:
#					return
#				Global.magicSelectIndex += 1
#				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
#				get_parent().get_parent().get_node("subSound").play()				
			


func _on_right_button_button_down():
	if !Global.noKeyboard:
		return
	for i in players:
		i.get_node("selectIndic").visible = false
	players[Global.allieSelectIndex].get_node("selectIndic").visible = false		
		
		
	if Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false:
		magicPanel = get_tree().get_nodes_in_group("magic")
		if Global.magicSelectIndex == Global.currPlayerMagic.size() - 1:
			return
		Global.magicSelectIndex += 1
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_parent().get_node("subSound").play()			
	if Global.onMagicAttackPicking:
		
		#if Global.currPlayerMagic.size()>0:
		if Global.currUsingMagic.attackType != "buff":
			Global.target = monsters[Global.targetMonsterIdx]  				

			if Global.targetMonsterIdx == 0:
				Global.targetMonsterIdx = monsters.size() - 1
			else:
				Global.targetMonsterIdx -= 1				
		else:
			Global.target = players[Global.allieSelectIndex]  

			if Global.allieSelectIndex == players.size() - 1:
				Global.allieSelectIndex = 0
			else:
				Global.allieSelectIndex += 1
			Global.target = players[Global.allieSelectIndex]
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
		get_parent().get_parent().get_node("subSound").play()	
				
	elif Global.onAttackPicking:				
		if currPlayer.name != "朱雀":	
			if Global.targetMonsterIdx == 0:
				Global.targetMonsterIdx = monsters.size() - 1
			else:
				Global.targetMonsterIdx -= 1
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Global.allieSelectIndex == players.size() - 1:
				Global.allieSelectIndex = 0
			else:
				Global.allieSelectIndex += 1
			Global.target = players[Global.allieSelectIndex]
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
		get_parent().get_parent().get_node("subSound").play()
			
			
			
								
	#道具用在谁身上				
	if Global.onItemUsePicking:
		if Global.currUsingItem.info.effect == "damage":
			Global.target = monsters[Global.targetMonsterIdx]  
			if Global.targetMonsterIdx == 0:
				Global.targetMonsterIdx = monsters.size() - 1
			else:
				Global.targetMonsterIdx -= 1
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Global.allieSelectIndex == players.size() - 1:
				Global.allieSelectIndex = 0
			else:
				Global.allieSelectIndex += 1
			Global.target = players[Global.allieSelectIndex]

			












func _on_left_button_button_down():
	if !Global.noKeyboard:
		return
	for i in players:
		i.get_node("selectIndic").visible = false
	players[Global.allieSelectIndex].get_node("selectIndic").visible = false
	if Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false:
		magicPanel = get_tree().get_nodes_in_group("magic")
		if Global.magicSelectIndex == 0:
			return
		Global.magicSelectIndex -= 1
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
		get_parent().get_parent().get_node("subSound").play()		
	if Global.onMagicAttackPicking:
		
		#if Global.currPlayerMagic.size()>0:
		if Global.currUsingMagic.attackType != "buff":
			Global.target = monsters[Global.targetMonsterIdx]  
			if Global.targetMonsterIdx == monsters.size() - 1:
				Global.targetMonsterIdx = 0
			else:
				Global.targetMonsterIdx += 1
			Global.target = monsters[Global.targetMonsterIdx]								
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Global.allieSelectIndex == 0:
				return
			Global.allieSelectIndex -= 1
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
		get_parent().get_parent().get_node("subSound").play()					
	elif Global.onAttackPicking:
			#Global.target = monsters[Global.targetMonsterIdx]  
		if currPlayer.name != "朱雀":
			if Global.targetMonsterIdx == monsters.size() - 1:
				Global.targetMonsterIdx = 0
			else:
				Global.targetMonsterIdx += 1
			Global.target = monsters[Global.targetMonsterIdx]				
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Global.allieSelectIndex == 0:
				return
			else:
				Global.allieSelectIndex -= 1						
		get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
		get_parent().get_parent().get_node("subSound").play()		
	
	#道具用在谁身上				
	if Global.onItemUsePicking:
		#if Global.currPlayerMagic.size()>0:
		if Global.currUsingItem.info.effect == "damage":
			Global.target = monsters[Global.targetMonsterIdx]  
			if Global.targetMonsterIdx == monsters.size() - 1:
				Global.targetMonsterIdx = 0
			else:
				Global.targetMonsterIdx += 1
			Global.target = monsters[Global.targetMonsterIdx]
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Global.allieSelectIndex == 0:
				return
			else:
				Global.allieSelectIndex -= 1	
			

func _on_accept_button_button_down():
	if !Global.noKeyboard:
		return
	if Global.onAttackingList:
		if Global.onMagicSelectPicking == true and Global.onMagicAttackPicking == false :
			magicPanel = get_tree().get_nodes_in_group("magic")

			if Global.playerMagicList[Global.magicSelectIndex].name == "高等炼体术":
				return
			if Global.playerMagicList[Global.magicSelectIndex].cost > currPlayer.currMp:
				$systemSound.stream = load("res://Audio/SE/humandie2 (5).ogg")
				$systemSound.play()
				return		
			else:
				get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_parent().get_node("subSound").play()	
							
				Global.onMagicSelectPicking = false
				Global.onMagicAttackPicking = true		

	
	
	
		elif Global.onMagicAttackPicking and  Global.onMagicSelectPicking == false and Global.onAttackingList and currPlayer.playerName == Global.onAttackingList[0] :
			#如果法术不是buff，那就指向敌人
			
			currPlayer.get_parent().get_node("Panel").visible = true
			if Global.currPlayerMagic[Global.magicSelectIndex].attackType != "buff" and monsters.size()>0:
				Global.target = monsters[Global.targetMonsterIdx]
				currPlayer.target = monsters[Global.targetMonsterIdx]
				currPlayer.targetPosition = Global.target.position
			#指向自己人
			else:
				currPlayer.get_parent().get_node("enemyInfo").visible = false
				currPlayer.get_parent().get_node("allyInfo").visible = true
				
				Global.target = players[Global.allieSelectIndex]
				currPlayer.target = Global.target
				

			if currPlayer.playerMagic[Global.magicSelectIndex].attackType == "multi":
				currPlayer.multiPosition = currPlayer.targetPosition
				
				Global.onMultiHit = currPlayer.playerMagic[Global.magicSelectIndex].multiHitTimes 

				currPlayer.cast_magic_multiple_times(deltas, currPlayer.playerMagic[Global.magicSelectIndex], Global.target, "keyboard", currPlayer.playerMagic[Global.magicSelectIndex].multiHitTimes )
			else:

				currPlayer.castMagic(deltas, currPlayer.playerMagic[Global.magicSelectIndex], Global.target, "keyboard", false)
			Global.onAttackPicking = false
			Global.onMagicAttackPicking = false
			Global.onAttacking = false
	if Global.onAttackPicking and Global.onAttackingList[0] == currPlayer.playerName:
			
			if monsters:
		
				Global.target = monsters[Global.targetMonsterIdx]
			
			
			
			if Global.target or currPlayer.target and currPlayer.canAttack == true:
				if currPlayer.playerName == "朱雀":
					currPlayer.canSelect = false
					Global.target = players[Global.allieSelectIndex]					
					currPlayer.朱雀auto()
					return
				currPlayer.attack(Global.target, "keyboard")
				if currPlayer.playerName != '姜韵':
					currPlayer.moveCharacter(deltas)    #重点，把移动和攻击分开，这样就算onAttacking = true 不能重复按之后也能移动
				currPlayer.canSelect = false
			else:
				return
	if Global.onItemUsePicking and  Global.onItemSelectPicking == false and Global.onAttackingList and currPlayer.playerName == Global.onAttackingList[0] and currPlayer.itemList.size() > 0:
		if Global.currUsingItem.info.effect == "hp":
			get_parent().get_node("allyInfo").visible = true
			
		Global.target = players[Global.allieSelectIndex]
		currPlayer.useItem(Global.currUsingItem, Global.target, "keyboard") 	
		Global.onItemUsePicking = false
	
	if currPlayer.commanButtonIndex == 1 and Global.onMultiHit == 0:
		currPlayer.attackButton.modulate = "#00f2e9"
		currPlayer.magicButton.modulate = "#ffffff"
		currPlayer.defenseButton.modulate = "#ffffff"
		currPlayer.itemButton.modulate = "#ffffff"
		if currPlayer.get_parent().get_parent().canPress:
			if Global.onAttackPicking == false and currPlayer.canAttack and Global.onAttackingList.size()>0 and (Global.onAttackingList[0] in Global.onTeamPlayer or Global.onAttackingList[0] in Global.onTeamPet):
				if currPlayer.canAttack:
					Global.onAttackPicking = true
					currPlayer.get_parent().get_node("enemyInfo").visible = false
					get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_parent().get_node("subSound").play()			



	if currPlayer.commanButtonIndex == 2 and Global.onMultiHit == 0:
		currPlayer.magicButton.modulate = "#00f2e9"
		
		currPlayer.attackButton.modulate = "#ffffff"
		currPlayer.defenseButton.modulate = "#ffffff"
		currPlayer.itemButton.modulate = "#ffffff"
		
		if currPlayer.get_parent().get_parent().canPress:
			if Global.onAttackingList:
				if Global.onMagicSelectPicking == false and Global.onMagicAttackPicking == false and Global.onMagicAttacking == false and currPlayer.playerName == Global.onAttackingList[0]:
					currPlayer.get_node("battleCommends").visible = false
					Global.onMagicSelectPicking = true
					Global.magicSelectIndex = 0
					currPlayer.get_parent().get_node("magicDescription").visible = true
					currPlayer.get_parent().get_node("magicSelection").visible = true
					currPlayer.get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					currPlayer.get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()							

					for i in currPlayer.playerMagic:
						currPlayer.magicScene = preload("res://Scene/magic_selection.tscn")
						var magicSceneInstance = currPlayer.magicScene.instantiate()
						magicSceneInstance.get_node("Button/name").text = i.name
						magicSceneInstance.get_node("Button/cost").text = str(i.cost)
						magicSceneInstance.get_node("Button/icon").texture = load(i.icon)
						if i.cost >currPlayer.currMp:
							magicSceneInstance.get_node("Button").modulate.a = 0.4
						currPlayer.get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)
	
	
	
	if currPlayer.commanButtonIndex == 3 and Global.onMultiHit == 0:
		currPlayer.defenseButton.modulate = "#00f2e9"
		
		currPlayer.attackButton.modulate = "#ffffff"
		currPlayer.magicButton.modulate = "#ffffff"
		currPlayer.itemButton.modulate = "#ffffff"
		if currPlayer.canDefense:
			currPlayer.canDefense = false
			currPlayer.get_node("canDefense").start()
			
			currPlayer.currHp += currPlayer.hp /10
			currPlayer.currMp += currPlayer.mp/10
			if currPlayer.currMp > currPlayer.mp:
				currPlayer.currMp = currPlayer.mp
			currPlayer.speedBar = 0
			currPlayer.get_node("Control/speedBar").value = 0
			currPlayer.play(currPlayer.playerName + "defend")
			currPlayer.get_node("battleCommends").visible = false
			currPlayer.get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
			currPlayer.get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()
	if currPlayer.commanButtonIndex == 4 and Global.onMultiHit == 0:
		currPlayer.itemButton.modulate = "#00f2e9"
		
		currPlayer.attackButton.modulate = "#ffffff"
		currPlayer.magicButton.modulate = "#ffffff"
		currPlayer.defenseButton.modulate = "#ffffff"
	
		if currPlayer.get_parent().get_parent().canPress:
			if Global.onAttackingList and currPlayer.itemList.size()>0:
				if Global.onItemSelectPicking == false and Global.onItemUsePicking == false and Global.onItemUsing == false and currPlayer.playerName == Global.onAttackingList[0]:
					currPlayer.get_node("battleCommends").visible = false
					Global.onItemSelectPicking = true
					get_parent().get_node("magicDescription").visible = true
					get_parent().get_node("magicSelection").visible = true
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_parent().get_parent().get_parent().get_node("subSound").play()				
					for i in currPlayer.itemList:
						currPlayer.magicScene = preload("res://Scene/itemButton.tscn")
						#magicScene = preload("res://Scene/itemSelection.tscn")
						var magicSceneInstance = currPlayer.magicScene.instantiate()
						
						magicSceneInstance.get_node("Button/name").text = i.info.name
						magicSceneInstance.get_node("Button/amount").text = ""
						magicSceneInstance.get_node("Button/icon").texture = load(i.info.icon)
						get_parent().get_node("magicSelection/GridBoxContainer").add_child(magicSceneInstance)		
	


func _on_fight_time_timeout():
	fightTime += 1

func seconds_to_hms(total_seconds: int) -> String:
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60

	return str(hours) + "时" + str(minutes) + "分" + str(seconds) + "秒"

func setFightTime():
	Global.fightTime = seconds_to_hms(75)
