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
	}	
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
		"description": "恢复300仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 100		
	},	
}

var battleConsume ={
	"金疮药":{
		"name": "金疮药",
		"effect": "hp",
		"value": 200,
		"icon": "res://Icons/金疮药.png",
		"picture":"res://Pictures/Pictures/SP (8).png",
		"description": "恢复200生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 50
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
		"gold": 200
	}
}

var weapon = {
	"大剑":{
		"name": "大剑",
		"user": "时追云",
		"icon": "res://Icons/〓大刀 副本.png",
		"picture":"res://Pictures/Pictures/〓大刀.png",
		"value": {"additionDmg":30},
		"description": "伤害+10",
		"key":false,
		"added": false,
		"gold": 200
	},
	"精钢剑":{
		"name": "精钢剑",
		"user": "时追云",
		"icon": "res://Icons/〓精钢剑 副本.png",
		"picture": "res://Pictures/〓精钢剑.png",
		"value": {"additionDmg": 150},
		"description": "伤害+20",
		"key":false,
		"added": false,
		"gold": 600
	},
}

var cloth = {
	"布衣":{
		"name": "布衣",
		"user": "all",
		"icon": "res://Icons/0750-80e74115-00000 副本.png",
		"picture": "res://Pictures/Pictures/ny (6).png",
		"value": {"addPhysicDefense": 10,"addMagicDefense": 10},
		"description": "物理防御+10，魔法防御+10",
		"key":false,
		"added":false,
		"gold": 100
	},
	"锦衣":{
		"name": "锦衣",
		"user": "all",
		"icon": "res://Icons/1410-eeaa3c26-00000 副本.png",
		"picture":"res://Pictures/Pictures/ny (2).png",
		"value": {"addPhysicDefense": 30,"addMagicDefense": 30},
		"description": "物理防御+30，魔法防御+30",
		"key":false,
		"added":false,
		"gold": 300
	}
}

var shoes = {
	"草鞋":{
		"name": "草鞋",
		"user": "all",
		"icon": "res://Icons/0283-30225bdd-00004 副本.png",
		"picture": "res://Pictures/Pictures/xz (8).png",
		"value": {"addPlayerSpeed": 10},
		"description": "速度+10",
		"key":false,
		"added":false,
		"gold": 100,
	},
	"皮鞋":{
		"name": "皮鞋",
		"user": "all",
		"icon": "res://Icons/0283-30225bdd-00003 副本.png",
		"picture": "res://Pictures/Pictures/xz (7).png",
		"value": {"addPlayerSpeed": 20},
		"description": "速度+20",
		"key":false,
		"added":false,
		"gold": 300
	}
}

var accessories = {
	"护身符":{
		"name": "护身符",
		"user": "时追云",
		"icon": "res://Icons/0016-3b8b41e-00003 副本.png",
		"picture": "res://Pictures/Pictures/■护身符.png",
		"value": {"addPlayerSpeed": 50, "addPhysicDefense": 50, "addMagicDefense": 50, "additionDmg":50, "addHp":200},
		"description": "速度+50, 物理防御+50，灵力防御+50，伤害+50，血量+200",
		"key":true,
		"added":false,
		"gold":9999999999999999999,
	}
}

var hat = {
	"方巾":{
		"name": "方巾",
		"user": "all",
		"icon": "res://Icons/方巾.png",
		"picture": "res://Pictures/Pictures/方巾.png",
		"value": {"addPhysicDefense": 10},
		"description": "物理防御+10",
		"key":false,
		"added":false,
		"gold": 150
	},
	"面具":{
		"name": "面具",
		"user": "all",
		"icon": "res://Icons/面具.png",
		"picture": "res://Pictures/面具.png",
		"value": {"addPhysicDefense": 20},
		"description": "物理防御+20",
		"key":false,
		"added":false,
		"gold": 400
	},
		
}
