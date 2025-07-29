extends AnimatedSprite2D
var petName




var idle = "idle"
var magic = "magic"
var autoAttack = "autoAttack"

var state = idle
var rageBar = 0
var str 
var tempStr = 0
var monsters 
var aliveMonsters = []
var oriPosition
var canMove = false
var timerCalled = false
var turnIdleCalled = false
var target
var targets = []
var magicInfo
var players
var targetFound = false
# Called when the node enters the scene tree for the first time.
var playerName = ["时追云", "凌若昭", "小二", "姜韵","小二真身"]
var rageFreq
func _ready():
	scale = Vector2(0.6,0.6)
	oriPosition = position
	if Global.onTeamSmallPet.size()>0:
		self.visible = true
		petName = Global.onTeamSmallPet[0]
		str = SmallPetData.currSmallPetData.get(petName).str
		rageFreq = SmallPetData.currSmallPetData.get(petName).rage
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.onTeamSmallPet.size() == 0:
		return
	players = get_tree().get_nodes_in_group("fightScenePlayers")
	$TextureProgressBar.value = rageBar
	monsters =  get_tree().get_nodes_in_group("monster")
	aliveMonsters = []
	if Global.onMultiHit <= 1:
		for i in monsters:
			if i.currHp > 0:
				aliveMonsters.append(i)
		
		if state == idle:
			play(petName + idle)
		elif state == "magic":
			targets = []
			magicInfo = SmallPetData.currSmallPetData[petName].petMagic

			if monsters.size() >magicInfo.hitNum:
				while targets.size()<magicInfo.hitNum:
					var randi = randi_range(0,aliveMonsters.size()-1)
					if (aliveMonsters[randi] in targets) == false:
						targets.append(aliveMonsters[randi])
			else:
				for target in monsters:
					targets.append(target)				
						
			for target in targets:
				if is_instance_valid(target) and magicInfo.type != "healing":
					#target.get_node("debuff").visible = true
					#target.get_node("debuff").play(magicInfo.name)
					target.get_node("getHitEffect").visible = true
					target.get_node("getHitEffect").play(magicInfo.name)			
				if magicInfo.name == "逆天破":
					target.get_node("逆天破").visible = true
					target.get_node("逆天破/AnimationPlayer").play("show")
			play(petName + magic)
			#Global.onPetAttack = true
			$onPetAttackTimer.start()
		elif state == autoAttack:
			if aliveMonsters.size() > 0:
				if !targetFound:
					target = aliveMonsters[randi_range(0,aliveMonsters.size()-1)]
				targetFound = true
		
				if !timerCalled:
					$start.start()
				timerCalled = true
				if canMove:
					moveCharacter(delta)
				#Global.onPetAttack = true
				$onPetAttackTimer.start()
		if Global.onAttackingList:
			if Global.onAttackingList[0] in playerName :
				if Global.onAttacking or Global.onMagicAttacking:
					if SmallPetData.currSmallPetData[petName].hungry >= SmallPetData.currSmallPetData[petName].hungryValue:
						state = autoAttack
		if rageBar >= 100:
		#	Global.onPetAttack = true
			$onPetAttackTimer.start()
			state = magic
			rageBar = 0 


func _on_animation_finished():
	targetFound = false
	if state == autoAttack and is_instance_valid(target):
		if target.canSee:
			if SmallPetData.currSmallPetData[petName].hungry >= SmallPetData.currSmallPetData[petName].hungryValue:
				rageBar += rageFreq
				attack()
				SmallPetData.currSmallPetData[petName].hungry -= SmallPetData.currSmallPetData[petName].hungryValue
	if state == magic:
		castMagic()
		if is_instance_valid(target):
			target.get_node("getHitEffect").visible = false
	state = idle
	canMove = false
	position = oriPosition	
	timerCalled = false

func attack():

	if is_instance_valid(target):
		if target.canSee:
			if target.currHp - (str + tempStr) <= 0:
				return
			target.get_node("Label").text = str(str + tempStr)
			target.get_node("petHpAnimation").play("petHp")
			target.currHp -= (str + tempStr)
	Global.onPetAttack = false
func castMagic():
	Global.onPetAttack = false
	magicInfo = SmallPetData.currSmallPetData[petName].petMagic
	if magicInfo.type == "healing":

		var alivePlayer=[]
		for i in players:
			if i.currHp>=0:
				alivePlayer.append(i)
		if find_player_with_lowest_hp_percent(alivePlayer):
			find_player_with_lowest_hp_percent(alivePlayer).currHp += magicInfo.value + SmallPetData.currSmallPetData[petName].abilityPower
	if magicInfo.type == "ice":
		for target in targets:
			if is_instance_valid(target):
				if target.onIce:
					return
				target.onIce = magicInfo.duration
				target.buffs.append({"onIceDebuff":  magicInfo.duration})
				target.get_node("Label").text = str(magicInfo.value)
				target.get_node("petHpAnimation").play("petHp")
				target.currHp -= magicInfo.value + SmallPetData.currSmallPetData[petName].abilityPower	
	if magicInfo.type == "aoe":
		for target in targets:
			if is_instance_valid(target):
				target.get_node("Label").text = str(magicInfo.value)
				target.get_node("petHpAnimation").play("petHp")
				target.currHp -= magicInfo.value + SmallPetData.currSmallPetData[petName].abilityPower			
	if magicInfo.type == "buff":
		if magicInfo.name == "战神念法":
			tempStr += SmallPetData.currSmallPetData[petName].abilityPower/4
		
		
func moveCharacter(delta):
	if petName == "狐葬魂":
		return
	var moveSpeed = 30
	if is_instance_valid(target):
		var newPosition = position.lerp(target.position, moveSpeed * 0.03)
	#target.play(remove_numbers_from_string(target.name) + "hurt")
	
		position.x = newPosition.x
		position.y = newPosition.y  



func _on_start_timeout():
	if !turnIdleCalled:
		$turnIdle.start()
	play(petName + autoAttack)
	attack()
	canMove = true
	
	
func remove_numbers_from_string(input_string: String) -> String:
	var result = ""
	for char in input_string:
		if not char.is_valid_int():
			result += char
	return result
	



# 寻找血量百分比最低的玩家
func find_player_with_lowest_hp_percent(players):
	var lowest_hp_player = null
	var lowest_hp_percentage = 100  # 初始化为100%
	
	for player in players:
		var hp_percentage = float(player["currHp"]) / (float(player["hp"]) + float(player["addHp"])) * 100
		if hp_percentage < lowest_hp_percentage:
			lowest_hp_percentage = hp_percentage
			lowest_hp_player = player
	
	return lowest_hp_player


func _on_on_pet_attack_timer_timeout():
	Global.onPetAttack = false
	print("petAttackStart")
