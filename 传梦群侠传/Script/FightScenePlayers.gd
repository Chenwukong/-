extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_status()
	update_players_with_item_stats()
	remove_empty_items()
	
func callFightScenePlayerData():
	var playerDataList = []
	for i in Global.onTeamPlayer:
		if i in fightScenePlayerData:
			playerDataList.append(fightScenePlayerData[i])
	for i in Global.onTeamPet:
		if i in fightScenePlayerData:
			playerDataList.append(fightScenePlayerData[i])			
			
	return playerDataList
var keyItem = {

}
var consumeItem = {
	"佛手":{
		"info": ItemData.consume.get("佛手"),
		"number": 5
	},
	"佛跳墙":{
		"info": ItemData.consume.get("佛跳墙"),
		"number": 5
	},
	"西瓜":{
		"info": ItemData.consume.get("西瓜"),
		"number": 10
	},	
}

var battleItem = {
	"金疮药":{
		"info": ItemData.battleConsume.get("金疮药"),
		"number": 5
	},
	"含沙射影":{
		"info": ItemData.battleConsume.get("含沙射影"),
		"number": 10
	}
}

var questItem = {
	
}

var bagArmorItem = {
	"大剑":{
		"info": ItemData.weapon.get("大剑"),
		"type": "weapon",
		"number": 2,
		"added": false
	},
	"布衣":{
		"info": ItemData.cloth.get("布衣"),
		"type": "cloth",
		"number": 1,
		"added": false
	},
	"方巾":{
		"info": ItemData.hat.get("方巾"),
		"type": "hat",
		"number": 1,
		"added": false
	},
	"草鞋":{
		"info": ItemData.shoes.get("草鞋"),
		"type": "shoes",
		"number": 2,	
		"added": false	
	},
}


var golds = 600
var seconds = 0

var fightScenePlayerData2= {
	"时追云":{
			"name": "时追云",
			"sex": "male",
			"icon":"res://portrait/时追云.png",
			"smallIcon":"res://main character/tile000.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 200,
			"currMp": 100,
			"potential": 0,
			"idle": "时追云idle",
			"autoAttack":'时追云autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"时追云magicAutoAttack",
			"playerMagic": [
				{
				"name": "调息法",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp","currMp",], 
				"value": 100,
				"cost": 30,
				"description": "调息周身运转，恢复状态",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/HEAL9.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (64).png",
			}			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/男-剑.ogg",
			"attackOnEnemySound": null,
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
			},
		"姜韵": {
			"name": "姜韵",
			"sex": "female",
			"icon":"res://Pictures/Pictures/烟儿.png",
			"smallIcon":"res://main character/jiangYuntile000.png",
			"playerAttackType": "range",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":1,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr":0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"mp": 100,
			"addMp":0,
			"currHp": 200,
			"currMp": 200,
			"potential": 0,
			"idle": "姜韵idle",
			"autoAttack":'姜韵autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
				{
				"name": "回春术",
				"level": 1,
				"currExp": 49,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp","currStr"], 
				"value": 50,
				"cost": 10,
				"description": "回复血量",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/108-Heal04.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (16).png",
			},
			{
				"name": "一苇渡江",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currPlayerSpeed"], 
				"value": 300,
				"cost": 10,
				"description": "提升速度",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 2,
				"duration": 4,
				"audio": "res://Audio/SE/133-Wind02.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},
			{
				"name": "冰封",
				"attackType": "debuff",
				"buffEffect": ["ice"], 
				"cost": 10,
				"description": "同时冰封3个敌人",	
				"effectArea": "aoe",
				"animationArea":"enemy",
				"effectingNum": 3,
				"duration": 2,
				"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
				"icon":"res://Icons/●图标 (119).png",
			},
			{
				"name": "催眠",
				"attackType": "debuff",
				"buffEffect": ["sleep"], 
				"cost": 10,
				"description": "同时催眠3个敌人",	
				"effectArea": "aoe",
				"animationArea":"enemy",
				"effectingNum": 3,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (88).png",
			},
			{
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 10,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},
			{
				"name": "五雷咒",
				"attackType": "range",
				"value": 10,				
				"cost": 10,
				"description": "引来天雷轰杀单体敌人",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio": "res://Audio/SE/123-Thunder01.ogg",
				"icon":"res://Icons/五雷.png"
			},
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-中性-出手.ogg",
			"attackOnEnemySound": "res://Audio/SE/法术1.ogg",
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
		},"大海龟": {
			"name": "大海龟",
			"icon":"",
			"smallIcon":"",
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":100,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr":0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"mp": 300,
			"addMp":0,
			"currHp": 200,
			"currMp": 300,
			"potential": 0,
			"idle": "大海龟idle",
			"autoAttack":'大海龟autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
			{
				"name": "水攻",
				"attackType": "range",
				"value": 2,				
				"cost": 10,
				"description": "水产基本法术",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio":"res://Audio/SE/法术12.ogg",
				"icon": "res://Icons/水攻.png",
			},{
				"name": "水漫金山",
				"attackType": "range",
				"value": 1, 
				"cost": 40,
				"description": "群攻法术",
				"effectArea": "aoe",
				"effectingNum": 4,
				"animationArea":"enemy",
				"audio":"res://Audio/SE/法术12.ogg",
				"icon":"res://Icons/●图标 (120).png"
			},			

			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/怪-法术.ogg",
			"attackOnEnemySound": "res://Audio/SE/打击1.ogg",
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
		},


}
var fightScenePlayerData = {
	"时追云":{
			"name": "时追云",
			"sex": "male",
			"icon":"res://Pictures/Pictures/时追云.png",
			"smallIcon":"res://main character/tile000.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 160,
			"currMp": 100,
			"potential": 0,
			"idle": "时追云idle",
			"autoAttack":'时追云autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"时追云magicAutoAttack",
			"playerMagic": [
				{
				"name": "调息法",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp","currMp",], 
				"value": 100,
				"cost": 30,
				"description": "调息周身运转，恢复状态",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/HEAL9.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (64).png",
			},
			{"name": "飞剑决",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"value": 2.5,
				"cost": 30,
				"description": "时追云通过修炼领悟的技能，比平A多点伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/096-Attack08.ogg",
				"icon": "res://Icons/斩龙诀.png"
			},	
	
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/男-剑.ogg",
			"attackOnEnemySound": null,
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
			},
		"姜韵": {
			"name": "姜韵",
			"sex": "female",
			"icon":"res://portrait/姜韵.png",
			"smallIcon":"res://main character/jiangYuntile000.png",
			"playerAttackType": "range",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,			
			"blockChance":1,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr":0,
			"abilityPower": 1000,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"mp": 100,
			"addMp":0,
			"currHp": 200,
			"currMp": 100000,
			"potential": 0,
			"idle": "姜韵idle",
			"autoAttack":'姜韵autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
				{
				"name": "回春术",
				"level": 1,
				"currExp": 49,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp","currStr",], 
				"value": 50,
				"cost": 10,
				"description": "回复血量",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/108-Heal04.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (16).png",
			},
			{
				"name": "一苇渡江",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currPlayerSpeed"], 
				"value": 300,
				"cost": 10,
				"description": "提升速度",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 2,
				"duration": 4,
				"audio": "res://Audio/SE/133-Wind02.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},
			{
				"name": "冰封",
				"attackType": "debuff",
				"buffEffect": ["ice"], 
				"cost": 10,
				"description": "同时冰封3个敌人",	
				"effectArea": "aoe",
				"animationArea":"enemy",
				"effectingNum": 3,
				"duration": 2,
				"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
				"icon":"res://Icons/●图标 (119).png",
			},
			{
				"name": "催眠",
				"attackType": "debuff",
				"buffEffect": ["sleep"], 
				"cost": 10,
				"description": "同时催眠3个敌人",	
				"effectArea": "aoe",
				"animationArea":"enemy",
				"effectingNum": 3,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (88).png",
			},
			{
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 10,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},
			{
				"name": "五雷咒",
				"attackType": "range",
				"value": 10,				
				"cost": 10,
				"description": "引来天雷轰杀单体敌人",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio": "res://Audio/SE/123-Thunder01.ogg",
				"icon":"res://Icons/五雷.png"
			},
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-中性-出手.ogg",
			"attackOnEnemySound": "res://Audio/SE/法术1.ogg",
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
		},
		"大海龟": {
			"name": "大海龟",
			"icon":"",
			"smallIcon":"",
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":100,
			"level": 4,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr":0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"mp": 300,
			"addMp":0,
			"currHp": 200,
			"currMp": 300,
			"potential": 0,
			"idle": "大海龟idle",
			"autoAttack":'大海龟autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
			{
				"name": "水攻",
				"attackType": "range",
				"value": 2,				
				"cost": 10,
				"description": "水产基本法术",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio":"res://Audio/SE/法术12.ogg",
				"icon": "res://Icons/水攻.png",
			},{
				"name": "水漫金山",
				"attackType": "range",
				"value": 1, 
				"cost": 40,
				"description": "群攻法术",
				"effectArea": "aoe",
				"effectingNum": 4,
				"animationArea":"enemy",
				"audio":"res://Audio/SE/法术12.ogg",
				"icon":"res://Icons/●图标 (120).png"
			},			

			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/怪-法术.ogg",
			"attackOnEnemySound": "res://Audio/SE/打击1.ogg",
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
		},
		"小二": {
			"name": "小二",
			"sex": "male",
			"icon": "res://Pictures/Pictures/1.png",
			"smallIcon":"res://portrait/小二.png",
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":0,
			"level": 4,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr":0,
			"abilityPower": 100,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"mp": 300,
			"addMp":0,
			"currHp": 200,
			"currMp": 300,
			"potential": 0,
			"idle": "小二idle",
			"autoAttack":'小二autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
			{
				"name": "千机变",
				"attackType": "special",
				"value": 2,				
				"cost": 10,
				"description": "小二模仿并释放上一次队友使用的技能",	
				"icon": "res://Icons/●图标 (91).png",
			},{
				"name": "唧唧歪歪",
				"level": 1,
				"currExp": 49,
				"needExp": 50,
				"attackType": "range",
				"value": 5,
				"cost": 30,
				"description": "小二的言语攻击，噪音污染",	
				"effectArea": "aoe",
				"effectingNum": 5,
				"animationArea":"enemy",
				"audio": "res://Audio/SE/鸟语花香.ogg",
				"icon": "res://Icons/●图标 (14).png"
			},			

			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/怪-法术.ogg",
			"attackOnEnemySound": "res://Audio/SE/打击1.ogg",
			"item":{
				"weapon":null,
				"cloth":null,
				"hat":null,
				"shoes":null,
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]
		},
}
 
var datas = {
	
}

func saveData():
	datas.battleItem = battleItem
	datas.bagArmorItem = bagArmorItem
	datas.seconds = seconds
	datas.golds = golds
	datas.fightScenePlayerData = fightScenePlayerData
	datas.questItem = questItem
	datas.keyItem = keyItem
	datas.consumeItem = consumeItem
func loadData():
	battleItem = datas.battleItem	
	bagArmorItem = datas.bagArmorItem
	seconds = datas.seconds
	golds = datas.golds
	fightScenePlayerData = datas.fightScenePlayerData
	questItem = datas.questItem
	keyItem = datas.keyItem
	consumeItem = datas.consumeItem
	
	
func update_status():
	for player_name in fightScenePlayerData:
		var player = fightScenePlayerData[player_name]

		while player["exp"] >= player["needExp"]:  # Use while loop to handle multiple level-ups
			#player["exp"] -= player["needExp"]  # Subtract the needed exp for current level
			player["level"] += 1
			player.potential += 5
			player["needExp"] = calculate_exp_for_player_level(player["level"])
			if player.name == "时追云":
				if player["level"] == 3:
					player.get("playerMagic").append(	
				{"name": "聚力",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",				
				"value": 30, 
				"cost": 30,
				"description": "增加自身攻击力",
				"effectArea": "single",
				"effectingNum":1,
				"animationArea":"self",
				"buffEffect":["currStr"],
				"duration": 4,
				"audio":"res://Audio/SE/男-法术-嗯.ogg",
				"icon":"res://Icons/●图标 (38).png"
				})
				if player["level"] == 5:
					player.get("playerMagic").append(
				{"name": "斩龙决",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"value": 2.5,
				"cost": 30,
				"description": "时追云通过修炼领悟的技能，比平A多点伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/096-Attack08.ogg",
				"icon": "res://Icons/斩龙诀.png"
				},									
						
				)
				
		var player_magic = player.get("playerMagic", [])
		for magic in player_magic:
			if magic.has("level"):
				magic["needExp"] = calculate_exp_for_magic_level(magic["level"])
				if magic.currExp >= magic.needExp:
					if magic.level < 5:
						magic.currExp = 0
						magic.level += 1
						magic.value = magic.value + 0.2 * magic.value
				if magic.level >= 5:
						magic.currExp = 250
						magic.level = 5	
						
						
						
		# Update attack damage based on player level
		if player.has("level"):
			player["needExp"] = calculate_exp_for_player_level(player["level"])
			var level = player["level"]
			#damage
			var baseDmg = 40 # Base damage at level 1
			var dmgIncreasePerLevel = 3 # Fixed amount to increase damage per level
			var newAttackDmg = baseDmg + dmgIncreasePerLevel * min(level - 1, 99) # Calculate new attack damage
			player["str"] = newAttackDmg
			#defense
			var defenseIncrease = calculate_defense_for_level(level,player["name"])
			player["magicDefense"] = defenseIncrease
			player["physicDefense"] = defenseIncrease
			#hp
			var hpIncrease = calculate_hp_for_level(level)
			player["hp"] = hpIncrease
			if player["hp"] < player["currHp"]:
				player["currHp"] = player["hp"]
			#speed
			player["playerSpeed"] = calculate_speed_for_level(player["level"],player["name"])
			#mp
			player["mp"] = calculate_mp_for_level(player["level"], player["name"])
			
			
			
func calculate_exp_for_magic_level(level):
	# You can adjust this formula as per your requirement
	return 50 * level

func calculate_exp_for_player_level(level):
	var baseExp = 50
	var linearComponent = 500 * (level - 1)  # Linear growth
	var exponentialComponent = baseExp * pow(1.14, level - 1)  # Exponential growth

	# Combine linear and exponential components
	var totalExp = linearComponent + exponentialComponent

	return int(totalExp)


func calculate_defense_for_level(level, player =null):
	var baseDefense = 50  # Base defense at level 1
	var finalDefense = 300  # Desired defense at level 100
	var defenseIncreasePerLevel = (finalDefense - baseDefense) / 99  # Linear increase per level

	var totalDefense = baseDefense + defenseIncreasePerLevel * (level - 1)
	return totalDefense
func calculate_hp_for_level(level):
	var baseHp = 200  # Base HP at level 1
	var finalHp = 2500  # Desired HP at level 100
	var hpIncreasePerLevel = (finalHp - baseHp) / 99  # Linear increase per level

	var totalHp = baseHp + hpIncreasePerLevel * (level - 1)
	return totalHp
	
func calculate_speed_for_level(level, player = null):
	var baseSpeed = 50.0  # Base speed at level 1
	var speedIncreasePerLevel = 2  # Speed increase per level
	if player == "大海龟":
		baseSpeed = 30.0
	var totalSpeed = baseSpeed + speedIncreasePerLevel * (level - 1)

	return totalSpeed
	
func calculate_mp_for_level(level, player = null):
	
	var baseMp = 100.0  # Base speed at level 1
	var mpIncreasePerLevel = 10  # Speed increase per level
	if player == "大海龟":
		baseMp = 100
	var totalMp = baseMp + mpIncreasePerLevel * (level - 1)
	return totalMp	
func apply_item_stats_to_player(player):
	for item_type in player["item"]:
		var item = player["item"][item_type]

		if item != null and not item["added"]:  # Check if item is not null and not already added
			if item["value"].has("additionDmg"):
				player["additionDmg"] += item["value"]["additionDmg"]
			if item["value"].has("addPlayerSpeed"):
				player["addPlayerSpeed"] += item["value"]["addPlayerSpeed"]
			if item["value"].has("addPhysicDefense"):
				player["addPhysicDefense"] += item["value"]["addPhysicDefense"]
			if item["value"].has("addMagicDefense"):
				player["addMagicDefense"] += item["value"]["addMagicDefense"]
			if item["value"].has("addHp"):
				player["addHp"] += item["value"]["addHp"]
			item["added"] = true  # Mark the item as added

#func apply_item_stats_to_player(player):
#	for item_type in player["item"]:
#		var item = player["item"][item_type]
#
#		if item != null or {}:
#			if item.value.has("additionDmg"):
#				if item.added == false:
#					player["additionDmg"] += item.value.additionDmg
#
#			if item.value.has("addPlayerSpeed"):
#				if item.added == false:
#					player["addPlayerSpeed"] += item.value.addPlayerSpeed
#
#			if item.value.has("addPhysicDefense"):
#				if item.added == false:
#					player["addPhysicDefense"] += item.value.addPhysicDefense	
#
#			if item.value.has("addMagicDefense"):
#				if item.added == false:
#					player["addMagicDefense"] += item.value.addMagicDefense	
#			if item.value.has("addHp"):
#				if item.added == false:
#					player["addHp"] += item.value.addMagicDefense			
#			item.added = true
func update_players_with_item_stats():
	for player_name in fightScenePlayerData:
		var player = fightScenePlayerData[player_name]
		apply_item_stats_to_player(player)

func remove_empty_items():
	var keys_to_remove = []

	# Find all keys where number is 0
	for key in bagArmorItem.keys():
		if bagArmorItem[key]["number"] <= 0:
			keys_to_remove.append(key)
			
	# Remove the items outside the loop to avoid modifying the dictionary while iterating
	for key in keys_to_remove:
		bagArmorItem.erase(key)
#{
#				"name": "唧唧歪歪",
#				"level": 1,
#				"currExp": 49,
#				"needExp": 50,
#				"attackType": "range",
#				"value": 5,
#				"cost": 30,
#				"description": "饼干的言语攻击，伤害拉满",	
#				"effectArea": "aoe",
#				"effectingNum": 5,
#				"animationArea":"enemy",
#				"audio": "res://Audio/SE/鸟语花香.ogg",
#				"icon": "res://Icons/●图标 (14).png"
#			},
#			{
#				"name": "舍命一击",
#				"level": 1,
#				"currExp": 0,
#				"needExp": 50,
#				"attackType": "melee",
#				"value": 3, 
#				"cost": 30,
#				"description": "全力攻击，休息一回合",
#				"effectArea": "single",
#				"animationArea":"enemy",
#				"audio": "res://Audio/SE/男-剑.ogg",
#				"icon": "res://Icons/●图标 (13).png",
#			},
#			{
#				"name": "聚力",
#				"level": 1,
#				"currExp": 0,
#				"needExp": 50,
#				"attackType": "buff",				
#				"value": 30, 
#				"cost": 30,
#				"description": "增加自身攻击力",
#				"effectArea": "single",
#				"effectingNum":1,
#				"animationArea":"self",
#				"buffEffect":["currAttackDmg"],
#				"duration": 4,
#				"audio":"res://Audio/SE/男-法术-嗯.ogg",
#				"icon":"res://Icons/●图标 (38).png"
#			},{
#				"name": "破空剑",
#				"level": 1,
#				"currExp": 0,
#				"needExp": 50,
#				"attackType": "melee",
#				"value": 5,
#				"cost": 30,
#				"description": "高伤害",	
#				"effectArea": "single",
#				"animationArea":"screen",
#				"audio": "res://Audio/SE/男-剑.ogg",
#				"icon": "res://Icons/●图标 (23).png"
#			},
#				"name": "飞剑决",
#				"level": 1,
#				"currExp": 0,
#				"needExp": 50,
#				"attackType": "range",
#				"value": 2.5,
#				"cost": 30,
#				"description": "时追云通过修炼领悟的技能，比平A多点伤害",	
#				"effectArea": "single",
#				"animationArea":"enemy",
#				"audio": "res://Audio/SE/096-Attack08.ogg",
#				"icon": "res://Icons/斩龙诀.png"
#			},			
			# Add more magic spells as needed
