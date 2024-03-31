extends Node



var monsterIdx = -1
var monsterRemain = false
var playerIdx = -1
var easyLevels = ["东海湾", "easy_level_2", "easy_level_3"]
var dangerScene = {"东海湾":2}
var menuOut = false

var onAttackingList = []
var currAttacker = ""

var target = null
var monsterTarget = null
var onPhone = true
var onButton = false

var battleButtonIndex = 0

var onAttackPicking = false #是否在选择攻击对象
var onMagicAttackPicking = false

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

var currHitType = ""
var currPhysicDmg = 0
var currMagicDmg = 0
var dealtDmg = 0

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

var itemPlayers = []
var itemPlayerIndex
func connectAutoAttackSignal(enemy_instance):
	enemy_instance.connect('autoAttackSignal', self, '_on_auto_attack')
	
func _on_auto_attack():
	print("Auto attack signal received")

var targetMonsterIdx = 0
var playerMagicList

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
var currUsingItemPlayer
var onTalk = false
var onQuitMenu = false
var onSavePage = false
var onLoadPage = false
var currShopItem 
var canEnemyHit = true
var onQuest = false
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
	#"res://Audio/BGM/轩辕-战斗2.mp3",复仇
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
	#"res://Audio/BGM/【战斗】神话降临.mp3",
	#"res://Audio/BGM/【镜影命缘】.mp3",
	]
#保存的
var questItem = {}
var atNight = false
var currentCamera
var currPlayer
var currScene
var onTeamPlayer = ["时追云","姜韵"]
var onTeamPet = []
var currPlayerPos
var currNpc = null
var saveIndex = 0
var systemMsg = [
	
]
var onSkipFight = false
var violencePoint = 0
var questHint = ""


var chapters = {
	"chapter1": {"completed": false, "tasks": {"task1": false, "task2": false}},
	"chapter2": {"completed": false, "tasks": {"task3": false}},
	# 直到 chapter10
}

var current_chapter_id = 1


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
	}	
	
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
			],
		"current_dialogue_index": 0,	
		"constNpc": false
	},	
	"传梦":{
		"dialogues": [
				#0
					{"chapter": 1, "dialogue": "新手警告", "unlocked": true, "bgm":null,"trigger":false},
				],
			"current_dialogue_index": 0,	
			"constNpc": false
		},						
}
var potentialBalls = {

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
}

func _ready():
	currScene = get_tree().get_current_scene().get_name()


func _process(delta):

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
func loadData():
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
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold/goldValue").text = str(goldAmount)
	FightScenePlayers.golds += goldAmount
	
	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer").visible = true	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/gold").visible = true	
	
	get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/006-System06.ogg")
	get_tree().current_scene.get_node("subSound").play()
	get_tree().current_scene.get_node("battleRewardGone").start()
	Global.systemMsg.append("全队获得了 " + str(goldAmount) + " 银两")
	get_tree().current_scene.get_node("CanvasLayer").renderMsg()

func addItem(item,type,bagPlace,num):
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").text = str("获得了"+item)
	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer").visible = true	
	get_tree().current_scene.get_node("BattleReward/BattleReward/CanvasLayer/Panel/item").visible = true	
	
	get_tree().current_scene.get_node("subSound").stream = load("res://Audio/SE/006-System06.ogg")
	get_tree().current_scene.get_node("subSound").play()
	get_tree().current_scene.get_node("battleRewardGone").start()
	var bag = FightScenePlayers[bagPlace]
	if bag.has(item):
		bag[item].number += 1
	else:
		bag[item] = {
			"info": ItemData[type].get(item),
			"type": type,
			"number": 1,
			"added": false
		}

	Global.systemMsg.append("获得了"+item)
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
