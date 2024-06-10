extends Node

var currSceneMonstersName = []
var currSceneMonstersData

var enemyScene  # 用来获取enemy的scene，目的是用来实例化enemy
var fightScenePlayerScene

var monsterIdx = Global.monsterIdx #获取怪物的index，根据这个锁定目标
var playerIdx = Global.playerIdx

var fightScenePlayerData = []

var monsters #获取已经实例化的怪物
var players

var randomBgmIndex 
var magicPanel
var currPlayer
var deadTrigger = false

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
func areAllPlayersDead() -> bool:
	for player in players:
		if player.alive:
			return false
	# If the loop completes without finding any living player, return true
	return true

func _ready():
	
	if Global.atNight == true:
		get_parent().get_node("nightBgm").stop()
	
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

	$battleFieldPicture/Panel/ProgressBar.max_value = totalHp
	
	#FightScenePlayers.update_players_with_item_stats()
	#随机
	
	$bgmTimer.start()
	randomBgmIndex = randi() % Global.bgmList.size()
#	get_parent().get_node("AudioStreamPlayer2D").stream = load(Global.bgmList[randomIndex])
#	get_parent().get_node("AudioStreamPlayer2D").stream.loop
#	get_parent().get_node("AudioStreamPlayer2D").play()
	
func _process(delta):
	#var players = get_tree().get_nodes_in_group("fightScenePlayer")
	if Global.onAttackingList.size() > 0:
		if Global.onAttackingList[0] in Global.onTeamPlayer or Global.onAttackingList[0] in Global.onTeamPet:
			$battleFieldPicture/currPlayer.visible = true
			$battleFieldPicture/currPlayer/Panel/currPlayerName.text = Global.onAttackingList[0]
			$battleFieldPicture/currPlayer/Panel/hpBar/Label2.text = str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currHp) + "/" + str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addHp)
			$battleFieldPicture/currPlayer/Panel/hpBar.max_value = FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).hp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addHp
			$battleFieldPicture/currPlayer/Panel/hpBar.value = FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currHp
			$battleFieldPicture/currPlayer/Panel/manaBar/Label2.text = str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currMp) + "/" + str(FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addMp)
			$battleFieldPicture/currPlayer/Panel/manaBar.max_value = FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).mp + FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).addMp
			$battleFieldPicture/currPlayer/Panel/manaBar.value = FightScenePlayers.fightScenePlayerData.get(Global.onAttackingList[0]).currMp			
			var children = $battleFieldPicture/currPlayer/Panel/buffs.get_children()
			for i in children:
				i.visible = false
			for i in players:
				if i.name == Global.onAttackingList[0]:
					#print(i.buffs,111)
					for index in i.buffs.size():					
						get_node("battleFieldPicture/currPlayer/Panel/buffs/buff"+str(index+1)).visible = true
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
											
														
						get_node("battleFieldPicture/currPlayer/Panel/buffs/buff"+str(index+1)).texture = load(icon)	
					
		else:
			$battleFieldPicture/currPlayer.visible = false
	else:
		$battleFieldPicture/currPlayer.visible = false

			
			
			
	get_parent().get_node("DirectionalLight2D").energy = 0	
	if Global.atNight == true:
		get_parent().get_node("nightBgm").stop()
		
	if randiTrans == 0:
		get_node("battleFieldPicture/trans").set_fill_mode(0)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.5
		get_node("battleFieldPicture/trans").value -= 1 
	elif randiTrans == 1:
		get_node("battleFieldPicture/trans").set_fill_mode(1)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.5 
		get_node("battleFieldPicture/trans").set_fill_mode(2)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1
	elif randiTrans == 3:
		get_node("battleFieldPicture/trans").set_fill_mode(3)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 4:
		get_node("battleFieldPicture/trans").set_fill_mode(4)
		get_node("battleFieldPicture/trans").self_modulate.a  = 0.5
		get_node("battleFieldPicture/trans").value -= 1	
	elif randiTrans == 5:
		get_node("battleFieldPicture/trans").set_fill_mode(5)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 6:
		get_node("battleFieldPicture/trans").set_fill_mode(6)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1
	elif randiTrans == 7:
		get_node("battleFieldPicture/trans").set_fill_mode(7)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1 	
	elif randiTrans == 8:
		get_node("battleFieldPicture/trans").set_fill_mode(8)
		get_node("battleFieldPicture/trans").self_modulate.a  =0.5
		get_node("battleFieldPicture/trans").value -= 1		
	elif randiTrans == 9:
		get_node("battleFieldPicture/trans").self_modulate.a -= 0.01	
	if get_node("battleFieldPicture/trans").value == 0:
		get_node("battleFieldPicture/trans").visible = false

	monsters = get_tree().get_nodes_in_group("monster")
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	
			
	$battleFieldPicture/Panel/ProgressBar.value = getCurrTotalHp()
	
	$battleFieldPicture/enemyInfo.visible = false
	if Global.onAttackPicking or Global.onMagicAttackPicking:
		if Global.target and monsters:
			$battleFieldPicture/enemyInfo.visible = true
			$battleFieldPicture/enemyInfo/enemyName.text = remove_numbers_from_string(monsters[Global.targetMonsterIdx].name)
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
									
				get_node("battleFieldPicture/enemyInfo/buffs/buff"+str(index+1)).texture = load(icon)			
		$battleFieldPicture/allyInfo/allyName.text = players[Global.allieSelectIndex].name
		$battleFieldPicture/allyInfo/hpBar.max_value = players[Global.allieSelectIndex].hp
		$battleFieldPicture/allyInfo/hpBar.value = players[Global.allieSelectIndex].currHp
		$battleFieldPicture/allyInfo/hpBar/Label2.text = str(players[Global.allieSelectIndex].currHp) + "/" + str(players[Global.allieSelectIndex].hp)
	
		$battleFieldPicture/allyInfo/manaBar.max_value = players[Global.allieSelectIndex].mp
		$battleFieldPicture/allyInfo/manaBar.value = players[Global.allieSelectIndex].currMp
		$battleFieldPicture/allyInfo/manaBar/Label2.text = str(players[Global.allieSelectIndex].currMp) + "/" + str(players[Global.allieSelectIndex].mp)
		
		var allyBuffSlot =  $battleFieldPicture/allyInfo/buffs.get_children()
		for buff in players[Global.allieSelectIndex].buffs:
			pass
#		for buff in $battleFieldPicture/allyInfo/buffs.get_children():
#			print(players[Global.allieSelectIndex])
		
	if Global.onItemUsePicking:
		if Global.currUsingItem.info.effect == "damage":
			$battleFieldPicture/enemyInfo.visible = true
			$battleFieldPicture/enemyInfo/enemyName.text = remove_numbers_from_string(monsters[Global.targetMonsterIdx].name)
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
									
												
				get_node("battleFieldPicture/allyInfo/buffs/buff"+str(index+1)).texture = load(icon)	
			for buff in players[Global.allieSelectIndex].buffs:
				pass
	if Global.onAttackingList:
		for i in players:
			if i.name == Global.onAttackingList[0]:
				currPlayer = i
			
	if areAllPlayersDead() and !deadTrigger:
		
		if Global.canLose:
			for i in players:
				i.currHp += i.hp/10
			Global.lost = true
			get_parent().get_node("player").visible = true
			get_parent().get_node("player").canMove = true
			get_parent().get_node("enterFightCd").start()
			get_parent().onFight = false
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
				get_parent().get_node("nightBgm").play()
				get_parent().get_node("DirectionalLight2D").energy = 4.7	
			else:
				if !Global.onHurry:
					get_parent().get_node("AudioStreamPlayer2D").volume_db = 4
				elif Global.onHurry:
					get_parent().get_node("AudioStreamPlayer2D").volume_db = 4.5			
			get_parent().get_node("battleBgm").stop()
			queue_free()
			
			if dialogue:
				var npc = Global.npcs[dialogue]
				var dialogue_index = npc["current_dialogue_index"]
				var dialogue_entry = npc["dialogues"][dialogue_index]
				print(dialogue_entry,dialogue_entry.chapter)
				var chapterNum = dialogue_entry.chapter
				DialogueManager.show_chat(load("res://Dialogue/"+str(chapterNum)+".dialogue"),get_npc_dialogue(dialogue))
			get_parent().get_node("shadow").visible = true
			get_parent().get_node("CanvasLayer").visible = true
			get_parent().get_node("battleBgm").stop()
			if !Global.onHurry:
				get_parent().get_node("AudioStreamPlayer2D").play()				
		else:		
			deadTrigger = true
			get_tree().current_scene.get_node("AnimationPlayer").play("turnDark")
			$systemSound.stream = load("res://Audio/SE/011-System11.ogg")
			$systemSound.play()
			$deadTimer.start()
		
		
	#循环播放随机战斗背景音乐
	if get_parent().get_node("battleBgm").is_playing() == false:
		get_parent().get_node("battleBgm").stream = load(currBgm)
		get_parent().get_node("battleBgm").play()
	
	#如果怪物等于0就摧毁战斗场景并且让一切恢复成战斗之前
	if monsters.size() <= 0:	
		for i in players:
			i.currHp += i.hp/10

		get_parent().get_node("player").visible = true
		get_parent().get_node("player").canMove = true
		get_parent().get_node("enterFightCd").start()
		get_parent().onFight = false
		Global.monsterIdx = -1
		Global.onAttackingList = []
		get_parent().get_node("subSound").stream = load("res://Audio/ME/胜利.wav")
		get_parent().get_node("subSound").play()
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
			get_parent().get_node("nightBgm").play()
			get_parent().get_node("DirectionalLight2D").energy = 4.7	
		else:
			if !Global.onHurry:
				get_parent().get_node("AudioStreamPlayer2D").volume_db = 8
			elif Global.onHurry:
				get_parent().get_node("AudioStreamPlayer2D").volume_db = 4.5		
		queue_free()
		if dialogue:
			DialogueManager.show_chat(load("res://Dialogue/"+str(Global.current_chapter_id)+".dialogue"),get_npc_dialogue(dialogue))

	
		get_parent().get_node("shadow").visible = true
		get_parent().get_node("CanvasLayer").visible = true
		#战后结算经验和金币
		get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").visible = false
		get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp").visible = true
		get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold").visible = true
		get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp/expValue").text = str(totalExp)
		get_parent().get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold/goldValue").text = str(totalGold)
		Global.systemMsg.append("全队获得了 " + str(totalExp) + " 经验 "+ "和 "+ str(totalGold) + " 金币")
		get_tree().current_scene.get_node("CanvasLayer").renderMsg()
		for player_name in FightScenePlayers.fightScenePlayerData:
			var player = FightScenePlayers.fightScenePlayerData[player_name]
			player["exp"] += totalExp
		FightScenePlayers.golds += totalGold
		get_parent().get_node("battleBgm").stop()
		if !Global.onHurry:
			get_parent().get_node("AudioStreamPlayer2D").play()
		for i in Global.onTeamPet:
			for player in players:
				if player.name == i:
					player.currHp = FightScenePlayers.fightScenePlayerData.get(i).hp
					player.currMp = FightScenePlayers.fightScenePlayerData.get(i).mp
			FightScenePlayers.fightScenePlayerData.get(i).currHp = 	FightScenePlayers.fightScenePlayerData.get(i).hp
			FightScenePlayers.fightScenePlayerData.get(i).currMp = 	FightScenePlayers.fightScenePlayerData.get(i).mp				
			
			
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
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.targetMonsterIdx == 0:
					Global.targetMonsterIdx = monsters.size() - 1
				else:
					Global.targetMonsterIdx -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()					
		else:
			Global.target = players[Global.allieSelectIndex]  
			if Input.is_action_just_pressed("ui_right"):
				if Global.allieSelectIndex == players.size() - 1:
					Global.allieSelectIndex = 0
				else:
					Global.allieSelectIndex += 1
				Global.target = players[Global.allieSelectIndex]
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()	
			if Input.is_action_just_pressed("ui_left"):
				if Global.allieSelectIndex == 0:
					return
				Global.allieSelectIndex -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()					
	elif Global.onAttackPicking:
			#Global.target = monsters[Global.targetMonsterIdx]  
			if Input.is_action_just_pressed("ui_left"):
				if Global.targetMonsterIdx == monsters.size() - 1:
					Global.targetMonsterIdx = 0
				else:
					Global.targetMonsterIdx += 1
				Global.target = monsters[Global.targetMonsterIdx]
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.targetMonsterIdx == 0:
					Global.targetMonsterIdx = monsters.size() - 1
				else:
					Global.targetMonsterIdx -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/064-Swing03.ogg")
				get_parent().get_node("subSound").play()						
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
					Global.magicSelectIndex -= 2	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()						
					
			if Input.is_action_just_pressed("ui_down"):
				if Global.magicSelectIndex >= magicPanel.size() - 2:
					return
				else:
					Global.magicSelectIndex += 2	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left"):
				if Global.magicSelectIndex == 0:
					return
				Global.magicSelectIndex -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.magicSelectIndex == Global.currPlayerMagic.size() - 1:
					return
				Global.magicSelectIndex += 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()				
			

			
			if Input.is_action_just_released("ui_accept"):
				if Global.playerMagicList[Global.magicSelectIndex].cost > currPlayer.currMp:
					$systemSound.stream = load("res://Audio/SE/humandie2 (5).ogg")
					$systemSound.play()
					return		
				else:
					get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
					get_parent().get_node("subSound").play()	
								
					Global.onMagicSelectPicking = false
					Global.onMagicAttackPicking = true					
		elif Global.onItemSelectPicking == true and Global.onItemUsePicking == false :
			magicPanel = get_tree().get_nodes_in_group("magic")
			if Input.is_action_just_pressed("ui_up"):
				if Global.itemSelectIndex <= 1:
					return
				else:
					Global.itemSelectIndex -= 2	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()						
			if Input.is_action_just_pressed("ui_down"):
				if Global.itemSelectIndex >= Global.itemList.size() - 2:
					return
				else:
					Global.itemSelectIndex += 2	
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()	


			if Input.is_action_just_pressed("ui_left"):
				if Global.itemSelectIndex == 0:
					return
				Global.itemSelectIndex -= 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()					
			if Input.is_action_just_pressed("ui_right"):
				if Global.itemSelectIndex == Global.itemList.size() - 1:
					return
				Global.itemSelectIndex += 1
				get_parent().get_node("subSound").stream = load("res://Audio/SE/001-System01.ogg")
				get_parent().get_node("subSound").play()				
			

			
			if Input.is_action_just_released("ui_accept"):
				Global.onItemSelectPicking = false
				Global.onItemUsePicking = true					
				get_parent().get_node("subSound").stream = load("res://Audio/SE/002-System02.ogg")
				get_parent().get_node("subSound").play()				
			
			
			#magicPanel[2].get_node("Button").grab_focus()
			
			
#	if Global.onMagicSelectPicking:
#		magicPanel = get_tree().get_nodes_in_group("magic")
#		#magicPanel[Global.magicSelectIndex].get_node("Button").grab_focus()	
#		for i in magicPanel:
#			if i == magicPanel[Global.magicSelectIndex]:
#				i.get_node("Button").modulate = "ff0000"
#			else:
#				i.get_node("Button").modulate = "ffffff"
		#magicPanel[Global.magicSelectIndex].get_node("Button").modulate = "ff0000"
			

	#让全部场景中的怪物被定位攻击目标时显示指针
	for i in monsters:
			if !Global.onAttacking and	Global.target == i and Global.onAttackPicking and i.animation != remove_numbers_from_string(i.name + "hurt"):
				i.get_node("selectIndic").visible = true
			
			elif !Global.onMagicAttacking and Global.target == i and Global.onMagicAttackPicking and i.animation != remove_numbers_from_string(i.name + "hurt") and Global.currPlayerMagic[Global.magicSelectIndex].attackType != "buff":
				i.get_node("selectIndic").visible = true
				
			elif Global.target == i and Global.onItemUsePicking and i.animation != remove_numbers_from_string(i.name + "hurt"):
				i.get_node("selectIndic").visible = true
		
			else:
				i.get_node("selectIndic").visible = false
				
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
		enemySceneInstance.hp = monsterData.hp
		enemySceneInstance.idle = monsterData.idle
		enemySceneInstance.monsterName = monsterData.name
		enemySceneInstance.monsterMagicList = monsterData.monsterMagicList
		enemySceneInstance.exp = monsterData.exp
		enemySceneInstance.gold = monsterData.gold
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
		

		# Set the position of the character instance
		enemySceneInstance.position.x = posX
		enemySceneInstance.position.y = posY
		enemySceneInstance.monsterPosition = enemySceneInstance.position
		# Add the character instance to the scene hierarchy
		$battleFieldPicture.add_child(enemySceneInstance)

		# Play the idle animation
		enemySceneInstance.play(enemySceneInstance.idle)
				
func instantiatePlayers():
	fightScenePlayerData = FightScenePlayers.callFightScenePlayerData()
	
	for i in fightScenePlayerData:
		var fightScenePlayerSceneInstance = fightScenePlayerScene.instantiate()
		fightScenePlayerSceneInstance.add_to_group("fightScenePlayers")
		fightScenePlayerSceneInstance.idle = i.idle
		fightScenePlayerSceneInstance.autoAttack = i.autoAttack
		fightScenePlayerSceneInstance.magicAutoAttack = i.magicAutoAttack
		fightScenePlayerSceneInstance.playerName = i.name
		fightScenePlayerSceneInstance.playerAttackType = i.playerAttackType
		fightScenePlayerSceneInstance.hp = i.hp
		fightScenePlayerSceneInstance.mp = i.mp
		fightScenePlayerSceneInstance.playerSpeed = i.playerSpeed
		fightScenePlayerSceneInstance.playerMagic = i.playerMagic
		fightScenePlayerSceneInstance.str = i.str
		fightScenePlayerSceneInstance.addStr = i.addStr
		
		
		fightScenePlayerSceneInstance.abilityPower = i.abilityPower
		fightScenePlayerSceneInstance.autoAttackSound = i.autoAttackSound
		fightScenePlayerSceneInstance.attackOnEnemySound = i.attackOnEnemySound
		fightScenePlayerSceneInstance.physicDefense = i.physicDefense 
		fightScenePlayerSceneInstance.magicDefense = i.magicDefense 
		fightScenePlayerSceneInstance.additionDmg = i.additionDmg
		fightScenePlayerSceneInstance.addMagicDefense = i.addMagicDefense
		fightScenePlayerSceneInstance.addPhysicDefense = i.addPhysicDefense
		fightScenePlayerSceneInstance.addPlayerSpeed = i.addPlayerSpeed
		fightScenePlayerSceneInstance.addHp = i.addHp
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
	
	get_parent().get_node("battleBgm").volume_db = 5
	
	if boss == false:
		get_parent().get_node("battleBgm").stream = load(Global.bgmList[randomBgmIndex])
		currBgm = Global.bgmList[randomBgmIndex]
	else:
		get_parent().get_node("battleBgm").stream = load(bossBgm)
		currBgm = bossBgm
	
	if !Global.onHurry:
		if get_parent().get_node("battleBgm").stream:	
			get_parent().get_node("battleBgm").stream.loop
			get_parent().get_node("battleBgm").play()


func _on_dead_timer_timeout():
	get_tree().change_scene_to_file("res://Scene/failScene.tscn")
func get_npc_dialogue(npc_id):
	if Global.npcs.has(npc_id):
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


#func _on_button_pressed():
#	print(Global.onItemSelectPicking, 1231312123)
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
	if Global.onAttackPicking:
		canPress = false
		$canPressTimer.start()
		Global.onAttackPicking = false
		get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_node("subSound").play()			
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
		get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_node("subSound").play()
	if Global.onMagicAttackPicking:
		$battleFieldPicture/allyInfo.visible = false
		$battleFieldPicture/enemyInfo.visible = false		
		canPress = false
		$canPressTimer.start()		
		Global.onMagicAttackPicking = false
		Global.onMagicSelectPicking = true
		get_node("battleFieldPicture/magicSelection").visible = true
		get_node("battleFieldPicture/magicDescription").visible = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_node("subSound").play()			
		
						
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
		get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_node("subSound").play()	
	if Global.onItemUsePicking:
		$battleFieldPicture/allyInfo.visible = false
		$battleFieldPicture/enemyInfo.visible = false
		get_node("battleFieldPicture/Panel").visible = true
		Global.onItemUsePicking = false
		Global.onItemSelectPicking = true
		get_node("battleFieldPicture/magicSelection").visible = true
		get_node("battleFieldPicture/magicDescription").visible = true
		get_parent().get_node("subSound").stream = load("res://Audio/SE/interface002.ogg")
		get_parent().get_node("subSound").play()			

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
	if Global.canBlock:
		Global.blocked = true
		Global.canBlock = false
		get_tree().current_scene.get_node("battleField/battleFieldPicture/blockButton").visible = false
		#get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/兵器-钝器.ogg")
		get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/097-Attack09.ogg")
		get_tree().current_scene.get_node("subSound").play()
		Global.alivePlayers[Global.monsterTarget].play(Global.alivePlayers[Global.monsterTarget].playerName + "block")			
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").stop()
		Global.alivePlayers[Global.monsterTarget].get_node("getHitEffect").visible = false						
		Global.alivePlayers[Global.monsterTarget].self_modulate = "#ffffff"
		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").play("block")
		Global.alivePlayers[Global.monsterTarget].get_node("blockEffect").visible = true
