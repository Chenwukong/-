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
	if toScene in Global.cantShow:
		visible = false
		$area2D/CollisionShape2D.disabled = true
	else:
		visible = true
		$area2D/CollisionShape2D.disabled = false		

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("mapPlayer"):
		if Global.atNight:
			for i in noNightScene:
				if toScene == i:
					return
		
		if toScene == "江南野外" and Global.current_chapter_id == 2:
			get_tree().change_scene_to_file("res://Scene/chapterPreview.tscn")
		else:
			Global.prevScene = currScene.name
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
		if toScene == "东海海道":
			return Vector2(1598, 481)
	if currScene == "建邺城":
		if toScene == "东海湾":
			return Vector2(148, 693)		
		if toScene == "建邺城右":
			return Vector2(1639, 96)
		if toScene == "李善人家1":
			return Vector2(582, 459)
	if currScene == "李善人家1":
		if toScene == "建邺城":
			return Vector2(121, 522)	
		if toScene == "李善人家2":
			return Vector2(767,332)
	if currScene == "李善人家2":
		return Vector2(190, 434)
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
		if toScene == "建邺城右":	
			return Vector2(214, 480)	
					
	if currScene == "长安北":
		if toScene == "长安城":
			return Vector2(1353,77)			
		if toScene == "大唐官府":
			return Vector2(3654,1974)
		if toScene == "锁妖塔1":
			return Vector2(1519,1479)
		if toScene ==  "江南野外":
			return Vector2(-16, 157)	
			
			
			
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
		if toScene == "回春堂":
			return Vector2(445,410)
			
	if currScene == "大唐官府":
		if toScene == "大唐官府大厅":
			return Vector2(654,403)			
		if toScene == "长安城":
			return Vector2(288,254)	
		if toScene == "长安北":
			return Vector2(442,417)				
	if currScene == "大唐官府大厅"	:	
		if toScene == "大唐官府":
			return Vector2(2091,1231)												
	if currScene == "金甲家":		
		if toScene == "长安城":
			return Vector2(3831,1253)								
	if currScene == "回春堂":
		if toScene == "长安城":
			return Vector2(1754,2002)				
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
			return Vector2(1997,635)
		if toScene == "锁妖塔5":
			return Vector2(2635, 942)		
	if currScene == "锁妖塔5":
		if toScene == "锁妖塔4":
			return Vector2(2805,787)
		if toScene == "锁妖塔6":
			return Vector2(1147, 1055)		
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
		if toScene == "国境南":
			return Vector2(2650,900)
	if currScene == "国境南":
		if toScene == "大唐国境":
			return Vector2(2222,1260)
		if toScene == "平定峰":
			return Vector2(2460,1222)	
	if currScene == "方寸山迷境":
		return Vector2(526,2133)	
	if currScene == "方寸山":
		if toScene == "灵台宫":
			return Vector2(116, 397)
		if toScene == "方寸厢房":
			return Vector2(444,324)
	if currScene == "方寸厢房":
		return Vector2(3352,1981)
	if currScene == "灵台宫":
		return Vector2(2763, 137)
	if currScene == "东海海道": 
		if toScene == "东海海道2":
			return Vector2(1094, 949)
		if toScene == "东海湾":
			return Vector2(1928, 758)
	if currScene == "东海海道2": 
		if toScene == "东海海道":
			return Vector2(1094, 949)
		if toScene == "东海海道3":
			return Vector2(1567, 1316)			
	if currScene == "东海海道3": 
		if toScene == "东海海道2":
			return Vector2(3110, 1086)
		if toScene == "东海龙宫":
			return Vector2(256, 2151)						
	if currScene == "东海龙宫":
		if toScene == "水晶宫":
			return Vector2(130,388)
		if toScene == "东海海道3":
			return Vector2(2786,908)
	if currScene == "水晶宫":
		return Vector2(2258,1051)
	if currScene == "东海沉船":
		if toScene == "东海沉船内":
			return Vector2(1474,736)
		if toScene == "海底迷宫1":
			return Vector2(1182, 1319)			
	if currScene == "东海沉船内":
		return Vector2(1803,220)
	if currScene == "傲来国":
		if toScene == "傲来杂货铺":
			return Vector2(1989, 1084)
		if toScene == "傲来酒店":
			return Vector2(2346, 1252)
		if toScene == "傲来布店":
			return Vector2(1945, 1012)
		if toScene == "傲来钱庄":
			return Vector2(1945, 1012)		
		if toScene == "傲来武器铺":
			return Vector2(1490, 976)	
		if toScene == "傲来民居":
			return Vector2(301, 368)	
		if toScene == "傲来药店":
			return Vector2(520,400)							
		if toScene == "女儿村":
			return Vector2(2336, 2423)		
		if toScene == "花果山":
			return Vector2(2336, 2423)					
				
				
						
	if currScene == "傲来酒店":
		return Vector2(2618, 2134)
	if currScene == "傲来杂货铺":
		return Vector2(975,2343)
	if currScene == "傲来布店":
		return Vector2(-371, 1299)
	if currScene == "傲来钱庄":
		return Vector2(1081, 1490)		
	if currScene == "傲来武器铺":
		return Vector2(1550, 1867)
	if currScene == "傲来民居":
		return Vector2(398,540)
	if currScene == "傲来药店":
		return Vector2(133,1924)		
		
		
	if currScene == "女儿村":
		if toScene == "傲来国":
			return Vector2(-891, -117)
		if toScene == "女儿村村长家":
			return Vector2(433, 251)
		if toScene == "女儿村民居":
			return Vector2(1490, 976)
	if currScene == "女儿村村长家":
		return Vector2(271, 251)
	if currScene == "女儿村民居":
		return Vector2(1795,452)
	if currScene == "花果山":
		if toScene == "水帘洞":
			return Vector2(469, 1479)						
	if currScene == "水帘洞":
		return Vector2(861, 957)			
			
	if currScene == "海底迷宫1":
		if toScene == "花果山":
			return Vector2(2361, 2209)
		if toScene == "海底迷宫1":
			return Vector2(1182, 1319)				
		if toScene == "海底迷宫2":
			return Vector2(1296, 1340)			
	if currScene == "海底迷宫2":
		if toScene == "海底迷宫1":
			return Vector2(2531,454)			
		if toScene == "海底迷宫3":
			return Vector2(1114, 1108)		
	if currScene == "海底迷宫3":
		if toScene == "海底迷宫2":
			return Vector2(2499,1022)
		if toScene == "海底迷宫1":
			return Vector2(2531,454)			
		if toScene == "海底迷宫4":
			return Vector2(1233, 1263)	
	if currScene == "海底迷宫4":
		
		if toScene == "海底迷宫3":
			return Vector2(2597, 437)				
		if toScene == "海底迷宫5":
			return Vector2(1626, 1244)	
	if currScene == "海底迷宫5":
		if toScene == "海底迷宫4":
			return Vector2(2360, 1299)	
	if currScene == "地府":
		if toScene == "地府迷宫1":
			return Vector2(185,1932)
		if toScene == "轮回司":
			return Vector2(1208,1533)
		if toScene == "森罗殿":
			return Vector2(1641, 1420)
		if toScene == "轮回之门":
			return Vector2(2034,1766)			
	if currScene == "轮回之门":
		return Vector2(2171,1815)	
	if currScene == "森罗殿":
			return Vector2(241, 1081)			
	if currScene == "轮回司":
			return Vector2(1682, 1336)							
	if currScene == "地府迷宫1":
		if toScene == "地府":
			return Vector2(283, 232)
		if toScene == "地府迷宫2":
			return Vector2(2253, 1958)
	if currScene == "地府迷宫2":
		if toScene == "地府迷宫1":
			return Vector2(135,600)
		if toScene == "地府迷宫3":
			return Vector2(2021, 1821)			
	if currScene == "地府迷宫3":
		if toScene == "地府迷宫2":
			return Vector2(190,785)
		if toScene == "地府迷宫4":
			return Vector2(2253, 1958)					
	if currScene == "地府迷宫4":
		if toScene == "地府迷宫3":
			return Vector2(2241,495)
		if toScene == "鬼城下":
			return Vector2(-127,1613)					
	if currScene == "鬼城下":
		if toScene == "鬼城上":
			return Vector2(2241,495)	
	if currScene == "鬼城上":
		if toScene == "地狱深处":
			return Vector2(2241,495)				
	if currScene == "大唐国境边缘":
		if toScene == "大唐境外":
			return Vector2(1509, -108)				
	if currScene == "大唐境外":
		if toScene == "大唐国境边缘":
			return Vector2(-1132, 1226)				
		if toScene == "普陀山":
			return Vector2(1544, 1453)					
		if toScene == "五庄观":
			return Vector2(62, 581)				
			
			
			
			
			
			
			
						
	if currScene == "北俱芦洲":
		if toScene == "凤巢1":
			return Vector2(900,1760)	
		if toScene == "龙窟1":
			return Vector2(2552, 1960)	
	if currScene == "凤巢1":
		if toScene == "北俱芦洲":
			return Vector2(634, -150)
		if toScene == "凤巢2":
			return Vector2(185, 660)
	if currScene == "凤巢2":
		if toScene == "凤巢1":
			return Vector2(1440,593)
		if toScene == "凤巢3":
			return Vector2(151, 745)
	if currScene == "凤巢3":
		if toScene == "凤巢2":
			return Vector2(2290, 965)
		if toScene == "凤巢4":
			return Vector2(357,817)	
	if currScene == "凤巢4":
		if toScene == "凤巢3":
			return Vector2(2320,1750)
		if toScene == "凤巢5":
			return Vector2(1440,1764)	
	if currScene == "凤巢5":
		if toScene == "凤巢4":
			return Vector2(1373,590)
		if toScene == "凤巢6":
			return Vector2(109, 1678)	
	if currScene == "凤巢6":
		if toScene == "凤巢5":
			return Vector2(2142,621)
		if toScene == "凤巢7":
			return Vector2(88, 1067)	
	if currScene == "凤巢7":
		if toScene == "凤巢6":
			return Vector2(2225, 1086)
			
	if currScene == "龙窟1":
		if toScene == "北俱芦洲":
			return Vector2(-850, 1268)
		if toScene == "龙窟2":
			return Vector2(2338, 1385)
	if currScene == "龙窟2":
		if toScene == "龙窟1":
			return Vector2(-91, 755)
		if toScene == "龙窟3":
			return Vector2(-40, 492)
	if currScene == "龙窟3":
		if toScene == "龙窟2":
			return Vector2(315, 1727)
		if toScene == "龙窟4":
			return Vector2(32, 1730)	
	if currScene == "龙窟4":
		if toScene == "龙窟3":
			return Vector2(2280,1403)
		if toScene == "龙窟5":
			return Vector2(2323,644)	
	if currScene == "龙窟5":
		if toScene == "龙窟4":
			return Vector2(2355,1386)
		if toScene == "龙窟6":
			return Vector2(481, 1690)	
	if currScene == "龙窟6":
		if toScene == "龙窟5":
			return Vector2(689,1652)
		if toScene == "龙窟7":
			return Vector2(-11, 599)	
	if currScene == "龙窟7":
		if toScene == "龙窟6":
			return Vector2(2114,719)
	if currScene == "普陀山":
		if toScene == "潮音洞":
			return Vector2(904, 990)
		if toScene == "大唐境外":
			return Vector2(-528,-247)
			
	if currScene == "普陀山":
		return Vector2(536,794)
	if currScene == "五庄观":
		if toScene == "大唐境外":
			return Vector2(1487,475)
		if toScene == "乾坤殿":
			return Vector2(1487,475)
	if currScene == "乾坤殿":
		if toScene == "五庄观":
			return Vector2(483, 331)
