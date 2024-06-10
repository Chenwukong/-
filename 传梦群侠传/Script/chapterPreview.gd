extends Node2D
var chapterId

# Called when the node enters the scene tree for the first time.
func _ready():
	chapterId = Global.current_chapter_id
	match chapterId:
		1:
			$Panel/Label.text = "第一章:  始"
		2:
			$Panel/Label.text = "第二章:  人"	
		3: 
			$Panel/Label.text = "第三章:  仙"
	
	
	
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
