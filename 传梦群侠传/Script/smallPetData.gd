extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	update_descriptions()

func  _process(delta):
	update_descriptions()
	
# Updates magic descriptions to avoid circular references
func update_descriptions():
	magics["甘露逢春"].description = "恢复生命最低的队友" + str(200 + currSmallPetData.get("小鹿").abilityPower ) + "点生命"
	magics["水满金山"].description = "随机攻击五名敌人，造成" + str(200 + currSmallPetData.get("敖雨").abilityPower ) + "点伤害"

# Magic definitions
var magics = {
	"甘露逢春": {
		"name": "甘露逢春",
		"type": "healing",
		"hitNum": 1,
		"value": 200,
		"description": ""  # Initially empty, updated in _ready()
	},
	"水满金山": {
		"name": "水满金山",
		"type": "aoe",
		"hitNum": 5,
		"duration": 1,
		"value": 200,
		"description": ""
	}
}

# Original pet data
var oriSmallPetData = {
	"小鹿": {
		"name": "小鹿",
		"petAttackType": "melee",
		"level": 1,
		"str": 100,
		"abilityPower": 0,
		"hungry": 20000,
		"hungryValue": 1,
		"rage": 10,
		"petMagic": magics.get("甘露逢春"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "方寸山长大的小鹿，认凌若昭为主，因生来便饮仙泉，吃仙果，浑身散发着一股仙气"
	},
	"敖雨": {
		"name": "敖雨",
		"petAttackType": "melee",
		"level": 1,
		"str": 600,
		"abilityPower": 0,
		"hungry": 20000,
		"hungryValue": 3,
		"rage": 7,
		"petMagic": magics.get("水满金山"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "东海龙宫敖阳之妹,有着身为地方神的傲气与责任感,也有近似凡人的天真"
	}
}

# Current pet data
var currSmallPetData = {
	"小鹿": {
		"name": "小鹿",
		"petAttackType": "melee",
		"level": 1,
		"str": 100,
		"abilityPower": 100,
		"hungryValue": 1,
		"hungry": 20000,
		"rage": 10,
		"petMagic": magics.get("甘露逢春"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null
	},
	"敖雨": {
		"name": "敖雨",
		"petAttackType": "melee",
		"level": 1,
		"str": 100,
		"abilityPower": 0,
		"hungry": 200,
		"hungryValue": 3,
		"rage": 10,
		"petMagic": magics.get("水满金山"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null
	}
}
