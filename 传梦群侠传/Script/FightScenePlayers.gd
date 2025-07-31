extends Node
var hashTable = {}
var gold = 0
var golds = 0 * Global.enKey
var seconds = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	return
	golds *= Global.enKey
	


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
	"洗髓丹":{
		"info": ItemData.keyItem.get("洗髓丹"),
		"number": 9999
	},
#	"避祸香囊":{
#		"info": ItemData.keyItem.get("避祸香囊"),
#		"number": 9999
#	},
}
var consumeItem = {
#	"佛手":{
#		"info": ItemData.consume.get("佛手"),
#		"number": 5
#	},
#	"佛跳墙":{
#		"info": ItemData.consume.get("佛跳墙"),
#		"number": 100
#	},
#	"西瓜":{
#		"info": ItemData.consume.get("西瓜"),
#		"number": 100
#	},	
#	"人参果":{
#		"info": ItemData.consume.get("人参果"),
#		"number": 1
#	},		
	
}

var battleItem = {
	"金疮药":{
		"info": ItemData.battleConsume.get("金疮药"),
		"number": 5
	},
#	"月饼":{
#		"info": ItemData.battleConsume.get("月饼"),
#		"number": 10
#	},
#	"老君仙丹":{
#		"info": ItemData.battleConsume.get("老君仙丹"),
#		"number": 5
#	},
#	"含沙射影":{
#		"info": ItemData.battleConsume.get("含沙射影"),
#		"number": 10
#	}
}

var questItem = {
	
}
var totalPetFoodBall =0
var petFoodBall = 0
var petFood = 10
var bagArmorItem = {
	"大剑":{
		"info": ItemData.weapon.get("大剑"),
		"type": "weapon",
		"number": 1,
		"added": false
	},
	"传梦之剑":{
		"info": ItemData.weapon.get("传梦之剑"),
		"type": "weapon",
		"number": 1,
		"added": false
	},
#	"梦澹":{
#		"info": ItemData.weapon.get("梦澹"),
#		"type": "weapon",
#		"number": 1,
#		"added": false
#	},
#	"黄金剑":{
#		"info": ItemData.weapon.get("黄金剑"),
#		"type": "weapon",
#		"number": 2,
#		"added": false
#	},
#	"碧玉剑":{
#		"info": ItemData.weapon.get("碧玉剑"),
#		"type": "weapon",
#		"number": 1,
#		"added": false
#	},
##
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
#
	"草鞋":{
		"info": ItemData.shoes.get("草鞋"),
		"type": "shoes",
		"number": 1,	
		"added": false	
	},
#	"护身符":{
#		"info": ItemData.accessories.get("护身符"),
#		"type": "accessories",
#		"number": 1,	
#		"added": false	
#	},	
#	"江湖夜雨":{
#		"info": ItemData.accessories.get("江湖夜雨"),
#		"type": "accessories",
#		"number": 2,	
#		"added": false	
#	},
#	"精钢剑":{
#		"info": ItemData.weapon.get("精钢剑"),
#		"type": "weapon",
#		"number": 1,	
#		"added": false	
#	},
#	"赤铁双剑":{
#		"info": ItemData.weapon.get("赤铁双剑"),
#		"type": "weapon",
#		"number": 1,	
#		"added": false	
#	},
#	"面具":{
#		"info": ItemData.hat.get("面具"),
#		"type": "hat",
#		"number": 1,
#		"added": false
#	},
#	"珍珠头带":{
#		"info": ItemData.hat.get("珍珠头带"),
#		"type": "hat",
#		"number": 1,
#		"added": false
#	},	
#	"皮鞋":{
#		"info": ItemData.shoes.get("皮鞋"),
#		"type": "shoes",
#		"number": 2,	
#		"added": false	
#	},	



}




var fightScenePlayerData2= {
	"小二真身": {
		"name": "小二真身",
		"sex": "male",
		"icon": "res://portrait/小二真身.png",
		"smallIcon": "res://main character/小二右下.png",
		"playerAttackType": "melee",
		"playerSpeed": 20,
		"addPlayerSpeed": 300 * Global.enKey,
		"critChance": 1,
		"addCritChance": 0 * Global.enKey,
		"blockChance": 0,
		"addBlockChance": 0 * Global.enKey,
		"level": 100,
		"exp": 0 * Global.enKey,
		"needExp": 100 * Global.enKey,
		"magicDefense": 5,
		"addMagicDefense": 0 * Global.enKey,
		"physicDefense": 5,
		"addPhysicDefense": 0 * Global.enKey,
		"str": 80,
		"addStr": 600 * Global.enKey,
		"abilityPower": 100 * Global.enKey,
		"addAbilityPower": 600 * Global.enKey,
		"additionDmg": 0 * Global.enKey,
		"hp": 200,
		"addHp": 4000 * Global.enKey,
		"mp": 30000,
		"addMp": 30000 * Global.enKey,
		"currHp": 7497,
		"currMp": 31090,
		"potential": 35 * Global.enKey,
		"idle": "小二真身idle",
		"autoAttack": "小二真身autoAttack",
		"magicAutoAttack": "",
		"playerMagic": [
			{
				"name": "千机变",
				"attackType": "special",
				"value": 2,				
				"cost": 10,
				"animationArea": "enemy",
				"description": "小二模仿并释放上一次队友使用的技能",	
				"icon": "res://Icons/●图标 (91).png",
			},
			{
				"name": "黑炎焱燚",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"multiHitTimes": 8,
				"effectingNum": 8,
				"damageSource": "AP",
				"duration": 1,
				"value": 4, 
				"cost": 100,
				"description": "黑色的火焰！！！(灵力加成)",
				"effectArea": "aoe",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/火4.ogg",
				"icon": "res://Icons/●图标 (15).png",
			},
			{
				"name": "兽爪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"value": 6,
				"cost": 60,
				"description": "野兽般的一击！（物理加成）",	
				"damageSource": "AD",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/093-Attack05.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},	
		],
		"autoAttackSound": "res://Audio/SE/090-Attack02.ogg",
		"attackOnEnemySound": "res://Audio/SE/打击1.ogg",
		"item": {
			"weapon": null,
			"cloth": null,
			"hat": null,
			"shoes": null,
			"accessories": null
		},
		"buff": ["speed", "strength", "accuracy", "defense"]
	},		
	"时追云":{
			"name": "时追云",
			"sex": "male",
			"icon":"res://Pictures/Pictures/时追云.png",
			"smallIcon":"res://main character/tile000.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 0,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 1,
			"exp": 0,
			"needExp":100 ,
			"magicDeense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100 ,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0 ,
			"additionDmg": 0 * Global.enKey,
			"hp": 200,
			"addHp": 0 ,
			"addMp": 0 ,
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
				"value": 260,
				"cost": 50,
				"description": "调息周身运转，恢复状态",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/HEAL9.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (64).png",
			},{
					"name": "小试牛刀",
					"attackType": "range",
					"value": 1.7,
					"cost": 5,
					"damageSource": "AD",
					"description": "江湖必备小试牛刀，单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/●图标 (77).png",
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
			"addBlockChance": 0,
			"level": 45,
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
			"currHp": 1000,
			"currMp": 490,
			"potential": 0,
			"idle": "姜韵idle",
			"autoAttack":'姜韵autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
				{
				"name": "回春术",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp",], 
				"value": 1000,
				"cost": 10,
				"description": "回复血量",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/108-Heal04.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (16).png",
			},{
				"name": "初始之力",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"damageSource": "AD",
				"value": 20000,
				"cost": 200,
				"description": "对魔类敌人造成固定高额伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/魔音.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},
			{
				"name": "一苇渡江",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currPlayerSpeed"], 
				"value": 70,
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
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 100,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},
			{
				"name": "抽丝断魂",
				"attackType": "range",
				"damageSource": "AP",
				"value": 4000,				
				"cost": 50,
				"description": "在地府学会的法术，造成固定伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio":"res://Audio/SE/法术12.ogg",
				"icon": "res://Icons/水攻.png",
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
			"addBlockChance": 0,
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
			"potential":15,
			"idle": "大海龟idle",
			"autoAttack":'大海龟autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
			{
				"name": "水攻",
				"attackType": "range",
				"damageSource": "AP",
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
				"damageSource": "AP",
				"value": 1, 
				"cost": 50,
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
			"icon": "res://portrait/小二.png",
			"smallIcon": "res://main character/小二右下.png",
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":0,
			"addBlockChance": 0,
			"level": 10,
			"exp": 0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 80,
			"addStr":0,
			"abilityPower": 1 * Global.enKey,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 1000,
			"addHp": 0,
			"mp": 300,
			"addMp":0,
			"currHp": 2000,
			"currMp": 300,
			"potential": 45 ,
			"idle": "小二idle",
			"autoAttack":'小二autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
	{
				"name": "唧唧歪歪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"damageSource": "AP",
				"attackType": "range",
				"value": 1,
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
	"凌若昭":{
			"name": "凌若昭",
			"sex": "female",
			"icon":"res://Pictures/Pictures/云燕儿.png",
			"smallIcon":"res://main character/若昭右下.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 20,
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
			"potential": 95,
			"idle": "凌若昭idle",
			"autoAttack":'凌若昭autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"凌若昭magicAutoAttack",
			"playerMagic": [
#				{
#					"name": "催眠",
#					"attackType": "debuff",
#					"buffEffect": ["sleep"], 
#					"cost": 10,
#					"description": "同时催眠3个敌人",	
#					"effectArea": "aoe",
#					"animationArea":"enemy",
#					"effectingNum": 3,
#					"duration": 2,
#					"audio": "res://Audio/SE/法术5.ogg",
#					"icon":"res://Icons/●图标 (88).png",
#				},	{
#					"name": "冰封",
#					"attackType": "debuff",
#					"buffEffect": ["ice"], 
#					"cost": 10,
#					"description": "同时冰封3个敌人",	
#					"effectArea": "aoe",
#					"animationArea":"enemy",
#					"effectingNum": 3,
#					"duration": 2,
#					"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
#					"icon":"res://Icons/●图标 (119).png",
#				},				
				{
					"name": "五雷咒",
					"attackType": "range",
					"damageSource": "AP",
					"value": 2.5,				
					"cost": 180,
					"description": "引来天雷轰杀单体敌人",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/五雷.png"
				},

			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-攻击-哈.ogg",
			"attackOnEnemySound": null,
			"item":{
				"weapon":ItemData.weapon.get("竹节双剑"),
				"cloth": ItemData.cloth.get("锦衣"),
				"hat":ItemData.hat.get("面具"),
				"shoes":ItemData.shoes.get("皮鞋"),
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]		
	},
	"金甲":{
			"name": "金甲",
			"sex": "male",
			"icon": "",
			"smallIcon":"res://Pictures/Pictures/云燕儿.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 13,
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
			"potential": 60,
			"idle": "金甲idle",
			"autoAttack":'金甲autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"金甲magicAutoAttack",
			"playerMagic": [
				{
					"name": "扎实一剑",
					"attackType": "melee",
					"damageSource": "AD",
					"cost": 10,
					"value": 3,
					"description": "金甲日日夜夜练习的扎实一剑",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"audio": "res://Audio/SE/猛男-喝X.ogg",
					"icon":"res://Icons/●图标 (88).png",
				}
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/猛男-喝X.ogg",
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
	"敖雨":{
			"name": "敖雨",
			"sex": "female",
			"icon": "",
			"smallIcon":"res://Pictures/Pictures/云燕儿.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 40,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 10,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 1000,
			"currMp": 1000,
			"potential": 70,
			"idle": "敖雨idle",
			"autoAttack":'敖雨autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"金甲magicAutoAttack",
			"playerMagic": [
#				{
#				"name": "虚沉冰封",
#				"attackType": "debuff",
#				"buffEffect": ["ice"], 
#				"cost": 400,
#				"chance": 1000,
#				"description": "百分百控制住一个人一个回合",	
#				"effectArea": "single",
#				"animationArea":"enemy",
#				"effectingNum": 1,
#				"duration": 1,
#				"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
#				"icon":"res://Icons/●图标 (119).png",
#			},			
			{
				"name": "水满金山",
				"attackType": "range",
				"damageSource": "AP",
				"value": 2,
				"cost": 60,
				"description": "水漫金山的进阶法术",
				"effectArea": "aoe",
				"effectingNum": 6,
				"animationArea": "enemy",
				"audio": "res://Audio/SE/127-Water02.ogg",
				"icon": "res://Icons/●图标 (14).png"
			}
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-呀.ogg",
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
	"敖白":{
			"name": "敖白",
			"sex": "male",
			"icon": "res://Pictures/¤敖白.png",
			"smallIcon":"res://Pictures/¤敖白.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 60,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 300,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 500,
			"currMp": 500,
			"potential": 295,
			"idle": "敖白idle",
			"autoAttack":'敖白autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"敖白magicAutoAttack",
			"playerMagic": [
				{
				"name": "龙卷雨击",
				"attackType": "range",
				"damageSource": "AP",
				"value": 3, 
				"cost": 400,
				"description": "群攻法术",
				"effectArea": "aoe",
				"effectingNum": 8,
				"animationArea":"screen",
				"audio":"res://Audio/SE/暗雷.ogg",
				"icon":"res://Icons/龙卷雨击.png"
			},			{
				"name": "双龙戏珠",
				"attackType": "range",
				"damageSource": "AP",
				"value": 5,
				"cost": 200,
				"description": "龙王法术",
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea": "enemy",
				"audio": "res://Audio/SE/双龙戏猪.ogg",
				"icon": "res://Icons/●图标 (1).png"
			},				
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/逍遥生攻击剑.ogg",
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
	"小追云":{
			"name": "小追云",
			"sex": "male",
			"icon": "res://portrait/小追云.png",
			"smallIcon":"res://portrait/小追云.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 0,
			"idle": "小追云idle",
			"autoAttack":'小追云autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"小追云magicAutoAttack",
			"playerMagic": [
			{
					"name": "小试牛刀",
					"attackType": "range",
					"value": 1.7,
					"cost": 5,
					"damageSource": "AD",
					"description": "江湖必备小试牛刀，单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/●图标 (77).png",
			},					
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/虎锤.ogg",
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
	"朱雀":{
			"name": "朱雀",
			"sex": "male",
			"icon": "res://portrait/朱雀.png",
			"smallIcon":"res://portrait/朱雀.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 75,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 500,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":1000,
			"mp": 200,
			"currHp": 200,
			"currMp": 200,
			"potential": 370,
			"idle": "朱雀idle",
			"autoAttack":'朱雀autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"朱雀magicAutoAttack",
			"playerMagic": [	
				{
					"name": "神风燎火",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 8,
					"damageSource": "AP",
					"duration": 1,
					"value": 3, 
					"cost": 300,
					"description": "朱雀圣火！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/119-Fire03.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},{
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 50,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},				
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/132-Wind01.ogg",
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
	"玄武":{
			"name": "玄武",
			"sex": "male",
			"icon": "res://portrait/玄武.png",
			"smallIcon":"res://portrait/玄武.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 99,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 800,
			"physicDefense": 5,
			"addPhysicDefense": 800,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 300,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp": 1500,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 345,
			"idle": "玄武idle",
			"autoAttack":'玄武autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"玄武magicAutoAttack",
			"playerMagic": [
				{
					"name": "水龙吟",
					"level": 1,
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 8,
					"damageSource": "AP",
					"duration": 1,
					"value": 5, 
					"cost": 200,
					"description": "攻击全体敌人",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/128-Water03.ogg",
					"icon": "res://Icons/龙卷雨击.png",
				},					
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/127-Water02.ogg" ,
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
	"青龙":{
			"name": "青龙",
			"sex": "male",
			"icon": "res://portrait/青龙.png",
			"smallIcon":"res://portrait/青龙.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 80,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 500,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp": 1000,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 395,
			"idle": "青龙idle",
			"autoAttack":'青龙autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"青龙magicAutoAttack",
			"playerMagic": [
				{
					"name": "龙怒",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 1,
					"damageSource": "AP",
					"duration": 1,
					"value": 6, 
					"cost": 200,
					"description": "龙族法术",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/法术16.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},			
			{
					"name": "灭世雷劫",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 4,
					"effectingNum": 1,
					"damageSource": "AP",
					"duration": 1,
					"value": 8, 
					"cost": 1000,
					"description": "灭世之雷！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/061-Thunderclap01.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},					
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/092-Attack04.ogg",
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
	"白虎":{
			"name": "白虎",
			"sex": "male",
			"icon": "res://portrait/白虎.png",
			"smallIcon":"res://portrait/白虎.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 99,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 500,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 345,
			"idle": "白虎idle",
			"autoAttack":'白虎autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"白虎magicAutoAttack",
			"playerMagic": [
			{
				"name": "虎啸",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currStr"], 
				"value": 200,
				"cost": 100,
				"description": "提升全队力量！",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 8,
				"duration": 4,
				"audio":"res://Audio/SE/082-Monster04.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},			
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/093-Attack05.ogg",
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
	"狐葬魂":{
			"name": "狐葬魂",
			"sex": "male",
			"icon": "res://portrait/白虎.png",
			"smallIcon":"res://portrait/白虎.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 100,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":3200,
			"mp": 100,
			"currHp": 200,
			"currMp": 3000,
			"potential": 0,
			"idle": "狐葬魂idle",
			"autoAttack":'狐葬魂autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"狐葬魂magicAutoAttack",
			"playerMagic": [
			{
				"name": "狐啸",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currStr"], 
				"value": 250,
				"cost": 100,
				"description": "狐族技能，啸叫提升所有人肉体本能！",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 8,
				"duration": 4,
				"audio":"res://Audio/SE/妖怪-哈~.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},			
			{
				"name": "六月飞雪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "multi",
				"multiHitTimes": 6,
				"damageSource": "AD",
				"duration": 1,
				"value": 1, 
				"cost": 50,
				"description": "全力攻击六次，休息一回合",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/男侠客-出招吼.ogg",
				"icon": "res://Icons/●图标 (11).png",
			},			
			{
					"name": "逆天破",
					"level": 1,
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 1,
					"damageSource": "AD",
					"duration": 1,
					"value": 300, 
					"cost": 300,
					"description": "终结技！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/050-Explosion03.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},				
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/剑侠客-攻击.ogg",
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
		
	
	
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
	
var fightScenePlayerData = {
	"小二真身": {
		"name": "小二真身",
		"sex": "male",
		"icon": "res://portrait/小二真身.png",
		"smallIcon": "res://main character/小二右下.png",
		"playerAttackType": "melee",
		"playerSpeed": 20,
		"addPlayerSpeed": 300 * Global.enKey,
		"critChance": 1,
		"addCritChance": 0 * Global.enKey,
		"blockChance": 0,
		"addBlockChance": 0 * Global.enKey,
		"level": 100,
		"exp": 0 * Global.enKey,
		"needExp": 100 * Global.enKey,
		"magicDefense": 5,
		"addMagicDefense": 0 * Global.enKey,
		"physicDefense": 5,
		"addPhysicDefense": 0 * Global.enKey,
		"str": 80,
		"addStr": 600 * Global.enKey,
		"abilityPower": 100 * Global.enKey,
		"addAbilityPower": 600 * Global.enKey,
		"additionDmg": 0 * Global.enKey,
		"hp": 200,
		"addHp": 4000 * Global.enKey,
		"mp": 30000,
		"addMp": 30000 * Global.enKey,
		"currHp": 7497,
		"currMp": 31090,
		"potential": 35 * Global.enKey,
		"idle": "小二真身idle",
		"autoAttack": "小二真身autoAttack",
		"magicAutoAttack": "",
		"playerMagic": [
			{
				"name": "千机变",
				"attackType": "special",
				"value": 2,				
				"cost": 10,
				"animationArea": "enemy",
				"description": "小二模仿并释放上一次队友使用的技能",	
				"icon": "res://Icons/●图标 (91).png",
			},
			{
				"name": "黑炎焱燚",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"multiHitTimes": 8,
				"effectingNum": 8,
				"damageSource": "AP",
				"duration": 1,
				"value": 4, 
				"cost": 100,
				"description": "黑色的火焰！！！(灵力加成)",
				"effectArea": "aoe",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/火4.ogg",
				"icon": "res://Icons/●图标 (15).png",
			},
			{
				"name": "兽爪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"value": 6,
				"cost": 60,
				"description": "野兽般的一击！（物理加成）",	
				"damageSource": "AD",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/093-Attack05.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},	
		],
		"autoAttackSound": "res://Audio/SE/090-Attack02.ogg",
		"attackOnEnemySound": "res://Audio/SE/打击1.ogg",
		"item": {
			"weapon": null,
			"cloth": null,
			"hat": null,
			"shoes": null,
			"accessories": null
		},
		"buff": ["speed", "strength", "accuracy", "defense"]
	},		
	"时追云":{
			"name": "时追云",
			"sex": "male",
			"icon":"res://Pictures/Pictures/时追云.png",
			"smallIcon":"res://main character/tile000.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 0,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 1,
			"exp": 0,
			"needExp":100 ,
			"magicDeense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100 ,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0 ,
			"additionDmg": 0 * Global.enKey,
			"hp": 200,
			"addHp": 0 ,
			"addMp": 0 ,
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
				"value": 300,
				"cost": 50,
				"description": "调息周身运转，恢复状态",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/HEAL9.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (64).png",
			},{
					"name": "小试牛刀",
					"attackType": "range",
					"value": 1.7,
					"cost": 5,
					"damageSource": "AD",
					"description": "江湖必备小试牛刀，单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/●图标 (77).png",
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
			"addBlockChance": 0,
			"level": 45,
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
			"currHp": 1000,
			"currMp": 490,
			"potential": 0,
			"idle": "姜韵idle",
			"autoAttack":'姜韵autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
				{
				"name": "回春术",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currHp",], 
				"value": 1000,
				"cost": 10,
				"description": "回复血量",	
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea":"allie",
				"audio": "res://Audio/SE/108-Heal04.ogg",
				"duration": 3,
				"icon":"res://Icons/●图标 (16).png",
			},{
				"name": "初始之力",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"damageSource": "AD",
				"value": 20000,
				"cost": 200,
				"description": "对魔类敌人造成固定高额伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/魔音.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},
			{
				"name": "一苇渡江",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currPlayerSpeed"], 
				"value": 70,
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
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 100,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},
			{
				"name": "抽丝断魂",
				"attackType": "range",
				"damageSource": "AP",
				"value": 4000,				
				"cost": 50,
				"description": "在地府学会的法术，造成固定伤害",	
				"effectArea": "single",
				"animationArea":"enemy",
				"effectingNum": 1,
				"audio":"res://Audio/SE/法术12.ogg",
				"icon": "res://Icons/水攻.png",
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
			"addBlockChance": 0,
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
			"potential":15,
			"idle": "大海龟idle",
			"autoAttack":'大海龟autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
			{
				"name": "水攻",
				"attackType": "range",
				"damageSource": "AP",
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
				"damageSource": "AP",
				"value": 1, 
				"cost": 50,
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
			"icon": "res://portrait/小二.png",
			"smallIcon": "res://main character/小二右下.png",
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance":0,
			"blockChance":0,
			"addBlockChance": 0,
			"level": 10,
			"exp": 0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 80,
			"addStr":0,
			"abilityPower": 1 * Global.enKey,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 1000,
			"addHp": 0,
			"mp": 300,
			"addMp":0,
			"currHp": 2000,
			"currMp": 300,
			"potential": 45 ,
			"idle": "小二idle",
			"autoAttack":'小二autoAttack',
			"magicAutoAttack": "",
			"playerMagic":[
	{
				"name": "唧唧歪歪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"damageSource": "AP",
				"attackType": "range",
				"value": 1,
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
	"凌若昭":{
			"name": "凌若昭",
			"sex": "female",
			"icon":"res://Pictures/Pictures/云燕儿.png",
			"smallIcon":"res://main character/若昭右下.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 20,
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
			"potential": 95,
			"idle": "凌若昭idle",
			"autoAttack":'凌若昭autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"凌若昭magicAutoAttack",
			"playerMagic": [
#				{
#					"name": "催眠",
#					"attackType": "debuff",
#					"buffEffect": ["sleep"], 
#					"cost": 10,
#					"description": "同时催眠3个敌人",	
#					"effectArea": "aoe",
#					"animationArea":"enemy",
#					"effectingNum": 3,
#					"duration": 2,
#					"audio": "res://Audio/SE/法术5.ogg",
#					"icon":"res://Icons/●图标 (88).png",
#				},	{
#					"name": "冰封",
#					"attackType": "debuff",
#					"buffEffect": ["ice"], 
#					"cost": 10,
#					"description": "同时冰封3个敌人",	
#					"effectArea": "aoe",
#					"animationArea":"enemy",
#					"effectingNum": 3,
#					"duration": 2,
#					"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
#					"icon":"res://Icons/●图标 (119).png",
#				},				
				{
					"name": "五雷咒",
					"attackType": "range",
					"damageSource": "AP",
					"value": 2.5,				
					"cost": 180,
					"description": "引来天雷轰杀单体敌人",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/五雷.png"
				},

			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-攻击-哈.ogg",
			"attackOnEnemySound": null,
			"item":{
				"weapon":ItemData.weapon.get("竹节双剑"),
				"cloth": ItemData.cloth.get("锦衣"),
				"hat":ItemData.hat.get("面具"),
				"shoes":ItemData.shoes.get("皮鞋"),
				"accessories":null
			},
			"buff":["speed","strength","accuracy","defense"]		
	},
	"金甲":{
			"name": "金甲",
			"sex": "male",
			"icon": "",
			"smallIcon":"res://Pictures/Pictures/云燕儿.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 13,
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
			"potential": 60,
			"idle": "金甲idle",
			"autoAttack":'金甲autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"金甲magicAutoAttack",
			"playerMagic": [
				{
					"name": "扎实一剑",
					"attackType": "melee",
					"damageSource": "AD",
					"cost": 10,
					"value": 3,
					"description": "金甲日日夜夜练习的扎实一剑",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"audio": "res://Audio/SE/猛男-喝X.ogg",
					"icon":"res://Icons/●图标 (88).png",
				}
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/猛男-喝X.ogg",
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
	"敖雨":{
			"name": "敖雨",
			"sex": "female",
			"icon": "",
			"smallIcon":"res://Pictures/Pictures/云燕儿.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 40,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 10,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 1000,
			"currMp": 1000,
			"potential": 70,
			"idle": "敖雨idle",
			"autoAttack":'敖雨autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"金甲magicAutoAttack",
			"playerMagic": [
#				{
#				"name": "虚沉冰封",
#				"attackType": "debuff",
#				"buffEffect": ["ice"], 
#				"cost": 400,
#				"chance": 1000,
#				"description": "百分百控制住一个人一个回合",	
#				"effectArea": "single",
#				"animationArea":"enemy",
#				"effectingNum": 1,
#				"duration": 1,
#				"audio": "res://Audio/SE/crack-and-crunch-14891.mp3",
#				"icon":"res://Icons/●图标 (119).png",
#			},			
			{
				"name": "水满金山",
				"attackType": "range",
				"damageSource": "AP",
				"value": 2,
				"cost": 60,
				"description": "水漫金山的进阶法术",
				"effectArea": "aoe",
				"effectingNum": 6,
				"animationArea": "enemy",
				"audio": "res://Audio/SE/127-Water02.ogg",
				"icon": "res://Icons/●图标 (14).png"
			}
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/女-呀.ogg",
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
	"敖白":{
			"name": "敖白",
			"sex": "male",
			"icon": "res://Pictures/¤敖白.png",
			"smallIcon":"res://Pictures/¤敖白.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 60,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 300,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 200,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 500,
			"currMp": 500,
			"potential": 295,
			"idle": "敖白idle",
			"autoAttack":'敖白autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"敖白magicAutoAttack",
			"playerMagic": [
				{
				"name": "龙卷雨击",
				"attackType": "range",
				"damageSource": "AP",
				"value": 3, 
				"cost": 400,
				"description": "群攻法术",
				"effectArea": "aoe",
				"effectingNum": 8,
				"animationArea":"screen",
				"audio":"res://Audio/SE/暗雷.ogg",
				"icon":"res://Icons/龙卷雨击.png"
			},			{
				"name": "双龙戏珠",
				"attackType": "range",
				"damageSource": "AP",
				"value": 5,
				"cost": 200,
				"description": "龙王法术",
				"effectArea": "single",
				"effectingNum": 1,
				"animationArea": "enemy",
				"audio": "res://Audio/SE/双龙戏猪.ogg",
				"icon": "res://Icons/●图标 (1).png"
			},				
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/逍遥生攻击剑.ogg",
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
	"小追云":{
			"name": "小追云",
			"sex": "male",
			"icon": "res://portrait/小追云.png",
			"smallIcon":"res://portrait/小追云.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 1,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 0,
			"idle": "小追云idle",
			"autoAttack":'小追云autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"小追云magicAutoAttack",
			"playerMagic": [
			{
					"name": "小试牛刀",
					"attackType": "range",
					"value": 1.7,
					"cost": 5,
					"damageSource": "AD",
					"description": "江湖必备小试牛刀，单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/●图标 (77).png",
			},					
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/虎锤.ogg",
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
	"朱雀":{
			"name": "朱雀",
			"sex": "male",
			"icon": "res://portrait/朱雀.png",
			"smallIcon":"res://portrait/朱雀.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 75,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 500,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":1000,
			"mp": 200,
			"currHp": 200,
			"currMp": 200,
			"potential": 370,
			"idle": "朱雀idle",
			"autoAttack":'朱雀autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"朱雀magicAutoAttack",
			"playerMagic": [	
				{
					"name": "神风燎火",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 8,
					"damageSource": "AP",
					"duration": 1,
					"value": 3, 
					"cost": 300,
					"description": "朱雀圣火！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/119-Fire03.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},{
				"name": "回魂术",
				"attackType": "buff",
				"buffEffect": ["alive"], 
				"cost": 50,
				"description": "复活一个友军",	
				"effectArea": "single",
				"animationArea":"allie",
				"effectingNum": 1,
				"duration": 2,
				"audio": "res://Audio/SE/法术5.ogg",
				"icon":"res://Icons/●图标 (84).png"
			},				
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/132-Wind01.ogg",
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
	"玄武":{
			"name": "玄武",
			"sex": "male",
			"icon": "res://portrait/玄武.png",
			"smallIcon":"res://portrait/玄武.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 99,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 800,
			"physicDefense": 5,
			"addPhysicDefense": 800,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 300,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp": 1500,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 345,
			"idle": "玄武idle",
			"autoAttack":'玄武autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"玄武magicAutoAttack",
			"playerMagic": [
				{
					"name": "水龙吟",
					"level": 1,
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 8,
					"damageSource": "AP",
					"duration": 1,
					"value": 5, 
					"cost": 200,
					"description": "攻击全体敌人",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/128-Water03.ogg",
					"icon": "res://Icons/龙卷雨击.png",
				},					
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/127-Water02.ogg" ,
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
	"青龙":{
			"name": "青龙",
			"sex": "male",
			"icon": "res://portrait/青龙.png",
			"smallIcon":"res://portrait/青龙.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 0,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 80,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower": 500,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp": 1000,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 395,
			"idle": "青龙idle",
			"autoAttack":'青龙autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"青龙magicAutoAttack",
			"playerMagic": [
				{
					"name": "龙怒",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 1,
					"damageSource": "AP",
					"duration": 1,
					"value": 6, 
					"cost": 200,
					"description": "龙族法术",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/法术16.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},			
			{
					"name": "灭世雷劫",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 4,
					"effectingNum": 1,
					"damageSource": "AP",
					"duration": 1,
					"value": 8, 
					"cost": 1000,
					"description": "灭世之雷！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/061-Thunderclap01.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},					
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/092-Attack04.ogg",
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
	"白虎":{
			"name": "白虎",
			"sex": "male",
			"icon": "res://portrait/白虎.png",
			"smallIcon":"res://portrait/白虎.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 99,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 550,
			"physicDefense": 5,
			"addPhysicDefense": 550,
			"str": 100,
			"addStr": 500,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":0,
			"mp": 100,
			"currHp": 200,
			"currMp": 200,
			"potential": 345,
			"idle": "白虎idle",
			"autoAttack":'白虎autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"白虎magicAutoAttack",
			"playerMagic": [
			{
				"name": "虎啸",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currStr"], 
				"value": 200,
				"cost": 100,
				"description": "提升全队力量！",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 8,
				"duration": 4,
				"audio":"res://Audio/SE/082-Monster04.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},			
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/093-Attack05.ogg",
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
	"狐葬魂":{
			"name": "狐葬魂",
			"sex": "male",
			"icon": "res://portrait/白虎.png",
			"smallIcon":"res://portrait/白虎.png",
			"alive":true,
			"playerAttackType": "melee",
			"playerSpeed": 20,
			"addPlayerSpeed": 0,
			"critChance": 1,
			"addCritChance": 100,
			"blockChance":1,
			"addBlockChance": 0,
			"level": 70,
			"exp":0,
			"needExp":100,
			"magicDefense": 5,
			"addMagicDefense": 0,
			"physicDefense": 5,
			"addPhysicDefense": 0,
			"str": 100,
			"addStr": 0,
			"abilityPower": 0,
			"addAbilityPower":0,
			"additionDmg": 0,
			"hp": 500,
			"addHp": 0,
			"addMp":3200,
			"mp": 100,
			"currHp": 200,
			"currMp": 3000,
			"potential": 0,
			"idle": "狐葬魂idle",
			"autoAttack":'狐葬魂autoAttack',
			#"playerAutoSound": "res://Audio/SE/男-剑.ogg",
			"magicAutoAttack":"狐葬魂magicAutoAttack",
			"playerMagic": [
			{
				"name": "狐啸",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "buff",
				"buffEffect": ["currStr"], 
				"value": 250,
				"cost": 100,
				"description": "狐族技能，啸叫提升所有人肉体本能！",	
				"effectArea": "aoe",
				"animationArea":"allie",
				"effectingNum": 8,
				"duration": 4,
				"audio":"res://Audio/SE/妖怪-哈~.ogg",
				"icon":"res://Icons/●图标 (77).png",
			},			
			{
				"name": "六月飞雪",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "multi",
				"multiHitTimes": 6,
				"damageSource": "AD",
				"duration": 1,
				"value": 1, 
				"cost": 50,
				"description": "全力攻击六次，休息一回合",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/男侠客-出招吼.ogg",
				"icon": "res://Icons/●图标 (11).png",
			},			
			{
					"name": "逆天破",
					"level": 1,
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 1,
					"damageSource": "AD",
					"duration": 1,
					"value": 300, 
					"cost": 300,
					"description": "终结技！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/050-Explosion03.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},				
			
			# Add more magic spells as needed
			],
			"autoAttackSound": "res://Audio/SE/剑侠客-攻击.ogg",
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
		
	
	
}

func get_真身数据():
	return {
	"name": "小二真身",
	"icon": "res://portrait/小二真身.png",
	"playerAttackType": "melee",	
	"playerSpeed": fightScenePlayerData['小二'].playerSpeed +  fightScenePlayerData['小二'].addPlayerSpeed + 200,
	"magicDefense": fightScenePlayerData['小二'].magicDefense +  fightScenePlayerData['小二'].addMagicDefense + 100,		
	"physicDefense": fightScenePlayerData['小二'].magicDefense +  fightScenePlayerData['小二'].addPhysicDefense + 100,		
	"str": fightScenePlayerData['小二'].str +  fightScenePlayerData['小二'].addStr + 500,		
	"abilityPower": fightScenePlayerData['小二'].abilityPower +  fightScenePlayerData['小二'].addAbilityPower + 500,		
	"hp": fightScenePlayerData['小二'].hp +  fightScenePlayerData['小二'].addHp + 1000,		
	"mp": fightScenePlayerData['小二'].mp +  fightScenePlayerData['小二'].addMp + 1000,		
	"autoAttackSound": "res://Audio/SE/090-Attack02.ogg",
	}
		




var datas = {
	
}

#func saveData():
#
#
#	fightScenePlayerData.get("时追云").additionDmg = decrypt(fightScenePlayerData.get("时追云").additionDmg)
#	datas.battleItem = battleItem.duplicate()
#	datas.bagArmorItem = bagArmorItem.duplicate()
#	datas.seconds = seconds
#	datas.golds = golds

#	datas.fightScenePlayerData = fightScenePlayerData.duplicate()
#
#
#	datas.questItem = questItem
#	datas.keyItem = keyItem
#	datas.consumeItem = consumeItem
#	datas.petFoodBall = petFoodBall
#	datas.petFood = petFood

#	fightScenePlayerData.get("时追云").additionDmg = fightScenePlayerData.get("时追云").additionDmg * Global.enKey

#
func saveData():
	# 对所有玩家的数据进行处理
	for player_name in fightScenePlayerData.keys():
		var player_data = fightScenePlayerData[player_name]
		
		# 解密所有带 * Global.enKey 的字段
		player_data.addPlayerSpeed = decrypt(player_data.addPlayerSpeed)
		player_data.addCritChance = decrypt(player_data.addCritChance)
		player_data.addBlockChance = decrypt(player_data.addBlockChance)
		player_data.exp = decrypt(player_data.exp)
		player_data.needExp = decrypt(player_data.needExp)
		player_data.addMagicDefense = decrypt(player_data.addMagicDefense)
		player_data.addPhysicDefense = decrypt(player_data.addPhysicDefense)
		player_data.addStr = decrypt(player_data.addStr)
		player_data.addAbilityPower = decrypt(player_data.addAbilityPower)
		player_data.additionDmg = decrypt(player_data.additionDmg)
		player_data.addHp = decrypt(player_data.addHp)
		player_data.addMp = decrypt(player_data.addMp)
		player_data.potential = decrypt(player_data.potential)

	# 处理其他数据的保存
	datas.battleItem = battleItem.duplicate()
	datas.bagArmorItem = bagArmorItem.duplicate()
	datas.seconds = seconds
	datas.golds = decrypt(golds)
	datas.totalPetFoodBall = totalPetFoodBall
	# 深拷贝 fightScenePlayerData 进 datas
	datas.fightScenePlayerData = deep_copy(fightScenePlayerData)

	datas.questItem = questItem
	datas.keyItem = keyItem
	datas.consumeItem = consumeItem
	datas.petFoodBall = petFoodBall
	datas.petFood = petFood
	
	# 保存完成后，将数据重新加密
	for player_name in fightScenePlayerData.keys():
		var player_data = fightScenePlayerData[player_name]
		
		# 重新加密所有带 * Global.enKey 的字段
		player_data.addPlayerSpeed *= Global.enKey
		player_data.addCritChance *= Global.enKey
		player_data.addBlockChance *= Global.enKey
		player_data.exp *= Global.enKey
		player_data.needExp *= Global.enKey
		player_data.addMagicDefense *= Global.enKey
		player_data.addPhysicDefense *= Global.enKey
		player_data.addStr *= Global.enKey
		player_data.addAbilityPower *= Global.enKey
		player_data.additionDmg *= Global.enKey
		player_data.addHp *= Global.enKey
		player_data.addMp *= Global.enKey
		player_data.potential *= Global.enKey



# 递归深拷贝函数
func deep_copy(original):
	if typeof(original) == TYPE_DICTIONARY:
		var copy_dict = {}
		for key in original.keys():
			copy_dict[key] = deep_copy(original[key])
		return copy_dict
	elif typeof(original) == TYPE_ARRAY:
		var copy_array = []
		for element in original:
			copy_array.append(deep_copy(element))
		return copy_array
	else:
		return original

func loadData():
	# 遍历每个玩家的数据，重新加密所有带 * Global.enKey 的字段
	for player_name in datas.fightScenePlayerData.keys():
		var player_data = datas.fightScenePlayerData[player_name]
			
		# 重新加密所有带 * Global.enKey 的字段
		player_data.addPlayerSpeed *= Global.enKey
		player_data.addCritChance *= Global.enKey
		player_data.addBlockChance *= Global.enKey
		player_data.exp *= Global.enKey
		player_data.needExp *= Global.enKey
		player_data.addMagicDefense *= Global.enKey
		player_data.addPhysicDefense *= Global.enKey
		player_data.addStr *= Global.enKey
		player_data.addAbilityPower *= Global.enKey
		player_data.additionDmg *= Global.enKey
		player_data.addHp *= Global.enKey
		player_data.addMp *= Global.enKey
		player_data.potential *= Global.enKey

	# 处理其他游戏数据
	battleItem = datas.battleItem	
	bagArmorItem = datas.bagArmorItem
	seconds = datas.seconds
	golds = datas.golds * Global.enKey
	totalPetFoodBall = datas.totalPetFoodBall
	# 将解密后的 fightScenePlayerData 赋值回去
	fightScenePlayerData = datas.fightScenePlayerData
	
	# 处理其他数据的加载
	questItem = datas.questItem
	keyItem = datas.keyItem
	consumeItem = datas.consumeItem
	petFoodBall = datas.petFoodBall
	petFood = datas.petFood

func update_status():
	for player_name in fightScenePlayerData:
		var player = fightScenePlayerData[player_name]

		while decrypt(player["exp"]) >= decrypt(player["needExp"]):  # Use while loop to handle multiple level-ups
			#player["exp"] -= player["needExp"]  # Subtract the needed exp for current level
			player["level"] += 1
			player.potential +=  5 * Global.enKey
			player["exp"] -= player["needExp"]
			player["needExp"] = calculate_exp_for_player_level(player["level"]) * Global.enKey
		
				
		var player_magic = player.get("playerMagic", [])
		for magic in player_magic:
			if magic.has("level"):
				magic["needExp"] = calculate_exp_for_magic_level(magic["level"])
				if magic.currExp >= magic.needExp:
					
					if player.name == "凌若昭":		
						if magic.level < 20:
							magic.currExp = 0
							magic.level += 1
							magic.value = magic.value + 0.2 * magic.value	
							Global.showMsg(magic["name"]+"提升至"+str(magic['level'])+"级!")					
						if magic.level >= 19:
							magic.currExp = 0
							magic.level	= 20	
															
					else:
						if magic.level < 5:
							magic.currExp = 0
							magic.level += 1
							magic.value = magic.value + 0.2 * magic.value
							Global.showMsg(magic["name"]+"提升至"+str(magic['level'])+"级!")	
						if magic.level >= 5:
							magic.currExp = 250
							magic.level = 5	
							
				
						
						
		# Update attack damage based on player level
		if player.has("level"):

			player["needExp"] = calculate_exp_for_player_level(player["level"]) * Global.enKey
			#player["needExp"] * Global.enKey
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
			var hpIncrease = calculate_hp_for_level(level,player["name"])
			player["hp"] = hpIncrease
			if player["hp"]  + player["addHp"] < player["currHp"]:
				player["currHp"] = player["hp"]
			#speed
			player["playerSpeed"] = calculate_speed_for_level(player["level"],player["name"])
			#mp
			player["mp"] = calculate_mp_for_level(player["level"], player["name"])
			player["abilityPower"] = calculate_abilityPower_for_level(player["level"], player["name"])
			
			
func calculate_exp_for_magic_level(level):
	# You can adjust this formula as per your requirement	
	return 20 * level

func calculate_exp_for_player_level(level: int) -> int:
	var baseExp = 100  # 从60增到100
	var linearComponent = 80 * (level - 1)  # 线性增量增大
	var exponentialComponent = baseExp * pow(1.22, level - 1)  # 指数增幅保持温和

	var totalExp = linearComponent + exponentialComponent

	return int(totalExp)



func calculate_defense_for_level(level, player =null):
	var baseDefense = 50  # Base defense at level 1
	var finalDefense = 300  # Desired defense at level 100
	if player == "姜韵" and !Global.onGhost:
		finalDefense = 500
	var defenseIncreasePerLevel = (finalDefense - baseDefense) / 99  # Linear increase per level
	
	var totalDefense = baseDefense + defenseIncreasePerLevel * (level - 1)
	return totalDefense
func calculate_hp_for_level(level, player = null):
	var baseHp = 220  # Base HP at level 1
	var finalHp = 2500  # Desired HP at level 100
	if player == "姜韵":
		finalHp = 3200
	var hpIncreasePerLevel = (finalHp - baseHp) / 99  # Linear increase per level

	var totalHp = baseHp + hpIncreasePerLevel * (level - 1)
	return totalHp
	
func calculate_speed_for_level(level, player = null):
	var baseSpeed = 50.0  # Base speed at level 1
	var speedIncreasePerLevel = 2  # Speed increase per level
	if player == "大海龟":
		baseSpeed = 35.0
		speedIncreasePerLevel = 3	
	if player == "敖白" or player == "敖雨" or player == "金甲":
		speedIncreasePerLevel = 4

		
	var totalSpeed = baseSpeed + speedIncreasePerLevel * (level - 1)

	return totalSpeed
	
func calculate_abilityPower_for_level(level, player = null):
	var baseAp = 90.0  # Base speed at level 1
	var apIncreasePerLevel = 1  # Speed increase per level
	var totalAp = baseAp + apIncreasePerLevel * (level - 1)	
	if player == "大海龟" or player == "敖雨":
		apIncreasePerLevel = 3  # Speed increase per level
	if player == "敖白":
		apIncreasePerLevel = 4 # Speed increase per level

	totalAp = baseAp + apIncreasePerLevel * (level - 1)		
		
	
	return totalAp * Global.enKey
#	if player == "敖阳":
#		var baseAp = 1.0  # Base speed at level 1
#		var apIncreasePerLevel = 10  # Speed increase per level
#		var totalAp = baseAp + apIncreasePerLevel * (level - 1)

#		return totalAp		
	
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
var unLearnMagic = {
			"飞剑决":{"name": "飞剑决",
							"level": 1,
							"currExp": 0,
							"needExp": 50,
							"attackType": "range",
							"damageSource": "AD",
							"value": 2.2,
							"cost": 60,
							"description": "时追云通过修炼领悟的技能，比普通斩击多点伤害",	
							"effectArea": "single",
							"animationArea":"enemy",
							"audio": "res://Audio/SE/096-Attack08.ogg",
							"icon": "res://Icons/斩龙诀.png"
						},		
	
	
			"催眠咒":{
					"name": "催眠",
					"attackType": "debuff",
					"buffEffect": ["sleep"], 
					"cost": 100,
					"chance": 50,
					"description": "同时催眠3个敌人",	
					"effectArea": "aoe",
					"animationArea":"enemy",
					"effectingNum": 3,
					"duration": 2,
					"audio": "res://Audio/SE/法术5.ogg",
					"icon":"res://Icons/●图标 (88).png",
				},	
			"舍命一击":{
				"name": "舍命一击",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"value": 3, 
				"cost": 30,
				"description": "全力攻击，休息一回合",
				"damageSource": "AD",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/男-剑.ogg",
				"icon": "res://Icons/●图标 (13).png",
			},
			"横扫千军":{
				"name": "横扫千军",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "multi",
				"multiHitTimes": 3,
				"damageSource": "AD",
				"duration": 1,
				"value": 1.3, 
				"cost": 50,
				"description": "全力攻击，休息一回合,如果三次攻击同一个目标，第三次伤害暴涨",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/男-剑.ogg",
				"icon": "res://Icons/●图标 (11).png",
			},
			"破暗":{
				"name": "破暗",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"damageSource": "AD",
				"value": 2,
				"cost": 40,
				"description": "对鬼怪敌人造成额外伤害",	
				"effectArea": "single",
				"animationArea":"screen",
				"audio": "res://Audio/SE/男-剑.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},
			"初始之力":{
				"name": "初始之力",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"damageSource": "AD",
				"value": 15000,
				"cost": 30,
				"description": "对魔类敌人造成固定高额伤害",	
				"effectArea": "single",
				"animationArea":"screen",
				"audio": "res://Audio/SE/魔音.ogg",
				"icon": "res://Icons/●图标 (23).png"
			},				
			"千机变":{
				"name": "千机变",
				"attackType": "special",
				"value": 2,				
				"cost": 10,
				"animationArea": "enemy",
				"description": "小二模仿并释放上一次队友使用的技能，但不可模仿符咒招式和凡间武艺",	
				"icon": "res://Icons/●图标 (91).png",
			},		
			"神佑咒":{
					"name": "神佑咒",
					"currExp": 0,
					"needExp": 50,
					"attackType": "buff",
					"buffEffect": ["currPhysicDefense", "currMagicDefense"], 
					"value": 150,
					"cost": 20,
					"description": "提高四人防御",	
					"effectArea": "aoe",
					"animationArea":"allie",
					"effectingNum": 4,
					"duration": 4,
					"audio": "res://Audio/SE/133-Wind02.ogg",
					"icon":"res://Icons/●图标 (77).png",
				},
			"破甲术":{
					"name": "破甲术",
					"currExp": 0,
					"needExp": 50,
					"attackType": "debuff",
					"buffEffect": ["physicDefenseDebuff", "magicDefenseDebuff"], 
					"value": 200,
					"cost": 300,
					"description": "此次战斗永久降低大量被击中目标的防御",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 3000,
					"audio": "res://Audio/SE/133-Wind02.ogg",
					"icon":"res://Icons/●图标 (86).png",
				},
			"高等炼体术":{
					"name": "高等炼体术",
					"currExp": 0,
					"needExp": 50,
					"attackType": "passive",
					"buffEffect": ["currPhysicDefense", "currMagicDefense","currPlayerSpeed","currStr"], 
					"value": 150,
					"cost": 0,
					"description": "被动提高双抗，力量，速度，血量，仙能。",	
					"effectArea": "aoe",
					"animationArea":"allie",
					"effectingNum": 4,
					"duration": 3,
					"audio": "res://Icons/●图标 (89).png",
					"icon":"res://Icons/●图标 (85).png"
				},
			"虚空斩":{
				"name": "虚空斩",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "melee",
				"damageSource": "AD",
				"duration": 1,
				"value": 4, 
				"cost": 50,
				"description": "剑斩虚空",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/男-剑.ogg",
				"icon": "res://Icons/●图标 (11).png",
			},
			"开阳":{
				"name": "开阳",
				"currExp": 0,
				"needExp": 50,
				"attackType": "special",
				"multiHitTimes": 8,
				"effectingNum": 8,
				"damageSource": "AD",
				"duration": 1,
				"value": 1.6, 
				"cost": 50,
				"description": "让所有鬼怪无所遁形",
				"effectArea": "single",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/HEAL13.ogg",
				"icon": "res://Icons/●图标 (8).png",
			},			

			"万符归元":{
					"name": "万符归元",
					"level": 1,
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 1,
					"damageSource": "AP",
					"duration": 1,
					"value": 3, 
					"cost": 200,
					"description": "菩提教给若昭的终极单体技能，勤学苦练方可领悟法术真谛！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/114-Remedy02.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},		
			"黑炎焱燚":{
					"name": "黑炎焱燚",
					"level": 1,
					"currExp": 0,
					"needExp": 300,
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 8,
					"damageSource": "AP",
					"duration": 1,
					"value": 5, 
					"cost": 30,
					"description": "小二的特殊火焰！",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/114-Remedy02.ogg",
					"icon": "res://Icons/●图标 (15).png",
				},	
			"风雨雷电":{
					"currExp": 0,
					"name": "风雨雷电",
					"attackType": "range",
					"multiHitTimes": 8,
					"effectingNum": 4,
					"damageSource": "AP",
					"duration": 1,
					"value": 2, 
					"cost": 200,
					"description": "有风有雨有雷有电",
					"effectArea": "aoe",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/风 (2).wav",
					"icon": "res://Icons/●图标 (15).png",
				},				
				
			"斩龙决":{
					"name": "斩龙决",
					"currExp": 0,
					"needExp": 50,
					"attackType": "range",
					"damageSource": "AD",
					"value": 3,
					"cost": 100,
					"description": "前人所著斩龙诀窍，对龙类敌人杀伤力巨大",	
					"effectArea": "single",
					"animationArea":"enemy",
					"audio": "res://Audio/SE/096-Attack08.ogg",
					"icon": "res://Icons/斩龙诀.png"
						},	
			"净瓶仙露":{ 
					"name": "净瓶仙露",
					"currExp": 0,
					"needExp": 50,
					"attackType": "buff",
					"buffEffect": ["contHp"], 
					"value": 500,
					"cost": 240,
					"description": "杨柳仙露的功效，持续恢复4名队友血量4回合",	
					"effectArea": "aoe",
					"animationArea":"allie",
					"effectingNum": 4,
					"duration": 4,
					"audio": "res://Audio/SE/回复-观音.ogg",
					"icon":"res://Icons/●图标 (77).png",
			},			
			"金刚经":{
					"name": "金刚经",
					"currExp": 0,
					"needExp": 50,
					"attackType": "buff",
					"buffEffect": ["currMagicDefense"], 
					"value": 600,
					"cost": 500,
					"description": "短时间内给三名队友提升大量灵力防御",	
					"effectArea": "aoe",
					"animationArea":"allie",
					"effectingNum": 3,
					"duration": 1,
					"audio": "res://Audio/ME/啊弥拖佛.ogg",
					"icon":"res://Icons/●图标 (77).png",
				},			
			"火域":{
					"name": "火域",
					"attackType": "special",
					"value": 5,
					"cost": 500,
					"damageSource": "AP",
					"description": "触碰到的人都会受到伤害",	
					"effectArea": "aoe",
					"animationArea":"allie",
					"effectingNum": 3,
					"duration": 8,
					"audio": "res://Audio/SE/火4.ogg",
					"icon":"res://Icons/●图标 (77).png",
				},				
			"滔天":{
					"name": "滔天",
					"attackType": "range",
					"value": 8,
					"cost": 500,
					"damageSource": "AD",
					"description": "单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/053-Cannon02.ogg",
					"icon":"res://Icons/●图标 (77).png",
				},				
			"小试牛刀":{
					"name": "小试牛刀",
					"attackType": "range",
					"value": 1.5,
					"cost": 20,
					"damageSource": "AD",
					"description": "江湖必备小试牛刀，单体伤害",	
					"effectArea": "single",
					"animationArea":"enemy",
					"effectingNum": 1,
					"duration": 8,
					"audio": "res://Audio/SE/123-Thunder01.ogg",
					"icon":"res://Icons/●图标 (77).png",
				},		
			"真身现世":{
				"name": "真身现世",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"damageSource": "AP",
				"attackType": "special",
				"value": 1,
				"cost": 30,
				"description": "小二化作真身(需要小二行动5次后)",	
				"effectArea": "aoe",
				"effectingNum": 5,
				"animationArea":"enemy",
				"audio": "res://Audio/SE/风 (2).wav",
				"icon": "res://Icons/●图标 (14).png"
			},	
			"棍舞":{
				"name": "棍舞",
				"level": 1,
				"currExp": 0,
				"needExp": 50,
				"attackType": "range",
				"multiHitTimes": 8,
				"effectingNum": 3,
				"damageSource": "AD",
				"duration": 1,
				"value": 7, 
				"cost": 400,
				"description": "挥动玉箍棒砸扁敌人(物理加成)",
				"effectArea": "aoe",
				"animationArea":"enemy",
				"audio": "res://Audio/SE/法术-气势强.ogg",
				"icon": "res://Icons/●图标 (15).png",
			},				
}
func learnMagic(character, magicName):
	var magicList = fightScenePlayerData.get(character).playerMagic
	magicList.append(unLearnMagic.get(magicName))

func eraseMagic(character, magicName):
	var magicList = fightScenePlayerData.get(character).playerMagic
	for i in range(magicList.size()):
		if magicList[i].get("name") == "凝气":
			magicList.remove_at(i)
			break  # 找到后删除并退出循环
	fightScenePlayerData.get(character).playerMagic.erase(magicName)




#func compare_dictionaries(dict1: Dictionary, dict2: Dictionary) -> bool:
#	# Check if the keys and values are different in any way
#	for key in dict1.keys():
#		if not dict2.has(key) or dict1[key] != dict2[key]:
#			return true
#
#	# Check if there are keys in dict2 that are not in dict1
#	for key in dict2.keys():
#		if not dict1.has(key):
#			return true
#
#	# No differences found
#	return false
func compare_dictionaries(dict1: Dictionary, dict2: Dictionary) -> Dictionary:
	var differences = {}
	
	# 遍历第一个字典
	for key in dict1.keys():
		if not dict2.has(key):
			differences[key] = {"status": "missing in dict2", "value": dict1[key]}
		elif dict1[key] != dict2[key]:
			differences[key] = {"status": "different", "value_in_dict1": dict1[key], "value_in_dict2": dict2[key]}
	
	# 遍历第二个字典，查找只存在于 dict2 中的键
	for key in dict2.keys():
		if not dict1.has(key):
			differences[key] = {"status": "missing in dict1", "value": dict2[key]}
	
	return differences

func decrypt(value):
	return value / Global.enKey

func healAll():
	for i in fightScenePlayerData:
		
		fightScenePlayerData[i].currHp = decrypt(fightScenePlayerData[i].addHp) + fightScenePlayerData[i].hp
		fightScenePlayerData[i].currMp = decrypt(fightScenePlayerData[i].addMp) + fightScenePlayerData[i].mp

var tempMagic = []
func removeMagic(character):
	var magicList = fightScenePlayerData.get(character).playerMagic
	for i in magicList:
		tempMagic.append(i)
	fightScenePlayerData.get(character).playerMagic = []

