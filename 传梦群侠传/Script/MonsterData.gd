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
	var luck: int = 0
	var autoAttackSound = ""
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
		luck = params.luck if "luck" in params else 0
		type = params.type if "type" in params else ""
		autoAttackSound = params.autoAttackSound if "autoAttackSound" in params else ""
		monsterMagicList = params.monsterMagicList if "monsterMagicList" in params else []
# Define monsters organized by levels using dictionaries
func _ready():
	monsters["炼狱迷宫2"] = monsters['炼狱迷宫1']
	monsters["炼狱迷宫3"] = monsters['炼狱迷宫1']
	monsters["炼狱迷宫4"] = monsters['炼狱迷宫1']
	monsters["炼狱迷宫5"] = monsters['炼狱迷宫1']
	monsters["炼狱迷宫6"] = monsters['炼狱迷宫1']
	monsters["炼狱迷宫7"] = monsters['炼狱迷宫1']
	monsters["海底迷宫2"] = monsters['海底迷宫1']
	monsters["海底迷宫3"] = monsters['海底迷宫1']
	monsters["海底迷宫4"] = monsters['海底迷宫1']
	monsters["海底迷宫5"] = monsters['海底迷宫1']
	monsters["海底迷宫6"] = monsters['海底迷宫1']
	monsters["海底迷宫7"] = monsters['海底迷宫1']	
	monsters["东海海道2"] = monsters['东海海道']
	monsters["东海海道3"] = monsters['东海海道']
	monsters["地府迷宫2"] = monsters['地府迷宫1']
	monsters["地府迷宫3"] = monsters['地府迷宫1']
	monsters["地府迷宫4"] = monsters['地府迷宫1']
	monsters["地府监狱"] = monsters['地府迷宫1']		
	monsters["龙窟2"] = monsters['龙窟1']
	monsters["龙窟3"] = monsters['龙窟1']
	monsters["龙窟3"] = monsters['龙窟1']
	monsters["龙窟4"] = monsters['龙窟1']
	monsters["龙窟5"] = monsters['龙窟1']
	monsters["龙窟6"] = monsters['龙窟1']	
	monsters["龙窟7"] = monsters['龙窟1']	
	monsters["凤巢2"] = monsters['凤巢1']	
	monsters["凤巢2"] = monsters['凤巢1']
	monsters["凤巢3"] = monsters['凤巢1']
	monsters["凤巢4"] = monsters['凤巢1']
	monsters["凤巢5"] = monsters['凤巢1']	
	monsters["凤巢6"] = monsters['凤巢1']
	monsters["凤巢7"] = monsters['凤巢1']	
	monsters["幻境2"] = monsters['幻境1']		
	monsters["幻境3"] = monsters['幻境1']		
	monsters["幻境4"] = monsters['幻境1']			
	monsters["创界山顶"] = monsters['创界山']			
func calculate_monster_hp(level):
	var baseHp = 130  # Base HP at level 1
	var finalHp = 5000  # Desired HP at level 100
	
	var hpIncreasePerLevel = (finalHp - baseHp) / 99  # Linear increase per level

	var totalHp = baseHp + hpIncreasePerLevel * (level - 1)
	return totalHp
	
	
func calculate_monster_exp(hp):
	var exp = hp/3
	
	return exp
func calculate_monster_gold(hp):
	var gold = hp/5
	
	return gold



var magics = {
	"水漫金山":{
		"name": "水漫金山",
		"attackType": "range",
		"damage": 1, 
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
		"damage": 1.3, 
		"cost": 10,
		"description": "群攻法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/法术12.ogg"
	},
	"水炮":{
		"name": "水炮",
		"attackType": "range",
		"damage": 1.5, 
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
		"damage": 1.3, 
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
		"damage": 1.6, 
		"cost": 30,
		"description": "单体法术",
		"effectArea": "single",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/火1.ogg"
	},
	"毒粉尘":{
		"name": "毒粉尘",
		"attackType": "range",
		"damage": 1.5, 
		"cost": 30,
		"description": "单体法术",
		"effectArea": "single",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio":"res://Audio/SE/151-Support09.ogg"
	},
	"泰山压顶":{
		"name": "泰山压顶",
		"attackType": "range",
		"damage": 1.2, 
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
		"damage": 1.3, 
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
		"damage": 1.1, 
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
		"damage": 1.7, 
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
		"damage": 1.4, 
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
		"damage": 1.4, 
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
		"damage": 1.5, 
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
		"damage": 1.7, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/风 (2).wav"
	},
	"开天辟地":{
		"name": "开天辟地",
		"attackType": "melee",
		"damage": 3, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/119-Fire03.ogg"
	},	
	"硝爆":{
		"name": "硝爆",
		"attackType": "range",
		"damage": 3, 
		"cost": 50,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/049-Explosion02.ogg"
	},		
	"虚沉冰封":{
		"name": "虚沉冰封",
		"attackType": "debuff",
		"debuffType": "ice",
		"damage": 1.9, 
		"cost": 500,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/049-Explosion02.ogg"
	},							
	"双龙戏珠":{
		"name": "双龙戏珠",
		"attackType": "range",
		"debuffType": "ice",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/双龙戏猪.ogg"
	},								
	"魔音侵袭":{
		"name": "魔音侵袭",
		"attackType": "range",
		"debuffType": "ice",
		"damage": 1.4, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/咒语2.ogg"
	},			
	"双生碧击":{
		"name": "双生碧击",
		"attackType": "range",
		"debuffType": "ice",
		"damage": 2.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/140-Darkness03.ogg"
	},	
	"雷击":{
		"name": "雷击",
		"attackType": "range",
		"debuffType": "ice",
		"damage": 1.7, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/123-Thunder01.ogg"
	},		
	"水满金山":{
		"name": "水满金山",
		"attackType": "range",
		"debuffType": "ice",
		"damage": 1.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/127-Water02.ogg"
	},	
	"立墓":{
		"name": "立墓",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/127-Water02.ogg"
	},	
	"死亡召唤":{
		"name": "死亡召唤",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术10.ogg"
	},			
	
	
	"血傀":{
		"name": "血傀",
		"attackType": "range",
		"damage": 2.9, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 1
		,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/140-Darkness03.ogg"
	},		
	"龙怒":{
		"name": "龙怒",
		"attackType": "range",
		"damage": 3, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/暴风.ogg"
	},		
	"追云锁":{
		"name": "追云锁",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/127-Water02.ogg"
	},	
	"雾中花":{
		"name": "雾中花",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术4.ogg"
	},					
	"狮子吼":{
		"name": "狮子吼",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/082-Monster04.ogg"
	},
	"龙哮":{
		"name": "龙哮",
		"attackType": "range",
		"damage": 1.8, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/双龙戏猪.ogg"
	},	
	"雷龙腾":{
		"name": "雷龙腾",
		"attackType": "range",
		"damage": 2.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术13.ogg"
	},		
	"大台风":{
		"name": "大台风",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术13.ogg"
	},		
	"龙啸九天":{
		"name": "龙啸九天",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/083-Monster05.ogg"
	},	
	"飞沙走石":{
		"name": "飞沙走石",
		"attackType": "range",
		"damage": 1.8, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 5,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/火2.ogg"
	},		
	"佛掌":{
		"name": "佛掌",
		"attackType": "range",
		"damage": 2.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术 爆炸.ogg"
	},		
	"炼狱真火":{
		"name": "炼狱真火",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/火 5.ogg"
	},		
	"三味真火":{
		"name": "三味真火",
		"attackType": "range",
		"damage": 2.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/火4.ogg"
	},			
	"阎罗令":{
		"name": "阎罗令",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术16.ogg"
	},				
	"魔光毒虫":{
		"name": "魔光毒虫",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/汉子-笑9.ogg"
	},					
	"象脚":{
		"name": "象脚",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术 爆炸.ogg"
	},
	"雷龙吐息":{
		"name": "雷龙吐息",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/双龙戏猪.ogg"
	},
	"矢雨":{
		"name": "矢雨",
		"attackType": "range",
		"damage": 2.5, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 3,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/法术13.ogg"
	},	
	"气爆":{
		"name": "气爆",
		"attackType": "range",
		"damage": 1.9, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/051-Explosion04.ogg"
	},		
	"金身出鞘":{
		"name": "金身出鞘",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 2,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/杀.ogg"
	},
	"天劫":{
		"name": "天劫",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 4,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/051-Explosion04.ogg"
	},
	"星辰陨落":{
		"name": "星辰陨落",
		"attackType": "range",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "aoe",
		"effectingNum": 8,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/050-Explosion03.ogg"
	},	
	"治疗":{
		"name": "治疗",
		"attackType": "heal",
		"damage": 2, 
		"cost": 50,
		"duration": 2,
		"description": "群体法术",
		"effectArea": "single",
		"effectingNum": 1,
		"animationArea":"enemy",
		"audio": "res://Audio/SE/106-Heal02.ogg"
	},		
						
}


var monsters = {
	"传梦":{
		"传梦": Monster.new({
			"name": "传梦",
			"speed": 9999,
			"level": 99,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 999999,
			"magicDmg": 999999,
			"posi": "middle",
			"hp": 9999999,
			"exp": 0,
			"gold": 0,
			"luck": 10,
			"idle": "传梦idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),	
	},		
	
	
	
	"东海湾": {
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 50,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 50,
			"magicDmg": 40,
			"hp": 130,
			"exp": 30,
			"gold": 20,
			"luck": 10,
			"idle": "海毛虫idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/小怪-攻击.ogg"
			}),
		"大海龟": Monster.new({
			"name": "大海龟",
			"speed":45,
			"level": 3,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 50,
			"magicDmg": 30,
			"luck": 10,
			"hp": 200,
			"exp": 40,
			"gold": 20,
			"idle": "大海龟idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/怪-法术.ogg"
		}),
	},	
	"巨蛙":{
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 40,
			"level": 3,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 35,
			"posi": "middle",
			"hp": calculate_monster_hp(3),
			"exp": calculate_monster_exp(calculate_monster_hp(3)),
			"gold": calculate_monster_gold(calculate_monster_hp(3)),
			"luck": 10,
			"idle": "海毛虫idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/小怪-攻击.ogg"
			}),
		"巨蛙": Monster.new({
			"name": "巨蛙",
			"speed": 60,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 100,
			"magicDmg": 40,
			"hp": 2000,
			"exp": 1000,
			"gold": 1000,
			"luck": 10,
			"idle": "巨蛙idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/巨蛙X.ogg"
			}),		
		"大海龟": Monster.new({
			"name": "大海龟",
			"speed":40,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 35,
			"hp": calculate_monster_hp(5),
			"exp": calculate_monster_exp(calculate_monster_hp(5)),
			"gold": calculate_monster_gold(calculate_monster_hp(5)),
			"luck": 10,
			"idle": "大海龟idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/怪-法术.ogg"
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
			"speed": 2000,
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
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/锤击.ogg"
			}),
		"虾兵2": Monster.new({
			"name": "虾兵",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/锤击.ogg"
			}),	
		"虾兵3": Monster.new({
			"name": "虾兵",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/锤击.ogg"
			}),
		"蟹将1": Monster.new({
			"name": "蟹将",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
			}),
		"蟹将2": Monster.new({
			"name": "蟹将",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
			}),		
		"蟹将3": Monster.new({
			"name": "蟹将",
			"speed": 40,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 55,
			"magicDmg": 35,
			"hp": 300,
			"exp": 50,
			"gold": 10,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
			}),														
	},
	"牛羊怪":{
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 80,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 150,
			"magicDmg": 70,
			"hp": 2000,
			"exp": calculate_monster_exp(2000),
			"gold": 500,
			"idle": "牛妖idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			"autoAttackSound": "res://Audio/SE/虎-刀.ogg"
			
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 90,
			"level": 8,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 130,
			"magicDmg": 80,
			"hp": 2000,
			"exp": calculate_monster_exp(2000),
			"gold": 500,
			"idle": "羊妖idle",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			],
			"autoAttackSound":"res://Audio/SE/103-Attack15.ogg"
			}),
	},
	"蓝羽妖女":{
		"蓝羽妖女":Monster.new({
			"name": "蓝羽妖女",
			"speed": 120,
			"level": 1,
			"magicDefense": 50,
			"physicDefense": 50,
			"attackDmg": 250,
			"type": "",
			"posi": "middle",
			"magicDmg": 200,
			"hp": 4000,
			"exp": calculate_monster_exp(3500),
			"gold": calculate_monster_gold(3500),
			"idle": "蓝羽妖女idle",
			 "monsterMagicList": [
				magics.get("静电"),
			],
			}
			),
			"autoAttackSound": "res://Audio/SE/物理法术-妖女.ogg"
			
			},		
	"江南野外": {
		"狐狸精": Monster.new({
			"name": "狐狸精",
			"speed": 50,
			"level": 8,
			"magicDefense": 5,
			"physicDefense": 30,
			"attackDmg": 130,
			"magicDmg": 80,
			"hp": calculate_monster_hp(8),
			"exp": calculate_monster_exp(calculate_monster_hp(8)),
			"gold": calculate_monster_gold(calculate_monster_hp(8)),
			"luck": 10,
			"type": "",
			"idle": "狐狸精idle",
			 "monsterMagicList": [
				magics.get("狐魅术"),
			],
			"autoAttackSound": "res://Audio/SE/狐狸-攻击.ogg"
			}),
		"花妖": Monster.new({
			"name": "花妖",
			"speed": 60,
			"level": 9,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 110,
			"magicDmg": 100,
			"luck": 10,
			"hp": calculate_monster_hp(9),
			"exp": calculate_monster_exp(calculate_monster_hp(9)),
			"gold": calculate_monster_gold(calculate_monster_hp(9)),
			"type": "",
			"idle": "花妖idle",
			 "monsterMagicList": [
				magics.get("漫天花雨"),
			],
			"autoAttackSound": "res://Audio/SE/打击3.ogg"
		}),
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 70,
			"level": 10,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 150,
			"magicDmg": 50,
			"luck": 10,
			"hp": calculate_monster_hp(10),
			"exp": calculate_monster_exp(calculate_monster_hp(10)),
			"gold": calculate_monster_gold(calculate_monster_hp(10)),
			"type": "",
			"idle": "牛妖idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			"autoAttackSound": "res://Audio/SE/虎-刀.ogg"
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 75,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 140,
			"magicDmg": 120,
			"luck": 10,
			"hp": calculate_monster_hp(10),
			"exp": calculate_monster_exp(calculate_monster_hp(10)),
			"gold": calculate_monster_gold(calculate_monster_hp(10)),
			"type": "",
			"idle": "羊妖idle",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			]
			,
			"autoAttackSound":"res://Audio/SE/103-Attack15.ogg"
			}
			),
			
	},
	"大鹏":{
		"大鹏":Monster.new({
			"name": "大鹏",
			"speed": 140,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 130,
			"magicDmg": 150,
			"hp": 3000,
			"posi": "middle",
			"exp": 400,
			"gold": 1500,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			"type":"",
			"autoAttackSound":"res://Audio/SE/凤凰-攻击.ogg"

			})},		
	"牛冠军": {
		"牛冠军": Monster.new({
			"name": "牛冠军",
			"speed": 150,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 500,
			"magicDmg": 150,
			"exp": 200,
			"posi": "middle",
			"gold": 1000,
			"luck": 0,
			"hp": 3000,
			"idle": "牛冠军idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],	
			"type":"",
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
		}),
	},
	"鼠先锋": {
		"鼠先锋": Monster.new({
			"name": "鼠先锋",
			"speed": 90,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 200,
			"magicDmg": 150,
			"posi": "middle",
			"exp": calculate_monster_exp(1800),
			"gold": calculate_monster_gold(1800),
			"hp": 1800,
			"idle": "鼠先锋idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
				magics.get("落岩"),
			],	
			"type":"",
			"autoAttackSound":"res://Audio/SE/小妖-攻击.ogg"
		}),
	},
	"爷傲奈我何": {
		"爷傲奈我何": Monster.new({
			"name": "爷傲奈我何",
			"speed": 180,
			"level": 1,
			"magicDefense": 20,
			"physicDefense": 20,
			"attackDmg": 50,
			"magicDmg": 1,
			"posi": "middle",
			"exp": 200,
			"luck": 10,
			"gold": 80,
			"hp": 1000,
			"idle": "爷傲奈我何idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			"type":"",
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
		}),
	},	
	"锁妖塔2"	:{
		"狐狸精": Monster.new({
			"name": "狐狸精",
			"speed": 140,
			"level": 15,
			"magicDefense": 5,
			"physicDefense": 30,
			"attackDmg": 180,
			"magicDmg": 140,
			"hp": calculate_monster_hp(15),
			"exp": calculate_monster_exp(calculate_monster_hp(15)),
			"luck": 10,
			"gold": calculate_monster_gold(calculate_monster_hp(15)),
			"idle": "狐狸精idle",
			 "monsterMagicList": [
				magics.get("狐魅术"),
			],
			"type":"",
			"autoAttackSound": "res://Audio/SE/狐狸-攻击.ogg"
			}),
		"花妖": Monster.new({
			"name": "花妖",
			"speed": 150,
			"level": 16,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 150,
			"magicDmg": 150,
			"hp": calculate_monster_hp(16),
			"exp": calculate_monster_exp(calculate_monster_hp(16)),
			"luck": 10,
			"gold": calculate_monster_gold(calculate_monster_hp(16)),
			"idle": "花妖idle",
			 "monsterMagicList": [
				magics.get("漫天花雨"),
			],
			"type":"",
			"autoAttackSound": "res://Audio/SE/打击3.ogg"
		}),			
	},
	
	"鳄额呃":{
		"鳄额呃": Monster.new({
			"name": "鳄额呃",
			"speed": 180,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 450,
			"magicDmg": 1,
			"posi": "middle",
			"hp": 4500,
			"exp": 2000,
			"luck": 50,
			"gold":1200,
			"type":"",
			"idle": "鳄额呃idle",
			 "monsterMagicList": [
			],
			"autoAttackSound": "res://Audio/SE/小怪-攻击.ogg"
		}),				
	},
	"锁妖塔3":{
		"牛妖":Monster.new({
			"name": "牛妖",
			"speed": 150,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 240,
			"magicDmg": 180,
			"luck": 10,
			"hp": calculate_monster_hp(20),
			"exp": calculate_monster_exp(calculate_monster_hp(17)),
			"gold": calculate_monster_gold(calculate_monster_hp(17)),
			"idle": "牛妖idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			"autoAttackSound": "res://Audio/SE/虎-刀.ogg"
			}),
		"羊妖":Monster.new({
			"name": "羊妖",
			"speed": 160,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 190,
			"magicDmg": 170,
			"luck": 10,
			"hp": calculate_monster_hp(20),
			"exp": calculate_monster_exp(calculate_monster_hp(18)),
			"gold": calculate_monster_gold(calculate_monster_hp(18)),
			"idle": "羊妖idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("泰山压顶"),
			],
			"autoAttackSound":"res://Audio/SE/103-Attack15.ogg"
			}),
	},
	"鼠老大":{
		"鼠老大": Monster.new({
			"name": "鼠先锋",
			"speed": 230,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"attackDmg": 440,
			"posi": "middle",
			"luck": 50,
			"magicDmg": 1.5,
			"hp": 5000,
			"exp": 2500,
			"gold":1600,
			"type":"",
			"idle": "鼠先锋idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/小妖-攻击.ogg"
		}),				
	},	
	"锁妖塔4":{
		"兔子精":Monster.new({
			"name": "兔子精",
			"speed": 280,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 190,
			"magicDmg": 50,
			"luck": 10,
			"hp": calculate_monster_hp(19),
			"exp": calculate_monster_exp(calculate_monster_hp(19)),
			"gold": calculate_monster_gold(calculate_monster_hp(19)),
			"idle": "兔子精idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			"autoAttackSound":"res://Audio/SE/小妖-攻击.ogg"
			}),
		"黑熊精":Monster.new({
			"name": "黑熊精",
			"speed": 160,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 300,
			"magicDmg": 90,
			"luck": 10,
			"hp": calculate_monster_hp(20),
			"exp": calculate_monster_exp(calculate_monster_hp(20)),
			"gold": calculate_monster_gold(calculate_monster_hp(20)),
			"idle": "黑熊精idle",
			"type": "",
			 "monsterMagicList": [
				
			],
			"autoAttackSound":"res://Audio/SE/虎-刀.ogg"
			}),
	},	
	"黑熊王":{
		"黑熊王": Monster.new({
			"name": "黑熊王",
			"speed": 240,
			"level": 1,
			"magicDefense":5,
			"physicDefense": 30,
			"posi": "middle",
			"attackDmg": 580,
			"magicDmg": 1.5,
			"luck": 50,
			"hp": 6500,
			"exp": 4000,
			"gold": 3000,
			"type":"",
			"idle": "黑熊王idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/野兽-攻击.ogg"
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
			"posi": "middle",
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
			"speed": 200,
			"level": 20,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 280,
			"magicDmg":30,
			"luck": 10,
			"hp": calculate_monster_hp(25),
			"exp": calculate_monster_exp(calculate_monster_hp(21)),
			"gold": calculate_monster_gold(calculate_monster_hp(21)),
			"idle": "树怪idle",
			"type": "",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/104-Attack16.ogg"
			}),
	},	
	"千年树":{
		"千年树": Monster.new({
			"name": "千年树",
			"speed": 280,
			"level": 1,
			"magicDefense":5,
			"posi": "middle",
			"physicDefense": 30,
			"attackDmg": 500,
			"magicDmg": 1.5,
			"hp": 8000,
			"luck": 50,
			"exp": 5000,
			"gold": 4000,
			"type":"",
			"idle": "千年树idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/104-Attack16.ogg"
		}),				
	},
	"鹰孽大王":{
		"鹰孽大王": Monster.new({
			"name": "鹰孽大王",
			"speed": 200,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 600,
			"magicDmg": 190,
			"posi": "middle",
			"hp": 14000,
			"exp": 10000,
			"gold":5000,
			"luck": 65,
			"type":"",
			"idle": "鹰孽大王idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
				magics.get("天火陨石"),
				#magics.get("吸魂大法"),
			],
			"autoAttackSound":"res://Audio/SE/099-Attack11.ogg"
		}),				
	},
	"大唐国境":{
		"反贼小头目":Monster.new({
			"name": "反贼小头目",
			"speed": 105,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 130,
			"magicDmg": 2,
			"posi": "middle",
			"hp": 600,
			"exp": 60,
			"luck": 20,
			"gold": 40,
			"idle": "反贼小头目idle",
			"type": "",
			 "monsterMagicList": [
				
			],
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
			}),
		"反贼大头目":Monster.new({
			"name": "反贼大头目",
			"speed": 110,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 130,
			"magicDmg": 2,
			"hp": 850,
			"posi": "middle",
			"exp": 60,
			"luck": 20,
			"gold": 40,
			"idle": "反贼大头目idle",
			"type": "",
			 "monsterMagicList": [
				
			],
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
			}),
	},
	"反贼小头目":{
		"反贼小头目": Monster.new({
			"name": "反贼小头目",
			"speed": 110,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 150,
			"luck": 30,
			"magicDmg": 2,
			"hp": 3000,
			"posi": "middle",
			"exp": 200,
			"gold": 500,
			"type":"",
			"idle": "反贼小头目idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
		}),				
	},
	"反贼大头目":{
		"反贼大头目": Monster.new({
			"name": "反贼大头目",
			"speed": 120,
			"level": 1,
			"luck": 30,
			"magicDefense":0,
			"physicDefense": 0,
			"posi": "middle",
			"attackDmg": 180,
			"magicDmg": 2,
			"hp": 4000,
			"exp": 300,
			"gold": 500,
			"type":"",
			"idle": "反贼大头目idle",
			 "monsterMagicList": [

			],
			"autoAttackSound":"res://Audio/SE/兵器-入肉.ogg"
		}),				
	},
	"堕逝":{
		"堕逝": Monster.new({
			"name": "堕逝",
			"speed": 190,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 580,
			"magicDmg": 210,
			"posi": "middle",
			"hp": 12000,
			"exp": 8000,
			"gold": 4000,
			"type":"",
			"idle": "堕逝idle",
			 "monsterMagicList": [
				magics.get("风雨雷电"),
			],
			"autoAttackSound":"res://Audio/SE/092-Attack04.ogg"
		}),				
	},
	"程咬金":{
		"程咬金": Monster.new({
			"name": "程咬金",
			"speed": 300,
			"level": 1,
			"magicDefense":0,
			"physicDefense": 0,
			"attackDmg": 1200,
			"magicDmg": 250,
			"luck": 50,
			"hp": 13000,
			"posi": "middle",
			"exp": 0,
			"gold": 0,
			"type":"",
			"idle": "程咬金idle",
			 "monsterMagicList": [
				magics.get("开天辟地")
			],
			"autoAttackSound":"res://Audio/SE/098-Attack10.ogg"
		}),				
	},	
	"黑山":{
		"黑山": Monster.new({
			"name": "黑山",
			"speed": 230,
			"level": 1,
			"magicDefense": 1000,
			"luck": 10,
			"physicDefense": 1000,
			"attackDmg": 600,
			"magicDmg": 300 ,
			"hp":  11000,
			"posi": "middle",
			"exp": 5000,
			"gold": 2000,
			"type":"",
			"idle": "黑山idle",
			 "monsterMagicList": [
				magics.get("硝爆")
			],
			"autoAttackSound":"res://Audio/SE/大力金刚X.ogg"
		}),				
	},
	"小师弟":{
		"小师弟": Monster.new({
			"name": "小师弟",
			"speed": 180,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 450,
			"magicDmg": 200,
			"hp":  8000,
			"exp": 1000,
			"posi": "middle",
			"gold": 0,
			"type":"",
			"idle": "小师弟idle",
			 "monsterMagicList": [
				magics.get("天火陨石")
			],
			"autoAttackSound":"res://Audio/SE/103-Attack15.ogg"
		}),				
	},
	"机关人":{
		"机关人": Monster.new({
			"name": "机关人",
			"speed": 180,
			"level": 25,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 400,
			"luck": 0,
			"magicDmg": 3,
			"hp":  7000,
			"posi": "middle",
			"exp": 800,
			"gold": 0,
			"type":"",
			"idle": "机关人idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/101-Attack13.ogg"
		}),				
	},	
	"东海海道":{
		"虾兵": Monster.new({
			"name": "虾兵",
			"speed": 170,
			"level": 35,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 300,
			"magicDmg": 190,
			"hp": 3000,
			"luck": 30,
			"exp": 850,
			"gold": 450,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			"autoAttackSound": "res://Audio/SE/锤击.ogg"
			}
			),

		"蟹将": Monster.new({
			"name": "蟹将",
			"speed": 160,
			"level": 35,
			"magicDefense": 5,
			"luck": 30,
			"physicDefense": 20,
			"attackDmg": 350,
			"magicDmg": 180,
			"hp": 3200,
			"exp": 1050,
			"gold": 500,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
			],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
			}),

			},


	"敖雨":{
		"敖雨": Monster.new({
			"name": "敖雨",
			"speed": 200,
			"level": 35,
			"magicDefense": 500,
			"physicDefense": 500,
			"attackDmg": 800,
			"magicDmg": 400,
			"luck": 50,
			"hp":  23000,
			"posi": "middle",
			"exp": 15000,
			"gold": 6000,
			"type":"",
			"idle": "敖雨idle",
			 "monsterMagicList": [
				magics.get("虚沉冰封"),
				magics.get("水满金山")
			],
			"autoAttackSound": "res://Audio/SE/126-Water01.ogg"
		}),				
	},	
	"蟹将":{
		"蟹将": Monster.new({
				"name": "蟹将",
				"speed": 200,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 200,
				"attackDmg": 500,
				"magicDmg": 350,
				"hp": 13000,
				"luck": 10,
				"exp": 5000,
				"gold": 2500,
				"idle": "蟹将idle",
				 "monsterMagicList": [
					magics.get("水攻"),
				],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
				})},		
	"虾将":{
		"虾将": Monster.new({
				"name": "虾兵",
				"speed": 160,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 200,
				"attackDmg": 300,
				"luck": 10,
				"magicDmg": 10,
				"hp": 11000,
				"exp": 1000,
				"gold": 800,
				"idle": "虾兵idle",
				 "monsterMagicList": [
					magics.get("水攻"),
				],
				"autoAttackSound": "res://Audio/SE/锤击.ogg"
				})},
	"巨蛙兄":{
		"巨蛙": Monster.new({
				"name": "巨蛙",
				"speed": 210,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 150,
				"attackDmg": 400,
				"magicDmg": 400,
				"posi": "middle",
				"hp": 17000,
				"exp": 8000,
				"luck": 10,
				"gold": 3000,
				"idle": "巨蛙idle",
				 "monsterMagicList": [
					magics.get("水漫金山"),
					magics.get("水攻"),
					
				],
				})},				
	"窝壳贝":{
		"窝壳贝": Monster.new({
				"name": "窝壳贝",
				"speed": 220,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 300,
				"attackDmg": 500,
				"magicDmg": 400,
				"hp": 18000,
				"posi": "middle",
				"exp": 9000,
				"gold": 3500,
				"luck": 10,
				"idle": "窝壳贝idle",
				 "monsterMagicList": [
					magics.get("水炮"),
				],
				"autoAttackSound": "res://Audio/SE/怪叫-咕.ogg"
				})},	
	"海夜叉":{
		"海夜叉": Monster.new({
				"name": "海夜叉",
				"speed": 240,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 300,
				"attackDmg": 700,
				"magicDmg": 450,
				"posi": "middle",
				"hp": 25000,
				"exp": 10000,
				"gold": 6000,
				"luck": 10,
				"idle": "海夜叉idle",
				 "monsterMagicList": [
					magics.get("水炮"),
				],
				"autoAttackSound": "res://Audio/SE/镰刀.ogg"
				})},					
				
				
				
	"龙王们":{
		"龙王1": Monster.new({
				"name": "龙王",
				"speed": 210,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 350,
				"attackDmg": 600,
				"magicDmg": 400,
				"luck": 60,
				"hp": 20000,
				"exp": 7000,
				"gold": 1500,
				"idle": "龙王idle",
				 "monsterMagicList": [
					magics.get("双龙戏珠"),
				],
				}),
		"龙王2": Monster.new({
				"name": "龙王",
				"speed": 210,
				"level": 35,
				"magicDefense": 5,
				"physicDefense": 350,
				"luck": 60,
				"attackDmg": 600,
				"magicDmg": 400,
				"hp": 20000,
				"exp": 7000,
				"gold": 1500,
				"idle": "龙王idle",
				 "monsterMagicList": [
					magics.get("双龙戏珠"),
				],
				}),				
		"龙王3": Monster.new({
				"name": "龙王",
				"speed": 210,
				"level": 35,
				"luck": 60,
				"magicDefense": 5,
				"physicDefense": 350,
				"attackDmg": 600,
				"magicDmg": 1.5,
				"hp": 20000,
				"exp": 7000,
				"gold": 1500,
				"idle": "龙王idle",
				 "monsterMagicList": [
					magics.get("双龙戏珠"),
				],
				})				
				
				},					
	"黑蝠":{
		"黑蝠": Monster.new({
				"name": "黑蝠",
				"speed": 300,
				"level": 40,
				"magicDefense": 500,
				"physicDefense": 350,
				"attackDmg": 800,
				"magicDmg": 400,
				"luck": 50,
				"hp": 40000,
				"exp": 20000,
				"posi": "middle",
				"gold": 7000,
				"idle": "黑蝠idle",
				 "monsterMagicList": [
					magics.get("魔音侵袭"),
				],
				}),
			},
	"逆无邪":{
		"逆无邪": Monster.new({
				"name": "逆无邪",
				"speed": 200,
				"level": 40,
				"magicDefense": 100,
				"physicDefense": 150,
				"attackDmg": 600,
				"magicDmg": 4,
				"posi": "middle",
				"luck": 50,
				"hp": 9000,
				"exp": 2000,
				"gold": 1500,
				"idle": "逆无邪idle",
				 "monsterMagicList": [

				],
				}),
			},
	"珍珠姐妹":{
		"珍珠姐妹": Monster.new({
				"name": "珍珠姐妹",
				"speed": 250,
				"level": 40,
				"magicDefense": 100,
				"physicDefense": 150,
				"attackDmg": 1000,
				"magicDmg": 400,
				"luck": 50,
				"hp": 30000,
				"exp": 20000,
				"posi": "middle",
				"gold": 6000,
				"idle": "珍珠姐妹idle",
				 "monsterMagicList": [
					magics.get("双生碧击")
				],
				"autoAttackSound": "res://Audio/SE/蝴蝶女.ogg"
				}),
			},			
	"海底迷宫1":{
		"虾兵": Monster.new({
			"name": "虾兵",
			"speed": 120,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 205,
			"luck": 10,
			"magicDmg": 8,
			"hp": 1800,
			"exp": 200,
			"gold": 100,
			"idle": "虾兵idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"蟹将": Monster.new({
			"name": "蟹将",
			"speed": 130,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 255,
			"magicDmg": 8,
			"hp": 2000,
			"exp": 250,
			"gold": 100,
			"idle": "蟹将idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			"autoAttackSound": "res://Audio/SE/敲击.ogg"
			}),
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 140,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 200,
			"magicDmg": 6,
			"hp": 1500,
			"exp": 200,
			"gold": 10,
			"luck": 10,
			"idle": "海毛虫idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
			}),
		"巨蛙": Monster.new({
			"name": "巨蛙",
			"speed": 150,
			"level": 40,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 240,
			"magicDmg": 10,
			"hp": 2200,
			"exp": 300,
			"gold": 1000,
			"luck": 10,
			"idle": "巨蛙idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
				magics.get("水攻"),
			],
			}),				
			},

															
	"龟丞相":{
		"龟丞相": Monster.new({
			"name": "龟丞相",
			"speed": 220,
			"level": 40,
			"magicDefense": 1100,
			"physicDefense": 1100,
			"attackDmg": 500,
			"luck": 10,
			"magicDmg": 700,
			"hp": 20000,
			"posi": "middle",
			"exp": 30000,
			"gold": 8000,
			"idle": "龟丞相idle",
			 "monsterMagicList": [
				magics.get("水漫金山"),
			],
				"autoAttackSound": "res://Audio/SE/逗乐.ogg"
			}),		
		},
		
		
	"花果山":{
		"老虎精": Monster.new({
			"name": "老虎精",
			"speed": 200,
			"level": 40,
			"magicDefense": 100,
			"physicDefense": 100,
			"attackDmg": 1000,
			"luck": 10,
			"magicDmg": 200,
			"hp": 5000,
			"exp": 1100,
			"gold": 200,
			"idle": "老虎精idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			}),		
		"黑蝠": Monster.new({
				"name": "黑蝠",
				"speed": 190,
				"level": 40,
				"magicDefense": 0,
				"physicDefense": 0,
				"attackDmg": 100,
				"magicDmg": 200,
				"luck": 10,
				"hp": 4800,
				"exp": 900,
				"gold": 180,
				"idle": "黑蝠idle",
				 "monsterMagicList": [
					magics.get("魔音侵袭"),
				],
				}),			
			
			
		},		
	"双大鹏":{
		"强壮大鹏": Monster.new({
			"name": "大鹏",
			"speed": 240,
			"level": 40,
			"magicDefense": 100,
			"physicDefense": 100,
			"attackDmg": 300,
			"luck": 40,
			"magicDmg": 350,
			"hp": 15000,
			"exp": 10000,
			"gold": 7000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			}),		
		"强壮大鹏2": Monster.new({
			"name": "大鹏",
			"speed": 240,
			"level": 40,
			"magicDefense": 100,
			"physicDefense": 100,
			"attackDmg": 300,
			"luck": 40,
			"magicDmg": 350,
			"hp": 15000,
			"exp": 10000,
			"gold": 6000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			}),	
		},			
	"双黑蝠":{
		"黑蝠": Monster.new({
				"name": "黑蝠",
				"speed": 220,
				"level": 40,
				"magicDefense": 0,
				"physicDefense": 0,
				"attackDmg": 500,
				"magicDmg": 280,
				"luck": 50,
				"hp": 28000,
				"exp": 20000,
				"gold": 8000,
				"idle": "黑蝠idle",
				 "monsterMagicList": [
					magics.get("魔音侵袭"),
				],
				}),
		"黑蝠2": Monster.new({
				"name": "黑蝠",
				"speed": 220,
				"level": 40,
				"magicDefense": 0,
				"physicDefense": 0,
				"attackDmg": 500,
				"magicDmg": 280,
				"luck": 50,
				"hp": 28000,
				"exp": 20000,
				"gold": 8000,
				"idle": "黑蝠idle",
				 "monsterMagicList": [
					magics.get("魔音侵袭"),
				],
				}),				
				
				
			},
	"兔子精":{
		"兔子精":Monster.new({
			"name": "兔子精",
			"speed": 500,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 330,
			"magicDmg": 180,
			"hp": 20000,
			"luck": 50,
			"exp": 10000,
			"posi": "middle",
			"gold": 6000,
			"idle": "兔子精idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			}),	
			},
	"蛤蟆精":{
		"蛤蟆精":Monster.new({
			"name": "蛤蟆精",
			"speed": 260,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 1000,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 30000,
			"luck": 50,
			"exp": 20000,
			"gold": 6000,
			"idle": "蛤蟆精idle",
			"type": "",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
			}),	
			},			
	"奔霸2":{
		"奔霸": Monster.new({
			"name": "奔霸",
			"speed": 190,
			"level": 40,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 1100,
			"magicDmg": 360,
			"hp": 60000,
			"posi": "middle",
			"exp": 50000,
			"gold": 5000,
			"idle": "奔霸idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
				"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),
			},
	"奔霸3":{
		"奔霸": Monster.new({
			"name": "奔霸",
			"speed": 220,
			"level": 40,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 1200,
			"posi": "middle",
			"magicDmg": 410,
			"hp": 100000,
			"exp": 60000,
			"gold": 10000,
			"idle": "奔霸idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
				"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),
			},					
	"奔霸4":{
		"奔霸": Monster.new({
			"name": "奔霸",
			"speed": 30,
			"level": 40,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 400,
			"hp": 2,
			"exp": 100,
			"gold": 100,
			"idle": "奔霸idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
			}),
			},		
			
			
			
	"怨蛛":{
		"怨蛛": Monster.new({
			"name": "怨蛛",
			"speed": 220,
			"level": 50,
			"magicDefense": 0,
			"physicDefense": 350,
			"attackDmg": 800,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 30000,
			"exp": 60000,
			"gold": 5500,
			"idle": "怨蛛idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/妖攻击-诡异.ogg"
			
			}),
			},		
	"野鬼":{
			"野鬼": Monster.new({
			"name": "野鬼",
			"speed": 170,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 5000,
			"exp": 16000,
			"gold": 4000,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),
			"野鬼2": Monster.new({
			"name": "野鬼",
			"speed": 170,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 5000,
			"exp": 16000,
			"gold": 4000,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),			
		"野鬼3":Monster.new({
			"name": "野鬼",
			"speed": 170,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 5000,
			"exp": 16000,
			"gold": 4000,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),		
	}	,	
	"冥鸟":{
		"魔鸟": Monster.new({
			"name": "魔鸟",
			"speed": 230,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 350,
			"hp": 32000,
			"exp": 50000,
			"gold": 8050,
			"type": "鬼",
			"idle": "魔鸟idle",
			 "monsterMagicList": [
				magics.get("追云锁")
			],
				"autoAttackSound": "res://Audio/SE/雷鸟人.ogg"
			}),			
			},					
						
	"初鬼":{
		"野鬼": Monster.new({
			"name": "野鬼",
			"speed": 210,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 2200,
			"exp": 700,
			"gold": 550,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),
		"野鬼1": Monster.new({
			"name": "野鬼",
			"speed": 210,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 2200,
			"exp": 700,
			"gold": 550,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),	
		"野鬼2": Monster.new({
			"name": "野鬼",
			"speed": 210,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 600,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 2200,
			"exp": 700,
			"gold": 550,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),		
		"骷髅": Monster.new({
			"name": "骷髅",
			"speed": 200,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 650,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 2300,
			"exp": 700,
			"gold": 600,
			"type": "鬼",
			"idle": "骷髅idle",
			 "monsterMagicList": [
			],
			}),
						
			
			
			
			},					
	"地府迷宫1":{
		"野鬼": Monster.new({
			"name": "野鬼",
			"speed": 160,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 500,
			"posi": "middle",
			"magicDmg": 280,
			"hp": 5000,
			"exp": 6000,
			"gold": 1450,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
				magics.get("死亡召唤"),
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),
		"骷髅": Monster.new({
			"name": "骷髅",
			"speed": 170,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 400,
			"posi": "middle",
			"magicDmg": 280,
			"hp": 5500,
			"exp": 7000,
			"gold": 1500,
			"type": "鬼",
			"idle": "骷髅idle",
			 "monsterMagicList": [
				magics.get("立墓"),
			],
				"autoAttackSound": "res://Audio/SE/怪突击.ogg"
			}),		"马面": Monster.new({
			"name": "马面",
			"speed": 180,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 255,
			"posi": "middle",
			"magicDmg": 300,
			"hp": 4000,
			"exp": 6000,
			"gold": 2000,
			"type": "鬼",
			"idle": "马面idle",
			 "monsterMagicList": [
				magics.get("魔音侵袭"),
			],
				"autoAttackSound": "res://Audio/SE/马面-攻击.ogg"
			}),					
		"牛头": Monster.new({
			"name": "牛头",
			"speed": 180,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 405,
			"posi": "middle",
			"magicDmg": 3.3,
			"hp": 15000,
			"exp": 7000,
			"gold": 2000,
			"type": "鬼",
			"idle": "牛头idle",
			 "monsterMagicList": [
				
			],
				"autoAttackSound": "res://Audio/SE/牛叫.ogg"
			}),		
			},					

	
	
	"机关兽":{
		"机关兽": Monster.new({
			"name": "机关兽",
			"speed": 50,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 40,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 80000,
			"exp": 100,
			"gold": 100,
			"type": "",
			"idle": "机关兽idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/猛兽.ogg"
			}),
			},				
	"鬼将军":{
		"怨蛛1": Monster.new({
			"name": "怨蛛",
			"speed": 150,
			"level": 50,
			"magicDefense": 0,
			"physicDefense": 350,
			"attackDmg": 400,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 20000,
			"exp": 60000,
			"gold": 5500,
			"idle": "怨蛛idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/妖攻击-诡异.ogg"
			
			}),
		"鬼将军": Monster.new({
			"name": "鬼将军",
			"speed": 260,
			"level": 50,
			"magicDefense": 0,
			"physicDefense": 600,
			"attackDmg": 750,
			"magicDmg": 200,
			"posi": "middle",
			"hp": 70000,
			"exp": 150000,
			"gold": 30000,
			"type": "鬼",
			"idle": "鬼将军idle",
			 "monsterMagicList": [
				magics.get("血傀"),				
			],
				"autoAttackSound": "res://Audio/SE/虎锤.ogg"
			}),
		"怨蛛": Monster.new({
			"name": "怨蛛",
			"speed": 150,
			"level": 50,
			"magicDefense": 0,
			"physicDefense": 350,
			"attackDmg": 400,
			"posi": "middle",
			"magicDmg": 3,
			"hp": 20000,
			"exp": 60000,
			"gold": 5500,
			"idle": "怨蛛idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/妖攻击-诡异.ogg"
			
			}),			
			
			
			
			},		
	"僵尸王":{
		"僵尸": Monster.new({
			"name": "僵尸",
			"speed": 300,
			"level": 50,
			"magicDefense":600,
			"physicDefense": 500,
			"attackDmg": 950,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 25000,
			"exp": 50000,
			"gold": 8000,
			"type": "鬼",
			"idle": "僵尸idle",
			 "monsterMagicList": [
				
			],
			}),
			},				
			
	"鬼司":{
		"野鬼1": Monster.new({
			"name": "野鬼",
			"speed": 160,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 500,
			"posi": "middle",
			"magicDmg": 250,
			"hp": 5000,
			"exp": 6000,
			"gold": 1450,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
				magics.get("死亡召唤"),
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),	
		"鬼司": Monster.new({
			"name": "鬼司",
			"speed": 230,
			"level": 50,
			"magicDefense":600,
			"physicDefense": 500,
			"attackDmg": 850,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 19000,
			"exp": 50000,
			"gold": 8000,
			"type": "鬼",
			"idle": "鬼司idle",
			 "monsterMagicList": [
				
			],
			}),		
		"野鬼": Monster.new({
			"name": "野鬼",
			"speed": 160,
			"level": 50,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 500,
			"posi": "middle",
			"magicDmg": 250,
			"hp": 5000,
			"exp": 6000,
			"gold": 1450,
			"type": "鬼",
			"idle": "野鬼idle",
			 "monsterMagicList": [
				magics.get("死亡召唤"),
			],
				"autoAttackSound": "res://Audio/SE/野鬼.ogg"
			}),			
			
			},			
			
			
			
	"骷刹":{
		"骷刹": Monster.new({
			"name": "骷刹",
			"speed": 350,
			"level": 1,
			"magicDefense":600,
			"physicDefense": 500,
			"attackDmg": 1850,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 100000,
			"exp": 14000,
			"gold": 8000,
			"type": "鬼",
			"idle": "骷刹idle",
			 "monsterMagicList": [
				
			],
			}),
			},					
			
	"噬天虎":{
		"噬天虎": Monster.new({
			"name": "噬天虎",
			"speed": 260,
			"level": 50,
			"magicDefense":300,
			"physicDefense": 300,
			"attackDmg": 1050,
			"magicDmg": 40,
			"posi": "middle",
			"hp": 35000,
			"exp": 50000,
			"gold": 1000,
			"type": "",
			"idle": "噬天虎idle",
			 "monsterMagicList": [
				
			],
				"autoAttackSound": "res://Audio/SE/野兽-攻击X.ogg"
			
			}),
			},					
	"大唐国境边缘":{
		"野猪": Monster.new({
			"name": "野猪",
			"speed": 160,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 405,
			"luck": 10,
			"magicDmg": 200,
			"hp": 5000,
			"exp": 5500,
			"gold": 2100,
			"idle": "野猪idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
				"autoAttackSound": "res://Audio/SE/野猪.ogg"
			}),
		"蝶妖": Monster.new({
			"name": "蝶妖",
			"speed": 160,
			"level": 40,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 255,
			"magicDmg": 208,
			"hp": 4000,
			"exp": 5080,
			"gold": 2800,
			"idle": "蝶妖idle",
			 "monsterMagicList": [
				magics.get("毒粉尘"),
			],
				"autoAttackSound": "res://Audio/SE/打击1.ogg"
			}),
			},						
	"大唐境外":{
		"野猪": Monster.new({
			"name": "野猪",
			"speed": 160,
			"level": 50,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 505,
			"luck": 10,
			"magicDmg": 200,
			"hp": 7000,
			"exp": 17000,
			"gold": 5000,
			"idle": "野猪idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
				"autoAttackSound": "res://Audio/SE/野猪.ogg"
			
			}),
		"蝶妖": Monster.new({
			"name": "蝶妖",
			"speed": 160,
			"level": 50,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 455,
			"magicDmg": 308,
			"hp": 6000,
			"exp": 18080,
			"gold": 4000,
			"idle": "蝶妖idle",
			 "monsterMagicList": [
				magics.get("毒粉尘"),
			],
				"autoAttackSound": "res://Audio/SE/打击1.ogg"
			}),
		"巨石怪": Monster.new({
			"name": "巨石怪",
			"speed": 150,
			"level": 50,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 425,
			"magicDmg": 150,
			"hp": 10000,
			"exp": 30080,
			"gold": 8000,
			"idle": "巨石怪idle",
			 "monsterMagicList": [
				magics.get("天火陨石")
			],
				"autoAttackSound": "res://Audio/SE/怪-震地.ogg"		
			}),			
			},						
	"大唐境外南":{
		"野猪": Monster.new({
			"name": "野猪",
			"speed": 160,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"attackDmg": 405,
			"luck": 10,
			"magicDmg": 200,
			"hp": 5000,
			"exp": 17000,
			"gold": 5000,
			"idle": "野猪idle",
			 "monsterMagicList": [
				magics.get("落岩"),
			],
				"autoAttackSound": "res://Audio/SE/野猪.ogg"
			
			}),
		"蝶妖": Monster.new({
			"name": "蝶妖",
			"speed": 160,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 255,
			"magicDmg": 208,
			"hp": 4000,
			"exp": 17080,
			"gold": 4000,
			"idle": "蝶妖idle",
			 "monsterMagicList": [
				magics.get("毒粉尘"),
			],
				"autoAttackSound": "res://Audio/SE/打击1.ogg"
			}),
		"巨石怪": Monster.new({
			"name": "巨石怪",
			"speed": 150,
			"level": 1,
			"magicDefense": 5,
			"physicDefense": 20,
			"luck": 10,
			"attackDmg": 325,
			"magicDmg": 150,
			"hp": 30000,
			"exp": 25080,
			"gold": 6000,
			"idle": "巨石怪idle",
			 "monsterMagicList": [
				magics.get("天火陨石")
			],
				"autoAttackSound": "res://Audio/SE/怪-震地.ogg"		
			}),			
			},	
	"青面兽":{
		"青面兽": Monster.new({
			"name": "青面兽",
			"speed": 340,
			"level": 50,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 2000,
			"magicDmg": 480,
			"posi": "middle",
			"hp": 140000,
			"exp": 180000,
			"gold": 40000,
			"idle": "青面兽idle",
			 "monsterMagicList": [
				magics.get("狮子吼"),
			],
				"autoAttackSound": "res://Audio/SE/猛男-刀2.ogg"
			
			}),
			},			
	"白虎":{
		"白虎": Monster.new({
			"name": "白虎",
			"speed": 340,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2600,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 80000,
			"exp": 100000,
			"gold": 30000,
			"idle": "白虎idle",
			 "monsterMagicList": [
				
			],
				"autoAttackSound": "res://Audio/SE/虎-锤.ogg"
			
			
			}),
			},	
	"北俱芦洲":{
		"白熊": Monster.new({
			"name": "白熊",
			"speed": 180,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 800,
			"magicDmg": 100,
			"posi": "middle",
			"hp": 5800,
			"exp": 18000,
			"gold": 7100,
			"idle": "白熊idle",
			 "monsterMagicList": [
				magics.get("水满金山")
			],
				"autoAttackSound": "res://Audio/SE/103-Attack15.ogg"
			}),	
			
			},				
	"凤巢1":{
		"凤凰": Monster.new({
			"name": "凤凰",
			"speed": 200,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 400,
			"magicDmg": 230,
			"posi": "middle",
			"hp": 20000,
			"exp": 25000,
			"gold": 4100,
			"idle": "凤凰idle",
			 "monsterMagicList": [
				magics.get("地裂火"),
			],
				"autoAttackSound": "res://Audio/SE/鸟叫.ogg"
			}),
		"蝶妖": Monster.new({
			"name": "蝶妖",
			"speed": 225,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg":350,
			"magicDmg": 350,
			"posi": "middle",
			"hp": 5000,
			"exp": 18000,
			"gold": 4100,
			"idle": "蝶妖idle",
			 "monsterMagicList": [
				magics.get("毒粉尘"),
			],
				"autoAttackSound": "res://Audio/SE/打击1.ogg"
			}),					
			
			},	

	"红鸟":{
		"大鹏": Monster.new({
			"name": "大鹏",
			"speed": 280,
			"level": 60,
			"magicDefense": 300,
			"physicDefense": 400,
			"attackDmg": 1750,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 60000,
			"exp": 55000,
			"gold": 15000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
				"autoAttackSound": "res://Audio/SE/雷鸟人.ogg"
			}),		
			},			
	"百足虫":{
		"百足虫": Monster.new({
			"name": "百足虫",
			"speed": 280,
			"level": 60,
			"magicDefense": 500,
			"physicDefense": 500,
			"attackDmg": 1900,
			"magicDmg": 700,
			"posi": "middle",
			"hp": 66500,
			"exp": 60000,
			"gold": 20100,
			"idle": "百足虫idle",
			 "monsterMagicList": [
				magics.get("死亡召唤"),
			],
				"autoAttackSound": "res://Audio/SE/099-Attack11.ogg"
			}),		
			},		
	"龙窟1":{
#		"蛟龙": Monster.new({
#			"name": "蛟龙",
#			"speed": 190,
#			"level": 1,
#			"magicDefense": 200,
#			"physicDefense": 200,
#			"attackDmg": 650,
#			"magicDmg": 300,
#			"posi": "middle",
#			"hp": 23000,
#			"exp": 40000,
#			"type": "龙",
#			"gold": 5100,
#			"idle": "蛟龙idle",
#			 "monsterMagicList": [
#				magics.get("水炮"),
#			],
#			}),
		"麒麟": Monster.new({
			"name": "麒麟",
			"speed": 170,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 750,
			"magicDmg": 250,
			"posi": "middle",
			"hp": 20000,
			"exp": 42000,
			"type": "龙",
			"gold": 6000,
			"idle": "麒麟idle",
			 "monsterMagicList": [
				magics.get("龙哮"),
			],
				"autoAttackSound": "res://Audio/SE/082-Monster04.ogg"
			}),			
		"修罗": Monster.new({
			"name": "修罗",
			"speed": 140,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 1200,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 5000,
			"exp": 38100,
			"gold": 6000,
			"idle": "修罗idle",
			 "monsterMagicList": [

			],
				"autoAttackSound": "res://Audio/SE/090-Attack02.ogg"
			}),			
			
			},	
	
																		
	"青龙":{
		"青龙": Monster.new({
			"name": "青龙",
			"speed": 425,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 3450,
			"magicDmg": 570,
			"posi": "middle",
			"hp": 200000,
			"exp": 450000,
			"gold": 30100,
			"type": "龙",
			"idle": "青龙idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("龙怒"),
				magics.get("雷龙腾"),
			],
			}),
			},
	"人形青龙":{
		"人形青龙": Monster.new({
			"name": "人形青龙",
			"speed": 320,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 2500,
			"magicDmg": 450,
			"posi": "middle",
			"hp": 80000,
			"exp": 300000,
			"gold": 20000,
			"type": "龙",
			"idle": "人形青龙idle",
			 "monsterMagicList": [
				magics.get("龙怒"),
			],		
			"autoAttackSound":"res://Audio/SE/051-Explosion04.ogg",
			}),
			},		
			
			
			
			
	"镰魔":{
		"镰魔": Monster.new({
			"name": "镰魔",
			"speed": 800,
			"level": 1,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 100000,
			"exp": 40000000,
			"gold": 20000,
			"type": "魔",
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			}),
			},				
	"关重七伤势":{
		"关重七伤势": Monster.new({
			"name": "关重七伤势",
			"speed": 200,
			"level": 60,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 1400,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 20000,
			"exp": 500,
			"gold": 0,
			"type": "",
			"idle": "关重七伤势idle",
			 "monsterMagicList": [
			],
			}),
			},				
	"瑞兽":{
		"瑞兽": Monster.new({
			"name": "瑞兽",
			"speed": 330,
			"level": 60,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2800,
			"magicDmg": 800,
			"posi": "middle",
			"hp": 10000,
			"exp": 190000,
			"gold": 20000,
			"type": "龙",
			"idle": "瑞兽idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("龙哮"),
			
			],
			}),
			},			
	"人参果虫":{
		"海毛虫": Monster.new({
			"name": "海毛虫",
			"speed": 220,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 100,
			"magicDmg": 250,
			"posi": "middle",
			"hp": 170000,
			"exp": 100,
			"gold": 100,
			"type": "龙",
			"idle": "海毛虫idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("落岩"),
			
			],
			}),
		"海毛虫2": Monster.new({
			"name": "海毛虫",
			"speed": 220,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 100,
			"magicDmg": 250,
			"posi": "middle",
			"hp": 170000,
			"exp": 70100,
			"gold": 20100,
			"type": "龙",
			"idle": "海毛虫idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("落岩"),
			
			],
			}),
		"海毛虫3": Monster.new({
			"name": "海毛虫",
			"speed": 220,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 100,
			"magicDmg": 250,
			"posi": "middle",
			"hp": 170000,
			"exp": 70000,
			"gold": 20100,
			"type": "龙",
			"idle": "海毛虫idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("落岩"),
			
			],
			}),
		"海毛虫4": Monster.new({
			"name": "海毛虫",
			"speed": 220,
			"level": 60,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 100,
			"magicDmg": 250,
			"posi": "middle",
			"hp": 170000,
			"exp": 70000,
			"gold": 20100,
			"type": "龙",
			"idle": "海毛虫idle",
			"autoAttackSound":"res://Audio/SE/085-Monster07.ogg",
			 "monsterMagicList": [
				magics.get("落岩"),	
			],
			}),								
			
			},				
					
	"金翅大鹏":{
		"金翅大鹏": Monster.new({
			"name": "金翅大鹏",
			"speed": 600,
			"level": 65,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 2310,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 80000,
			"exp": 450100,
			"gold": 20100,
			"idle": "金翅大鹏idle",
			 "monsterMagicList": [
				magics.get("大台风"),
			],
				"autoAttackSound": "res://Audio/SE/132-Wind01.ogg"
			
			}),
			},				
	"怪僧":{
		"怪僧": Monster.new({
			"name": "怪僧",
			"speed": 400,
			"level": 65,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 2000,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 80000,
			"exp": 300100,
			"gold": 20000,
			"idle": "怪僧idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
				"autoAttackSound": "res://Audio/SE/103-Attack15.ogg"
			}),
			},					
	"罗非":{
		"罗非": Monster.new({
			"name": "罗非",
			"speed": 550,
			"level": 65,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 1800,
			"magicDmg": 320,
			"posi": "middle",
			"hp": 70000,
			"exp": 100000,
			"gold": 30000,
			"idle": "罗非idle",
			 "monsterMagicList": [
				magics.get("龙啸九天"),
			],
			"autoAttackSound": "res://Audio/SE/逍遥生攻击剑.ogg"
			}),
			},
	"小西天":{
		"沙狸": Monster.new({
			"name": "沙狸",
			"speed": 300,
			"level": 65,
			"magicDefense": 600,
			"physicDefense": 0,
			"attackDmg": 1300,
			"magicDmg": 320,
			"posi": "middle",
			"hp": 10000,
			"exp": 120000,
			"gold": 9000,
			"idle": "沙狸idle",
			 "monsterMagicList": [
				magics.get("飞沙走石"),
			],
			"autoAttackSound": "res://Audio/SE/怪-施法.ogg"
			}),
		"沙虫": Monster.new({
			"name": "沙虫",
			"speed": 280,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 600,
			"attackDmg": 1300,
			"magicDmg": 330,
			"posi": "middle",
			"hp": 14000,
			"exp": 130000,
			"gold": 10000,
			"idle": "沙虫idle",
			 "monsterMagicList": [
				magics.get("飞沙走石"),
			],
			"autoAttackSound": "res://Audio/SE/怪-施法.ogg"
			}),			
			},
	"沙暴":{
		"沙暴": Monster.new({
			"name": "沙暴",
			"speed": 600,
			"level": 65,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 2000,
			"magicDmg": 500,
			"posi": "middle",
			"hp": 130000,
			"exp": 1000100,
			"gold": 30100,
			"idle": "沙暴idle",
			 "monsterMagicList": [
				magics.get("飞沙走石"),
				
			],
			"autoAttackSound": "res://Audio/SE/怪-施法.ogg"
			}),
			},			
			
	"弥勒佛":{
		"弥勒佛": Monster.new({
			"name": "弥勒佛",
			"speed": 540,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 3300,
			"magicDmg": 1000,
			"posi": "middle",
			"hp": 180000,
			"exp": 5000000,
			"gold": 60100,
			"idle": "弥勒佛idle",
			 "monsterMagicList": [
				magics.get("佛掌"),
			],
			"autoAttackSound": "res://Audio/SE/猛男-刀2.ogg"
			}),
			},
	"蝎霸王":{
		"蝎霸王": Monster.new({
			"name": "蝎霸王",
			"speed": 700,
			"level": 65,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 5000,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 120000,
			"exp": 3000000,
			"gold": 30100,
			"idle": "蝎霸王idle",
			 "monsterMagicList": [
			
			],
			"autoAttackSound": "res://Audio/SE/092-Attack04.ogg"
			}),
			},			
	"长寿郊外":{
		"蛤蟆精": Monster.new({
			"name": "蛤蟆精",
			"speed": 300,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 3500,
			"magicDmg": 700,
			"posi": "middle",
			"hp": 12000,
			"exp": 1000000,
			"gold": 20100,
			"idle": "蛤蟆精idle",
			 "monsterMagicList": [
				magics.get("水满金山")
			],
				"autoAttackSound": "res://Audio/SE/065-Swing04.ogg"
			}),					
			},			


	"幻境1":{
		"雾中妖": Monster.new({
			"name": "雾中妖",
			"speed": 300,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 1900,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 16000,
			"exp": 1000000,
			"gold": 10100,
			"idle": "雾中妖idle",
			 "monsterMagicList": [
				magics.get("雾中花")
			],
				"autoAttackSound": "res://Audio/SE/女妖猛击.ogg"
			}),					
			},			
	"女娲神迹":{
		"灵鹤": Monster.new({
			"name": "灵鹤",
			"speed": 160,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 1900,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 19000,
			"exp": 1100000,
			"gold": 12100,
			"idle": "灵鹤idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
				"autoAttackSound": "res://Audio/SE/鸟X.ogg"
			}),
		"绿萼": Monster.new({
			"name": "绿萼",
			"speed": 150,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 1300,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 15000,
			"exp": 1000000,
			"gold": 13100,
			"idle": "绿萼idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
				"autoAttackSound": "res://Audio/SE/女-中性.ogg"
			}),			
			
			
			},
	"妖盟":{
		"野猪王": Monster.new({
			"name": "野猪王",
			"speed": 250,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 5000,
			"magicDmg": 100,
			"posi": "middle",
			"hp": 16000,
			"exp": 1200100,
			"gold": 20000,
			"idle": "野猪王idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野猪.ogg"
			}),
		"鹰孽": Monster.new({
			"name": "鹰孽大王",
			"speed": 320,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 1800,
			"magicDmg": 300,
			"posi": "middle",
			"hp": 20000,
			"exp": 1300000,
			"gold": 20100,
			"idle": "鹰孽大王idle",
			 "monsterMagicList": [
				magics.get("天火陨石"),
			],
			"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),			
		"大鹏": Monster.new({
			"name": "大鹏",
			"speed": 700,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2000,
			"magicDmg": 300,
			"posi": "middle",
			"hp": 15000,
			"exp": 120000,
			"gold": 10000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			"autoAttackSound": "res://Audio/SE/雷鸟人.ogg"
			}),					
		"堕逝": Monster.new({
			"name": "堕逝",
			"speed": 500,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2500,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 16000,
			"exp": 1300100,
			"gold": 100,
			"idle": "堕逝idle",
			 "monsterMagicList": [
				magics.get("风雨雷电"),
			],
			"autoAttackSound": "res://Audio/SE/103-Attack15.ogg"
			}),				
			},			
	"夜护法":{
		"野猪王": Monster.new({
			"name": "野猪王",
			"speed": 250,
			"level": 65,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 5000,
			"magicDmg": 100,
			"posi": "middle",
			"hp": 16000,
			"exp": 800100,
			"gold": 20000,
			"idle": "野猪王idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/野猪.ogg"
			}),
		"鹰孽": Monster.new({
			"name": "鹰孽大王",
			"speed": 320,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 1800,
			"magicDmg": 300,
			"posi": "middle",
			"hp": 20000,
			"exp": 900000,
			"gold": 20100,
			"idle": "鹰孽大王idle",
			 "monsterMagicList": [
				magics.get("天火陨石"),
			],
			"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),			
		"大鹏": Monster.new({
			"name": "大鹏",
			"speed": 700,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2000,
			"magicDmg": 300,
			"posi": "middle",
			"hp": 15000,
			"exp": 800000,
			"gold": 10000,
			"idle": "大鹏idle",
			 "monsterMagicList": [
				magics.get("奔雷"),
			],
			"autoAttackSound": "res://Audio/SE/雷鸟人.ogg"
			}),					
		"堕逝": Monster.new({
			"name": "堕逝",
			"speed": 500,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2500,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 16000,
			"exp": 900100,
			"gold": 100,
			"idle": "堕逝idle",
			 "monsterMagicList": [
				magics.get("风雨雷电"),
			],
			"autoAttackSound": "res://Audio/SE/103-Attack15.ogg"
			}),								
		"夜护法": Monster.new({
				"name": "夜护法",
				"speed": 580,
				"level": 65,
				"magicDefense": 0,
				"physicDefense": 0,
				"attackDmg": 4500,
				"magicDmg": 700,
				"posi": "middle",
				"hp": 130000,
				"exp": 1300000,
				"gold": 100100,
				"idle": "夜护法idle",
				 "monsterMagicList": [
					magics.get("追云锁"),
				],
				"autoAttackSound": "res://Audio/SE/女-发威2.ogg"
				}),				
					
			},					
								
	"鬼帝":{
		"鬼帝": Monster.new({
			"name": "鬼帝",
			"speed": 650,
			"level": 75,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 5000,
			"magicDmg": 900,
			"posi": "middle",
			"hp": 400000,
			"exp": 30000000,
			"gold": 150000,
			"type": "鬼",
			"idle": "鬼帝idle",
			 "monsterMagicList": [
				magics.get("血傀"),
			],
			"autoAttackSound": "res://Audio/SE/050-Explosion03.ogg"
			}),
			},					
	"创界山":{
		"牛魔": Monster.new({
			"name": "牛魔",
			"speed": 300,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2800,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 20000,
			"exp": 1500100,
			"gold": 30100,
			"type": "魔",
			"idle": "牛魔idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],			
			"autoAttackSound": "res://Audio/SE/牛叫.ogg"
			}),
		"贪念魔": Monster.new({
			"name": "贪念魔",
			"speed": 310,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2600,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 15000,
			"exp": 1600000,
			"gold": 30100,
			"type": "魔",
			"idle": "贪念魔idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
				"autoAttackSound": "res://Audio/SE/女法术Y.ogg"
			}),			
		"嗔念魔": Monster.new({
			"name": "嗔念魔",
			"speed": 320,
			"level": 65,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 1900,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 30000,
			"exp": 2000000,
			"gold": 40100,
			"type": "魔",
			"idle": "嗔念魔idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/女妖猛击.ogg"
			}),		
			},				
			
	"黑龙王":{
		"黑龙王": Monster.new({
			"name": "黑龙王",
			"speed": 200,
			"level": 75,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 200,
			"magicDmg": 200,
			"posi": "middle",
			"hp": 130000,
			"exp": 10000,
			"gold": 10000,
			"idle": "黑龙王idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
			}),		
			},	
	"炼狱迷宫1":{
		"牛魔": Monster.new({
			"name": "牛魔",
			"speed": 300,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2800,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 20000,
			"exp": 1500100,
			"gold": 30100,
			"type": "魔",
			"idle": "牛魔idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],			
			"autoAttackSound": "res://Audio/SE/牛叫.ogg"
			}),
		"贪念魔": Monster.new({
			"name": "贪念魔",
			"speed": 310,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2600,
			"magicDmg": 400,
			"posi": "middle",
			"hp": 15000,
			"exp": 1600000,
			"gold": 30100,
			"type": "魔",
			"idle": "贪念魔idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
				"autoAttackSound": "res://Audio/SE/女法术Y.ogg"
			}),			
		"嗔念魔": Monster.new({
			"name": "嗔念魔",
			"speed": 320,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 1900,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 30000,
			"exp": 2000000,
			"gold": 40100,
			"type": "魔",
			"idle": "嗔念魔idle",
			 "monsterMagicList": [
			],
				"autoAttackSound": "res://Audio/SE/女妖猛击.ogg"
			}),	
		"痴念魔": Monster.new({
			"name": "痴念魔",
			"speed": 300,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 0,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 28000,
			"exp": 1500000,
			"gold": 50000,
			"type": "魔",
			"idle": "痴念魔idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
			}),				
									
			},	
								
	"魔刹":{
		"魔刹": Monster.new({
			"name": "魔刹",
			"speed": 550,
			"level": 75,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 12999,
			"magicDmg": 300,
			"posi": "middle",
			"hp": 160000,
			"exp": 45000000,
			"gold": 100000,
			"type": "魔",
			"idle": "魔刹idle",
			 "monsterMagicList": [
				magics.get("追云锁"),
			],
				"autoAttackSound": "res://Audio/SE/物理法术-妖女.ogg"
			}),		
			},	
	"魔画":{
		"魔画": Monster.new({
			"name": "魔画",
			"speed": 500,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 1200,
			"posi": "middle",
			"hp": 150000,
			"exp": 45000000,
			"gold": 100000,
			"type": "魔",
			"idle": "魔画idle",
			 "monsterMagicList": [
				magics.get("漫天花雨"),
			],
			}),		
			},				
	"魔狐":{
		"魔狐": Monster.new({
			"name": "魔狐",
			"speed": 510,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7200,
			"magicDmg": 2000,
			"posi": "middle",
			"hp": 155000,
			"exp": 46000000,
			"gold": 100000,
			"type": "魔",
			"idle": "魔狐idle",
			 "monsterMagicList": [
				magics.get("狐魅术"),
			],
			"autoAttackSound": "res://Audio/SE/蝴蝶女.ogg"
			}),		
			},								
	"魔阎罗":{
		"魔阎罗": Monster.new({
			"name": "魔阎罗",
			"speed": 520,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7400,
			"magicDmg": 1200,
			"posi": "middle",
			"hp": 160000,
			"exp": 47000000,
			"gold": 110000,
			"type": "魔",
			"idle": "魔阎罗idle",
			 "monsterMagicList": [
				magics.get("阎罗令"),
			],
			"autoAttackSound": "res://Audio/SE/088-Action03.ogg"
			}),		
			},	
	"魔妾":{
		"魔妾": Monster.new({
			"name": "魔妾",
			"speed": 540,
			"level": 75,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7600,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 165000,
			"exp": 49000000,
			"gold": 120000,
			"type": "魔",
			"idle": "魔妾idle",
			 "monsterMagicList": [
				magics.get("大台风"),
			],
			"autoAttackSound": "res://Audio/SE/女-鞭.ogg"			
			
			}),		
			},	
	"蛟魔王":{
		"蛟魔王": Monster.new({
			"name": "蛟魔王",
			"speed": 600,
			"level": 75,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 9000,
			"magicDmg": 1300,
			"posi": "middle",
			"hp": 170000,
			"exp": 62000000,
			"gold": 200100,
			"type": "魔",
			"idle": "蛟魔王idle",
			 "monsterMagicList": [
				magics.get("龙啸九天"),
			],
			"autoAttackSound": "res://Audio/SE/兵器.ogg"
			}),		
			},	
	"蚩尤":{
		"蚩尤": Monster.new({
			"name": "蚩尤",
			"speed": 620,
			"level": 75,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 10000,
			"magicDmg": 850,
			"posi": "middle",
			"hp": 500000,
			"exp": 100000000,
			"gold": 400000,
			"idle": "蚩尤idle",
			 "monsterMagicList": [
				magics.get("炼狱真火"),
			],
			"autoAttackSound": "res://Audio/SE/猛男攻击-气势强.ogg"
			}),		
			},				
	"六耳猕猴":{
		"六耳猕猴": Monster.new({
			"name": "六耳猕猴",
			"speed": 630,
			"level": 75,
			"magicDefense": 500,
			"physicDefense": 500,
			"attackDmg": 9500,
			"magicDmg": 800,
			"posi": "middle",
			"hp": 400000,
			"exp": 80000000,
			"gold": 250000,
			"idle": "六耳猕猴idle",
			 "monsterMagicList": [
				magics.get("三味真火"),
			],
			"autoAttackSound": "res://Audio/SE/打击4.ogg"

			}),		
			},								
	"杨戬":{
		"杨戬": Monster.new({
			"name": "杨戬",
			"speed": 580,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 9000,
			"magicDmg": 800,
			"posi": "middle",
			"hp": 300000,
			"exp": 120000000,
			"gold": 300000,
			"idle": "杨戬idle",
			 "monsterMagicList": [
				magics.get("雷龙腾"),
			],
			"autoAttackSound": "res://Audio/SE/男-枪.ogg"	
			}),		
			},	
	"魔如意":{
		"魔如意": Monster.new({
			"name": "魔如意",
			"speed": 500,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 9000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 180000,
			"exp": 100000000,
			"gold": 50000,
			"type": "魔",
			"idle": "魔如意idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
			"autoAttackSound": "res://Audio/SE/女-呀.ogg"
			}),		
			},			
									
	"魔巫":{
		"魔巫": Monster.new({
			"name": "魔巫",
			"speed": 500,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 9000,
			"magicDmg": 1300,
			"posi": "middle",
			"hp": 180000,
			"exp": 100000000,
			"gold": 50000,
			"type": "魔",
			"idle": "魔巫idle",
			 "monsterMagicList": [
				magics.get("魔光毒虫"),
			],
				"autoAttackSound": "res://Audio/SE/打击4.ogg"
			}),		
			},
	"冲天魔":{
		"冲天魔": Monster.new({
			"name": "冲天魔",
			"speed": 650,
			"level": 1,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "魔",
			"hp": 300000,
			"exp": 100000000,
			"gold": 100000,
			"idle": "冲天魔idle",
			 "monsterMagicList": [
				magics.get("狮子吼"),
			],
			"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),		
			},				
	"弑天魔":{
		"弑天魔": Monster.new({
			"name": "弑天魔",
			"speed": 650,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 3000,
			"magicDmg": 600,
			"posi": "middle",
			"hp": 300050,
			"exp": 100000000,
			"gold": 100000,
			"type": "魔",
			"idle": "弑天魔idle",
			 "monsterMagicList": [
				magics.get("炼狱真火"),
			],
			"autoAttackSound": "res://Audio/SE/法术 爆炸.ogg"
			}),		
			},		
	"炎魔神":{
		"炎魔神": Monster.new({
			"name": "炎魔神",
			"speed": 600,
			"level": 1,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 2800,
			"magicDmg": 800,
			"posi": "middle",
			"hp": 300050,
			"exp": 100000000,
			"gold": 100000,
			"type": "魔",
			"idle": "炎魔神idle",
			 "monsterMagicList": [
				magics.get("三味真火"),
			],
			"autoAttackSound": "res://Audio/SE/杀.ogg"
			}),		
			},	
	"吸血鬼组":{
		"魔画": Monster.new({
			"name": "魔画",
			"speed": 100,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 0,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 50,
			"exp": 100,
			"gold": 100,
			"type": "魔",
			"idle": "魔画idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
				magics.get("水炮"),
			],
			}),					
		"镰魔": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),				
		"镰魔1": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),			
		"镰魔2": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),			
		"镰魔3": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),			
		"镰魔4":Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),			
		"镰魔6": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),			

		},	
	"小魔头组":{
		"镰魔": Monster.new({
			"name": "镰魔",
			"speed": 200,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 50,
			"exp": 100,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			}),					
		"小魔头": Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头1":  Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头2":  Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头3":  Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头4":  Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头5": Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"小魔头6":  Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	

		},		
	"四人组":{
		"魔鸟": Monster.new({
			"name": "魔鸟",
			"speed": 360,
			"level": 85,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 6100,
			"magicDmg": 1000,
			"posi": "middle",
			"hp": 130000,
			"exp": 150000000,
			"gold": 100000,
			"idle": "魔鸟idle",
			"type": "魔",
			 "monsterMagicList": [
				magics.get("追云锁")
			],
				"autoAttackSound": "res://Audio/SE/雷鸟人.ogg"
			}),	
		"魔金刚": Monster.new({
			"name": "魔金刚",
			"speed": 400,
			"level": 85,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 6000,
			"magicDmg": 1000,
			"posi": "middle",
			"hp": 200000,
			"exp": 200000000,
			"gold": 500000,
			"type": "魔",
			"idle": "魔金刚idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
				"autoAttackSound": "res://Audio/SE/大力金刚X.ogg"
			}),	
		"鬼面": Monster.new({
			"name": "鬼面",
			"speed": 380,
			"level": 85,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 6200,
			"magicDmg": 1600,
			"posi": "middle",
			"type": "鬼",
			"hp": 170000,
			"exp": 150000000,
			"gold": 300000,
			"idle": "鬼面idle",
			 "monsterMagicList": [
				magics.get("立墓"),
			],
			"autoAttackSound": "res://Audio/SE/妖怪-哈~.ogg"
			}),	
		"雷龙": Monster.new({
			"name": "雷龙",
			"speed": 360,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5800,
			"magicDmg": 1200,
			"posi": "middle",
			"type": "龙",
			"hp": 170000,
			"exp": 160000000,
			"gold": 50000,
			"idle": "雷龙idle",
			 "monsterMagicList": [
				magics.get("雷龙吐息"),
			],
			"autoAttackSound": "res://Audio/SE/男-攻击-呀.ogg"
			}),	
		},	
	"悟空二郎神":{
			"孙悟空": Monster.new({
			"name": "孙悟空",
			"speed": 550,
			"level": 85,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 7000,
			"magicDmg": 1700,
			"posi": "middle",
			"type": "",
			"hp": 230000,
			"exp": 300000000,
			"gold": 0,
			"idle": "孙悟空idle",
			 "monsterMagicList": [
				magics.get("气爆"),
			],
				"autoAttackSound":"res://Audio/SE/打击4.ogg"
			}),
		"真陀护法": Monster.new({
			"name": "真陀护法",
			"speed": 400,
			"level": 85,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 6000,
			"magicDmg": 1400,
			"posi": "middle",
			"hp": 100000,
			"exp": 200000000,
			"gold": 0,
			"type": "魔",
			"idle": "真陀护法idle",
			 "monsterMagicList": [
				magics.get("金身出鞘"),
			],
			"autoAttackSound":"res://Audio/SE/打击2.ogg"
			}),				
		"二郎神": Monster.new({
			"name": "二郎神",
			"speed": 520,
			"level": 85,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 8000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "",
			"hp": 220000,
			"exp": 300000000,
			"gold": 0,
			"idle": "二郎神idle",
			 "monsterMagicList": [
				magics.get("矢雨"),
			],
			"autoAttackSound": "res://Audio/SE/怪突击.ogg"
			}),
	},
	"魔尊":{				
		"魔尊": Monster.new({
			"name": "魔尊",
			"speed": 600,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 9000,
			"magicDmg": 1200,
			"posi": "middle",
			"hp": 400000,
			"exp": 500000000,
			"gold": 0,
			"type": "魔",
			"idle": "魔尊idle",
			 "monsterMagicList": [
				magics.get("炼狱真火"),
			],
			"autoAttackSound": "res://Audio/SE/猛男-唔哈。气势.ogg"
			
			}),		
		"妖皇": Monster.new({
			"name": "妖皇",
			"speed": 500,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 8000,
			"magicDmg": 1200,
			"posi": "middle",
			"type": "",
			"hp": 220000,
			"exp": 150000000,
			"gold": 0,
			"idle": "妖皇idle",
			 "monsterMagicList": [
				magics.get("象脚"),
			],
			"autoAttackSound": "res://Audio/SE/打击4.ogg"
			}),			
		},				
	"巨灵神":{				
		"巨灵神": Monster.new({
			"name": "巨灵神",
			"speed": 500,
			"level": 100,
			"magicDefense": 600,
			"physicDefense": 600,
			"attackDmg": 11000,
			"magicDmg": 0,
			"posi": "middle",
			"type": "",
			"hp": 250000,
			"exp": 150000000,
			"gold": 0,
			"idle": "巨灵神idle",
			 "monsterMagicList": [
				
			],
			}),
		},
	"四大天王":{				
		"广目天王": Monster.new({
			"name": "广目天王",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 8000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "",
			"hp": 160050,
			"exp": 150000000,
			"gold": 0,
			"idle": "广目天王idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
			}),
		"增长天王": Monster.new({
			"name": "增长天王",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 8000,
			"magicDmg": 1000,
			"posi": "middle",
			"hp": 160000,
			"exp": 150000000,
			"gold": 0,
			"idle": "增长天王idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
			}),				
		"持国天王": Monster.new({
			"name": "持国天王",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 8000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "",
			"hp": 200000,
			"exp": 200000000,
			"gold": 0,
			"idle": "持国天王idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
			}),
		"多闻天王": Monster.new({
			"name": "多闻天王",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 8000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "",
			"hp": 160000,
			"exp": 150000000,
			"gold": 0,
			"idle": "多闻天王idle",
			 "monsterMagicList": [
				magics.get("水满金山"),
			],
			}),					
		},			
	"初代蛙":{				
		"巨蛙": Monster.new({
			"name": "巨蛙",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 10000,
			"magicDmg": 1900,
			"posi": "middle",
			"type": "",
			"hp": 180000,
			"exp": 150000000,
			"gold": 0,
			"idle": "巨蛙idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),
		},	
	"铁牛":{				
		"反贼大头目": Monster.new({
			"name": "反贼大头目",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 120000,
			"magicDmg": 1800,
			"posi": "middle",
			"type": "",
			"hp": 180000,
			"exp": 150000000,
			"gold": 0,
			"idle": "反贼大头目idle",
			 "monsterMagicList": [
				magics.get("烈火"),
			],
			}),
		},			
	"符鬼":{				
		"魔巫": Monster.new({
			"name": "魔巫",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 11000,
			"magicDmg": 1200,
			"posi": "middle",
			"type": "",
			"hp": 200000,
			"exp": 150000000,
			"gold": 0,
			"idle": "魔巫idle",
			 "monsterMagicList": [
				magics.get("魔光毒虫"),
			],
			}),
		},	
	"西游虎":{				
		"噬天虎": Monster.new({
			"name": "噬天虎",
			"speed": 500,
			"level": 100,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 9000,
			"magicDmg": 1000,
			"posi": "middle",
			"type": "",
			"hp": 180000,
			"exp": 200000000,
			"gold": 0,
			"idle": "噬天虎idle",
			 "monsterMagicList": [
			],
			}),
		},		
	"无敌天道":{				
		"天道": Monster.new({
			"name": "天道",
			"speed": 1000,
			"level": 100,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 20500,
			"magicDmg": 20000,
			"posi": "middle",
			"type": "",
			"hp": 500000,
			"exp": 100,
			"gold": 100,
			"idle": "天道idle",
			 "monsterMagicList": [
				magics.get("水攻"),
			],
			}),
		},		
	"天道":{				
		"天道": Monster.new({
			"name": "天道",
			"speed": 650,
			"level": 1,
			"magicDefense": 800,
			"physicDefense": 800,
			"attackDmg": 13500,
			"magicDmg": 1800,
			"posi": "middle",
			"type": "",
			"hp": 500000,
			"exp": 0,
			"gold": 0,
			"idle": "天道idle",
			 "monsterMagicList": [
				magics.get("天劫"),
			],
			}),
		},				
	"残血天道":{				
		"天道": Monster.new({
			"name": "天道",
			"speed": 70,
			"level": 1,
			"magicDefense": 0,
			"physicDefense": 0,
			"attackDmg": 100,
			"magicDmg": 30,
			"posi": "middle",
			"type": "",
			"hp": 1200,
			"exp": 100,
			"gold": 100,
			"idle": "天道idle",
			 "monsterMagicList": [
			],
			}),
		},		
	"天宫":{				
		"魔巫": Monster.new({
			"name": "魔巫",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 3000,
			"magicDmg": 500,
			"posi": "middle",
			"type": "",
			"hp": 20550,
			"exp": 22000000,
			"gold": 100,
			"idle": "魔巫idle",
			 "monsterMagicList": [
				magics.get("魔光毒虫"),
			],
			}),
		"小魔头": Monster.new({
			"name": "小魔头",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 5000,
			"magicDmg": 1500,
			"posi": "middle",
			"hp": 21050,
			"exp": 22000000,
			"gold": 100000,
			"idle": "小魔头idle",
			 "monsterMagicList": [
				magics.get("雷击"),
			],
			"autoAttackSound": "res://Audio/SE/孩子-逗乐.ogg"
			}),	
		"镰魔": Monster.new({
			"name": "镰魔",
			"speed": 250,
			"level": 85,
			"magicDefense": 200,
			"physicDefense": 200,
			"attackDmg": 7000,
			"magicDmg": 0,
			"posi": "middle",
			"hp": 21000,
			"exp": 20000000,
			"gold": 100,
			"idle": "镰魔idle",
			 "monsterMagicList": [
			],
			"autoAttackSound":"res://Audio/SE/镰刀.ogg"
			}),				
		}															
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
func _process(delta):
	pass

