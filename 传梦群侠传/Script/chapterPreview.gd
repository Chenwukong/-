extends Node2D
var chapterId

# Called when the node enters the scene tree for the first time.
func _ready():
	chapterId = Global.current_chapter_id
	match chapterId:
		1:
			$Panel/Label.text = "第一章:  浮生难安"
		2:
			Global.cantShow.append("建邺城右")
			$Panel/Label.text = "第二章:  人以当先"	
		3: 
			$Panel/Label.text = "第三章:  灵台仙闻"
		4:
			$Panel/Label.text = "第四章:  无妄妖祸"
		5:
			$Panel/Label.text = "第五章:  鬼蜮迷途"
		6:
			$Panel/Label.text = "第六章:  魅情实切"
		7:
			$Panel/Label.text = "第七章:  不屈之魂"
		8:
			$Panel/Label.text = "第八章:  西域险行"
		9:
			$Panel/Label.text = "第九章:  梦澹现世"			
		10:
			$Panel/Label.text = "第十章:  魔窟深渊"				
		11:
			$Panel/Label.text = "第十一章:  终局之战"			
		12:
			$Panel/Label.text = "第十二章:  道归虚无"				
		
		
	
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	match chapterId:
		1:
			get_tree().change_scene_to_file("res://Scene/"+"东海湾"+".tscn")
		2:
			get_tree().change_scene_to_file("res://Scene/"+"江南野外"+".tscn")	
			Global.mapPlayerPos = Vector2(2622,1276)
		3:
			get_tree().change_scene_to_file("res://Scene/"+"方寸山迷境"+".tscn")	
			Global.mapPlayerPos = Vector2(-1046, 283)			
		4:
			get_tree().change_scene_to_file("res://Scene/"+"东海沉船"+".tscn")	
		5:
			get_tree().change_scene_to_file("res://Scene/"+"阴阳洞"+".tscn")			
		6:
			Global.dial = "凌若昭回忆"
			get_tree().change_scene_to_file("res://Scene/"+"两界山"+".tscn")	
		7:
			get_tree().change_scene_to_file("res://Scene/"+"第七章序幕"+".tscn")	
		8:
			get_tree().change_scene_to_file("res://Scene/"+"方寸山"+".tscn")	
		9:
			Global.dial = "菩提老祖"
			Global.changeScene("灵台宫",Vector2(391,277))	
		10:
			Global.mapPlayerPos = Vector2(1995,1759)
			get_tree().change_scene_to_file("res://Scene/"+"创界山"+".tscn")	
			Global.dial = "创界山"
		11:
			get_tree().change_scene_to_file("res://Scene/"+"天上虚空"+".tscn")			
		12:
			Global.changeScene("凌霄宝殿",Vector2(906,983))	
			Global.dial = "道归虚无"
