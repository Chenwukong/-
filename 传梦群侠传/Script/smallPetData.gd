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
	magics["逆天破"].description = "随机攻击五名敌人，造成" + str(800 + currSmallPetData.get("狐葬魂").abilityPower ) + "点伤害"
	magics["战神念法"].description = "每次释放之后按照当前仙力本场战斗永久叠加" + str(SmallPetData.currSmallPetData["水无痕"].abilityPower/4) + "点攻击力"

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
	},
	"逆天破": {
		"name": "逆天破",
		"type": "aoe",
		"hitNum": 5,
		"duration": 1,
		"value": 800,
		"description": "逆天破！"
	},
	"战神念法": {
		"name": "战神念法",
		"type": "buff",
		"hitNum": 0,
		"duration": 1,
		"value": 10,
		"description": "每次释放之后按照当前仙力本场战斗永久叠加攻击力"
	}		
	
	
}

# Original pet data
var oriSmallPetData = {
	"小鹿": {
		"name": "小鹿",
		"petAttackType": "melee",
		"level": 1,
		"str": 100,
		"abilityPower": 100,
		"tempStr":0,
		"hungryValue": 0,
		"hungry": 20000,
		"rage": 10,
		"petMagic": magics.get("甘露逢春"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "方寸山灵鹿"
	},
	"敖雨": {
		"name": "敖雨",
		"petAttackType": "melee",
		"level": 1,
		"str": 100,
		"abilityPower": 0,
		"tempStr":0,
		"hungry": 200,
		"hungryValue": 0,
		"rage": 100,
		"petMagic": magics.get("水满金山"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "敖白之妹，有近乎凡人的天真"
	},
	"狐葬魂": {
		"name": "狐葬魂",
		"petAttackType": "range",
		"level": 1,
		"str": 400,
		"abilityPower": 100,
		"tempStr":0,
		"hungry": 20000,
		"hungryValue": 0,
		"rage": 10,
		"petMagic": magics.get("逆天破"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "西游奇缘2的男主狐葬魂摸样的假人"
	},
	"水无痕": {
		"name": "水无痕",
		"petAttackType": "melee",
		"level": 1,
		"str": 600,
		"abilityPower": 100,
		"tempStr":0,
		"hungry": 20000,
		"hungryValue": 0,
		"rage": 10,
		"petMagic": magics.get("战神念法"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "梦幻群侠传2的男主水无痕摸样的假人"
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
		"tempStr":0,
		"hungryValue": 1,
		"hungry": 200,
		"rage": 100,
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
		"tempStr":0,
		"hungry": 200,
		"hungryValue": 3,
		"rage": 10,
		"petMagic": magics.get("水满金山"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null
	},
	"狐葬魂": {
		"name": "狐葬魂",
		"petAttackType": "range",
		"level": 1,
		"str": 400,
		"abilityPower": 100,
		"tempStr":0,
		"hungry": 20000,
		"hungryValue": 3,
		"rage": 10,
		"petMagic": magics.get("逆天破"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "西游奇缘2的男主狐葬魂摸样的假人"
	},
	"水无痕": {
		"name": "水无痕",
		"petAttackType": "melee",
		"level": 1,
		"str": 600,
		"abilityPower": 100,
		"tempStr":0,
		"hungry": 20000,
		"hungryValue": 3,
		"rage": 10,
		"petMagic": magics.get("战神念法"),
		"autoAttackSound": "res://Audio/SE/男-剑.ogg",
		"attackOnEnemySound": null,
		"description": "梦幻群侠传2的男主水无痕摸样的假人"
	}			
	
}

# 假如你的代码是在同一个script中:

func deep_copy_dictionary(original: Dictionary) -> Dictionary:
	var new_dictionary = {}
	for key in original.keys():
		var value = original[key]
		if value is Dictionary:
			new_dictionary[key] = deep_copy_dictionary(value)
		elif value is Array:
			new_dictionary[key] = deep_copy_array(value)
		else:
			new_dictionary[key] = value
	return new_dictionary


func deep_copy_array(arr: Array) -> Array:
	var new_array = []
	for item in arr:
		if item is Dictionary:
			new_array.append(deep_copy_dictionary(item))
		elif item is Array:
			new_array.append(deep_copy_array(item))
		else:
			new_array.append(item)
	return new_array


func reset_curr_pet_data():
	currSmallPetData = deep_copy_dictionary(oriSmallPetData)
	# 这样修改 currSmallPetData 就不会作用到 oriSmallPetData
