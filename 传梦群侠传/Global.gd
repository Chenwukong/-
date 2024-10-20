extends Node



var monsterIdx = -1
var monsterRemain = false
var playerIdx = -1
var easyLevels = ["东海湾", "easy_level_2", "easy_level_3"]
var dangerScene = {"东海湾":3, "江南野外": 5, "锁妖塔2": 4,"锁妖塔3":4,"锁妖塔4":4,"锁妖塔6":5, "大唐国境": 8, "东海海道":5, "东海海道2":5,"东海海道3":5,"花果山":8,"海底迷宫1":8 
,"海底迷宫2":8 ,"海底迷宫3":8 ,"海底迷宫4":8 ,"海底迷宫5":8  }
var menuOut = false

var onAttackingList = []
var currAttacker = ""
var wait
var target = null
var monsterTarget = null
var onPhone = false
var onButton = false

var battleButtonIndex = 0

var onAttackPicking = false #是否在选择攻击对象
var onMagicAttackPicking = false
var playersAppended = false
var onMagicAttacking = false
var onAttacking = false

var onHitPlayer = []
var alivePlayers = []
var selectedTarget = false

var currPlayerMagic = []
var onMagicSelectPicking = false
var magicSelectIndex = 0
var currUsingMagic = null
var killedAmount = 0

signal autoAttackSignal

var onItemSelectPicking = false
var onItemUsePicking = false
var onItemUsing = false
var currUsingItem = null
var itemSelectIndex = 0
var itemList
var canCalculateAfterMulti = true
var currHitType = ""
var currPhysicDmg = 0
var currMagicDmg = 0
var dealtDmg = 0
var playerDirection = ""
var onHitEnemy = []
var onHitAllie = []
var canBlock = false
var blocked = false
var allieSelectIndex = 0
var allieTarget = null
var buffTarget = []
var usingDart = false
var onItemSelect
var onItemIndexSelect
var currMenuItem
var onMenuItemUsing
var showBlack = true
var itemPlayers = []
var itemPlayerIndex
var canAttack = false
func connectAutoAttackSignal(enemy_instance):
	enemy_instance.connect('autoAttackSignal', self, '_on_auto_attack')
var noSounds = false
func _on_auto_attack():
	print("Auto attack signal received")
var lost = false
var targetMonsterIdx = 0
var playerMagicList
var lastMagic = {"magicInfo":null}
var finishingBattle = false
var onMenuSelectCharacter = false
var onItemPage = false
var onMagicPage = false
var onStatusPage = false
var onArmorItemPage = false
var onSkillPointPage = false
var onMouse = false
var onFight = false
var canLose = false
var itemControlType = "keyboard"
var key = 1
var currUsingItemPlayer
var onTalk = false
var onQuitMenu = false
var onSavePage = false
var onLoadPage = false
var currShopItem 
var canEnemyHit = true
var onQuest = false
var onMultiHit = 0
var fangCunState = 1
var atDark = false
var onBoss = false
var cantShow = ["东海海道", "长安北","长安镖局", "长安","花果山","海底迷宫1","女儿村", "地府"]
var bgmList = [
	"res://Audio/BGM/战斗-城市.mp3",
	"res://Audio/BGM/战斗-森林.mp3",
	"res://Audio/BGM/战斗-步天阶.ogg", 
	"res://Audio/BGM/战斗-水浒.mp3",
	"res://Audio/BGM/战斗-雪.mp3",
	"res://Audio/BGM/战斗Y.mp3",
	"res://Audio/BGM/战斗-九龙.mp3",
	#"res://Audio/BGM/战斗-Y.mp3",
	#"res://Audio/BGM/战斗-BOSS 正义.mp3",
	"res://Audio/BGM/战斗-仙剑.mp3",
	"res://Audio/BGM/战斗-任务.mp3",
	"res://Audio/BGM/金庸-战斗.mp3",
	"res://Audio/BGM/黄鹤遗址.ogg",
	"res://Audio/BGM/战斗草原.mp3",
	"res://Audio/BGM/轩辕-战斗.mp3",
	"res://Audio/BGM/轩辕-战斗2.mp3",
	#"res://Audio/BGM/P39.mp3",
	"res://Audio/BGM/大话三国 (1).ogg", 
	"res://Audio/BGM/战斗-生肖.ogg",
	"res://Audio/BGM/战斗-生肖2.ogg",
	"res://Audio/BGM/战斗-梦想1.ogg",
	"res://Audio/BGM/网易游戏 - 战斗7-山地.mp3",
	"res://Audio/BGM/战斗5.ogg",
	"res://Audio/BGM/战斗2.ogg",
	"res://Audio/BGM/战斗1.ogg",
	"res://Audio/BGM/战斗0.ogg",
	#"res://Audio/BGM/战斗-梦想3.ogg",
	"res://Audio/BGM/【战斗】传说开始的地方.mp3",
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗一 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗一(Av995118947,P1).mp3", 
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗三 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗三(Av312602269,P1).mp3", 
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗二 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗二(Av740045895,P1).mp3", 
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——特殊事件二 - 1.《大侠立志传》游戏音乐BGM纯享版——特殊事件二(Av570749068,P1).mp3"
	#"res://Audio/BGM/【战斗】神话降临.mp3",
	#"res://Audio/BGM/【镜影命缘】.mp3",
	]
#保存的
var questItem = {}
var atNight = false
var currentCamera
var currPlayer
var currScene
var onTeamPlayer = ["时追云",]
var onTeamPet = []
var onTeamSmallPet = []
var currPlayerPos
var currNpc = null
var saveIndex = 0
var petTarget
var systemMsg = [
	
]
var onPet = false
var onSkipFight = false
var violencePoint = 0
var questHint = ""

var damageReward1 = 1

var chapters = {
	"chapter1": {"completed": false, "tasks": {"task1": false, "task2": false}},
	"chapter2": {"completed": false, "tasks": {"task3": false}},
	# 直到 chapter10
}

var tempValue = 0
var arDark = false
var current_chapter_id = 1

var mcVisible = true
var npcVis = {
	"东海湾":{
		"鱼叟":{"visible" : true},
		"大海龟":{"visible" : true},
		"丁真":{"visible" : true},
		"丁真2":{"visible" : false},
		"丙假":{"visible" : true},
		"王姨":{"visible" : false},
		"巨蛙":{"visible" : false},
		"奔霸":{"visible" : false},
		"小兵":{"visible" : false},
		"小兵2":{"visible" : false},
		"小兵3":{"visible" : false},
		"小兵4":{"visible" : false},
		"小兵5":{"visible" : false},
		"小兵6":{"visible" : false},
	},
	"建邺城":{
		"城主": {"visible" : false},
		"乞丐": {"visible" : false},
		"管家": {"visible" : false},
		"王大锤": {"visible" : true},
		"王大锤2": {"visible" : false},
		"乞丐2": {"visible" : false},
	},
	"建邺城右":{
		"难民": {"visible" : true},
		"二娃": {"visible" : false},
		"威迪": {"visible" : true},
		"威迪2": {"visible" : false},
		"二娃2": {"visible" : false},
		"城主": {"visible" : false},
		"王姨": {"visible" : false},
		"柳老": {"visible" : false},
		"姜韵": {"visible" : false},
		"小兵": {"visible" : false},
		"小兵2": {"visible" : false},
		"小兵3": {"visible" : false},
		"小兵4": {"visible" : false},
		"小兵5": {"visible" : false},
		"小兵6": {"visible" : false},
		"小兵7": {"visible" : false},
		"小兵8": {"visible" : false},
		"小兵9": {"visible" : false},
		"敖阳": {"visible" : false},
		"妖魔尸体": {"visible" : false},
		"妖魔尸体2": {"visible" : false},
		"妖魔尸体3": {"visible" : false},
		"妖魔尸体4": {"visible" : false},
		"妖魔尸体5": {"visible" : false},
		"妖魔尸体6": {"visible" : false},
		"妖魔尸体7": {"visible" : false},
		"妖魔尸体8": {"visible" : false},
		"妖魔尸体9": {"visible" : false},
		"妖魔尸体10": {"visible" : false},
		"妖魔尸体11": {"visible" : false},
		"妖魔尸体12": {"visible" : false},
		"妖魔尸体13": {"visible" : false},
		"妖魔尸体14": {"visible" : false},
		"妖魔尸体15": {"visible" : false},
		"妖魔尸体16": {"visible" : false},
		"妖魔尸体17": {"visible" : false},
		"妖魔尸体18": {"visible" : false},
		"堆积妖魔": {"visible" : false},
		"堆积妖魔2": {"visible" : false},
		"堆积妖魔3": {"visible" : false},
		"堆积妖魔4": {"visible" : false},
		"堆积妖魔5": {"visible" : false},
		
		
		
		
	},
	"李善人家1":{
		"管家": {"visible" : true},
	},
	"李善人家2":{
		"城主": {"visible" : true},
	},
	"建邺布店":{
		"蒙布郎": {"visible" : true},
	},	
	"建邺药店":{
		"柳老": {"visible" : true},
		"王姨": {"visible" : true},
	},
	"时追云家":{
		"姜韵": {"visible" : true},
	},
	"江南野外":{
		"牛妖": {"visible" : true},
		"羊妖": {"visible" : true},
		"小二": {"visible" : true},
		"小二2": {"visible" : false},
		"王婆": {"visible" : true},
		"npc": {"visible" : true},
	},
	"大唐官府":{
		"程咬金": {"visible" : false},
	},		
	"大唐官府大厅":{
		"程咬金": {"visible" : false},
		"金甲": {"visible" : false},
	},	
	"长安城":{
		"警戒士兵": {"visible" : false},
		"乞丐": {"visible" : true},
		"凌若昭": {"visible" : false},		
		"提毗": {"visible" : false},
		
				
	},
	"长安北":{
		"看守": {"visible" : true},
		"金甲3": {"visible" : false},
		"小二2": {"visible" : true},
	},
	"锁妖塔1":{
		"凌若昭":{"visible": true}
	},
	"锁妖塔2":{
		"鳄额呃":{"visible": true}
	},
	"锁妖塔3":{
		"鼠老大":{"visible": true}
	},
	"锁妖塔4":{
		"黑熊王":{"visible": true}
	},
	"锁妖塔5":{
		"蒙面人":{"visible": true}
	},
	"锁妖塔6":{
		"千年树":{"visible": true}
	},
	"锁妖塔7":{
		"鹰孽大王":{"visible": true},
		"小二":{"visible": false},
		"凌若昭":{"visible": false},
		"金甲":{"visible": false},
		"金甲2":{"visible": false},
	},
	"大唐国境":{
		"反贼小头目":{"visible": true},
		"npcs":{"visible":true}
	},	
	"国境北":{
		"反贼大头目":{"visible": true},
		"npcs":{"visible":true}
	},
	"国境南":{
		"反贼大头目":{"visible": true},
		"npcs":{"visible":true}
	},
	"平定峰":{
		"堕逝": {"visible":true},
		"程咬金": {"visible":true},
		"鹰狂": {"visible":true},
		"npcs":{"visible":true}
	},
	"方寸山":{
		"提毗": {"visible":true},
		"黑山": {"visible":true},
		"菩提老祖": {"visible":false},
		"凌若昭": {"visible":false},
		"小二": {"visible":false},
		"小师弟": {"visible":true},
		"小师弟2": {"visible":true},
		"小师弟3": {"visible":true},
		"小鹿": {"visible":false},
		"碧玉剑": {"visible":false},
		
	},
	"方寸厢房":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
	},
	"灵台宫":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},
		"菩提老祖": {"visible":true},
	},
	"水晶宫":{
		"敖雨": {"visible":true},
		"敖阳": {"visible":true},
		"南海龙王": {"visible":true},
		"北海龙王": {"visible": true},
		"西海龙王": {"visible": true}	
	
	},
	"东海龙宫":{
		"敖雨": {"visible":false},
		"敖阳": {"visible":false},
		"敖雨2": {"visible":false},
		"小二": {"visible":false},
		"凌若昭": {"visible":false},
	},		
	"敖阳寝宫":{
		"敖雨": {"visible":true},
		"敖阳": {"visible":true},
	},		
	"龙泉":{
		"碧水夜叉": {"visible":true},
		"敖阳": {"visible":false},
	},			
	"海斗场":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
		"巨蛙": {"visible":true},
		"敖雨": {"visible":true},
		"北海龙王": {"visible":true},
		"西海龙王": {"visible":true},
		"南海龙王": {"visible":true},
	},	
	"傲来船":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
		"敖阳": {"visible":true},
		"敖雨": {"visible":true},

	},		
	
	"傲来国":{
		"老李头": {"visible":true},
		"黑蝠": {"visible":true},
		"npcs": {"visible":false},
		"npcs2": {"visible":false},
		"逆无邪": {"visible":false},
		"上官冕": {"visible":false},
	},		
	"傲来民居":{
		"大生": {"visible":true},
	},		
	"女儿村":{
		"逆无邪": {"visible":true},
	},			
	"女儿村村长家":{
		"逆无邪": {"visible":true},
		"上官冕": {"visible":true},
	},			
	"花果山":{
		"大鹏": {"visible":true},
		"大鹏2": {"visible":true},
		"黑蝠": {"visible":true},
		"黑蝠2": {"visible":true},		
		"敖阳": {"visible": false},		
		"黑蝠3": {"visible":true},	
		"兔子精": {"visible":true},	
		"蛤蟆精": {"visible":true},	
		"npcs": {"visible":false},	
		"凌若昭": {"visible":false},	
		"敖阳2": {"visible":false},	
		"小二": {"visible":false},	
		"奔霸": {"visible":true},	
		"敖雨": {"visible":false},	
	},		
	"水帘洞":{
		"敖阳": {"visible":false},
		"敖雨": {"visible":false},
		"小二": {"visible":false},
		"凌若昭": {"visible":false},		
		
	},			
	"两界山":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},		
		
	},	
										
}

var musicOn = true
var enKey = randi_range(1, 3000)
var quests ={
	"方寸罗师兄":{"小师弟":0, "complete":false},
	"传梦之路":{"传":false,"梦":false,"之":false,"路":false,      "complete":false}
}

func changeVis(npcList: Array, scene) -> void:
	for npc in npcList:
		npcVis.get(scene).get(npc).visible = !npcVis.get(scene).get(npc).visible

		
var load = false
var npcs = {
	"鱼叟": {
		"dialogues": [ 
			#0
			{"chapter": 1, "dialogue": "鱼叟初次见面", "unlocked": true, "bgm":null, "trigger":false},
			{"chapter": 1, "dialogue": "鱼叟第二天见面", "unlocked": false, "bgm":null,"trigger":false},
			{"chapter": 1, "dialogue": "鱼叟告别", "unlocked": false, "bgm":null,"trigger":false}
		],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"大海龟":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "遇见海龟", "unlocked": false, "bgm":"res://Audio/BGM/幽默 - 05.mp3",},
			],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"丁真":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "初见两兵", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "二见两兵", "unlocked": false, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"丙假":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "初见两兵", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "二见两兵", "unlocked": false, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"姜韵":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "初见女主", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "二见女主", "unlocked": false, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "三见女主", "unlocked": false, "bgm":null,"trigger":false},
				
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"二娃":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "二娃请求", "unlocked": true, "bgm":"res://Audio/BGM/幽默 - 04.mp3","trigger":false},
				{"chapter": 1, "dialogue": "还木剑", "unlocked": false, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
		
	"蒙布郎":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "建邺布老板", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},
	"城主":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "城主施舍", "unlocked": false, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "索要木剑", "unlocked": false, "bgm":"res://Audio/BGM/幽默 - 04.mp3","trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"王姨":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "王姨尖叫", "unlocked": false, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "王姨遇险", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "王姨得救", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},
	"柳老":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "建邺药老板", "unlocked": false, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": true
	},
	"管家":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "管家请求", "unlocked": false, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "管家交付", "unlocked": false, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"威迪":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "威迪", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": true
	},		
	"王大锤":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "王大锤", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": true		
	},
	
	
	"奔霸":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "初见奔霸", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},
	"system":{
		"dialogues": [
			#0
				{"chapter": 1, "dialogue": "时追云杀完", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "时追云杀完2", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "时追云杀完3", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "杀戮", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "时追云进城", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "时追云赶到", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "白龙救场", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "安葬", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 1, "dialogue": "斩妖", "unlocked": true, "bgm":null,"trigger":false},
				
				{"chapter": 2, "dialogue": "初见小二", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "解释抢钱", "unlocked": true, "bgm":null,"trigger":false}, #10
				
				{"chapter": 2, "dialogue": "程咬金登场", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "金甲帮书生", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "小二休息", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "王婆卖瓜", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "打赢王婆", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "起床找金甲", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "传出塔外", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 2, "dialogue": "首入国境", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 3, "dialogue": "破甲术", "unlocked": true, "bgm":null,"trigger":false},
				{"chapter": 3, "dialogue": "又失眠", "unlocked": true, "bgm":null,"trigger":false}, #20
				{"chapter": 3, "dialogue": "听见异响", "unlocked": true, "bgm":"res://Audio/BGM/0妖族阴谋.mp3","trigger":false},
				{"chapter": 3, "dialogue": "离山", "unlocked": true, "bgm":null ,"trigger":false},
				{"chapter": 3, "dialogue": "重回建邺", "unlocked": true, "bgm":null ,"trigger":false},
				{"chapter": 3, "dialogue": "东海海道", "unlocked": true, "bgm":null ,"trigger":false}, #23
				{"chapter": 4, "dialogue": "逛傲来", "unlocked": true, "bgm":null ,"trigger":false},
				{"chapter": 4, "dialogue": "初进花果山", "unlocked": true, "bgm":null ,"trigger":false},
				{"chapter": 4, "dialogue": "打败大鹏", "unlocked": true, "bgm":null ,"trigger":false},
				
			],
		"current_dialogue_index": 0,	
		"constNpc": false	},	
	"传梦":{
		"dialogues": [
				#0
					{"chapter": 1, "dialogue": "新手警告", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 1, "dialogue": "送物资", "unlocked": true, "bgm":null,"trigger":false},
					
				],
			"current_dialogue_index": 0,	
			"constNpc": false
		},	
	"老鸨":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "进妓院", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true	
	},
	"金甲":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "解围金甲", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "结识金甲", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "金甲吃饭", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "金甲再帮书生", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "帮郎中", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "看望霍嫬儿", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "金甲解释", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "查看凶案", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "金甲塔外", "unlocked": false, "bgm":null,"trigger":false},
					
					{"chapter": 2, "dialogue": "进塔", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "塔2", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "塔3", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "塔4", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "塔5", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "塔6", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 2, "dialogue": "看望金甲", "unlocked": true, "bgm":null,"trigger":false},			
					{"chapter": 2, "dialogue": "遮儿学医", "unlocked": true, "bgm":null,"trigger":false},				
				],
			"current_dialogue_index": 0,	
			"constNpc": false	
	},
	"牛冠军":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "叫你交钱", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true
		},		
	"擂台管理":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "交钱", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true
		},
	"打赢牛冠军":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "打赢牛冠军", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true		
	},
	"围观群众1":{
		"dialogues": [ 
				#0
					{"chapter": 2, "dialogue": "围观群众1", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},
	"围观群众2":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "围观群众2", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},
	"围观群众3":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "围观群众3", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},	
	"围观群众6":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "围观群众6", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},
	"画陀":{
		"dialogues": [
			#0
				{"chapter": 2, "dialogue": "画陀", "unlocked": true, "bgm":null,"trigger":false},
			],
		"current_dialogue_index": 0,	
		"constNpc": true		
	},		
	"周周":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "周周", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},			
	"铁匠":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "铁匠", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},				
	"傲来武器铺老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "傲来武器铺老板", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},		
	
	"傲来布店老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "傲来布店老板", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true				
	},		


	"小二":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "当诱饵", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢鼠先锋", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 3, "dialogue": "方寸夜晚小二谈恋爱", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 3, "dialogue": "方寸夜晚小二谈恋爱2", "unlocked": true, "bgm":"res://Audio/BGM/聂薇 - 墨家村-夜晚.mp3","trigger":false},
					
				],
			"current_dialogue_index": 0,	
			"constNpc": false			
	},	
	"酒店老板":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "酒店休息", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true			
	},
	"傲来酒店老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "酒店休息", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true			
	},				
	"守门兵甲":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "守门兵甲", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true							
	},
	"守门兵乙":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "守门兵乙", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true							
	},	
	"爷傲奈我何":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "爷傲奈我何", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打败爷傲", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false							
	},		
	"师爷":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "求加固", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "告诉金甲", "unlocked": false, "bgm": null,"trigger":false},
				],
		"current_dialogue_index":0,	
		"constNpc": false							
	},	
	"凌若昭":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "初见若昭", "unlocked": false, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "再见凌若昭", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "传送方寸", "unlocked": false, "bgm":null,"trigger":false},
					{"chapter": 3, "dialogue": "假方寸", "unlocked": false, "bgm":null,"trigger":false},				
					{"chapter": 3, "dialogue": "真方寸山", "unlocked": true, "bgm":"","trigger":false},
	
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false							
	},	
	"方寸山秘境":{
		"dialogues": [
				{"chapter": 3, "dialogue": "遣返", "unlocked": true, "bgm":"res://Audio/BGM/幽默 - 04.mp3","trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false							
	},	
		
	
	"鳄额呃":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔2boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢塔2boss", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},
	"鼠老大":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔3boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢塔3boss", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},		
	"黑熊王":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔4boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢塔4boss", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},	
	"蒙面人":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔5boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢塔5boss", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},	
	"千年树":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔6boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "打赢塔6boss", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},
	"鹰孽大王":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "塔7boss", "unlocked": true, "bgm": "res://Audio/BGM/0情况危机.ogg","trigger":false},
					{"chapter": 2, "dialogue": "打赢塔7boss", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 2, "dialogue": "金甲牺牲", "unlocked": true, "bgm":null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},
	"反贼小头目":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "反贼小头目", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 2, "dialogue": "打死反贼小头目", "unlocked": true, "bgm": "","trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},				
	"反贼大头目":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "反贼大头目", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 2, "dialogue": "打死反贼大头目", "unlocked": true, "bgm": "","trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},
	"程咬金":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "平定峰", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 2, "dialogue": "打死堕逝", "unlocked": true, "bgm": null, "trigger":false},
					{"chapter": 2, "dialogue": "程咬金切磋", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 2, "dialogue": "学习横扫千军", "unlocked": true, "bgm": null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false			
	},			
	"提毗":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "提毗", "unlocked": true, "bgm": null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true			
	},	
	"黑山":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "闯山", "unlocked": true, "bgm": "res://Audio/BGM/圆周率 - 优雅嘲讽.mp3","trigger":false},
					{"chapter": 3, "dialogue": "落败黑山", "unlocked": true, "bgm": "res://Audio/BGM/幽默2.mp3","trigger":false},
					{"chapter": 3, "dialogue": "想策", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 3, "dialogue": "被勾引", "unlocked": true, "bgm":"res://Audio/BGM/庄严快节奏.mp3",  "trigger":false},
					{"chapter": 3, "dialogue": "登顶", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 3, "dialogue": "击败黑山前", "unlocked": false, "bgm": null,"trigger":false},
					{"chapter": 3, "dialogue": "击败黑山后", "unlocked": false, "bgm": null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false		
	},	
	"菩提老祖":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "初见菩提", "unlocked": true, "bgm":"res://Audio/BGM/#豪爽.ogg" ,"trigger":false},
					{"chapter": 3, "dialogue": "厢房休息", "unlocked": true, "bgm":null ,"trigger":false},
					{"chapter": 3, "dialogue": "菩提解惑", "unlocked": true, "bgm":"res://Audio/BGM/#豪爽.ogg" ,"trigger":false},
					{"chapter": 3, "dialogue": "教学千机", "unlocked": true, "bgm":"res://Audio/BGM/#豪爽.ogg" ,"trigger":false},
					{"chapter": 3, "dialogue": "篝火烧烤", "unlocked": true, "bgm": "res://Audio/BGM/欢乐家园.mp3","trigger":false},
					{"chapter": 3, "dialogue": "送丹药", "unlocked": true, "bgm":null ,"trigger":false},
					{"chapter": 3, "dialogue": "告知打赢", "unlocked": true, "bgm":null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false		
	},									
	"罗师兄":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "初见罗师兄", "unlocked": true, "bgm":null ,"trigger":false},
					{"chapter": 3, "dialogue": "完成罗任务", "unlocked": true, "bgm":null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false		
	},		
	"小师弟":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "小师弟", "unlocked": true, "bgm":null ,"trigger":false},
					{"chapter": 3, "dialogue": "教训师弟", "unlocked": true, "bgm":null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"机关人":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "机关人", "unlocked": true, "bgm":null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},			
	"傲来钱庄老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "傲来钱庄老板", "unlocked": true, "bgm":null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},				
	"傲来杂货铺老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "傲来杂货铺老板", "unlocked": true, "bgm":null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},		
	"傲来药店老板":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "傲来药店老板", "unlocked": true, "bgm":null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},		
	"祭坛守卫":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "祭坛守卫", "unlocked": true, "bgm":null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},							
	"灵鹿":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "灵鹿", "unlocked": true, "bgm":"res://Audio/BGM/燕子与小狗.mp3" ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},					
	"敖阳":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "龙王聚会", "unlocked": true, "bgm": "res://Audio/BGM/0情况危机.ogg" ,"trigger":false},
					{"chapter": 3, "dialogue": "吸魂", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},						
	"碧玉剑":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "黑山送剑", "unlocked": true, "bgm":  "res://Audio/BGM/四个人的幸福时光.mp3" ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"敖雨":{
		"dialogues": [
				#0
					{"chapter": 3, "dialogue": "初遇敖雨", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 3, "dialogue": "解除误会", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 3, "dialogue": "敖阳寝宫", "unlocked": true, "bgm": null ,"trigger":false},
					
					{"chapter": 3, "dialogue": "传送海斗场", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 3, "dialogue": "第一轮决斗", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "第二轮决斗", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "第三轮决斗", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "第四轮决斗", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "偷龙泉", "unlocked": true, "bgm": "res://Audio/BGM/2-阴谋.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "第五轮决斗", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "围殴", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "敖阳到场", "unlocked": true, "bgm": "res://Audio/BGM/00黎明破晓.mp3" ,"trigger":false},
					{"chapter": 3, "dialogue": "去寻奔霸", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 3, "dialogue": "玉箍棒", "unlocked": true, "bgm": "res://Audio/BGM/许镜清 - 云宫迅音.mp3" ,"trigger":false}, #12
					{"chapter": 3, "dialogue": "离开东海龙宫", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 3, "dialogue": "傲来船", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "沉船", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "近海恶蛟", "unlocked": true, "bgm": "res://Audio/BGM/0情况危机.ogg" ,"trigger":false},
					{"chapter": 4, "dialogue": "初到傲来国", "unlocked": true, "bgm": "res://Audio/BGM/幽默 - 02.mp3" ,"trigger":false},
					
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"老李头":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "救老李头", "unlocked": true, "bgm": "res://Audio/BGM/庄严2.mp3" ,"trigger":false},
					{"chapter": 4, "dialogue": "老李头感谢", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "老李头死", "unlocked": true, "bgm": "res://Audio/BGM/春天.ogg" ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"大生":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "大生猜题", "unlocked": true, "bgm": "res://Audio/BGM/O妖魔.mp3" ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"锦纹":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "锦纹找武器", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "还锦纹武器", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"逆无邪":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "初见逆无邪", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打败逆无邪", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"龟丞相":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "龟丞相", "unlocked": true, "bgm": "res://Audio/BGM/Immediate Music - Dark Side Of Power (No Choir).mp3","trigger":false},
					{"chapter": 4, "dialogue": "打死龟丞相", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 4, "dialogue": "走出祭堂", "unlocked": true, "bgm": "res://Audio/BGM/0众志成城.mp3","trigger":false},
					{"chapter": 4, "dialogue": "花果山前", "unlocked": true, "bgm": "res://Audio/BGM/千山.ogg","trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
				
	"珍珠姐妹":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "珍珠姐妹", "unlocked": true, "bgm": "res://Audio/BGM/临敌2.ogg" ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢珍珠姐妹", "unlocked": true, "bgm": null,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},						
	"上官冕":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "初见上官冕", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"黑蝠":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "杀双黑蝠", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"兵分两路":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "兵分两路", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"回归队伍":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "回归队伍", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	
	
	"蛤蟆精":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "蛤蟆精", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打败蛤蟆精", "unlocked": true, "bgm": "res://Audio/BGM/SWD5 临敌.mp3" ,"trigger":false},
					{"chapter": 4, "dialogue": "上官冕看情况", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "水帘洞内", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"老猴子":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "初见老猴子", "unlocked": true, "bgm": "res://Audio/BGM/胡寅寅 - 大圣歌.mp3" ,"trigger":false},
					{"chapter": 4, "dialogue": "上官冕发现失踪", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "老猴子疗伤", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "上官冕鼓舞", "unlocked": true, "bgm": "res://Audio/BGM/0众志成城.mp3" ,"trigger":false},
					{"chapter": 4, "dialogue": "等来支援", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "洞外碰面", "unlocked": true, "bgm": "res://Audio/BGM/0众志成城.mp3" ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"花果山拦敌":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "花果山拦敌1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "花果山拦敌2", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "花果山拦敌3", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "再见奔霸", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢奔霸1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "敖雨死亡", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢奔霸2", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢奔霸3", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢奔霸4", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢奔霸5", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "打赢胜仗", "unlocked": true, "bgm": "res://Audio/BGM/鼓励友情.mp3" ,"trigger":false},					
					{"chapter": 4, "dialogue": "时追云伤感", "unlocked": true, "bgm":  "res://Audio/BGM/#诗梦.mp3","trigger":false},		
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"前往地府":{
		"dialogues": [
				#0
					{"chapter": 4, "dialogue": "回方寸", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "回方寸第二天", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "两界山", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "到地府入口", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 4, "dialogue": "阴阳洞", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	
} 
var potentialBalls = {

}

var petFoodBalls = {
	
}

var treasureBox = {
	
}
var autoDialogue = {
	"chapter1":{
		"男主开头说话":{"dialogue":"男主开头说话", "trigger":false}
	}
}

var storyVars = {
	
}
var vis
var mapPlayerPos = Vector2(0, 0)
var haveLantern = false
var saveData = {}
var onHurry = false
var default_trigger_places
var saved_trigger_places
var totalPotentialBall = 0
var uniqueId
var countDown = false
var triggerPlace ={
	"新手警告": {"trigger":false, "disable": false},
	"二娃请求": {"trigger":false, "disable": true},
	"城主施舍": {"trigger":false, "disable": true},
	"王姨尖叫": {"trigger":false, "disable": true},
	"王姨遇险": {"trigger":false, "disable": true},
	"管家请求": {"trigger":false, "disable": true},
	"初见奔霸": {"trigger":false, "disable": true},
	"时追云杀完2": {"trigger":false, "disable": true},
	"时追云杀完3": {"trigger":false, "disable": true},
	"杀戮": {"trigger":false, "disable": true},
	"时追云进城": {"trigger":false, "disable": true},
	"时追云赶到": {"trigger":false, "disable": true},
	"斩妖": {"trigger":false, "disable": true},
	"初见小二": {"trigger":false, "disable": false},
	"小二休息": {"trigger":false, "disable": false},
	"王婆卖瓜": {"trigger":false, "disable": false},
	"解围金甲": {"trigger":false, "disable": false},
	"初见若昭": {"trigger":false, "disable": true},
	"进塔": {"trigger":false, "disable": false},
	"再见凌若昭": {"trigger":false, "disable": false},
	"塔2": {"trigger":false, "disable": false},
	"塔3": {"trigger":false, "disable": false},
	"塔4": {"trigger":false, "disable": false},
	"塔5": {"trigger":false, "disable": false},
	"塔6": {"trigger":false, "disable": false},
	"首入国境": {"trigger":false, "disable": false},
	"平定峰": {"trigger":false, "disable": false},
	"遣返": {"trigger":false, "disable": true},
	"登顶": {"trigger":false, "disable": false},
	"教学千机": {"trigger":false, "disable": true},
	"方寸夜晚小二谈恋爱2": {"trigger":false, "disable": true},
	"听见异响": {"trigger":false, "disable": true},
	"黑山送剑": {"trigger":false, "disable": true},
	"真方寸山": {"trigger":false, "disable": false},
	"重回建邺": {"trigger":false, "disable": true},
	"东海海道": {"trigger":false, "disable": false},
	"玉箍棒": {"trigger":false, "disable": true},
	"救老李头": {"trigger":false, "disable": false},
	"老李头死": {"trigger":false, "disable": true},
	"兵分两路": {"trigger":false, "disable": false},
	"花果山拦敌1": {"trigger":false, "disable": false},
	"花果山拦敌2": {"trigger":false, "disable": false},
	"花果山拦敌3": {"trigger":false, "disable": false},
	"再见奔霸": {"trigger":false, "disable": false},
	"到地府入口": {"trigger":false, "disable": false},
}

var isDead ={
	"塔5boss": false
}


func _ready():
	currScene = get_tree().get_current_scene().get_name()
	uniqueId = OS.get_unique_id()
	#FightScenePlayers.fightScenePlayerData['时追云'].additionDmg *= 10
	
var deltas


func _process(delta):
	
	
	deltas = delta
	currScene = get_tree().get_current_scene().get_name()
	if npcs["system"].current_dialogue_index == 5 and get_tree().current_scene.name == "建邺城右" :
		get_tree().current_scene.get_node("姜韵").play("dead")
		get_tree().current_scene.get_node("二娃2").play("dead")
		get_tree().current_scene.get_node("木剑").visible = true
		
		if npcs["system"].current_dialogue_index > 7:
			if get_tree().current_scene.get_node("木剑"):
				get_tree().current_scene.get_node("木剑").visible = false


func save():
	saveData.currScene = currScene
	saveData.currPlayer = currPlayer
	saveData.onTeamPlayer = onTeamPlayer
	saveData.currentCamera = currentCamera
	saveData.atNight = atNight
	saveData.currPlayerPos = currPlayerPos
	saveData.currNpc = currNpc
	saveData.systemMsg = systemMsg
	saveData.chapters = chapters
	saveData.current_chapter_id = current_chapter_id
	saveData.npcs = npcs
	saveData.potentialBalls = potentialBalls
	saveData.petFoodBalls = petFoodBalls
	saveData.saveIndex = saveIndex
	saveData.mapPlayerPos = mapPlayerPos
	saveData.autoDialogue = autoDialogue
	saveData.storyVars = storyVars	
	saveData.npcVis = npcVis	
	saveData.haveLantern = haveLantern
	saveData.triggerPlace = triggerPlace
	saveData.killAmount = killedAmount
	saveData.dangerScene = dangerScene
	saveData.questItem = questItem
	saveData.onHurry = onHurry
	saveData.onQuest = onQuest
	saveData.onSkipFight = onSkipFight
	saveData.violencePoint = violencePoint
	saveData.questHint = questHint
	saveData.onTeamPet = onTeamPet
	saveData.treasureBox = treasureBox
	saveData.isDead = isDead
	saveData.fangCunState = fangCunState
	saveData.quests = quests
	saveData.uniqueId = uniqueId
	saveData.cantShow = cantShow
	saveData.onTeamSmallPet = onTeamSmallPet
func loadData():
	onTeamSmallPet = saveData.onTeamSmallPet 
	currScene = saveData.currScene
	currPlayer = saveData.currPlayer
	onTeamPlayer = saveData.onTeamPlayer
	currentCamera  =saveData.currentCamera
	atNight = saveData.atNight
	currPlayerPos  =saveData.currPlayerPos
	currNpc  =saveData.currNpc 
	systemMsg  =saveData.systemMsg
	chapters  =saveData.chapters
	current_chapter_id = saveData.current_chapter_id 
	npcs  =saveData.npcs
	potentialBalls  =saveData.potentialBalls
	petFoodBalls = saveData.petFoodBalls
	saveIndex = saveData.saveIndex
	mapPlayerPos = saveData.mapPlayerPos
	storyVars = saveData.storyVars
	autoDialogue = saveData.autoDialogue
	npcVis = saveData.npcVis 
	haveLantern = saveData.haveLantern
	triggerPlace = saveData.triggerPlace
	killedAmount = saveData.killAmount
	dangerScene = saveData.dangerScene
	questItem = saveData.questItem
	onHurry = saveData.onHurry
	onQuest = saveData.onQuest
	onSkipFight = saveData.onSkipFight
	violencePoint = saveData.violencePoint
	questHint = saveData.questHint
	onTeamPet = saveData.onTeamPet
	fangCunState = saveData.fangCunState
	quests = saveData.quests
	cantShow = saveData.cantShow
	if saveData.has("isDead"):
		isDead = saveData.isDead
	if saveData.has("treasureBox"):
		treasureBox = saveData.treasureBox
	uniqueId = saveData.uniqueId
	default_trigger_places = {
		"新手警告": {"trigger": false, "disable": false},
		"二娃请求": {"trigger": false, "disable": true},
		"城主施舍": {"trigger": false, "disable": true},
		"王姨尖叫": {"trigger": false, "disable": true},
		"王姨遇险": {"trigger": false, "disable": true},
		"管家请求": {"trigger": false, "disable": true},
		"初见奔霸": {"trigger": false, "disable": true},
		"时追云杀完2": {"trigger": false, "disable": true},
		"时追云杀完3": {"trigger": false, "disable": true},
		"杀戮": {"trigger": false, "disable": true},
		"时追云进城": {"trigger": false, "disable": true},
		"时追云赶到": {"trigger": false, "disable": true},
		"斩妖": {"trigger": false, "disable": true},
		"初见小二": {"trigger": false, "disable": false},
		"小二休息": {"trigger": false, "disable": false},
		"王婆卖瓜": {"trigger": false, "disable": false},
		"解围金甲": {"trigger":false, "disable": false},
		"初见若昭": {"trigger":false, "disable": true},
		"进塔": {"trigger":false, "disable": false},
		"再见凌若昭": {"trigger":false, "disable": false},
		"塔2": {"trigger":false, "disable": false},
		"塔3": {"trigger":false, "disable": false},		
		"塔4": {"trigger":false, "disable": false},
		"塔5": {"trigger":false, "disable": false},	
		"塔6": {"trigger":false, "disable": false},
		"首入国境": {"trigger":false, "disable": false},
		"平定峰": {"trigger":false, "disable": false},
		"遣返": {"trigger":false, "disable": true},
		"登顶": {"trigger":false, "disable": false},
		"真方寸山": {"trigger":false, "disable": false},
		"教学千机": {"trigger":false, "disable": true},
		"方寸夜晚小二谈恋爱2": {"trigger":false, "disable": true},
		"听见异响": {"trigger":false, "disable": true},
		"黑山送剑": {"trigger":false, "disable": true},
		"重回建邺": {"trigger":false, "disable": true},
		"东海海道": {"trigger":false, "disable": false},
		"玉箍棒": {"trigger":false, "disable": true},
		"救老李头": {"trigger":false, "disable": false},
		"老李头死": {"trigger":false, "disable": true},
		"兵分两路": {"trigger":false, "disable": false},
		"花果山拦敌1": {"trigger":false, "disable": false},
		"花果山拦敌2": {"trigger":false, "disable": false},
		"花果山拦敌3": {"trigger":false, "disable": false},
		"再见奔霸": {"trigger":false, "disable": false},
		"到地府入口": {"trigger":false, "disable": false},
		
	}
	# Ensure saved data has all default places, add if missing
	saved_trigger_places = saveData.triggerPlace if saveData.has("triggerPlace") else {}
	for key in default_trigger_places.keys():
		if not saved_trigger_places.has(key):
			saved_trigger_places[key] = default_trigger_places[key]
	triggerPlace = saved_trigger_places		
	get_tree().change_scene_to_file("res://Scene/"+saveData.currScene+".tscn")
func turnDark():
	var current_scene = get_tree().current_scene
	current_scene.modulate = "000000"
func passNight():
	var current_scene = get_tree().current_scene
	
	current_scene.get_node("subSound").stream = load("res://Audio/ME/公鸡打鸣.ogg")
	current_scene.get_node("subSound").play()
	current_scene.get_node("AudioStreamPlayer2D").play()
	if current_scene.get_node("DirectionalLight2D"):
		current_scene.get_node("DirectionalLight2D").energy = 0
	for light in get_tree().get_nodes_in_group("nightLight"):
		light.energy = 0		
	atNight = false
	
#func passMoment():	
#	var current_scene = get_tree().current_scene
#	current_scene.get_node("AudioStreamPlayer2D").play()
#	if current_scene.get_node("DirectionalLight2D"):
#		current_scene.get_node("DirectionalLight2D").energy = 0	
		
		
		
func moveChengZhu():
	var current_scene = get_tree().current_scene
	current_scene.get_node("AnimationPlayer").play("城主走开")
func addGold(goldAmount):
	FightScenePlayers.gold = FightScenePlayers.golds
	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold/goldValue").text = str(goldAmount)
	FightScenePlayers.golds += enKey * goldAmount
	FightScenePlayers.golds *= enKey
	FightScenePlayers.golds = decrypt(FightScenePlayers.golds)
	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer").visible = true	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold").visible = true	
	
	get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/006-System06.ogg")
	get_tree().current_scene.get_node("subSound").play()
	get_tree().current_scene.get_node("battleRewardGone").start()
	Global.systemMsg.append("获得了 " + str(goldAmount) + " 银两")
	get_tree().current_scene.get_node("CanvasLayer").renderMsg()

func lostGold(goldAmount):
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold/goldValue").text = str(-goldAmount)
	FightScenePlayers.golds *= enKey
	FightScenePlayers.golds -= enKey * goldAmount
	
	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer").visible = true	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold").visible = true	
	
	get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/006-System06.ogg")
	get_tree().current_scene.get_node("subSound").play()
	get_tree().current_scene.get_node("battleRewardGone").start()
	Global.systemMsg.append("失去了 " + str(goldAmount) + " 银两")
	get_tree().current_scene.get_node("CanvasLayer").renderMsg()



func addItem(item,type,bagPlace,num):
#	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").text = str("获得了"+item)
#
#	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer").visible = true	
#	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").visible = true	
#
#	get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/006-System06.ogg")
#	get_tree().current_scene.get_node("subSound").play()
#	get_tree().current_scene.get_node("battleRewardGone").start()
	var bag = FightScenePlayers[bagPlace]
	if bag.has(item):
		bag[item].number += num
	else:
		bag[item] = {
			"info": ItemData[type].get(item),
			"type": type,
			"number": num,
			"added": false
		}

	Global.systemMsg.append("获得了"+item + "x" + str(num))
	get_tree().current_scene.get_node("CanvasLayer").renderMsg()	

func playSound(sound):
	get_tree().current_scene.get_node("subSound").stream = load(sound)
	get_tree().current_scene.get_node("subSound").play()
	#get_tree().current_scene.get_node("AudioStreamPlayer2D").stop()	
var dial = null
#func dialogue(dia):
#	get_tree().current_scene.get_node("dialogueTimer").start()
#	dial = dia
	
func get_npc_dialogue(npc_id):
	
	var npc = Global.npcs[npc_id]
	var dialogue_index = npc["current_dialogue_index"]

	if npc["dialogues"].size() > dialogue_index:
		var dialogue_entry = npc["dialogues"][dialogue_index]

		if dialogue_entry["unlocked"] and dialogue_entry["chapter"] == Global.current_chapter_id:
			update_npc_dialogue_index(npc_id)
			if npc["dialogues"][dialogue_index].bgm != null:
			
				self.get_parent().get_node("AudioStreamPlayer2D").stream = load(npc["dialogues"][dialogue_index].bgm)
				self.get_parent().get_node("AudioStreamPlayer2D").play()
			return dialogue_entry["dialogue"]
		
	return "没有更多可说的了"


func update_npc_dialogue_index(npc_id):
	if Global.npcs[npc_id]["constNpc"] == false:
		Global.npcs[npc_id]["current_dialogue_index"] += 1

func complete_task(chapter_id, task_id):
	if Global.chapters.has(chapter_id) and Global.chapters[chapter_id]["tasks"].has(task_id):
		Global.chapters[chapter_id]["tasks"][task_id] = true
		for npc_id in Global.npcs.keys():
			update_npc_dialogue_index(npc_id)
func moveChar(x,y):
	get_tree().current_scene.get_node("player/Sprite2D").visible = false
	get_tree().current_scene.get_node("player/AnimatedSprite2D").visible = true
	get_tree().current_scene.get_node("player/AnimatedSprite2D").play("up")
	var tween = get_tree().create_tween()
	var player_node = get_tree().current_scene.get_node("player")  # Get the player node
	
	var new_position =  Vector2(0,0)
	new_position.x = player_node.position.x+x
	new_position.y = player_node.position.y+y
	tween.tween_property(get_tree().current_scene.get_node("player"),
							   "position",  # Property to interpolate
							   new_position,  # Initial value
							   1
							)

	tween.play()
func changeQuest(location1, location2, method, value):
	if method == "add":
		quests.get(location1)[location2] += value
	if method == "boolean":
		quests.get(location1)[location2] = value
	
	
func decrypt(value):
	return value / enKey


func countDown(value):
	get_tree().current_scene.get_node("CanvasLayer").countDown(value)
