extends Node


#1初始
#2建业
#3长安
#4傲来
#5地府
#6北俱芦洲

func _ready():
	add_items_to_addItemInfo()	

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
	"渔夫草帽":{
		"name": "渔夫草帽",
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
	"梦字牌":{
		"name": "梦字牌",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/梦.png",
		"picture":"res://Pictures/梦.png",
		"description": "写着梦字",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":false,
		"gold":99999999	
	},
	"之字牌":{
		"name": "之字牌",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/之.png",
		"picture":"res://Pictures/之.png",
		"description": "写着之字",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":false,
		"gold":99999999	
	},	
	"路字牌":{
		"name": "路字牌",
		"effect": null,
		"value": 100,
		"icon": "res://Pictures/路.png",
		"picture":"res://Pictures/路.png",
		"description": "写着路字",
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
	"人参果":{
		"name": "人参果",
		"effect": null,
		"value": 100,
		"icon": "res://Icons/人参果.png",
		"picture":"res://Icons/人参果.png",
		"description": "人参果",
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
	"圣兽洗髓":{
		"name": "圣兽洗髓",
		"effect": "special",
		"value": 100,
		"icon": "res://Icons/紫金丹.png",
		"picture":"res://Icons/紫金丹.png",
		"description": "会重置全部盟友的加点！",
		"audio": "res://Audio/SE/056-Right02.ogg",
		"key":true,
		"useAble":true,
		"gold": 6000000	
	},	
	
	
	"筋斗云":{
		"name": "筋斗云",
		"effect": "special",
		"value": 100,
		"icon": "res://cloud.png",
		"picture":"res://cloud.png",
		"description": "可让角色走路速度加快，再次使用关闭",
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
	"狗不理包子":{
		"name": "狗不理包子",
		"effect": "hp",
		"value": 100,
		"icon": "res://Icons/狗不理包子.png",
		"picture":"res://Icons/狗不理包子.png",
		"description": "恢复100体力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 100		
	},		
	"西瓜":{
		"name": "西瓜",
		"effect": "hp",
		"value": 300,
		"icon": "res://Icons/西瓜.png",
		"picture":"res://Icons/西瓜.png",
		"description": "食用后可快速恢复自身300血量",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 300		
	},		
	
	"可食用人参果":{
		"name": "可食用人参果",
		"effect": "special",
		"value": 500,
		"icon": "res://Icons/人参果.png",
		"picture":"res://Icons/人参果.png",
		"description": "增加500体力上限！(注：食用之后吃洗髓丹会导致失去这个属性)",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 30000		
	},		
	"鳊鱼":{
		"name": "鳊鱼",
		"effect": "special",
		"value": 5,
		"icon": "res://Icons/鳊鱼.png",
		"picture": "res://Icons/鳊鱼.png",
		"description": "增加5灵力！(注：食用之后吃洗髓丹会导致失去这个属性)",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 30000		
	},			
	"怪力鱼":{
		"name": "怪力鱼",
		"effect": "special",
		"value": 5,
		"icon": "res://Icons/鳕鱼.png",
		"picture": "res://Icons/鳕鱼.png",
		"description": "增加5力量！(注：食用之后吃洗髓丹会导致失去这个属性)",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 30000		
	},		
	"娃娃鱼":{
		"name": "娃娃鱼",
		"effect": "special",
		"value": 50,
		"icon": "res://Icons/娃娃鱼.png",
		"picture": "res://Icons/娃娃鱼.png",
		"description": "增加50蓝量上限！(注：食用之后吃洗髓丹会导致失去这个属性)",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 30000		
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
		"gold": 1000
	},	
	"金香玉":{
		"name": "金香玉",
		"effect": "hp",
		"value": 1000 ,
		"icon": "res://Icons/金香玉.png" ,
		"picture":"res://Icons/金香玉.png",
		"description": "恢复1000生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 1800
	},		
	
	"老君仙丹":{
		"name": "老君仙丹",
		"effect": "hp",
		"value": 2400 ,
		"icon": "res://Icons/老君仙丹.png",
		"picture":"res://Icons/老君仙丹.png",
		"description": "恢复2400生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 30000
	},		
	
	"月饼":{
		"name": "月饼",
		"effect": "hp",
		"value": 3000 ,
		"icon": "res://Icons/月宫月饼.png",
		"picture":"res://Icons/月宫月饼.png",
		"description": "恢复3000生命值",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 0
	},		
	"人参":{
		"name": "人参",
		"effect": "mp",
		"value": 500 ,
		"icon": "res://Icons/人参.png",
		"picture":"res://Icons/百年人参.png",
		"description": "恢复500仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 10000
	},
	"仙狐涎":{
		"name": "仙狐涎",
		"effect": "mp",
		"value": 200 ,
		"icon": "res://Icons/仙狐涎.png",
		"picture":  "res://Icons/仙狐涎.png",
		"description": "恢复200仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 1000
	},		
	"蛇蝎美人":{
		"name": "蛇蝎美人",
		"effect": "mp",
		"value": 1200 ,
		"icon": "res://Icons/蛇蝎美人.png",
		"picture": "res://Icons/蛇蝎美人.png",
		"description": "恢复1200仙力",
		"audio": "res://Audio/SE/HEAL11.ogg",
		"key":false,
		"gold": 20000
	},	
	"含沙射影":{
		"name": "含沙射影",
		"effect": "damage",
		"value": 200,
		"icon": "res://Icons/含沙射影.png",
		"picture": "res://Icons/含沙射影.png",
		"description": "造成200伤害",
		"key":false,
		"audio": "res://Audio/SE/094-Attack06.ogg",
		"gold": 400
	},
	"飞蝗石":{
		"name": "飞蝗石",
		"effect": "damage",
		"value": 1000,
		"icon": "res://Icons/飞蝗石.png",
		"picture": "res://Icons/飞蝗石.png",
		"description": "造成1000伤害",
		"key":false,
		"audio": "res://Audio/SE/094-Attack06.ogg",
		"gold": 1200
	},
	"魔睛子":{
		"name": "魔睛子",
		"effect": "damage",
		"value": 3000,
		"icon": "res://Icons/魔睛子.png",
		"picture": "res://Icons/魔睛子.png",
		"description": "造成2500伤害",
		"key":false,
		"audio": "res://Audio/SE/094-Attack06.ogg",
		"gold": 5000
	}		
	
}

var weapon = {
	"传梦之剑":{
		"name": "传梦之剑",
		"user": "时追云",
		"icon": "res://Pictures/剑 (4).png",
		"picture":"res://Pictures/剑 (4).png",
		"value": {"additionDmg":999999 * Global.enKey},
		"description": "时追云专属武器，伤害+999999，测试版专用，非必要请勿使用",
		"key":false,
		"added": false,
		"gold": 200
	},
	"传梦之棍":{
		"name": "传梦之棍",
		"user": "小二",
		"icon": "res://Pictures/ba (4).png",
		"picture":"res://Pictures/ba (4).png",
		"value": {"additionDmg":999999 * Global.enKey},
		"description": "小二专属武器，伤害999999",
		"key":false,
		"added": false,
		"gold": 200
	},
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
	"梦澹":{
		"name": "梦澹",
		"user": "时追云",
		"icon": "res://SeparateAnimation/梦澹/梦澹icon(1).png",
		"picture": "res://SeparateAnimation/梦澹/梦澹icon(1).png",
		"value": {"additionDmg": 1800* Global.enKey},
		"description": "时追云专属武器，伤害+1800",
		"key":true,
		"added": false,
		"gold": 10000
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
		"description": "凌若昭专属武器，伤害+200，这只是赤铁双剑撒了狗血吧",
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
	"玉箍棒":{
		"name": "玉箍棒",
		"user": "小二",
		"icon": "res://Pictures/Pictures/ba.png",
		"picture": "res://Pictures/Pictures/ba.png",
		"value": {"additionDmg": 1400 * Global.enKey},
		"description": "小二专属武器，伤害+1400，金箍棒的孪生武器",
		"key":false,
		"added": false,
		"gold": 20000
	},				
	"墨玉双剑":{
		"name": "墨玉双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓墨玉双剑 副本.png",
		"picture": "res://Pictures/〓墨玉双剑.png",
		"value": {"additionDmg": 400 * Global.enKey},
		"description": "伤害+400，墨石所铸",
		"key":false,
		"added": false, #朱紫国
		"gold": 12000
	},	
	"阴阳双剑":{
		"name": "阴阳双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓阴阳双剑 副本.png",
		"picture": "res://Pictures/〓阴阳双剑.png",
		"value": {"additionDmg": 600 * Global.enKey},
		"description": "伤害+600，墨石所铸",
		"key":false,
		"added": false, #朱紫国
		"gold": 80000
	},	
	"青冥双剑":{
		"name": "青冥双剑",
		"user": "凌若昭",
		"icon": "res://Icons/〓青冥双剑 副本.png",
		"picture": "res://Pictures/〓青冥双剑.png",
		"value": {"additionDmg": 1000 * Global.enKey},
		"description": "伤害+1000，赤阳之铁成阳，玄冰之玉成阴，两仪相生，气韵非凡",
		"key":false,
		"added": false, #朱紫国
		"gold": 1000000
	},		
	"红丝缠":{
		"name": "红丝缠",
		"user": "姜韵",
		"icon": "res://Icons/缎带 (2).png",
		"picture": "res://Icons/缎带 (2).png",
		"value": {"additionDmg": 400 * Global.enKey},
		"description": "伤害+400，红丝缠绕",
		"key":false,
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
		"description": "通用，物理防御+15，魔法防御+15，江湖人必备布衣",
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
		"description": "通用，物理防御+30，魔法防御+30，好看才能增加防御",
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
		"description": "男用，物理防御+100，魔法防御+100，帅气衣甲",
		"key":false,
		"added":false, #长安城
		"gold": 1000
	},	
	"天香披肩":{
		"name": "天香披肩",
		"user": "female",
		"icon":  "res://Pictures/ni (5).png",
		"picture":"res://Pictures/ni (5).png",
		"value": {"addPhysicDefense": 100 * Global.enKey,"addMagicDefense": 100 * Global.enKey},
		"description": "女用，物理防御+100，魔法防御+100，带有香气",
		"key":false,
		"added":false, #长安城
		"gold": 1000
	},	
	"金刚甲":{
		"name": "金刚甲",
		"user": "male",
		"icon": "res://Pictures/Pictures/ny (7).png",
		"picture":"res://Pictures/Pictures/ny (7).png",
		"value": {"addPhysicDefense": 150 * Global.enKey,"addMagicDefense": 150 * Global.enKey},
		"description": "男用，物理防御+150，魔法防御+150，笨重，但有效",
		"key":false,
		"added":false, #傲来国
		"gold": 15000
	},		
	"抽丝断茧":{
		"name": "抽丝断茧",
		"user": "female",
		"icon":  "res://Pictures/ni (3).png",
		"picture":"res://Pictures/ni (3).png",
		"value": {"addPhysicDefense": 150 * Global.enKey,"addMagicDefense": 150 * Global.enKey},
		"description": "女用，物理防御+150，魔法防御+150,已经开始乱起名了",
		"key":false, #傲来国
		"added":false,
		"gold": 15000
	},		
	"夜魔披风":{
		"name": "夜魔披风",
		"user": "male",
		"icon":  "res://Pictures/Pictures/ny (3).png",
		"picture": "res://Pictures/Pictures/ny (3).png",
		"value": {"addPhysicDefense": 200 * Global.enKey,"addMagicDefense": 200 * Global.enKey},
		"description": "男用，物理防御+200，魔法防御+200,上面的骷髅貌似是用笔画的...",
		"key":false, #地府
		"added":false,
		"gold": 20000
	},		
	"龙骨甲":{
		"name": "龙骨甲",
		"user": "male",
		"icon":  "res://Pictures/Pictures/ny (4).png",
		"picture": "res://Pictures/Pictures/ny (4).png",
		"value": {"addPhysicDefense": 251 * Global.enKey,"addMagicDefense": 251 * Global.enKey},
		"description": "男用，物理防御+250+1，魔法防御+250+1，龙骨所制！",
		"key":false, #龙窟
		"added":false,
		"gold": 25000
	},
	"龙鳞羽衣":{
		"name": "龙鳞羽衣",
		"user": "female",
		"icon":  "res://Pictures/ni (4).png",
		"picture": "res://Pictures/ni (4).png",
		"value": {"addPhysicDefense": 251 * Global.enKey,"addMagicDefense": 251 * Global.enKey},
		"description": "女用，物理防御+220，魔法防御+251，龙鳞所制！",
		"key":false, #龙窟
		"added":false,
		"gold": 25000
	},	
	"死亡斗篷":{
		"name": "死亡斗篷",
		"user": "male",
		"icon":  "res://Pictures/Pictures/ny (5).png",
		"picture": "res://Pictures/Pictures/ny (5).png",
		"value": {"addPhysicDefense": 300 * Global.enKey,"addMagicDefense": 300 * Global.enKey},
		"description": "男用，物理防御+300，魔法防御+300，死亡斗篷",
		"key":false, #长寿村
		"added":false,
		"gold": 50000
	},		
	"七宝天衣":{
		"name": "七宝天衣",
		"user": "female",
		"icon":  "res://Pictures/ni (6).png",
		"picture": "res://Pictures/ni (6).png",
		"value": {"addPhysicDefense": 300 * Global.enKey,"addMagicDefense": 300 * Global.enKey},
		"description": "女用，物理防御+300，魔法防御+300，镶嵌了七颗宝石",
		"key":false, #长寿村
		"added":false,
		"gold": 50000
	},		
	"蝉翼金丝甲":{
		"name": "蝉翼金丝甲",
		"user": "male",
		"icon":  "res://Pictures/Pictures/ny.png",
		"picture": "res://Pictures/Pictures/ny.png",
		"value": {"addPhysicDefense": 350 * Global.enKey,"addMagicDefense": 350 * Global.enKey},
		"description": "男用，物理防御+350，魔法防御+350，月宫桂树上的灵蝉身上的蝉翼辅以金丝编织而成的铠甲。。",
		"key":false, #兜率宫
		"added":false,
		"gold": 150000
	},		
	"鎏金浣月衣":{
		"name": "鎏金浣月衣",
		"user": "female",
		"icon":  "res://Pictures/ni.png",
		"picture": "res://Pictures/ni.png",
		"value": {"addPhysicDefense": 350 * Global.enKey,"addMagicDefense": 350 * Global.enKey},
		"description": "女用，物理防御+350，魔法防御+350，以日月光芒所织造的霞衣。",
		"key":false, #兜率宫
		"added":false,
		"gold": 150000
	},			
	"GM战甲":{
		"name": "GM战甲",
		"user": "male",
		"icon": "res://Icons/GM男衣.png",
		"picture": "res://Pictures/GM神甲.png",
		"value": {"addPhysicDefense": 420 * Global.enKey,"addMagicDefense": 420 * Global.enKey},
		"description": "男用，物理防御+420，魔法防御+420，好，好，好！",
		"key":false, #兜率宫
		"added":false,
		"gold": 250000
	},		
	"GM凤披":{
		"name": "GM凤披",
		"user": "female",
		"icon": "res://Icons/GM女衣.png",
		"picture": "res://Pictures/GM凤披.png",
		"value": {"addPhysicDefense": 420 * Global.enKey,"addMagicDefense": 420 * Global.enKey},
		"description": "女用，物理防御+420，魔法防御+420，好，好，好！",
		"key":false, #兜率宫
		"added":false,
		"gold": 250000
	},	
	
	
}

var shoes = {
	"草鞋":{
		"name": "草鞋",
		"user": "all",
		"icon": "res://Icons/0283-30225bdd-00004 副本.png",
		"picture": "res://Pictures/Pictures/xz (8).png",
		"value": {"addPlayerSpeed": 15 * Global.enKey},
		"description": "速度+15，布缝制的鞋子，可以起到防御的作用",
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
		"description": "速度+20，牛皮缝制的靴子，速度和防御作用都比较强",
		"key":false,
		"added":false,
		"gold": 300
	},
#	"马靴":{
#		"name": "马靴",
#		"user": "all",
#		"icon": "res://Pictures/Pictures/xz (9).png",
#		"picture": "res://Pictures/Pictures/xz (9).png",
#		"value": {"addPlayerSpeed": 30 * Global.enKey},
#		"description": "速度+30，皮制的马靴，可以起到防御的作用",
#		"key":false,
#		"added":false,
#		"gold": 6000
#	},		
	"神行靴":{
		"name": "神行靴",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (6).png",
		"picture": "res://Pictures/Pictures/xz (6).png",
		"value": {"addPlayerSpeed": 40 * Global.enKey},
		"description": "速度+40，非常轻便的靴子，可以起到防御的作用",
		"key":false,
		"added":false,
		"gold": 800
	},	
#	"绿靴":{
#		"name": "绿靴",
#		"user": "all",
#		"icon": "res://Pictures/Pictures/xz (2).png",
#		"picture": "res://Pictures/Pictures/xz (2).png",
#		"value": {"addPlayerSpeed": 50 * Global.enKey},
#		"description": "速度+50，绿水晶制成的鞋子，防御作用非常的强",
#		"key":false,
#		"added":false,
#		"gold": 800
#	},	
	"追星踏月":{
		"name": "追星踏月",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (2).png",
		"picture": "res://Pictures/Pictures/xz (2).png",
		"value": {"addPlayerSpeed": 60 * Global.enKey},
		"description": "速度+60，由于鞋上有云月图案而得名，有不错的防御力",
		"key":false,
		"added":false,
		"gold": 5000
	},		
	"万里追云":{
		"name": "万里追云",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz.png",
		"picture": "res://Pictures/Pictures/xz.png",
		"value": {"addPlayerSpeed": 70 * Global.enKey},
		"description": "速度+70，可在任何地形疾走的神履，有不错的防御力",
		"key":false,
		"added":false,
		"gold": 10000
	},			
	"踏雪无痕":{
		"name": "踏雪无痕",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (3).png",
		"picture":"res://Pictures/Pictures/xz (3).png",
		"value": {"addPlayerSpeed": 80 * Global.enKey},
		"description": "速度+80，包蓄地之灵气，穿之幻影如风，踏雪无痕",
		"key":false,
		"added":false,
		"gold": 20000
	},			
	"金丝逐日履":{
		"name": "金丝逐日履",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (5).png",
		"picture":"res://Pictures/Pictures/xz (5).png",
		"value": {"addPlayerSpeed": 100 * Global.enKey},
		"description": "速度+100，相传神匠为纪念夸父特造此靴。穿上可追逐太阳，风云皆抛于脑后。",
		"key":false,
		"added":false,
		"gold": 60000 #长寿村
	},		
	"辟尘分光履":{
		"name": "辟尘分光履",
		"user": "all",
		"icon": "res://Pictures/Pictures/xz (10).png",
		"picture":"res://Pictures/Pictures/xz (10).png",
		"value": {"addPlayerSpeed": 135 * Global.enKey},
		"description": "速度+125，没有好看的鞋子图片了",
		"key":false,
		"added":false,
		"gold": 100000 #长寿村
	},			
	"GM战靴":{
		"name": "GM战靴",
		"user": "all",
		"icon": "res://Icons/GM鞋子.png",
		"picture":"res://Pictures/GM战靴.png",
		"value": {"addPlayerSpeed": 155 * Global.enKey},
		"description": "速度+155，好，好，好！",
		"key":false,
		"added":false,
		"gold": 200000 #长寿村
	},	
	
	
	
}

var accessories = { 
	"护身符":{
		"name": "护身符",
		"user": "时追云",
		"icon": "res://Pictures/Pictures/■护身符.png",
		"picture": "res://Pictures/Pictures/■护身符.png",
		"value": {"addPlayerSpeed": 20 * Global.enKey, "addPhysicDefense": 50* Global.enKey, "addMagicDefense": 50* Global.enKey, "additionDmg":50* Global.enKey, "addHp":200* Global.enKey},
		"description": "速度+20, 物理防御+50，灵力防御+50，伤害+50，血量+200 (时追云专属)",
		"key":true,
		"added":false,
		"gold":999999,
	},
	
	"五色飞石":{
		"name": "五色飞石",
		"user": "all",
		"icon": "res://Pictures/Pictures/SP.png",
		"picture": "res://Pictures/Pictures/SP.png",
		"value": {"addPlayerSpeed": 10 * Global.enKey, "addPhysicDefense": 20* Global.enKey, "addMagicDefense": 20* Global.enKey, "additionDmg":20* Global.enKey, "addHp":50* Global.enKey},
		"description": "速度+10, 物理防御+20，灵力防御+20，伤害+20，血量+50",
		"key":false,
		"added":false,
		"gold": 1200,
	},	
	"江湖夜雨":{
		"name": "江湖夜雨",
		"user": "all",
		"icon": "res://Pictures/Pictures/■江湖夜雨.png",
		"picture": "res://Pictures/Pictures/■江湖夜雨.png",
		"value": {"addPlayerSpeed": 20 * Global.enKey, "addPhysicDefense": 60* Global.enKey, "addMagicDefense": 60* Global.enKey, "additionDmg":40* Global.enKey, "addHp":150* Global.enKey},
		"description": "速度+20, 物理防御+60，灵力防御+60，伤害+40，血量+150",
		"key":false,
		"added":false,
		"gold": 8000,
	},		
	
	"高速之星":{
		"name": "高速之星",
		"user": "all",
		"icon": "res://Pictures/Pictures/SP (2).png",
		"picture": "res://Pictures/Pictures/SP (2).png",
		"value": {"addPlayerSpeed": 60 * Global.enKey, "addPhysicDefense": 65* Global.enKey, "addMagicDefense": 65* Global.enKey, "additionDmg":45* Global.enKey, "addHp":160* Global.enKey},
		"description":  "速度+60, 物理防御+65，灵力防御+65，伤害+45，血量+160",
		"key":false,
		"added":false,
		"gold": 20000,
	},		
	"八卦指环":{
		"name": "八卦指环",
		"user": "all",
		"icon": "res://Pictures/八卦指环.png",
		"picture": "res://Pictures/八卦指环.png",
		"value": {"addPlayerSpeed": 65 * Global.enKey, "addPhysicDefense": 105* Global.enKey, "addMagicDefense": 105* Global.enKey, "additionDmg": 255* Global.enKey, "addHp":400* Global.enKey},
		"description":  "速度+65, 物理防御+105，灵力防御+105，伤害+255，血量+400",
		"key":false,
		"added":false,
		"gold": 60000,
	},				
	"乾坤玉佩":{
		"name": "乾坤玉佩",
		"user": "all",
		"icon": "res://Pictures/Pictures/■灵隐玉佩.png",
		"picture": "res://Pictures/Pictures/■灵隐玉佩.png",
		"value": {"addPlayerSpeed": 85 * Global.enKey, "addPhysicDefense": 135* Global.enKey, "addMagicDefense": 135* Global.enKey, "additionDmg": 505* Global.enKey, "addHp":700* Global.enKey},
		"description":  "速度+65, 物理防御+105，灵力防御+105，伤害+225，血量+400",
		"key":false,
		"added":false,
		"gold": 200000,
	},		
	
	
	"GM奖牌":{
		"name": "GM奖牌",
		"user": "all",
		"icon": "res://Icons/0016-3b8b41e-00003 副本.png",
		"picture": "res://Pictures/Pictures/■护身符.png",
		"value": {"addPlayerSpeed": 125 * Global.enKey, "addPhysicDefense": 160* Global.enKey, "addMagicDefense": 160* Global.enKey, "additionDmg": 600* Global.enKey, "addHp":1000* Global.enKey},
		"description":  "速度+125, 物理防御+160，灵力防御+160，伤害+500，血量+1000",
		"key":false,
		"added":false,
		"gold": 990000,
	},			
	
	
	
}

var hat = {
	"方巾":{
		"name": "方巾",
		"user": "male",
		"icon": "res://Icons/方巾.png",
		"picture": "res://Pictures/Pictures/方巾.png",
		"value": {"addPhysicDefense": 15* Global.enKey},
		"description": "男用，物理防御+15",
		"key":false,
		"added":false, #(建邺)
		"gold": 150
	},
	"面具":{
		"name": "面具",
		"user": "all",
		"icon": "res://Icons/面具.png",
		"picture": "res://Pictures/面具.png",
		"value": {"addPhysicDefense": 20* Global.enKey},
		"description": "通用，物理防御+20",
		"key":false,
		"added":false,  #(建邺)
		"gold": 200
	},
	"羊角盔":{
		"name": "羊角盔",
		"user": "male",
		"icon": "res://Icons/羊角盔.png",
		"picture": "res://Pictures/羊角盔.png",
		"value": {"addPhysicDefense": 80* Global.enKey,},
		"description": "男用，物理防御+80",
		"key":false,
		"added":false, #(长安)
		"gold": 1000
	},
	"珍珠头带":{
		"name": "珍珠头带",
		"user": "female",
		"icon": "res://Pictures/NT (4).png",
		"picture": "res://Pictures/NT (4).png",
		"value": {"addPhysicDefense": 80* Global.enKey,},
		"description": "女用，物理防御+80",
		"key":false,
		"added":false,#(长安)
		"gold": 1000
	},	
	"狐媚面具":{
		"name": "狐媚面具",
		"user": "female",
		"icon": "res://Pictures/NT (2).png",
		"picture": "res://Pictures/NT (2).png",
		"value": {"addPhysicDefense": 120 * Global.enKey,},
		"description": "女用，物理防御+120",
		"key":false,
		"added":false,#(傲来国)
		"gold": 7000
	},		
	"乾坤帽":{
		"name": "乾坤帽",
		"user": "male",
		"icon": "res://Pictures/乾坤帽.png",
		"picture": "res://Pictures/乾坤帽.png",
		"value": {"addPhysicDefense": 120 * Global.enKey,},
		"description": "男用，物理防御+120",
		"key":false,
		"added":false,#(傲来国
		"gold": 7000
	},			
	"黑魔冠":{
		"name": "黑魔冠",
		"user": "all",
		"icon": "res://Icons/黑魔冠.png",
		"picture": "res://Pictures/黑魔冠.png",
		"value": {"addPhysicDefense": 140 * Global.enKey,},
		"description": "通用，物理防御+140",
		"key":false,
		"added":false,#(地府)
		"gold": 15000
	},			
	"白龙冠":{
		"name": "白龙冠",
		"user": "all",
		"icon": "res://Icons/白龙冠.png",
		"picture": "res://Pictures/白龙冠.png",
		"value": {"addPhysicDefense": 160 * Global.enKey,},
		"description": "通用，物理防御+160",
		"key":false,
		"added":false,#(北俱芦洲)朱紫国
		"gold": 20000
	},		
	"水晶帽":{
		"name": "水晶帽",
		"user": "all",
		"icon": "res://Icons/水晶帽.png",
		"picture": "res://Pictures/水晶帽.png",
		"value": {"addPhysicDefense": 180 * Global.enKey,},
		"description": "通用，物理防御+180",
		"key":false,
		"added":false,#长寿村
		"gold": 50000
	},		
	"金凤尾冠":{
		"name": "金凤尾冠",
		"user": "all",
		"icon": "res://Icons/紫金冠.png",
		"picture": "res://Pictures/紫金冠.png",
		"value": {"addPhysicDefense": 210 * Global.enKey,},
		"description": "通用，物理防御+210",
		"key":false,
		"added":false,#长寿村
		"gold": 150000
	},		
	
	
	"GM头盔":{
		"name": "GM头盔",
		"user": "all",
		"icon": "res://Icons/GM男头.png",
		"picture": "res://Pictures/GM战盔.png",
		"value": {"addPhysicDefense": 240 * Global.enKey,},
		"description": "物理防御+240",
		"key":false,
		"added":false,#长寿村
		"gold": 510000
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
	"飞蝗石":{
		"name": "飞蝗石",
		"type": "battleConsume",
		"bagPlace": "battleItem"
	},	
	"魔睛子":{
		"name": "魔睛子",
		"type": "battleConsume",
		"bagPlace": "battleItem"
	},		

	
	"佛手":{
		"name": "佛手",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"佛跳墙":{
		"name": "佛跳墙",
		"type": "consume",
		"bagPlace": "consumeItem"
	},
	"狗不理包子":{
		"name": "狗不理包子",
		"type": "consume",
		"bagPlace": "consumeItem"
	},
	"西瓜":{
		"name": "西瓜",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"怪力鱼":{
		"name": "怪力鱼",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"娃娃鱼":{
		"name": "娃娃鱼",
		"type": "consume",
		"bagPlace": "consumeItem"
	},		
	"鳊鱼":{
		"name": "鳊鱼",
		"type": "consume",
		"bagPlace": "consumeItem"
	},		
	"圣兽洗髓":{
		"name": "圣兽洗髓",
		"type": "keyItem",
		"bagPlace": "keyItem"
	},		
	
	"洗髓丹":{
		"name": "洗髓丹",
		"type": "keyItem",
		"bagPlace": "keyItem"
	},	
	"渔夫草帽":{
		"name": "渔夫草帽",
		"type": "keyItem",
		"bagPlace": "keyItem"
	},
	"可食用人参果":{
		"name": "可食用人参果",
		"type": "consume",
		"bagPlace": "consumeItem"
	},	
	"人参果":{
		"name": "人参果",
		"type": "keyItem",
		"bagPlace": "keyItem"
	},			
	"小还丹":{
		"name": "小还丹",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},	
	"金香玉":{
		"name": "金香玉",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},	
	"月饼":{
		"name": "月饼",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},
	"人参":{
		"name": "人参",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},			
	
	
	"仙狐涎":{
		"name": "仙狐涎",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},			
	"蛇蝎美人":{
		"name": "蛇蝎美人",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},			
	"老君仙丹":{
		"name": "老君仙丹",
		"type": "battleConsume",
		"bagPlace": "battleItem"		
	},				
	
}

# 假设 accessories / hat / cloth / shoes 这些字典都已定义

func add_items_to_addItemInfo():
	var categories = {
		"accessories": accessories,
		"hat": hat,
		"cloth": cloth, # 如果有的话就取消注释
		"shoes": shoes,
		"weapon": weapon,
	}
	
	for category_name in categories.keys():
		var category_dict = categories[category_name]
		
		for item_name in category_dict.keys():
			# 如果 addItemInfo 已经有这个物品名，就跳过
			if addItemInfo.has(item_name):
				continue
			
			# 否则添加进去
			addItemInfo[item_name] = {
				"name": item_name,
				"type": category_name,
				"bagPlace": "bagArmorItem"
			}


