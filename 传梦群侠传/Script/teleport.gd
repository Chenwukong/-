extends AnimatedSprite2D
@export var toScene = ""

var currScene
var noNightScene
# Called when the node enters the scene tree for the first time.
func _ready():
	currScene = get_tree().current_scene
	noNightScene = ["李善人家1", "李善人家2","建邺布店","建邺药店"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("mapPlayer"):
		if Global.atNight:
			for i in noNightScene:
				if toScene == i:
					return
		get_tree().change_scene_to_file("res://Scene/"+toScene+".tscn")
		Global.mapPlayerPos = checkSetPos(currScene.name, toScene)
	
	
	Global.load = true
func _on_area_2d_area_entered(area):
	pass
	
func checkSetPos(currScene, toScene): 
	print(currScene, toScene)
	if currScene == "新手村":
		if toScene == "东海湾":
			return Vector2(2284,1559)	
		if toScene == "chapterPreview":
			return Vector2(2284,1559)				
			
			
					
	if currScene == "东海湾":
		if toScene == "建邺城":
			return Vector2(1215,222)
		if toScene == "东海龙宫":
			pass
	if currScene == "建邺城":
		if toScene == "东海湾":
			return Vector2(148, 693)		
		if toScene == "建邺城右":
			return Vector2(1639, 96)
		if toScene == "李善人家1":
			return Vector2(581, 388)
	if currScene == "李善人家1":
		if toScene == "建邺城":
			return Vector2(121, 522)	
		if toScene == "李善人家2":
			return Vector2(767,332)
	if currScene == "李善人家2":
		return Vector2(186, 368)
	if currScene == "建邺城右":
		if toScene == "建邺城":
			return Vector2(584, 1345)
		if toScene == "江南野外":
			return Vector2(2622,1276)	
		if toScene == "建邺布店":
			return Vector2(264,308)
		if toScene == "建邺药店":
			return Vector2(504, 402)			
			
		if toScene == "时追云家":	
			return Vector2(544,391)

	if currScene == "时追云家":
		return Vector2(2257, 447)	
	if currScene == "建邺布店":
		if toScene == "建邺城右":
			return Vector2(784, 189)
	if currScene == "建邺药店":
		if toScene == "建邺城右":
			return Vector2(1717,738)			
	if currScene == "江南野外":	
		if toScene == "长安北":
			return Vector2(2773,353)			
	if currScene == "长安北":
		if toScene == "长安城":
			print(1233333333)
			return Vector2(1353,77)			
		if toScene == "大唐官府":
			print(1233333333)
			return Vector2(3654,1974)
		if toScene == "锁妖塔":
			return Vector2(2773,353)
			
	if currScene == "长安城":
		if toScene == "长安北":
			return Vector2(2247,1815)				
		if toScene == "大唐官府":
			return Vector2(2492,2050)		
		if toScene == "金甲家":
			return Vector2(207,334)
		if toScene == "长安酒店":
			return Vector2(154,546)	
		if toScene == "大唐国境":
			return Vector2(2579,912)
			
	if currScene == "大唐官府":
		if toScene == "大唐官府大厅":
			return Vector2(654,403)			
		if toScene == "长安城":
			return Vector2(288,254)	
		if toScene == "长安城北":
			return Vector2(442,417)				
	if currScene == "大唐官府大厅"	:	
		if toScene == "大唐官府":
			return Vector2(2091,1231)												
	if currScene == "金甲家":		
		if toScene == "长安城":
			return Vector2(3831,1253)								
			
	if currScene == "长安酒店":
		if toScene == "长安城":
			return Vector2(3026,939)			
	if currScene == "锁妖塔1":
		if toScene == "锁妖塔2":
			return Vector2(1950,698)
		if toScene == "长安北":
			return Vector2(3154,938)
	if currScene == "锁妖塔2":
		if toScene == "锁妖塔1":
			return Vector2(2218,513)
		if toScene == "锁妖塔3":
			return Vector2(2012,1601)		
	if currScene == "锁妖塔3":
		if toScene == "锁妖塔2":
			return Vector2(2137,1700)
		if toScene == "锁妖塔4":
			return Vector2(2057,683)	
	if currScene == "锁妖塔4":
		if toScene == "锁妖塔3":
			return Vector2(2137,1700)
		if toScene == "锁妖塔5":
			return Vector2(2540, 892)		
	if currScene == "锁妖塔5":
		if toScene == "锁妖塔4":
			return Vector2(2805,787)
		if toScene == "锁妖塔6":
			return Vector2(2540, 892)		
	if currScene == "锁妖塔6":
		if toScene == "锁妖塔5":
			return Vector2(1115,1124)
		if toScene == "锁妖塔7":
			return Vector2(2073, 1229)	
	if currScene == "锁妖塔7":
		if toScene == "锁妖塔6":
			return Vector2(2000,1090)
	if currScene == "大唐国境":
		if toScene == "长安城":
			return Vector2(193,1877)
		if toScene == "国境北":
			return Vector2(2650,900)
	if currScene == "国境南":
		if toScene == "大唐国境":
			return Vector2(2222,1260)
		if toScene == "平定峰":
			return Vector2(2460,1222)	

