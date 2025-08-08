extends Node



var monsterIdx = -1
var monsterRemain = false
var playerIdx = -1
var easyLevels = ["东海湾", "easy_level_2", "easy_level_3"]
var dangerScene = {"东海湾":2, "江南野外": 5, "锁妖塔2": 4,"锁妖塔3":4,"锁妖塔4":4,"锁妖塔6":5, "东海海道":5, "东海海道2":5,"东海海道3":5,"花果山":8,"海底迷宫1":8 
,"海底迷宫2":8 ,"海底迷宫3":8 ,"海底迷宫4":8 ,"海底迷宫5":8 , "地府迷宫1":4,"地府迷宫2":4,"地府迷宫3":4,"地府迷宫4":4,"地府监狱":4, "大唐国境边缘": 4,"大唐境外":5,"小西天":6, "北俱芦洲":6,
"龙窟1": 3,"龙窟2": 4,"龙窟3": 4,"龙窟4": 4,"龙窟5": 4,"龙窟6": 4,"龙窟7": 4,
"凤巢1": 3,"凤巢2": 3,"凤巢3": 3,"凤巢4": 3,"凤巢5": 3,"凤巢6": 3,"龙凤巢7": 4,
 "长寿郊外": 7,"幻境1": 2,"幻境2": 2,
 "女娲神迹": 2,
 "创界山":8, "创界山顶":8, "炼狱迷宫1": 8, "炼狱迷宫2":8, "炼狱迷宫3":8, "炼狱迷宫4":8, "炼狱迷宫5":8, "炼狱迷宫6":8, "炼狱迷宫7":8,"天宫":8}
var menuOut = false
var canMenu = true
var healBuffAmount = 0
var onAttackingList = []
var currAttacker = ""
var wait
var target = null
var monsterTarget = null
var onPhone = false
var onButton = false
var bgmTimer = 0
var levelLimit = 10
var battleButtonIndex = 0
var maxLevel = 10
var playerSpeed = 300
var onPetAttack = false
var onAttackPicking = false #是否在选择攻击对象
var onMagicAttackPicking = false
var playersAppended = false
var onMagicAttacking = false
var onAttacking = false
var names = []
var onFightDoubleSpeed = false
var onHitPlayer = []
var alivePlayers = []
var selectedTarget = false
var onBigPicture = false
var currPlayerMagic = []
var onMagicSelectPicking = false
var magicSelectIndex = 0
var currUsingMagic = null
var killedAmount = 0
var gameRound = 1
var haveGao = false
signal autoAttackSignal
var helperName = ""
var helperMsg = ""
var wutongOn = false
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
var prevScene = ""
var petPotentialProgress = 0
var difficulty = "hard"
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
var isBoss = ["巨蛙","鹰孽大王","堕逝","黑山","奔霸","大鹏","鬼将军", "青龙", "弥勒佛", "鬼帝", "蚩尤","魔尊","天道"]
var cantShow = ["东海海道", "长安北","长安镖局", "长安","镇魔地1","镇魔地2","镇魔地3","花果山","普陀山","海底迷宫1", "地府迷宫1", "森罗殿","轮回司","大唐境外","大唐境外","西行之路","轮回之门","五庄观","龙窟1","凤巢1","雷音地下", "创界山", "神庙","女娲神迹","炼狱迷宫1","凌霄宝殿"]
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
	#"res://Audio/BGM/战斗-仙剑.mp3", 
	"res://Audio/BGM/战斗-任务.mp3",
	"res://Audio/BGM/金庸-战斗.mp3",
	#"res://Audio/BGM/黄鹤遗址.ogg",
	"res://Audio/BGM/战斗草原.mp3",
	"res://Audio/BGM/轩辕-战斗.mp3",
	#"res://Audio/BGM/轩辕-战斗2.mp3",
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
	"res://Audio/BGM/战斗-急凑.mp3",
	
	#"res://Audio/BGM/战斗-梦想3.ogg",
	"res://Audio/BGM/【战斗】传说开始的地方.mp3",
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗一 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗一(Av995118947,P1).mp3", 
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗三 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗三(Av312602269,P1).mp3", 
	"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——战斗二 - 1.《大侠立志传》游戏音乐BGM纯享版——战斗二(Av740045895,P1).mp3", 
	#"res://Audio/BGM/《大侠立志传》游戏音乐BGM纯享版——特殊事件二 - 1.《大侠立志传》游戏音乐BGM纯享版——特殊事件二(Av570749068,P1).mp3"
	#"res://Audio/BGM/【战斗】神话降临.mp3",
	#"res://Audio/BGM/【镜影命缘】.mp3",
	
	]
#保存的
var questItem = {}
var atNight = false
var currentCamera
var currPlayer
var currScene
var noLimit = true
var haveQianJi = false
var onTeamPlayer = ["时追云","小二"]
var onTeamPet = ["敖白"]
var onTeamSmallPet = ["小鹿"]
var smallPets = []
var currPlayerPos
var currNpc = null
var saveIndex = 0
var petTarget
var systemMsg = [
	
]
var onUi = false
var onXiaoErZhenShen = false
var onPet = false
var onSkipFight = false
var violencePoint = 10
var questHint = ""
var questItemShow = {
	"佛手":{"visible":false},
	"双头斧": {"visible":false},
	"鞋子": {"visible":false},
	"拐杖": {"visible":false},
	"雪莲": {"visible":false},
}
var damageReward1 = 1

var chapters = {
	"chapter1": {"completed": false, "tasks": {"task1": false, "task2": false}},
	"chapter2": {"completed": false, "tasks": {"task3": false}},
	# 直到 chapter10
}
var haveUi = true
var tempValue = 0
var arDark = false
var current_chapter_id = 1
var fightTime = ""
var gai = false
var mcVisible = true

var sameBigScene = {
	"建邺城":["建邺城右","建邺城","建邺药店","建邺布店","李善人家1","李善人家2"],
	"长安城":["长安城","长安北","长安酒店","长安酒店二楼","金甲家","回春堂"],
	"大唐官府":["大唐官府","大唐官府大厅","大唐官府内室"],
	"潮音洞":["潮音洞","普陀山",],
	"五庄观":["五庄观","乾坤殿",],
	"方寸山":["方寸山","灵台宫",],
	"创界山":["创界山","创界山顶",],
	"长寿村":["长寿村","长寿村民居","长寿村药店","长寿村酒店","长寿村村长家","长寿郊外"],
	"傲来国":["傲来国","傲来布店","傲来杂货铺","傲来武器铺","傲来祭堂","傲来酒店","傲来药店","傲来钱庄","傲来民居",],
	"海底迷宫":["海底迷宫1","海底迷宫2","海底迷宫3","海底迷宫4","海底迷宫5","东海沉船","东海沉船内",],
	"东海海道":["东海海道","东海海道2","东海海道3"],
	"锁妖塔":["锁妖塔1","锁妖塔2","锁妖塔3","锁妖塔4","锁妖塔5","锁妖塔6","锁妖塔7"],
	"朱紫国":["朱紫国","灵力储存场","朱紫国旅馆","朱紫国杂货店"],
	
}

var npcVis = {
	"东海湾":{
		"鱼叟":{"visible" : true},
		"玉帝物品":{"visible" : false},
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
		"小二": {"visible" : false},		
		"凌若昭": {"visible" : false},		
		"梧桐": {"visible" : false},	
	},	
	"大唐官府内室":{
		"程咬金": {"visible" : true},
		"小二": {"visible" : true},		
		"凌若昭": {"visible" : true},		
	},	
	"长安城":{
		"警戒士兵": {"visible" : false},
		"乞丐": {"visible" : true},
		"凌若昭": {"visible" : false},		
		"提毗": {"visible" : false},
		
		
		"小二2": {"visible" : false},
				
	},
	"长安酒店":{
		"凌若昭": {"visible" : false},
	},	
	"长安北":{
		"看守": {"visible" : true},
		"金甲3": {"visible" : false},
		
		"小二2": {"visible" : false},
		"凌若昭": {"visible" : false},
	},
	"长安东":{
		"梧桐": {"visible" : true},
	},	
	"金甲家":{
		"小二": {"visible" : true},
	},	
	"锁妖塔1":{
		"凌若昭":{"visible": true},
		"小星星":{"visible": false}
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
		"千年树":{"visible": true},
		"小福星":{"visible": false}
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
		"黑山2": {"visible":false},
		"菩提老祖": {"visible":false},
		"菩提老祖2": {"visible":false},
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
		"姜韵": {"visible":false},	
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
	"东海沉船":{
		"近海恶蛟": {"visible":true},


	},			
	
	"傲来国":{
		"老李头": {"visible":true},
		"黑蝠": {"visible":true},
		"npcs": {"visible":false},
		"npcs2": {"visible":false},
		"逆无邪": {"visible":false},
		"上官冕": {"visible":false},
		"凌若昭": {"visible":false},
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
		"孙悟空": {"visible":false},	
	},			
	"两界山":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},		
		
	},	
	"地府":{
		"野鬼1": {"visible":false},
		"野鬼2": {"visible":false},
		"野鬼3": {"visible":false},
		"野鬼4": {"visible":false},
		"野鬼5": {"visible":false},
	},		
	
	"轮回司":{
		"地藏菩萨": {"visible":false},
		
	},		

	"地府迷宫2":{
		"鬼潇潇": {"visible":true},
		"鬼司": {"visible":true}
	},	
	"地府迷宫3":{
		"冥鸟": {"visible":true},
	},		
	"地府迷宫4":{
		"僵尸王": {"visible":true},
	},			
	"金山室内":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},		
		"戒色": {"visible":true},		
	},			
	"大唐国境边缘":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},		
		"梧桐": {"visible":false},					
	},
	"长安南":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},		
					
	},
	"枯骨山":{
		"小二": {"visible":true},
		"凌若昭": {"visible":false},
		"梧桐": {"visible":false},
					
	},
	"枯骨洞":{
		"小二": {"visible":false},
		"凌若昭": {"visible":false},
		"梧桐": {"visible":false},			
	},	
	"婚房":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
		"梧桐": {"visible":true},
					
	},		
	"枯骨山夜晚":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
					
	},
	"第七章序幕":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
		"梧桐": {"visible":true},					
	},
	"北俱芦洲":{
		"小二": {"visible":true},
		"凌若昭": {"visible":true},
		"梧桐": {"visible":true},	
		"梦老": {"visible":true},
		"红鸟": {"visible":false},
		"百足虫": {"visible":true},						
	},	
	"凤巢7":{
		"小二": {"visible":false},
		"梧桐": {"visible":false},	
						
	},	
	"五庄观":{
		"凌若昭": {"visible":false},		
		"清风": {"visible":true},				
		
	},	
	"普陀山":{
		"水云仙": {"visible":true},	
		"凌若昭": {"visible":false},		
	},
	"潮音洞":{
		"姜韵": {"visible":false},			
	},
	"大唐境外":{
		"瑞兽": {"visible":false},			
	},
	"朱紫国":{
		"凌若昭": {"visible":false},
		"方大爷": {"visible":false},	
		"怪僧": {"visible":true},
				
	},				
	"雷音寺":{
		"小二": {"visible":false},							
		"凌若昭": {"visible":false},					
	},				
	"长寿村":{
		"墨兮": {"visible":false},							
	},	
	"神庙":{
		"墨兮": {"visible":false},	
		"姜韵": {"visible":false},	
		"凌若昭": {"visible":false},	
		"小二": {"visible":false},	
						
							
	},				
	"长寿郊外":{
		"蝎霸王": {"visible":false},	
		"凌若昭": {"visible":false},				
		"小二": {"visible":false},		
		"妖盟": {"visible":false},								
	},	
	"幻境1":{
		"奔霸": {"visible":true},					
	},	
		
		
	"黑暗空间":{
		"凌若昭": {"visible":true},	
		"姜韵": {"visible":true},			
		"小二": {"visible":true},			
		
								
	},
	"传梦空间":{
		"关重七": {"visible":false},	
		"二胡游": {"visible":false},			

								
	},
	"炼狱迷宫1":{
		"魔画": {"visible":true},	
								
	},
	"炼狱迷宫2":{
		"魔狐": {"visible":true},	
								
	},
	"炼狱迷宫3":{
		"魔阎罗": {"visible":true},							
	},		
	"炼狱迷宫5":{
		"魔妾": {"visible":true},							
	},	
	"炼狱迷宫7":{
		"蛟魔王": {"visible":true},							
	},			
		
	"天宫":{
		#"炎魔神": {"visible":true},
		"魔巫": {"visible":true},			
		"魔刹": {"visible":true},
		"魔如意": {"visible":true},
		"太白金星": {"visible":true},							
	},		
	"月宫":{
		"孙悟空": {"visible":true},
		"吸血鬼组": {"visible":true},			
		"小魔头组": {"visible":true},	
		"吸血鬼组2": {"visible":true},		
		"小兵": {"visible":true},
		"雷龙": {"visible":false},	
		"魔金刚": {"visible":false},		
		"魔鸟": {"visible":false},		
		"鬼面": {"visible":false},
		"姜韵": {"visible":false},				
	},	
	"凌霄宝殿":{
		"凌若昭": {"visible":false},
		"小二": {"visible":false},
		"姜韵": {"visible":false},				
	},
	"玄天幻化":{
		"凌若昭": {"visible":true},
		"小二": {"visible":true},			
	}						
															
}
var baseChance = 0
var musicOn = true
var enKey = 1

var quests ={
	"锁妖塔":{"6":false,"7":false,},
	"方寸罗师兄":{"小师弟":0, "complete":false},
	"传梦之路":{"传":false,"梦":false,"之":false,"路":false},
	
	"抓鬼":{"野鬼":0, "complete":false},
	"镇魔地":{"镇魔地1":false,"镇魔地2":false,"镇魔地3":false,},
	"玉帝秘境":{"complete": false},
	"天庭魔军":{"魔如意":false,"魔刹":false,"杨戬":false,"魔巫":false}
}
var yuDiItem = false




func checkChuanMeng():
	for value in quests["传梦之路"].values():
		if value != true:
			return false
	return true

func checkTianTing():
	for value in quests["天庭魔军"].values():
		if value != true:
			return false
	return true

func checkZhenMo():
	for value in quests["镇魔地"].values():
		if value != true:
			return false
	return true



var canTake = false


func changeVis(npcList: Array, scene) -> void:
	for npc in npcList:
		npcVis.get(scene).get(npc).visible = !npcVis.get(scene).get(npc).visible

		
var load = false
var npcs = {
	"addMember": {
		"dialogues": [ 
			#0
			{"chapter": 1, "dialogue": "addMember", "unlocked": true, "bgm":null, "trigger":false},
		],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"战斗员": {
		"dialogues": [ 
			#0
			{"chapter": 1, "dialogue": "战斗员", "unlocked": true, "bgm":null, "trigger":false},
		],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"骑迹行者": {
		"dialogues": [ 
			#0
			{"chapter": 9, "dialogue": "骑迹行者", "unlocked": true, "bgm":null, "trigger":false},
		],
		"current_dialogue_index": 0,
		"constNpc": false
	},
	"宝箱1": {
		"dialogues": [ 
			#0
			{"chapter": 1, "dialogue": "宝箱质问", "unlocked": true, "bgm":null, "trigger":false},
		],
		"current_dialogue_index": 0,
		"constNpc": true
	},
	"玉帝物品事件": {
		"dialogues": [ 
			#0
			{"chapter": 1, "dialogue": "玉帝物品事件", "unlocked": true, "bgm":null, "trigger":false},
		],
		"current_dialogue_index": 0,
		"constNpc": false
	},	
	
	
	
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
				#9
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
				#19
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
					{"chapter": 9, "dialogue": "进入传梦空间", "unlocked": false, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "挑战传梦", "unlocked": true, "bgm":null,"trigger":false},		
					{"chapter": 9, "dialogue": "传梦真谛", "unlocked": true, "bgm":null,"trigger":false},										
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
	"小福星":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "小福星", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": true			
	},	
	"小星星":{
		"dialogues": [
				#0
					{"chapter": 2, "dialogue": "小星星", "unlocked": true, "bgm":null,"trigger":false},
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
					{"chapter": 3, "dialogue": "真方寸山", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "若昭移动", "unlocked": false, "bgm":null,"trigger":false},			
					{"chapter": 10, "dialogue": "若昭传送", "unlocked": true, "bgm":null,"trigger":false},							
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
					{"chapter": 3, "dialogue": "告知打赢", "unlocked": false, "bgm":null ,"trigger":false},
					{"chapter": 9, "dialogue": "菩提告辞", "unlocked": false, "bgm":null ,"trigger":false},
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
					{"chapter": 5, "dialogue": "阴阳洞", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "醒来", "unlocked": true, "bgm": null ,"trigger":false},					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"孟婆":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "初见孟婆", "unlocked": true, "bgm": null ,"trigger":false},

				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},
	"白无常":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "白无常", "unlocked": true, "bgm": null ,"trigger":false},

				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},				
	"钟馗":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "初见钟馗", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "劝说离开", "unlocked": false, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "抓鬼练习", "unlocked": false, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "完成抓鬼", "unlocked": false, "bgm": null ,"trigger":false},	
					{"chapter": 5, "dialogue": "钟馗谈心", "unlocked": false, "bgm": null ,"trigger":false},					
					{"chapter": 5, "dialogue": "钟馗送行", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"阎罗王":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "初见阎罗王", "unlocked": true, "bgm":  "res://Audio/BGM/0情况危机.ogg","trigger":false},
					{"chapter": 5, "dialogue": "查看生死簿", "unlocked": true, "bgm":  null,"trigger":false},
					
					
					{"chapter": 5, "dialogue": "阴间活", "unlocked": false, "bgm":"res://Audio/BGM/幽默 - 03.mp3" ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	
			
	"真离开地府":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "真离开地府", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "结局1", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},				
	"找罐子":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "找罐子", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"重遇上官":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "重遇上官1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "重遇上官2", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"第一次遇鬼":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "第一次遇鬼", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "撤退", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "退回地府", "unlocked": true, "bgm": null ,"trigger":false},					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"鬼司":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "鬼司1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "鬼司2", "unlocked": true, "bgm": null ,"trigger":false},			
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"冥鸟":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "冥鸟1", "unlocked": true, "bgm": null ,"trigger":false},		
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"僵尸王":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "僵尸王1", "unlocked": true, "bgm": null ,"trigger":false},		
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},							
	"回忆":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "回忆1回1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "回忆1回2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 5, "dialogue": "回忆1回3", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"回忆2":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "回忆2回1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "回忆2回2", "unlocked": true, "bgm": "res://Audio/BGM/大话-俩小无猜.ogg","trigger":false},	
					{"chapter": 5, "dialogue": "回忆2回3", "unlocked": true, "bgm": "res://Audio/BGM/大话-俩小无猜.ogg" ,"trigger":false},
					{"chapter": 5, "dialogue": "回忆2回4", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},					
	"回忆3":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "回忆3回1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "回忆3回2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 5, "dialogue": "回忆3回3", "unlocked": true, "bgm": "res://Audio/BGM/SWD5 临敌.mp3","trigger":false},
					{"chapter": 5, "dialogue": "回忆3回4", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"回忆4":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "回忆4回1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "回忆4回2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 5, "dialogue": "女主回归", "unlocked": true, "bgm": null ,"trigger":false},	

				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"鬼潇潇":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "鬼潇潇", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},		
	"鬼医":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "鬼医", "unlocked": true, "bgm": null ,"trigger":false},
					
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},			
	"野鬼":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "野鬼", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "抓到鬼", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},
	"地府回忆":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "地府回忆1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "地府回忆2", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "地府回忆3", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "地府回忆4", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},
	"进回忆":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "进回忆2", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "进回忆3", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "进回忆4", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "进回忆5", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false		
	},	
	"地府决战":{
		"dialogues": [
				#0
					{"chapter": 5, "dialogue": "女主回归", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "到地府监狱", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 5, "dialogue": "再见娘子", "unlocked": true, "bgm": "res://Audio/BGM/四个人的幸福时光.mp3" ,"trigger":false},
					{"chapter": 5, "dialogue": "打败鬼将军", "unlocked": true, "bgm": "res://Audio/BGM/天地劫 幽城幻剑录 - 破暗 [TubeRipper.cc].ogg" ,"trigger":false},
					{"chapter": 5, "dialogue": "打败鬼将军2", "unlocked": true, "bgm": "res://Audio/BGM/天地劫 幽城幻剑录 - 破暗 [TubeRipper.cc].ogg" ,"trigger":false},
					{"chapter": 5, "dialogue": "回森罗殿", "unlocked": true, "bgm": "res://Audio/BGM/幽默 - 01.mp3" ,"trigger":false},					
					{"chapter": 5, "dialogue": "回人间", "unlocked": true, "bgm": "res://Audio/BGM/欢乐家园.mp3" ,"trigger":false},					
										
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"红花":{
		"dialogues": [
				#0
					{"chapter": 6, "dialogue": "听闻砍头", "unlocked": true, "bgm": null ,"trigger":false},				
					{"chapter": 6, "dialogue": "寻找小二2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 6, "dialogue": "寻找小二3", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 6, "dialogue": "寻找小二4", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二5", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二6", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二7", "unlocked": true, "bgm": null ,"trigger":false},						
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	
	"凌若昭回忆":{
		"dialogues": [
				#0
					{"chapter": 6, "dialogue": "凌若昭回忆1", "unlocked": true, "bgm": "res://Audio/BGM/轩辕剑-幽愁.mp3" ,"trigger":false},				
					{"chapter": 6, "dialogue": "凌若昭回忆2", "unlocked": true, "bgm": null ,"trigger":false},											
					{"chapter": 6, "dialogue": "凌若昭回忆3", "unlocked": true, "bgm": null ,"trigger":false},				
					{"chapter": 6, "dialogue": "凌若昭回忆4", "unlocked": true, "bgm": "res://Audio/BGM/聂薇 - 墨家村-夜晚.mp3","trigger":false},				
					{"chapter": 6, "dialogue": "凌若昭回忆5", "unlocked": true, "bgm":  "res://Audio/BGM/SWD5 临敌.mp3","trigger":false},		
					{"chapter": 6, "dialogue": "凌若昭回忆6", "unlocked": true, "bgm": "res://Audio/BGM/轩辕-危机.mp3" ,"trigger":false},		
					{"chapter": 6, "dialogue": "凌若昭回忆7", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆8", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆9", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆10", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆11", "unlocked": true, "bgm": null, "trigger":false},									
					{"chapter": 6, "dialogue": "凌若昭回忆12", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆13", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆14", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆15", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆16", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆17", "unlocked": true, "bgm": null, "trigger":false},	
					{"chapter": 6, "dialogue": "凌若昭回忆18", "unlocked": true, "bgm": null, "trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"寻找小二":{
		"dialogues": [
				#0
					{"chapter": 6, "dialogue": "寻找小二1", "unlocked": true, "bgm": null ,"trigger":false},				
					{"chapter": 6, "dialogue": "寻找小二2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 6, "dialogue": "寻找小二3", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 6, "dialogue": "寻找小二4", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二5", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二6", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "寻找小二7", "unlocked": true, "bgm": null ,"trigger":false},						
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"再见小二":{
		"dialogues": [
				#0
					{"chapter": 6, "dialogue": "再见小二1", "unlocked": true, "bgm": "res://Audio/BGM/桃花岛.mp3" ,"trigger":false},									
					{"chapter": 6, "dialogue": "再见小二2", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "再见小二3", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 6, "dialogue": "再见小二4", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 6, "dialogue": "再见小二5", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 6, "dialogue": "再见小二6", "unlocked": true, "bgm": "res://Audio/BGM/0盛典.mp3" ,"trigger":false},				
					{"chapter": 6, "dialogue": "再见小二7", "unlocked": true, "bgm": null ,"trigger":false},						
					
					
								
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"梦老":{
		"dialogues": [
				#0
					{"chapter": 7, "dialogue": "梦老1", "unlocked": true, "bgm": null ,"trigger":false},			
					{"chapter": 7, "dialogue": "梦老2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 7, "dialogue": "梦老3", "unlocked": true, "bgm": null ,"trigger":false},																					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"百足虫":{
		"dialogues": [
				#0
					{"chapter": 7, "dialogue": "百足虫1", "unlocked": true, "bgm": null ,"trigger":false},																		
					{"chapter": 7, "dialogue": "百足虫2", "unlocked": true, "bgm": null ,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"红鸟":{
		"dialogues": [
				#0
					{"chapter": 7, "dialogue": "红鸟1", "unlocked": true, "bgm": null ,"trigger":false},																		
					{"chapter": 7, "dialogue": "红鸟2", "unlocked": true, "bgm": null ,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	"寻四圣":{
		"dialogues": [
				#0
					{"chapter": 7, "dialogue": "寻四圣1", "unlocked": true, "bgm": null ,"trigger":false},									
					{"chapter": 7, "dialogue": "寻四圣2", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣3", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣4", "unlocked": true, "bgm": null ,"trigger":false},									
					{"chapter": 7, "dialogue": "寻四圣5", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣6", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 7, "dialogue": "寻四圣7", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣8", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 7, "dialogue": "寻四圣9", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣10", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 7, "dialogue": "寻四圣11", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 7, "dialogue": "寻四圣12", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣13", "unlocked": true, "bgm": null ,"trigger":false},										
					{"chapter": 7, "dialogue": "寻四圣14", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣15", "unlocked": true, "bgm": null ,"trigger":false},										
					{"chapter": 7, "dialogue": "寻四圣16", "unlocked": true, "bgm":  "res://Audio/BGM/神威千重.ogg","trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣17", "unlocked": true, "bgm": null ,"trigger":false},																	
					{"chapter": 7, "dialogue": "寻四圣18", "unlocked": true, "bgm":  null,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣19", "unlocked": true, "bgm": null ,"trigger":false},										
					{"chapter": 7, "dialogue": "寻四圣20", "unlocked": true, "bgm":  null,"trigger":false},		
					{"chapter": 7, "dialogue": "寻四圣21", "unlocked": true, "bgm": null ,"trigger":false},								
								
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"寻四方":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "寻四方1", "unlocked": true, "bgm": null ,"trigger":false},									
					{"chapter": 8, "dialogue": "寻四方2", "unlocked": true, "bgm": null ,"trigger":false},						
				
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"初见观音":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "初见观音1", "unlocked": true, "bgm": null ,"trigger":false},														
					{"chapter": 8, "dialogue": "初见观音2", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 8, "dialogue": "初见观音3", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 8, "dialogue": "再见观音", "unlocked": true, "bgm": null ,"trigger":false},						
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	
			
	"水云仙":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "关重七1", "unlocked": true, "bgm": null ,"trigger":false},														
					{"chapter": 8, "dialogue": "关重七2", "unlocked": true, "bgm": "res://Audio/BGM/你在哪里.mp3" ,"trigger":false},		
					{"chapter": 8, "dialogue": "关重七3", "unlocked": true, "bgm": null ,"trigger":false},						
					{"chapter": 8, "dialogue": "关重七4", "unlocked": true, "bgm": null ,"trigger":false},									
					{"chapter": 8, "dialogue": "关重七5", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 8, "dialogue": "关重七6", "unlocked": true, "bgm": null ,"trigger":false},
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"瑞兽":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "瑞兽1", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 8, "dialogue": "瑞兽2", "unlocked": true, "bgm": null ,"trigger":false},																
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"清风":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "清风", "unlocked": true, "bgm": null ,"trigger":false},														
				],
		"current_dialogue_index": 0,	
		"constNpc": true		
	},			
	"明月":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "明月", "unlocked": true, "bgm": null ,"trigger":false},														
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},			
	"五庄观":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "五庄观1", "unlocked": true, "bgm": null ,"trigger":false},														
					{"chapter": 8, "dialogue": "五庄观2", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 8, "dialogue": "五庄观3", "unlocked": true, "bgm": null ,"trigger":false},								
					{"chapter": 8, "dialogue": "五庄观4", "unlocked": true, "bgm": null ,"trigger":false},	
					{"chapter": 8, "dialogue": "五庄观5", "unlocked": true, "bgm": null ,"trigger":false},							
							
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"除虫":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "除虫1", "unlocked": true, "bgm": null ,"trigger":false},														
					{"chapter": 8, "dialogue": "除虫2", "unlocked": true, "bgm": null ,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"金翅大鹏":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "初见大鹏1", "unlocked": true, "bgm": null ,"trigger":false},														
					{"chapter": 8, "dialogue": "初见大鹏2", "unlocked": true, "bgm": null ,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"怪僧":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "怪僧1", "unlocked": true, "bgm": null ,"trigger":false},				
					{"chapter": 8, "dialogue": "怪僧2", "unlocked": false, "bgm": null ,"trigger":false},	
					{"chapter": 8, "dialogue": "怪僧3", "unlocked": true, "bgm": null ,"trigger":false},
					{"chapter": 8, "dialogue": "怪僧4", "unlocked": true, "bgm": null ,"trigger":false},																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false,
	},
	"绿狸":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "绿狸", "unlocked": true, "bgm": null ,"trigger":false},																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false,
	},	
	"朱紫国药铺老板":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "朱紫国药铺老板", "unlocked": true, "bgm": null ,"trigger":false},				
													
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},		
	"方大爷":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "方大爷", "unlocked": true, "bgm": null ,"trigger":false},				
													
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},					
	"朱紫国士兵":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "卡路", "unlocked": true, "bgm": null ,"trigger":false},				
													
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},				
	"朱紫国阻拦":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "朱紫国阻拦", "unlocked": true, "bgm": null ,"trigger":false},																
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},			
	"看戏":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "看戏", "unlocked": true, "bgm": null ,"trigger":false},																
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"沙暴":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "沙暴1", "unlocked": true, "bgm": null ,"trigger":false},																
					{"chapter": 8, "dialogue": "沙暴2", "unlocked": true, "bgm": "res://Audio/BGM/我来助你.ogg" ,"trigger":false},				
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"鹿飞":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "鹿飞", "unlocked": true, "bgm": null ,"trigger":false},																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
				
	"朱紫国旅馆老板":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "问情况", "unlocked": false, "bgm": null ,"trigger":false},	
					{"chapter": 8, "dialogue": "问情况2", "unlocked": true, "bgm": null ,"trigger":false},	
																									
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"追杀":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "追杀1", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 8, "dialogue": "追杀2", "unlocked": true, "bgm": null ,"trigger":false},		
					{"chapter": 8, "dialogue": "追杀3", "unlocked": true, "bgm": null ,"trigger":false},																						
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	
	"黄眉":{
		"dialogues": [
				#0
					{"chapter": 8, "dialogue": "黄眉1", "unlocked": true, "bgm":  "res://Audio/BGM/0情况危机.ogg","trigger":false},		
					{"chapter": 8, "dialogue": "黄眉2", "unlocked": true, "bgm":"res://Audio/BGM/庄严1.mp3" ,"trigger":false},
					{"chapter": 8, "dialogue": "黄眉3", "unlocked": true, "bgm":"res://Audio/BGM/庄严1.mp3" ,"trigger":false},					
					{"chapter": 8, "dialogue": "黄眉4", "unlocked": true, "bgm":null ,"trigger":false},		
					{"chapter": 8, "dialogue": "黄眉5", "unlocked": true, "bgm":null ,"trigger":false},	
					{"chapter": 8, "dialogue": "黄眉6", "unlocked": true, "bgm":null ,"trigger":false},		
					{"chapter": 8, "dialogue": "黄眉7", "unlocked": true, "bgm":null ,"trigger":false},							
																																							
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"弑天魔":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "弑天魔1", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 9, "dialogue": "弑天魔2", "unlocked": true, "bgm": null,"trigger":false},																																								
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},						
	"炎魔神":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "炎魔神1", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 9, "dialogue": "炎魔神2", "unlocked": true, "bgm": null,"trigger":false},																																						
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"冲天魔":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "冲天魔1", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 9, "dialogue": "冲天魔2", "unlocked": true, "bgm": null,"trigger":false},																																						
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
				
	"女侠":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "女侠", "unlocked": true, "bgm":  null,"trigger":false},																																				
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},				
	"村长":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "长寿村1", "unlocked": true, "bgm":null ,"trigger":false},				
					{"chapter": 9, "dialogue": "长寿村2", "unlocked": true, "bgm":null ,"trigger":false},								
					{"chapter": 9, "dialogue": "长寿村3", "unlocked": true, "bgm":null ,"trigger":false},								
					{"chapter": 9, "dialogue": "长寿村4", "unlocked": false, "bgm":null ,"trigger":false},			
																																							
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"长寿村酒楼掌柜":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "长寿村酒楼掌柜", "unlocked": true, "bgm":null ,"trigger":false},																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},					
	"长寿药店大夫":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "长寿药店大夫", "unlocked": true, "bgm":null ,"trigger":false},																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},		
	"长寿布店老板":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "长寿布店老板", "unlocked": true, "bgm":null ,"trigger":false},																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},				
	"长寿铁匠":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "长寿铁匠", "unlocked": true, "bgm":null ,"trigger":false},																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},		
	
	
	"墨兮":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "墨兮1", "unlocked": true, "bgm":"res://Audio/BGM/幽默-市集.mp3" ,"trigger":false},			
																																					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},						
	"蝎霸王":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "蝎霸王1", "unlocked": true, "bgm": "res://Audio/BGM/0情况危机.ogg","trigger":false},	
					{"chapter": 9, "dialogue": "蝎霸王2", "unlocked": true, "bgm": null,"trigger":false},								
																																					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	
			
	"幻境":{
		"dialogues": [
				#0	
					{"chapter": 9, "dialogue": "神庙1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "幻境1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "幻境2", "unlocked": true, "bgm": "res://Audio/BGM/0情况危机.ogg","trigger":false},													
					{"chapter": 9, "dialogue": "幻境3", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "幻境4", "unlocked": true, "bgm":"res://Audio/BGM/十二国记-不尽的哀伤.mp3" ,"trigger":false},																																					
					{"chapter": 9, "dialogue": "幻境5", "unlocked": true, "bgm":null,"trigger":false},			
					{"chapter": 9, "dialogue": "幻境6", "unlocked": true, "bgm":null,"trigger":false},			
			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},								
	"妖盟入侵":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "妖盟入侵1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "妖盟入侵2", "unlocked": true, "bgm": "res://Audio/BGM/0妖族阴谋.mp3" ,"trigger":false},												
					{"chapter": 9, "dialogue": "妖盟入侵3", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "妖盟入侵4", "unlocked": true, "bgm":null,"trigger":false},					
					{"chapter": 9, "dialogue": "妖盟入侵5", "unlocked": true, "bgm":null,"trigger":false},					
					{"chapter": 9, "dialogue": "妖盟入侵6", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "妖盟入侵7", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "妖盟入侵8", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "妖盟入侵9", "unlocked": true, "bgm": "res://Audio/BGM/卢小旭 - 憾天威.mp3","trigger":false},					
					{"chapter": 9, "dialogue": "妖盟入侵10", "unlocked": true, "bgm": "res://Audio/BGM/未知.ogg","trigger":false},
					{"chapter": 9, "dialogue": "妖盟入侵11", "unlocked": true, "bgm":null,"trigger":false},																																																								
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},					
	"女娲神迹":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "女娲神迹1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "女娲神迹2", "unlocked": true, "bgm":"res://Audio/BGM/雪見-落入凡塵 [TubeRipper.cc].ogg","trigger":false},																																															
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"镰魔":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "镰魔1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "镰魔2", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"狼叔":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "狼叔", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"老寒":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "老寒", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"清风柒":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "清风柒", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"遗憾":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "遗憾", "unlocked": true, "bgm":null,"trigger":false},																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"桥":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "桥", "unlocked": true, "bgm":null,"trigger":false},																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"白泽":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "白泽", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},
	"汤姆":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "汤姆", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": true
	},						
	"入您":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "入您", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},				
	"橙子色的橘子":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "橙子色的橘子", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},			
	"关重七":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "关重七", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},						
	"二胡游":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "二胡游", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false
	},						
	"西游遗憾":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "西游遗憾1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "西游遗憾2", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "西游遗憾3", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "西游遗憾4", "unlocked": true, "bgm":null,"trigger":false},		
					{"chapter": 9, "dialogue": "西游遗憾5", "unlocked": true, "bgm":null,"trigger":false},																																																						
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"梦幻群侠传遗憾":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾2", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾3", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾4", "unlocked": true, "bgm":null,"trigger":false},					
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾5", "unlocked": true, "bgm":null,"trigger":false},			
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾6", "unlocked": true, "bgm":null,"trigger":false},					
					{"chapter": 9, "dialogue": "梦幻群侠传遗憾7", "unlocked": true, "bgm":null,"trigger":false},								
							
																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"玉帝秘境":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "玉帝秘境1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 9, "dialogue": "玉帝秘境2", "unlocked": true, "bgm":null,"trigger":false},																																												
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	"创界山":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "创界山1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "创界山2", "unlocked": true, "bgm":null,"trigger":false},																																												
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
							
	"六耳":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "六耳救女孩", "unlocked": true, "bgm":null,"trigger":false},	
																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"魔龙":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "魔龙1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "魔龙2", "unlocked": true, "bgm":null,"trigger":false},																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"炼狱迷宫":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "炼狱迷宫1", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫2", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫3", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫4", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫5", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫6", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 10, "dialogue": "炼狱迷宫7", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 10, "dialogue": "炼狱迷宫8", "unlocked": true, "bgm":null,"trigger":false},																																																												
					{"chapter": 10, "dialogue": "炼狱迷宫9", "unlocked": true, "bgm": "res://Audio/BGM/E.S.mp3","trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"女娲雕像":{
		"dialogues": [
				#0
					{"chapter": 9, "dialogue": "女娲雕像", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"画魔":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "画魔", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"熊猫商人":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "熊猫商人", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},						
	"魔狐":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "魔狐", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},					
	"魔阎罗":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "魔阎罗1", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 10, "dialogue": "魔阎罗2", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"蛟魔王":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "蛟魔王1", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 10, "dialogue": "蛟魔王2", "unlocked": true, "bgm":null,"trigger":false},																																																		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	"孙悟空":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "传送天庭", "unlocked": true, "bgm": null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	
	"天庭之战":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "天庭之战1", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 11, "dialogue": "天庭之战2", "unlocked": true, "bgm":null,"trigger":false},																																																		
					{"chapter": 11, "dialogue": "天庭之战3", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 11, "dialogue": "天庭之战4", "unlocked": true, "bgm":null,"trigger":false},		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
		
	"太白金星":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "太白金星1", "unlocked": true, "bgm":null,"trigger":false},
																																																					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
	"魔刹":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "幽灵1", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "幽灵2", "unlocked": true, "bgm":null,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"魔妾":{
		"dialogues": [
				#0
					{"chapter": 10, "dialogue": "魔妾1", "unlocked": true, "bgm":null,"trigger":false},																																																
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"魔巫":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "魔巫1", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "魔巫2", "unlocked": true, "bgm":null,"trigger":false},		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"魔如意":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "魔如意", "unlocked": true, "bgm":null,"trigger":false},																																																	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		
					
	"杨戬事件":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "杨戬1", "unlocked": true, "bgm":"res://Audio/BGM/临敌2.ogg","trigger":false},																																																
					{"chapter": 11, "dialogue": "杨戬2", "unlocked": true, "bgm":null,"trigger":false},		
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"月宫之战":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "月宫之战1", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "月宫之战2", "unlocked": true, "bgm":null,"trigger":false},
					{"chapter": 11, "dialogue": "月宫之战3", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "月宫之战4", "unlocked": true, "bgm":null,"trigger":false},		
					{"chapter": 11, "dialogue": "月宫之战5", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "月宫之战6", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 11, "dialogue": "月宫之战7", "unlocked": true, "bgm":null,"trigger":false},		
					{"chapter": 11, "dialogue": "月宫之战8", "unlocked": true, "bgm":null,"trigger":false},																																																
					{"chapter": 11, "dialogue": "月宫之战9", "unlocked": true, "bgm":null,"trigger":false},								
					{"chapter": 11, "dialogue": "月宫之战10", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 11, "dialogue": "月宫之战11", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 11, "dialogue": "月宫之战12", "unlocked": true, "bgm":null,"trigger":false},	
					{"chapter": 11, "dialogue": "月宫之战13", "unlocked": true, "bgm":null,"trigger":false},						
					{"chapter": 11, "dialogue": "月宫之战14", "unlocked": true, "bgm":null,"trigger":false},							
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"嫦娥":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "嫦娥", "unlocked": true, "bgm":null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},			
	"李靖":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "李靖", "unlocked": true, "bgm":null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},				
	"哪吒":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "哪吒", "unlocked": true, "bgm":null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"太上老君":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "太上老君", "unlocked": true, "bgm":null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": true	
	},			
	"玉帝殿前":{
		"dialogues": [
				#0
					{"chapter": 11, "dialogue": "玉帝殿前1", "unlocked": true, "bgm":null,"trigger":false},																																																			
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},	
	"道归虚无":{
		"dialogues": [
				#0
					{"chapter": 12, "dialogue": "道归虚无1", "unlocked": true, "bgm": "res://Audio/BGM/大堂-冲动.ogg","trigger":false},																																																			
					{"chapter": 12, "dialogue": "道归虚无2", "unlocked": true, "bgm": null,"trigger":false},	
					{"chapter": 12, "dialogue": "道归虚无3", "unlocked": true, "bgm": null,"trigger":false},	
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"挑战天道":{
		"dialogues": [
				#0
					{"chapter": 12, "dialogue": "挑战天道1", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "挑战天道2", "unlocked": true, "bgm": null,"trigger":false},		
					{"chapter": 12, "dialogue": "挑战天道3", "unlocked": true, "bgm": null,"trigger":false},																																																						
					{"chapter": 12, "dialogue": "挑战天道4", "unlocked": true, "bgm": null,"trigger":false},				
					{"chapter": 12, "dialogue": "挑战天道5", "unlocked": true, "bgm": null,"trigger":false},				
					{"chapter": 12, "dialogue": "挑战天道6", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "挑战天道7", "unlocked": true, "bgm": null,"trigger":false},		
					{"chapter": 12, "dialogue": "挑战天道8", "unlocked": true, "bgm": null,"trigger":false},																																																						
					{"chapter": 12, "dialogue": "挑战天道9", "unlocked": true, "bgm": null,"trigger":false},				
					{"chapter": 12, "dialogue": "挑战天道10", "unlocked": true, "bgm": null,"trigger":false},							
					{"chapter": 12, "dialogue": "挑战天道11", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "挑战天道12", "unlocked": true, "bgm": null,"trigger":false},		
					{"chapter": 12, "dialogue": "挑战天道13", "unlocked": true, "bgm": null,"trigger":false},																																																						
					{"chapter": 12, "dialogue": "挑战天道14", "unlocked": true, "bgm": null,"trigger":false},				
					{"chapter": 12, "dialogue": "挑战天道15", "unlocked": true, "bgm": null,"trigger":false},						
					{"chapter": 12, "dialogue": "挑战天道16", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "挑战天道17", "unlocked": true, "bgm": null,"trigger":false},		
					{"chapter": 12, "dialogue": "挑战天道18", "unlocked": true, "bgm": null,"trigger":false},																																																						
					{"chapter": 12, "dialogue": "挑战天道19", "unlocked": true, "bgm": null,"trigger":false},				
					{"chapter": 12, "dialogue": "挑战天道20", "unlocked": true, "bgm": null,"trigger":false},							
					
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},
	"直面天道":{
		"dialogues": [
				#0
					{"chapter": 12, "dialogue": "直面天道1", "unlocked": true, "bgm": null,"trigger":false},																																																			
					{"chapter": 12, "dialogue": "直面天道2", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 12, "dialogue": "直面天道3", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 12, "dialogue": "直面天道4", "unlocked": true, "bgm": null,"trigger":false},		
					{"chapter": 12, "dialogue": "直面天道5", "unlocked": true, "bgm": null,"trigger":false},			
					{"chapter": 12, "dialogue": "直面天道6", "unlocked": true, "bgm": null,"trigger":false},							
					{"chapter": 12, "dialogue": "直面天道7", "unlocked": true, "bgm": "res://Audio/BGM/鬼哭無明 [TubeRipper.cc].ogg","trigger":false},			
					{"chapter": 12, "dialogue": "直面天道8", "unlocked": true, "bgm": "res://Audio/BGM/四个人的幸福时光.mp3","trigger":false},								
				],
		"current_dialogue_index": 0,	
		"constNpc": false	
	},		

	"结局":{
		"dialogues": [
				#0
					{"chapter": 12, "dialogue": "结局0", "unlocked": true, "bgm": "res://Audio/BGM/#仙境.ogg","trigger":false},								
					{"chapter": 12, "dialogue": "结局1", "unlocked": true, "bgm": null,"trigger":false},																																																									
					{"chapter": 12, "dialogue": "结局2", "unlocked": true, "bgm": "res://Audio/BGM/比翼鸟.ogg","trigger":false},			
					{"chapter": 12, "dialogue": "结局3", "unlocked": true, "bgm": "res://Audio/BGM/四个人的幸福时光.mp3","trigger":false},
					{"chapter": 12, "dialogue": "结局4", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "结局5", "unlocked": true, "bgm":"res://Audio/BGM/SWD5 无奈.mp3" ,"trigger":false},
					{"chapter": 12, "dialogue": "结局6", "unlocked": true, "bgm": "res://Audio/BGM/雪見-落入凡塵 [TubeRipper.cc].ogg" ,"trigger":false},
					{"chapter": 12, "dialogue": "结局7", "unlocked": true, "bgm": null,"trigger":false},
					{"chapter": 12, "dialogue": "结局8", "unlocked": true, "bgm": null,"trigger":false},
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



var saved_trigger_places
var totalPotentialBall = 0
var uniqueId
var countDownOn = false
var triggerPlace ={				
   "新手警告": {"trigger":false, "disable": false},
	"玉帝物品事件": {"trigger":false, "disable": true},
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
	"金甲吃饭": {"trigger":false, "disable": false},
	
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
	"初见孟婆": {"trigger":false, "disable": false},
	"真离开地府": {"trigger":false, "disable": false},
	"找罐子": {"trigger":false, "disable": false},
	"重遇上官1": {"trigger":false, "disable": false},
	"重遇上官2": {"trigger":false, "disable": false},    
	"第一次遇鬼": {"trigger":false, "disable": false},
	"进回忆": {"trigger":false, "disable": false},    
	"进回忆2": {"trigger":false, "disable": false},            
	"进回忆3": {"trigger":false, "disable": false},    
	"进回忆4": {"trigger":false, "disable": false},    
	"回忆3": {"trigger":false, "disable": false},    
	"地府决战": {"trigger":false, "disable": false},    
	"凌若昭回忆": {"trigger":false, "disable": false},    
	"凌若昭回忆2": {"trigger":false, "disable": true}, 
	"听闻砍头": {"trigger":false, "disable": true},                          
	"再见小二": {"trigger":false, "disable": false},    
	"寻四圣2": {"trigger":false, "disable": false},    
	"寻四圣3": {"trigger":false, "disable": false},    
	"方寸山之魔": {"trigger":false, "disable": true},        
	"初见观音": {"trigger":false, "disable": false},        
	"五庄观": {"trigger":false, "disable": false},    
	"五庄观2": {"trigger":false, "disable": false},    
	"再见观音": {"trigger":false, "disable": true},        
	"长寿村酒楼掌柜": {"trigger":false, "disable": true},        
	"神庙": {"trigger":false, "disable": false},
	"幻境1": {"trigger":false, "disable": false},    
	"幻境2": {"trigger":false, "disable": false},        
	"幻境3": {"trigger":false, "disable": false},        
	"幻境4": {"trigger":false, "disable": false},        
	"女娲神迹": {"trigger":false, "disable": false},            
	"六耳救女孩": {"trigger":false, "disable": false},
	"月宫之战1": {"trigger":false, "disable": false},    
	"月宫之战2": {"trigger":false, "disable": false},        
	"月宫之战3": {"trigger":false, "disable": false},        
	"月宫之战4": {"trigger":false, "disable": false},  	
	"月宫之战5": {"trigger":false, "disable": false}, 
	"玉帝殿前": {"trigger":false, "disable": false}, 
	"直面天道5": {"trigger":false, "disable": true}, 
	
}

var isDead ={
	"塔5boss": false
}


func _ready():
	currScene = get_tree().get_current_scene().get_name()
	uniqueId = OS.get_unique_id()
	#FightScenePlayers.fightScenePlayerData['时追云'].additionDmg *= 10
	
var deltas

var noMouse = true
var noKeyboard = false

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
	saveData.petPotentialProgress = petPotentialProgress
	saveData.smallPets = smallPets
	saveData.totalPotentialBall = totalPotentialBall
	saveData.wutongOn = wutongOn
	saveData.canMenu = canMenu
	saveData.lost = lost
	saveData.questItemShow = questItemShow
	saveData.gameRound = gameRound
	saveData.maxLevel = maxLevel
	saveData.baseChance = baseChance
	saveData.noMouse = noMouse
	saveData.noKeyboard = noKeyboard
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
	saveData.smallPetData = SmallPetData.currSmallPetData
	saveData.onGhost = onGhost
	saveData.yuDiItem = yuDiItem
	saveData.gai = gai
func loadData():
	#lost = saveData.lost
	petPotentialProgress = saveData.petPotentialProgress
	smallPets = saveData.smallPets
	totalPotentialBall = saveData.totalPotentialBall
	wutongOn = saveData.wutongOn
	questItemShow = saveData.questItemShow
	gameRound = saveData.gameRound
	gai = saveData.gai
	canMenu = saveData.canMenu
	maxLevel = saveData.maxLevel
	onGhost = saveData.onGhost
	SmallPetData.currSmallPetData = saveData.smallPetData
	baseChance = saveData.baseChance
	noKeyboard = saveData.noKeyboard
	noMouse = saveData.noMouse
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
	yuDiItem = saveData.yuDiItem
	if saveData.has("isDead"):
		isDead = saveData.isDead
	if saveData.has("treasureBox"):
		treasureBox = saveData.treasureBox
	uniqueId = saveData.uniqueId

	# Ensure saved data has all default places, add if missing

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
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp").visible = false
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
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/exp").visible = false
	FightScenePlayers.golds = ( decrypt(FightScenePlayers.golds) - goldAmount ) * enKey 
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
	playsound("res://Audio/SE/006-System06.ogg")
	
func removeItem(item,type,bagPlace,num):
	var bag = FightScenePlayers[bagPlace]
	print(bag[item],"/",item,type,bagPlace,num)
	bag[item].number -= num
	if bag[item].number == 0:
		bag.erase(bag[item].info.name) 


	Global.systemMsg.append("失去了"+item + "x" + str(num))
	get_tree().current_scene.get_node("CanvasLayer").renderMsg()	







func playSound(sound):
	get_tree().current_scene.get_node("subSound").stop()
	get_tree().current_scene.get_node("subSound").stream = load(sound)
	get_tree().current_scene.get_node("subSound").play()
	#get_tree().current_scene.get_node("AudioStreamPlayer2D").stop()	
var dial = null
var onGhost = true
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

func showViolence(type,value):
	get_tree().current_scene.get_node("CanvasLayer/violencePoint").visible = true
	if type == "negative":
		get_tree().current_scene.get_node("CanvasLayer/violencePoint/Label").modulate = "red"
		get_tree().current_scene.get_node("CanvasLayer/violencePoint/Label").text = "-" + str(value)
	else:
		get_tree().current_scene.get_node("CanvasLayer/violencePoint/Label").modulate = "green"
		get_tree().current_scene.get_node("CanvasLayer/violencePoint/Label").text = "+" + str(value)
	get_tree().current_scene.get_node("CanvasLayer/AnimationPlayer").play("showViolence")
func changeScene(new_scene, position):

	get_tree().change_scene_to_file("res://Scene/"+new_scene+".tscn")
	if position == null:
		return
	Global.load = true
	mapPlayerPos = position
func changeDirection(direction):
	get_tree().current_scene.get_node("player/Sprite2D").visible = false
	get_tree().current_scene.get_node("player/AnimatedSprite2D").visible = true
	get_tree().current_scene.get_node("player/AnimatedSprite2D").play(direction)
func skipChapter():
	atNight = false
	FightScenePlayers.fightScenePlayerData["时追云"].level = 45
	FightScenePlayers.fightScenePlayerData["时追云"].potential = 290 * Global.enKey
	FightScenePlayers.fightScenePlayerData["时追云"].exp = 200000 * Global.enKey
	FightScenePlayers.fightScenePlayerData["大海龟"].level = 45
	FightScenePlayers.fightScenePlayerData["时追云"].item.weapon = ItemData.weapon.get("碧玉剑")
	FightScenePlayers.fightScenePlayerData["时追云"].item.accessories = ItemData.accessories.get("护身符")
	FightScenePlayers.fightScenePlayerData["时追云"].item.cloth = ItemData.cloth.get("金刚甲")	
	FightScenePlayers.fightScenePlayerData["时追云"].item.shoes = ItemData.shoes.get("无暇靴")	
	FightScenePlayers.fightScenePlayerData["时追云"].item.hat = ItemData.hat.get("乾坤帽")	
	onTeamPet.append("大海龟")
	onTeamSmallPet.append("敖雨")
	current_chapter_id = 6
	#dial = "前往地府"
	#npcs.get("前往地府").current_dialogue_index = 4
	changeScene("大唐国境边缘",null)
	FightScenePlayers.learnMagic("时追云","高等炼体术")
	FightScenePlayers.learnMagic("时追云","破甲术")
	FightScenePlayers.learnMagic("时追云","横扫千军")
func getnode(nodePath):
	return get_tree().current_scene.get_node(nodePath)
func changevis(place, name):
	if npcVis.get(place).get(name).visible: 
		npcVis.get(place).get(name).visible = false
	else:
		npcVis.get(place).get(name).visible = true
func changebgm(bgm):
	if bgm == null:
		get_tree().current_scene.get_node("AudioStreamPlayer2D").stream = null
		return
	get_tree().current_scene.get_node("AudioStreamPlayer2D").stream = load(bgm)
	get_tree().current_scene.get_node("AudioStreamPlayer2D").play()
func playsound(sound):
	if sound == null:
		get_tree().current_scene.get_node("oneTimeSound").stream = null
		return
	get_tree ().current_scene.get_node("oneTimeSound").stream = load(sound)
	get_tree().current_scene.get_node("oneTimeSound").play()		
func toggleballon():
	if get_tree().current_scene.get_node("ExampleBalloon").visible:
		get_tree().current_scene.get_node("ExampleBalloon").visible = false
	else:
		get_tree().current_scene.get_node("ExampleBalloon").visible = true
func addshader(place, shader):
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load(shader)
	# 应用到当前 2D 节点，比如 Sprite2D
	
	
	
	get_tree().current_scene.get_node(place).material = shader_material
func removeshader(place):
	get_tree().current_scene.get_node(place).material = null

func move():
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/白虎").visible = false
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/白虎2").visible = false
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/shadow").visible = false
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/shadow").visible = false	
	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/shadow").visible = false	
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/player").visible = false
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/player").visible = false	
	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/player").visible = false		
	
	
	
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/朱雀").visible = true
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/姜韵3").visible = true	
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/青龙3").visible = true
	
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/姜韵3").visible = true			
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/青龙3").visible = true

	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/姜韵3").visible = true		
	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/青龙3").visible = true

	
	
	get_tree().current_scene.get_node("SubViewportContainer/SubViewport/北俱芦洲/AnimationPlayer").play("move_凤凰")
	
func moveTiger():
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/白虎").visible = true
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/白虎2").visible = true
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/白虎").play("run")
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/白虎2").play("run")
	
	
	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/白虎3").visible = true
	get_tree().current_scene.get_node("SubViewportContainer3/SubViewport/北俱芦洲/白虎4").visible = true	
	
	
	get_tree().current_scene.get_node("SubViewportContainer2/SubViewport/北俱芦洲/AnimationPlayer").play("move白虎")
	
func showMsg(text):
	getnode("messageLayer/importantMsg").visible = true
	getnode("messageLayer/importantMsg/Panel/ImportantMsg").text = text

static func resetGlobal():
	var new_state = load("res://Global.gd").new()
	var vars_to_reset = [	"monsterIdx",
	"monsterRemain",
	"playerIdx",
	"easyLevels",
	"dangerScene",
	"menuOut",
	"healBuffAmount",
	"onAttackingList",
	"currAttacker",
	"wait",
	"target",
	"monsterTarget",
	"onPhone",
	"onButton",
	"bgmTimer",
	"battleButtonIndex",
	"maxLevel",
	"onAttackPicking",
	"onMagicAttackPicking",
	"playersAppended",
	"onMagicAttacking",
	"onAttacking",
	"onHitPlayer",
	"alivePlayers",
	"selectedTarget",
	"onBigPicture",
	"currPlayerMagic",
	"onMagicSelectPicking",
	"magicSelectIndex",
	"currUsingMagic",
	"killedAmount",
	"onItemSelectPicking",
	"onItemUsePicking",
	"onItemUsing",
	"currUsingItem",
	"itemSelectIndex",
	"itemList",
	"canCalculateAfterMulti",
	"currHitType",
	"currPhysicDmg",
	"currMagicDmg",
	"dealtDmg",
	"playerDirection",
	"onHitEnemy",
	"onHitAllie",
	"canBlock",
	"blocked",
	"allieSelectIndex",
	"allieTarget",
	"buffTarget",
	"usingDart",
	"onItemSelect",
	"onItemIndexSelect",
	"currMenuItem",
	"onMenuItemUsing",
	"showBlack",
	"itemPlayers",
	"itemPlayerIndex",
	"canAttack",
	"prevScene",
	"noSounds",
	"lost",
	"targetMonsterIdx",
	"playerMagicList",
	"lastMagic",
	"finishingBattle",
	"onMenuSelectCharacter",
	"onItemPage",
	"onMagicPage",
	"onStatusPage",
	"onArmorItemPage",
	"onSkillPointPage",
	"onMouse",
	"onFight",
	"canLose",
	"itemControlType",
	"key",
	"currUsingItemPlayer",
	"onTalk",
	"onQuitMenu",
	"onSavePage",
	"onLoadPage",
	"currShopItem",
	"canEnemyHit",
	"onQuest",
	"onMultiHit",
	"fangCunState",
	"atDark",
	"onBoss",
	"isBoss",
	"cantShow",
	"bgmList",
	"questItem",
	"atNight",
	"currentCamera",
	"currPlayer",
	"currScene",
	"noLimit",
	"onTeamPlayer",
	"onTeamPet",
	"onTeamSmallPet",
	"smallPets",
	"currPlayerPos",
	"currNpc",
	"saveIndex",
	"petTarget",
	"systemMsg",
	"onXiaoErZhenShen",
	"onPet",
	"onSkipFight",
	"violencePoint",
	"questHint",
	"damageReward1",
	"chapters",
	"tempValue",
	"arDark",
	"current_chapter_id",
	"fightTime",
	"gai",
	"mcVisible",
	"npcVis",
	"",
	"musicOn",
	"enKey",
	"quests",
	"yuDiItem",
	"canTake",
	"load",
	"npcs",
	"potentialBalls",
	"petFoodBalls",
	"treasureBox",
	"autoDialogue",
	"storyVars",
	"vis",
	"mapPlayerPos",
	"haveLantern",
	"saveData",
	"onHurry",
	"saved_trigger_places",
	"totalPotentialBall",
	"uniqueId",
	"countDownOn",
	"triggerPlace",
	"isDead",
	"dial",
	"onGhost"
	]
	for name in vars_to_reset:
		Global.set(name, new_state.get(name))

static func resetPlayer():
	var new_state = load("res://Script/FightScenePlayers.gd").new()
	var vars_to_reset = ["keyItem","fightScenePlayerData2","fightScenePlayerData"]
	for name in vars_to_reset:
		FightScenePlayers.set(name, new_state.get(name))
	FightScenePlayers.fightScenePlayerData = FightScenePlayers.fightScenePlayerData2

func playAllSound():
	for i in getnode("thunderSound").get_children():
		i.play()
func stopAllSound():
	for i in getnode("thunderSound").get_children():
		i.stream = null
static func resetNpcVis():
	var new_state = load("res://Global.gd").new()
	var vars_to_reset = ["npcVis","npcs"
	]
	for name in vars_to_reset:
		Global.set(name, new_state.get(name))
func addStuff():
	npcs["创界山"] = {
		"dialogues": [ 
			{
				"chapter": 10,
				"dialogue": "创界山1",
				"unlocked": true,
				"bgm": null,
				"trigger": false
			},
				{
				"chapter": 10,
				"dialogue": "创界山2",
				"unlocked": true,
				"bgm": null,
				"trigger": false
			}
		],
		"current_dialogue_index": 0,
		"constNpc": false
	}
#	npcs["月宫之战"]["dialogues"].append({
#		"chapter": 11,
#		"dialogue": "月宫之战14",
#		"unlocked": true,
#		"bgm": null,
#		"trigger": false,
#		"disable": false,
#	})


func isNewPlayer():
	if get_tree().current_scene.is_new_player():
		get_tree().current_scene.get_current_player_num()
	else:
		pass
