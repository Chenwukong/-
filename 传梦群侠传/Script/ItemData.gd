extends Node

var keyItem = {
	"避祸香囊":{
		"name": "避祸香囊",
		"effect": "special",
		"value": 100,
		"icon": "res://Pictures/SP (8).png",
		"picture":"res://Pictures/SP (8).png",
		"description": "可关闭或开启遇妖",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":true,
		"gold": 50		
	},
	"鱼大爷之帽":{
		"name": "鱼大爷之帽",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/Pictures/■麻布帽.png",
		"picture":"res://Pictures/Pictures/■麻布帽.png",
		"description": "鱼大爷遗落的帽子",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":false,
		"gold": 9999999		
	},	

	"传字牌":{
		"name": "传字牌",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/传.png",
		"picture":"res://Pictures/传.png",
		"description": "写着传字",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":false,
		"gold":99999999	
	},
	"桃木棒":{
		"name": "桃木棒",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/ba (1).png",
		"picture":"res://Pictures/ba (1).png",
		"description": "大圣的老武器，花果山友谊的证明",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":false,
		"gold":99999999	
	},	
	"洗髓丹":{
		"name": "洗髓丹",
		"effect": "special",
		"value": 100,
		"icon": "res://Icons/赤练仙丹.png",
		"picture":"res://Icons/赤练仙丹.png",
		"description": "可重新加点，需要脱掉全身装备后服用，慎用，慎用，慎用",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":true,
		"gold": 0	
	},
				
	
	
}

var consume = {
	"佛手":{
		"name": "佛手",
		"effect": "mp",
		"value": 100,
		"icon": "res://Icons/佛手.png",
		"picture":"res://Icons/佛手.png",
		"description": "恢复100仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 50		
	},
	"佛跳墙":{
		"name": "佛跳墙",
		"effect": "mp",
		"value": 300,
		"icon": "res://Icons/佛跳墙.png",
		"picture":"res://Icons/佛跳墙.png",
		"description": "恢复300仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 140		
	},
	"西瓜":{
		"name": "西瓜",
		"effect": "hp",
		"value": 100,
		"icon": "res://Icons/西瓜.png",
		"picture":"res://Icons/西瓜.png",
		"description": "恢复100体力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 100		
	},	
}

var battleConsume ={
	"金疮药":{
		"name": "金疮药",
		"effect": "hp",
		"value": 200 ,
		"icon": "res://Icons/金疮药.png",
		"picture":"res://Icons/金疮药.png",
		"description": "恢复200生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 200
	},
	"小还丹":{
		"name": "小还丹",
		"effect": "hp",
		"value": 600 ,
		"icon": "res://Icons/小还丹.png",
		"picture":"res://Icons/小还丹.png",
		"description": "恢复600生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 600
	},	
	
	
	"含沙射影":{
		"name": "含沙射影",
		"effect": "damage",
		"value": 200,
		"icon": "res://Icons/含沙射影.png",
		"picture": "res://Pictures/〓双锥剑.png",
		"description": "造成200伤害",
		"key":false,
		"audio": "res://Audio/SE/094-Attack06.ogg",
		"gold": 400
	},
	"飞蝗石":{
		"name": "飞蝗石",
		"effect": "damage",
		"value": 800,
		"icon": "res://Icons/飞蝗石.png",
		"picture": "res://Icons/飞蝗石.png",
		"description": "造成800伤害",
		"key":false,
		"audio": "res://Audio/SE/094-Attack06.ogg",
		"gold": 1200
	}	
	
	
}

var weapon = {
	"大剑":{
		"name": "大剑",
		"user": "时追云",
		"icon": "res://Icons/〓大刀 副本.png",
		"picture":"res://Pictures/Pictures/〓大刀.png",
		"value": {"additionDmg":60 * Global.enKey},
		"description": "时追云专属武器，伤害+60，大剑的造型为什么是一把刀",
		"key":false,
		"added": false,
		"gold": 200
	},
	"精钢剑":{
		"name": "精钢剑",
		"user": "时追云",
		"icon": "res://Icons/〓精钢剑 副本.png",
		"picture": "res://Pictures/〓精钢剑.png",
		"value": {"additionDmg": 100 * Global.enKey},
		"description": "时追云专属武器，伤害+100，精诚所至，精钢为开",
		"key":false,
		"added": false,
		"gold": 800
	},
	"黄金剑":{
		"name": "黄金剑",
		"user": "时追云",
		"icon": "res://Icons/〓黄金剑 副本.png",
		"picture":"res://Pictures/〓黄金剑.png",
		"value": {"additionDmg": 140 * Global.enKey},
		"description": "时追云专属武器，伤害+140，黄金居然也很硬",
		"key":false,
		"added": false,
		"gold": 3000
	},
	"竹节双剑":{
		"name": "竹节双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓竹节双剑 副本.png",
		"picture": "res://Icons/〓竹节双剑 副本.png",
		"value": {"additionDmg": 25 * Global.enKey},
		"description": "凌若昭专属武器，伤害+25，为什么要拿竹子打人，但有人都用木头了...",
		"key":false,
		"added": false,
		"gold": 200
	},	
	"赤铁双剑":{
		"name": "赤铁双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓赤铁双剑 副本.png",
		"picture": "res://Pictures/〓赤血双剑.png",
		"value": {"additionDmg": 75 * Global.enKey},
		"description": "凌若昭专属武器，伤害+75,总算是用上铁器了",
		"key":false,
		"added": false,
		"gold": 1700
	},
	"赤血双剑":{
		"name": "赤血双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓赤血双剑 副本.png",
		"picture": "res://Pictures/〓赤血双剑.png",
		"value": {"additionDmg": 200 * Global.enKey},
		"description": "凌若昭专属武器，伤害+150，这只是赤铁双剑撒了狗血吧",
		"key":false,
		"added": false,
		"gold": 10000
	},			
	"木头":{
		"name": "木头",
		"user": "小二",
		"icon": "res://Icons/00木头3.png",
		"picture": "res://Icons/00木头3.png",
		"value": {"additionDmg": 1 * Global.enKey},
		"description": "小二专属武器，伤害+1，聊胜于无",
		"key":false,
		"added": false,
		"gold": 0
	},		
	"长叶子的木头":{
		"name": "长叶子的木头",
		"user": "小二",
		"icon": "res://Icons/00木头2.png",
		"picture": "res://Icons/00木头2.png",
		"value": {"additionDmg": 10 * Global.enKey},
		"description": "小二专属武器，伤害+10，加了个叶子真的能提高伤害吗？",
		"key":false,
		"added": false,
		"gold": 10
	},	
	"粗壮的木头":{
		"name": "粗壮的木头",
		"user": "小二",
		"icon": "res://Icons/00木头1.png",
		"picture": "res://Icons/00木头1.png",
		"value": {"additionDmg": 20 * Global.enKey},
		"description": "小二专属武器，伤害+20，为什么还是木头，为什么总是木头",
		"key":false,
		"added": false,
		"gold": 20
	},		
			
	"碧玉剑":{
		"name": "碧玉剑",
		"user": "时追云",
		"icon": "res://Icons/〓碧玉剑 副本.png",
		"picture": "res://Pictures/〓碧玉剑.png",
		"value": {"additionDmg": 300* Global.enKey},
		"description": "时追云专属武器，伤害+300，带着黑山的灵气",
		"key":true,
		"added": false,
		"gold": 10000
	},	
	
}

var cloth = {
	"布衣":{
		"name": "布衣",
		"user": "all",
		"icon": "res://Icons/0750-80e74115-00000 副本.png",
		"picture": "res://Pictures/Pictures/ny (6).png",
		"value": {"addPhysicDefense": 15 * Global.enKey,"addMagicDefense": 15* Global.enKey },
		"description": "物理防御+15，魔法防御+15，江湖人必备布衣",
		"key":false,
		"added":false,
		"gold": 100
	},
	"锦衣":{
		"name": "锦衣",
		"user": "all",
		"icon": "res://Icons/1410-eeaa3c26-00000 副本.png",
		"picture":"res://Pictures/Pictures/ny (2).png",
		"value": {"addPhysicDefense": 30 * Global.enKey,"addMagicDefense": 30 * Global.enKey},
		"description": "物理防御+30，魔法防御+30，好看才能增加防御",
		"key":false,
		"added":false,
		"gold": 400
	},
	"锁子甲":{
		"name": "锁子甲",
		"user": "male",
		"icon": "res://Pictures/Pictures/ny (1).png",
		"picture":"res://Pictures/Pictures/ny (1).png",
		"value": {"addPhysicDefense": 100 * Global.enKey,"addMagicDefense": 100 * Global.enKey},
		"description": "物理防御+100，魔法防御+100，帅气衣甲",
		"key":false,
		"added":false,
		"gold": 1000
	},	
	"天香披肩":{
		"name": "天香披肩",
		"user": "female",
		"icon":  "res://Pictures/ni (5).png",
		"picture":"res://Pictures/ni (5).png",
		"value": {"addPhysicDefense": 100 * Global.enKey,"addMagicDefense": 100 * Global.enKey},
		"description": "物理防御+100，魔法防御+100，带有香气",
		"key":false,
		"added":false,
		"gold": 1000
	},	
	"金刚甲":{
		"name": "金刚甲",
		"user": "male",
		"icon": "res://Pictures/Pictures/ny (7).png",
		"picture":"res://Pictures/Pictures/ny (7).png",
		"value": {"addPhysicDefense": 200 * Global.enKey,"addMagicDefense": 200 * Global.enKey},
		"description": "物理防御+200，魔法防御+200，笨重，但有效",
		"key":false,
		"added":false,
		"gold": 10000
	},		
	"抽丝断茧":{
		"name": "抽丝断茧",
		"user": "female",
		"icon":  "res://Pictures/ni (5).png",
		"picture":"res://Pictures/ni (5).png",
		"value": {"addPhysicDefense": 200 * Global.enKey,"addMagicDefense": 200 * Global.enKey},
		"description": "物理防御+200，魔法防御+200,已经开始乱起名了",
		"key":false,
		"added":false,
		"gold": 10000
	},		
	
	
	
}

var shoes = {
	"草鞋":{
		"name": "草鞋",
		"user": "all",
		"icon": "res://Icons/0283-30225bdd-00004 副本.png",
		"picture": "res://Pictures/Pictures/xz (8).png",
		"value": {"addPlayerSpeed": 15 * Global.enKey},
		"description": "速度+15，可是刘皇叔之作？",
		"key":false,
		"added":false,
		"gold": 100,
	},
	"皮鞋":{
		"name": "皮鞋",
		"user": "all",
		"icon": "res://Icons/0283-30225bdd-00003 副本.png",
		"picture": "res://Pictures/Pictures/xz (7).png",
		"value": {"addPlayerSpeed": 20 * Global.enKey},
		"description": "速度+20，人造革",
		"key":false,
		"added":false,
		"gold": 300
	},
	"神行靴":{
		"name": "神行靴",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (6).png",
		"picture": "res://Pictures/Pictures/xz (6).png",
		"value": {"addPlayerSpeed": 30 * Global.enKey},
		"description": "速度+30，飞起",
		"key":false,
		"added":false,
		"gold": 800
	},	
	"无暇靴":{
		"name": "无暇靴",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (9).png",
		"picture": "res://Pictures/Pictures/xz (9).png",
		"value": {"addPlayerSpeed": 40 * Global.enKey},
		"description": "速度+40，天鞋无暇之作",
		"key":false,
		"added":false,
		"gold": 6000
	},		
	
}

var accessories = { 
	"护身符":{
		"name": "护身符",
		"user": "时追云",
		"icon": "res://Icons/0016-3b8b41e-00003 副本.png",
		"picture": "res://Pictures/Pictures/■护身符.png",
		"value": {"addPlayerSpeed": 15 * Global.enKey, "addPhysicDefense": 50* Global.enKey, "addMagicDefense": 50* Global.enKey, "additionDmg":50* Global.enKey, "addHp":200* Global.enKey},
		"description": "速度+15, 物理防御+50，灵力防御+50，伤害+50，血量+200 (时追云专属)",
		"key":true,
		"added":false,
		"gold":9999999999999999999,
	},
	"江湖夜雨":{
		"name": "江湖夜雨",
		"user": "all",
		"icon": "res://Pictures/Pictures/■江湖夜雨.png",
		"picture": "res://Pictures/Pictures/■江湖夜雨.png",
		"value": {"addPlayerSpeed": 10* Global.enKey, "addPhysicDefense": 20* Global.enKey, "addMagicDefense": 20* Global.enKey, "additionDmg":20* Global.enKey, "addHp":50* Global.enKey},
		"description": "速度+10, 物理防御+20，灵力防御+20，伤害+20，血量+50",
		"key":false,
		"added":false,
		"gold": 1200,
	},	
	"五色飞石":{
		"name": "五色飞石",
		"user": "all",
		"icon": "res://Pictures/Pictures/SP.png",
		"picture": "res://Pictures/Pictures/SP.png",
		"value": {"addPlayerSpeed": 20* Global.enKey, "addPhysicDefense": 180* Global.enKey, "addMagicDefense": 180* Global.enKey, "additionDmg":50* Global.enKey, "addHp": 150* Global.enKey},
		"description": "速度+20, 物理防御+180，灵力防御+180，伤害+50，血量+150",
		"key":false,
		"added":false,
		"gold": 8000,
	},		
	
}

var hat = {
	"方巾":{
		"name": "方巾",
		"user": "male",
		"icon": "res://Icons/方巾.png",
		"picture": "res://Pictures/Pictures/方巾.png",
		"value": {"addPhysicDefense": 15* Global.enKey},
		"description": "物理防御+15",
		"key":false,
		"added":false,
		"gold": 150
	},
	"面具":{
		"name": "面具",
		"user": "all",
		"icon": "res://Icons/面具.png",
		"picture": "res://Pictures/面具.png",
		"value": {"addPhysicDefense": 20* Global.enKey},
		"description": "物理防御+20",
		"key":false,
		"added":false,
		"gold": 200
	},
	"羊角盔":{
		"name": "羊角盔",
		"user": "male",
		"icon": "res://Icons/羊角盔.png",
		"picture": "res://Pictures/羊角盔.png",
		"value": {"addPhysicDefense": 80* Global.enKey,},
		"description": "物理防御+80",
		"key":false,
		"added":false,
		"gold": 1000
	},
	"珍珠头带":{
		"name": "珍珠头带",
		"user": "female",
		"icon": "res://Pictures/NT (4).png",
		"picture": "res://Pictures/NT (4).png",
		"value": {"addPhysicDefense": 80* Global.enKey,},
		"description": "物理防御+80",
		"key":false,
		"added":false,
		"gold": 1000
	},	
	"狐媚面具":{
		"name": "狐媚面具",
		"user": "female",
		"icon": "res://Pictures/NT (2).png",
		"picture": "res://Pictures/NT (2).png",
		"value": {"addPhysicDefense": 300 * Global.enKey,},
		"description": "物理防御+300",
		"key":false,
		"added":false,
		"gold": 7000
	},		
	"乾坤帽":{
		"name": "乾坤帽",
		"user": "female",
		"icon": "res://Pictures/乾坤帽.png",
		"picture": "res://Pictures/乾坤帽.png",
		"value": {"addPhysicDefense": 300 * Global.enKey,},
		"description": "物理防御+300",
		"key":false,
		"added":false,
		"gold": 7000
	},			
	
	
			
}
var addItemInfo ={
	"金疮药":{
		"name": "金疮药",
		"type": "battleConsume",
		"bagPlace": "battleItem"
	},
	"含沙射影":{
		"name": "含沙射影",
		"type": "battleConsume",
		"bagPlace": "battleItem"
	},
	"佛手":{
		"name": "佛手",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"西瓜":{
		"name": "西瓜",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"洗髓丹":{
		"name": "洗髓丹",
		"type": "keyItem",
		"bagPlace": "keyItem"
	},	
	"小还丹":{
		"name": "小还丹",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},		
}
