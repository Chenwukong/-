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
		"hitNum":3,
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
	"天火陨石":{
		"name": "天火陨石",
		"attackType": "range",
		"damage": 100, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/142-Burst02.ogg"
	},
	"吸魂大法":{
		"name": "吸魂大法",
		"attackType": "debuff",
		"damage": 0, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/140-Darkness03.ogg"
	},
	"风雨雷电":{
		"name": "风雨雷电",
		"attackType": "range",
		"damage": 150, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/风 (2).wav"
	},
	"开天辟地":{
		"name": "开天辟地",
		"attackType": "melee",
		"damage": 300, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/119-Fire03.ogg"
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
			"speed": 40,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 100,
			"magicDmg": 3,
			"hp": 1600,
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
			"attackDmg": 55,
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
			"attackDmg": 55,
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
			"attackDmg": 55,
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
			"attackDmg": 55,
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
			"attackDmg": 55,
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
			"attackDmg": 55,
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
			"speed": 50,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 100,
			"magicDmg": 2,
			"hp": 2000,
			"exp": 300,
			"gold": 300,
			"idle": "牛妖idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
			],
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 50,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 100,
			"magicDmg": 2,
			"hp": 2000,
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
			"speed": 100,
			"level": 1,
			"magicDefense": 50,
			"physicDefense": 50,
			"attackDmg": 170,
			"magicDmg": 4,
			"hp": 3500,
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
			"attackDmg": 130,
			"magicDmg": 2,
			"hp": 3000,
			"exp": 2000,
			"gold": 1000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			"type":""
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
			"type":""		
		}),
	},
	"鼠先锋": {
		"鼠先锋": Monster.new({
			"name": "鼠先锋",
			"speed": 60,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 120,
			"magicDmg": 1.5,
			"exp": 1000,
			"gold": 1000,
			"hp": 1500,
			"idle": "鼠先锋idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
				magics.get("落岩"),
			],	
			"type":""		
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
			"type":""		
		}),
	},	
	"锁妖塔2"	:{
		"狐狸精": Monster.new({
			"name": "狐狸精",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 30,
			"attackDmg": 55,
			"magicDmg": 1.5,
			"hp": 300,
			"exp": 130,
			"gold": 30,
			"idle": "狐狸精idle",
			 "monsterMagicList": [
				magics.get("狐魅术"),
			],
			"type":""
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
			"exp": 130,
			"gold":30,
			"idle": "花妖idle",
			 "monsterMagicList": [
				magics.get("漫天花雨"),
			],
			"type":""
		}),			
	},
	
	"鳄额呃":{
		"鳄额呃": Monster.new({
			"name": "鳄额呃",
			"speed":50,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 150,
			"magicDmg": 1,
			"hp": 2000,
			"exp": 1500,
			"gold":1200,
			"type":"",
			"idle": "鳄额呃idle",
			 "monsterMagicList": [
			],
		}),				
	},
	"锁妖塔3":{
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 30,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 2,
			"hp": 400,
			"exp": 160,
			"gold": 40,
			"idle": "牛妖idle",
			"type": "",
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
			"exp": 160,
			"gold": 40,
			"idle": "羊妖idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			],
			}),
	},
	"鼠老大":{
		"鼠老大": Monster.new({
			"name": "鼠先锋",
			"speed":60,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 170,
			"magicDmg": 1.5,
			"hp": 2000,
			"exp": 1500,
			"gold":1200,
			"type":"",
			"idle": "鼠先锋idle",
			 "monsterMagicList": [
			],
		}),				
	},	
	"锁妖塔4":{
		"兔子精":Monster.new({
			"name": "兔子精",
			"speed": 80,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 2,
			"hp": 400,
			"exp": 160,
			"gold": 40,
			"idle": "兔子精idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("地裂火"),
			],
			}),
		"黑熊精":Monster.new({
			"name": "黑熊精",
			"speed": 35,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1.5,
			"hp": 400,
			"exp": 160,
			"gold": 40,
			"idle": "黑熊精idle",
			"type": "",
			 "monsterMagicList": [
				
			],
			}),
	},	
	"黑熊王":{
		"黑熊王": Monster.new({
			"name": "黑熊王",
			"speed":60,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 190,
			"magicDmg": 1.5,
			"hp": 2000,
			"exp": 1500,
			"gold":1200,
			"type":"",
			"idle": "黑熊王idle",
			 "monsterMagicList": [
			],
		}),				
	},		
	"蒙面人":{
		"蒙面人": Monster.new({
			"name": "蒙面人",
			"speed":0,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 190,
			"magicDmg": 1.5,
			"hp": 1,
			"exp": 1,
			"gold":1,
			"type":"",
			"idle": "蒙面人idle",
			 "monsterMagicList": [
			],
		}),				
	},
	"锁妖塔6":{
		"树怪":Monster.new({
			"name": "树怪",
			"speed": 80,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 2,
			"hp": 800,
			"exp": 300,
			"gold": 100,
			"idle": "树怪idle",
			"type": "",
			 "monsterMagicList": [
			],
			}),
	},	
	"千年树":{
		"千年树": Monster.new({
			"name": "千年树",
			"speed": 50,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 190,
			"magicDmg": 1.5,
			"hp": 3000,
			"exp": 1500,
			"gold": 1000,
			"type":"",
			"idle": "千年树idle",
			 "monsterMagicList": [
			],
		}),				
	},
	"鹰孽大王":{
		"鹰孽大王": Monster.new({
			"name": "鹰孽大王",
			"speed": 60,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 210,
			"magicDmg": 2,
			"hp": 4000,
			"exp": 2000,
			"gold": 2000,
			"type":"",
			"idle": "鹰孽大王idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
				magics.get("天火陨石"),
				magics.get("吸魂大法"),
			],
		}),				
	},
	"反贼小头目":{
		"反贼小头目": Monster.new({
			"name": "反贼小头目",
			"speed": 60,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 210,
			"magicDmg": 2,
			"hp": 1500,
			"exp": 2000,
			"gold": 2000,
			"type":"",
			"idle": "反贼小头目idle",
			 "monsterMagicList": [
			],
		}),				
	},
	"反贼大头目":{
		"反贼大头目": Monster.new({
			"name": "反贼大头目",
			"speed": 60,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 210,
			"magicDmg": 2,
			"hp": 1700,
			"exp": 2000,
			"gold": 2000,
			"type":"",
			"idle": "反贼大头目idle",
			 "monsterMagicList": [

			],
		}),				
	},
	"堕逝":{
		"堕逝": Monster.new({
			"name": "堕逝",
			"speed": 50,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 160,
			"magicDmg": 1.5,
			"hp": 4000,
			"exp": 2000,
			"gold": 6000,
			"type":"",
			"idle": "堕逝idle",
			 "monsterMagicList": [
				magics.get("风雨雷电"),
			],
		}),				
	},
	"程咬金":{
		"程咬金": Monster.new({
			"name": "程咬金",
			"speed": 100,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 300,
			"magicDmg": 2 ,
			"hp": 2500,
			"exp": 0,
			"gold": 0,
			"type":"",
			"idle": "程咬金idle",
			 "monsterMagicList": [
				magics.get("开天辟地")
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
