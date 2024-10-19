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
			$Panel/Label.text = "第四章:  祸影流殇"
	
	
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
		
