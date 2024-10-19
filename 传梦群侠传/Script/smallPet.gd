extends AnimatedSprite2D
var petName




var idle = "idle"
var magic = "magic"
var autoAttack = "autoAttack"

var state = idle
var rageBar = 0
var str 
var monsters 
var aliveMonsters = []
var oriPosition
var canMove = false
var timerCalled = false
var turnIdleCalled = false
var target
var magicInfo
var players
var targetFound = false
# Called when the node enters the scene tree for the first time.
var playerName = ["时追云", "凌若昭", "小二", "姜韵"]
var rageFreq
func _ready():
	
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
			
			play(petName + magic)
			
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
			
		if Global.onAttackingList:
			if Global.onAttackingList[0] in playerName :
				if Global.onAttacking or Global.onMagicAttacking:
					if SmallPetData.currSmallPetData[petName].hungry >= SmallPetData.currSmallPetData[petName].hungryValue:
						state = autoAttack
		if rageBar >= 100:
			state = magic
			rageBar = 0 


func _on_animation_finished():
	targetFound = false
	if state == autoAttack:
		if SmallPetData.currSmallPetData[petName].hungry >= SmallPetData.currSmallPetData[petName].hungryValue:
			rageBar += rageFreq
			attack()
			SmallPetData.currSmallPetData[petName].hungry -= SmallPetData.currSmallPetData[petName].hungryValue
	if state == magic:
		castMagic()
	
	state = idle
	canMove = false
	position = oriPosition	
	timerCalled = false

func attack():
	if is_instance_valid(target):
		
		target.get_node("Label").text = str(str)
		target.get_node("petHpAnimation").play("petHp")
		target.currHp -= str 
	print(SmallPetData.currSmallPetData[petName].hungry)
func castMagic():
	magicInfo = SmallPetData.currSmallPetData[petName].petMagic
	if magicInfo.type == "healing":
		var alivePlayer=[]
		for i in players:
			if i.currHp>=0:
				alivePlayer.append(i)
		if find_player_with_lowest_hp_percent(alivePlayer):
			find_player_with_lowest_hp_percent(alivePlayer).currHp += magicInfo.value
		
		
func moveCharacter(delta):
	
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
