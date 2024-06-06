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
	var type: String = ""
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
		type = params.type if "type" in params else ""
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
		"damage": 40, 
		"cost": 30,
		"description": "群攻法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/落岩.ogg"
	},	
	"地裂火":{
		"name": "地裂火",
		"attackType": "range",
		"damage": 60, 
		"cost": 30,
		"description": "单体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/火1.ogg"
	},
	"泰山压顶":{
		"name": "泰山压顶",
		"attackType": "range",
		"damage": 50, 
		"cost": 30,
		"description": "单体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/羊.ogg"
	},
	"狐魅术":{
		"name": "狐魅术",
		"attackType": "range",
		"damage": 40, 
		"cost": 30,
		"description": "单体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/女-呀.ogg"
	},
	"漫天花雨":{
		"name": "漫天花雨",
		"attackType": "range",
		"damage": 25, 
		"cost": 30,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/鸟语花香.ogg"
	},	
	"静电":{
		"name": "静电",
		"attackType": "range",
		"damage": 60, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/女妖-法术.ogg"
	},	
	"奔雷":{
		"name": "奔雷",
		"attackType": "range",
		"damage": 50, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术3.ogg"
	},	
	"烈火":{
		"name": "烈火",
		"attackType": "range",
		"damage": 50, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/BGS/火3.ogg"
	},				
}


var monsters = {
	"东海湾": {
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"type": "龙",
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
			"type": "龙",
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
			"speed": 40000,
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
	"牛羊怪":{
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 70,
			"magicDmg": 2,
			"hp": 1200,
			"exp": 300,
			"gold": 300,
			"idle": "牛妖idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
			],
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 70,
			"magicDmg": 2,
			"hp": 1200,
			"exp": 300,
			"gold": 300,
			"idle": "羊妖idle",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			],
			}),
	},
	"蓝羽妖女":{
		"蓝羽妖女":Monster.new({
			"name": "蓝羽妖女",
			"speed": 40,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 80,
			"magicDmg": 2,
			"hp": 1500,
			"exp": 2000,
			"gold": 500,
			"idle": "蓝羽妖女idle",
			 "monsterMagicList": [
				magics.get("静电"),
			],
			})},		
	"江南野外": {
		"狐狸精": Monster.new({
			"name": "狐狸精",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 30,
			"attackDmg": 55,
			"magicDmg": 1.5,
			"hp": 300,
			"exp": 100,
			"gold": 30,
			"idle": "狐狸精idle",
			 "monsterMagicList": [
				magics.get("狐魅术"),
			],
			}),
		"花妖": Monster.new({
			"name": "花妖",
			"speed":30,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 55,
			"magicDmg": 1.5,
			"hp": 300,
			"exp": 100,
			"gold":30,
			"idle": "花妖idle",
			 "monsterMagicList": [
				magics.get("漫天花雨"),
			],
		}),
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 2,
			"hp": 400,
			"exp": 100,
			"gold": 40,
			"idle": "牛妖idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
			],
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 35,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1.5,
			"hp": 400,
			"exp": 100,
			"gold": 40,
			"idle": "羊妖idle",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			],
			}),
			
	},
	"大鹏":{
		"大鹏":Monster.new({
			"name": "大鹏",
			"speed": 140,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 80,
			"magicDmg": 1.5,
			"hp": 3000,
			"exp": 3000,
			"gold": 1000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			})},		
	"牛冠军": {
		"牛冠军": Monster.new({
			"name": "牛冠军",
			"speed": 60,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 300,
			"magicDmg": 2,
			"exp": 200,
			"gold": 800,
			"hp": 5000,
			"idle": "牛冠军idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],			
		}),
	},
	"鼠先锋": {
		"鼠先锋": Monster.new({
			"name": "鼠先锋",
			"speed": 30,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 80,
			"magicDmg": 1.5,
			"exp": 1500,
			"gold": 1000,
			"hp": 2000,
			"idle": "鼠先锋idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
				magics.get("落岩"),
			],			
		}),
	},
	"爷傲奈我何": {
		"爷傲奈我何": Monster.new({
			"name": "爷傲奈我何",
			"speed": 60,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"exp": 150,
			"gold": 0,
			"hp": 600,
			"idle": "爷傲奈我何idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],			
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
