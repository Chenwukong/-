extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#currSmallPetData["小鹿"].petMagic.value *= 2
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

var magics ={
	"甘露逢春":{
		"name":"甘露逢春",
		"type":"healing",
		"hitNum": 1,
		"value": 300,
	}
	
	
}

var oriSmallPetData = {
	"小鹿":{
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
	},

}

var currSmallPetData = {
	"小鹿":{
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
			"attackOnEnemySound": null,
	},

}	

