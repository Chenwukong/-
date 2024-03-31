extends Node2D

# Monster class with default values for attributes
class Monster:
	var name: String
	var speed: int = 0
	var level: int = 1
	var magicDefense: int = 0
	var physicDefense: int = 0
	var attackDmg: int = 0
	var magicDmg: int = 0
	var hp: int = 0
	var idle # Assuming animation is a scene resource
	var exp: int = 0
	var gold: int = 0
	var monsterMagicList = []
	
	func _init(params: Dictionary):
		name = params.name
		speed = params.speed if "speed" in params else 0
		level = params.level if "level" in params else 1
		magicDefense = params.magicDefense if "magicDefense" in params else 0
		physicDefense = params.physicDefense if "physicDefense" in params else 0
		attackDmg = params.attackDmg if "attackDmg" in params else 0
		magicDmg = params.magicDmg if "magicDmg" in params else 0
		hp = params.hp if "hp" in params else 0
		idle = params.idle
		exp = params.exp if "exp" in params else 0
		gold =  params.gold if "gold" in params else 0
		monsterMagicList = params.monsterMagicList if "monsterMagicList" in params else []
# Define monsters organized by levels using dictionaries

var magics = {
	"水漫金山":{
		"name": "水漫金山",
		"attackType": "range",
		"damage": 20, 
		"cost": 50,
		"description": "群攻法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/法术12.ogg"
	},
	"水攻":{
		"name": "水攻",
		"attackType": "range",
		"damage": 30, 
		"cost": 10,
		"description": "群攻法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/法术12.ogg"
	},
	"落岩":{
		"name": "落岩",
		"attackType": "range",
		"damage": 50, 
		"cost": 30,
		"description": "群攻法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/落岩.ogg"
	},	
	
}


var monsters = {
	"东海湾": {
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"hp": 100,
			"exp": 15,
			"gold": 10,
			"idle": "海毛虫idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"大海龟": Monster.new({
			"name": "大海龟",
			"speed":20,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"hp": 200,
			"exp": 30,
			"gold":10,
			"idle": "大海龟idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
		}),
	},	
	"巨蛙":{
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"hp": 200,
			"exp": 50,
			"gold": 10,
			"idle": "海毛虫idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"巨蛙": Monster.new({
			"name": "巨蛙",
			"speed": 60,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 60,
			"attackDmg": 100,
			"magicDmg": 3,
			"hp": 1500,
			"exp": 1000,
			"gold": 1000,
			"idle": "巨蛙idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
				magics.get("水攻"),
			],
			}),		
		"大海龟": Monster.new({
			"name": "大海龟",
			"speed":20,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"hp": 300,
			"exp": 50,
			"gold":10,
			"idle": "大海龟idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
		}),				
	},	
	"奔霸":{
		"虾兵": Monster.new({
			"name": "虾兵",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"虾兵2": Monster.new({
			"name": "虾兵",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),	
		"虾兵3": Monster.new({
			"name": "虾兵",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"蟹将1": Monster.new({
			"name": "蟹将",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),
		"蟹将2": Monster.new({
			"name": "蟹将",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),	
		"奔霸": Monster.new({
			"name": "奔霸",
			"speed": 4000,
			"level": 1,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 500,
			"magicDmg": 400,
			"hp": 20000,
			"exp": 50,
			"gold": 10,
			"idle": "奔霸idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
			],
			}),					
		"蟹将3": Monster.new({
			"name": "蟹将",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 200,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),							
	},
	"虾兵蟹将":{
		"虾兵": Monster.new({
			"name": "虾兵",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"虾兵2": Monster.new({
			"name": "虾兵",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),	
		"虾兵3": Monster.new({
			"name": "虾兵",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"蟹将1": Monster.new({
			"name": "蟹将",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),
		"蟹将2": Monster.new({
			"name": "蟹将",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),		
		"蟹将3": Monster.new({
			"name": "蟹将",
			"speed": 20,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 2,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),														
	},
	
	"东海湾2": {
		"狐狸精": Monster.new({
			"name": "狐狸精",
			"speed": 0,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 1,
			"hp": 100,
			"exp": 10000000,
			"gold": 150,
			"idle": "狐狸精idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
			],
			}),
		"花妖": Monster.new({
			"name": "花妖",
			"speed":0,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 1,
			"hp": 100,
			"exp": 200,
			"gold":200,
			"idle": "花妖idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
			],
		}),
	},
	2: {
		"laoHuJing": Monster.new({
			"name": "laoHuJing",
			"speed": 20,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 15,
			"magicDmg": 10,
			"hp": 50,
			"idle": null
		}),
	},
}


# Function to get monsters by level
func get_monsters_by_level(level: String) -> Dictionary:
	return monsters.get(level, {})

func getBoss(bossName) -> Dictionary:
	return monsters.get(bossName, {})




# 以下是不做多个场景的只切换动画
#var monsters = {
#    1: {
#        "huLiJing": {
#            "name": "huLiJing",
#            "age": 30,
#            "city": "New York",
#            "animation": preload("res://path/to/huLiJing_animation.tres")  # Replace with the actual path to your Animation resource
#        },
#        "laoShuJing": {
#            "name": "laoShuJing",
#            "age": 30,
#            "city": "New York",
#            "animation": preload("res://path/to/laoShuJing_animation.tres")  # Replace with the actual path to your Animation resource
#        }
#        # Add more monsters as needed
#    },
#    2: {
#        "laoHuJing": {
#            "name": "laoHuJing",
#            "age": 30,
#            "city": "New York",
#            "animation": preload("res://path/to/laoHuJing_animation.tres")  # Replace with the actual path to your Animation resource
#        }
#        # Add more monsters as needed
#    }
#    # Add more levels as needed
#}
#}
