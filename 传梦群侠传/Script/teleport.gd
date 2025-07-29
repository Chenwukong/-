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
		if toScene == "镇魔地1":
			return Vector2(735,496)			
	if currScene == "镇魔地1":
		return Vector2(1548,175)	
				
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
			#1094, 949
			return Vector2(2512,1110)
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
			return Vector2(-290,2216)					
				
				
						
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
		if toScene == "傲来国":
			return	Vector2(3200,-167)			
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
		if toScene == "阴间货铺":
			return Vector2(520,400)				
	if currScene == "阴间货铺":
		return Vector2(-217,2016)					
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
		if toScene == "枯骨山":
			return Vector2(2062,1649)						
		if toScene == "西行之路":
			return Vector2(7369, 2225)		
	if currScene == "枯骨山":
		if toScene == "大唐境外":
			return Vector2(-518,1217)				
							
	if currScene == "西行之路":
		if toScene == "大唐境外":
			return Vector2(-506,1808)					
		if toScene == "朱紫国":
			return Vector2(156,1607)					
			
			
			
			
						
	if currScene == "北俱芦洲":
		if toScene == "凤巢1":
			return Vector2(900,1760)	
		if toScene == "龙窟1":
			return Vector2(2572, 1981)	
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
			return Vector2(1627,1510)
		if toScene == "大唐境外":
			return Vector2(-461,-146)
		if toScene == "镇魔地2":
			return Vector2(818,548)
	if currScene == "镇魔地2":
		return Vector2(1442,1060)		
			
	if currScene == "潮音洞":
		return Vector2(901,1008)
	if currScene == "五庄观":
		if toScene == "大唐境外":
			return Vector2(1487,475)
		if toScene == "乾坤殿":
			return Vector2(330,389)
		if toScene == "镇魔地3":
			return Vector2(818,548)			
	if currScene == "镇魔地3":
		return Vector2(923,585)		
			
			
	if currScene == "乾坤殿":
		if toScene == "五庄观":
			return Vector2(483, 331)
	if currScene == "朱紫国":
		if toScene == "朱紫国旅馆":
			return Vector2(461,877)
		if toScene == "朱紫国皇宫":
			return Vector2(1093, 1118)
		if toScene == "灵力储存场":
			return Vector2(741,1041)			
	if currScene == "灵力储存场":
		if toScene == "朱紫国":
			return Vector2(577,548)			
	if currScene == "朱紫国旅馆":						
		return Vector2(1027,1490)	
	if currScene == "朱紫国皇宫":						
		if toScene == "朱紫国":
			return Vector2(2004,341)	
	if currScene == "小西天":						
		return Vector2(1466,1433)	
	if currScene == "雷音寺":		
		if toScene == "小西天":
			return Vector2(218,-107)
		if toScene == "雷音地下":			
			return Vector2(2786,460)
	if currScene == "长寿村":						
		if toScene == "神庙":
			return Vector2(1702,913)	
		if toScene == "长寿药店":
			return Vector2(433,318)		
		if toScene == "长寿武器店":
			return Vector2(433,318)		
		if toScene == "长寿布店":
			return Vector2(211,282)			
		if toScene == "长寿村村长家":
			return Vector2(1318,998)							
		if toScene == "长寿村民居":
			return Vector2(1900,974)	
		if toScene == "长寿村酒店":
			return Vector2(1934,970)	
		if toScene == "创界山":
			return Vector2(1995,1759)	
		if toScene == "长寿郊外":
			return Vector2(2378,174)
	if currScene == "长寿药店":
		return Vector2(1778,1702)				
	if currScene == "长寿武器店":
		return Vector2(1649,911)	
	if currScene == "长寿布店":
		return Vector2(1847,1277)								
	if currScene == "长寿郊外":
		return Vector2(2374,1795)				
	if currScene == "传梦空间":
		if toScene == "长寿村":
			return Vector2(1489,9)	
	if currScene == "神庙":						
		if toScene == "长寿村":
			return Vector2(2306,117)	
	if currScene == "长寿村药店":						
		return Vector2(1809,1722)
	if currScene == "长寿村村长家":						
		return Vector2(1234,122)
	if currScene == "长寿村民居":						
		return Vector2(1158,1515)
	if currScene == "长寿村酒店":						
		return Vector2(2116,456)
	if currScene == "秘境":						
		return Vector2(725,766)
	if currScene == "创界山":						
		if toScene == "长寿村":
			return Vector2(2061,-98)	
		if toScene == "创界山顶":
			return Vector2(2006,2345)				
	if currScene == "创界山顶":						
		if toScene == "创界山":
			return Vector2(1811,891)				
		if toScene == "炼狱迷宫1":
			return Vector2(1720,1608)						
	if currScene == "炼狱迷宫1":						
		if toScene == "创界山顶":
			return Vector2(1811,891)				
		if toScene == "炼狱迷宫2":
			return Vector2(2006,1472)	
	if currScene == "炼狱迷宫2":						
		if toScene == "炼狱迷宫1":
			return Vector2(822,890)				
		if toScene == "炼狱迷宫3":
			return Vector2(1772,1590)				
	if currScene == "炼狱迷宫3":						
		if toScene == "炼狱迷宫2":
			return Vector2(1828,804)				
		if toScene == "炼狱迷宫4":
			return Vector2(863,780)							
	if currScene == "炼狱迷宫4":						
		if toScene == "炼狱迷宫3":
			return Vector2(1900,896)				
		if toScene == "炼狱迷宫5":
			return Vector2(668,1590)	
	if currScene == "炼狱迷宫5":						
		if toScene == "炼狱迷宫4":
			return Vector2(1838,848)				
		if toScene == "炼狱迷宫6":
			return Vector2(547,818)	
	if currScene == "炼狱迷宫6":						
		if toScene == "炼狱迷宫5":
			return Vector2(1491,814)				
		if toScene == "炼狱迷宫7":
			return Vector2(1814,848)	
	if currScene == "炼狱迷宫7":						
		if toScene == "炼狱迷宫6":
			return Vector2(1751,1613)				
		if toScene == "炼狱终点":
			return Vector2(1112,1398)				
	if currScene == "炼狱终点":						
		if toScene == "炼狱迷宫7":
			return Vector2(822,738)				
		if toScene == "炼狱终点":
			return Vector2(1112,1398)	
	if currScene == "天宫":						
		if toScene == "战神殿":
			return Vector2(1622,1406)				
		if toScene == "月宫":
			return Vector2(2319,1926)	
		if toScene == "凌霄宝殿":
			return Vector2(1837,1309)		
		if toScene == "兜率宫":
			return Vector2(579,324)					
			
	if currScene == "兜率宫":				
		if toScene == "天宫":
			return Vector2(-784,2365)		
						
	if currScene == "战神殿":	
		return Vector2(3379,90)		
	if currScene == "月宫":						
		if toScene == "天宫":
			return Vector2(-531,-380)					
		if toScene == "广寒宫":
			return Vector2(988,1371)
	if currScene == "广寒宫":						
		if toScene == "月宫":
			return Vector2(1927,903)			
			
