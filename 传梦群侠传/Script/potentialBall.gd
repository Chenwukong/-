extends AnimatedSprite2D
@export var id = ""
var added = false
# Called when the node enters the scene tree for the first time.
func _ready():

	if get_tree().current_scene.name == "灵力储存场":
		var index = 0
		for child in get_parent().get_children():
			if child is AnimatedSprite2D and child.id == "":
				index += 1
				id = "灵力场" + str(index)
	if id in Global.potentialBalls:
		pass
	else:
		Global.potentialBalls[id] = {"pickUp": false}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if id in Global.potentialBalls:
		pass
	else:
		Global.potentialBalls[id] = {"pickUp": false}
	if Global.potentialBalls.get(id).pickUp:
		self.visible = false
	else:
		self.visible = true

func _on_area_2d_body_entered(body):
	
	if body.name == "StaticBody2D" or body.name == "CharacterBody2D":
		return
	if Global.potentialBalls.get(id).pickUp == false:
		Global.totalPotentialBall += 1
		if get_tree().current_scene.name == "灵力储存场":
			Global.violencePoint -= 20
			Global.showViolence("negative",20)
			
		for i in FightScenePlayers.fightScenePlayerData:
			if get_tree().current_scene.name == "灵力储存场":
				FightScenePlayers.fightScenePlayerData.get(i).potential += 2 * Global.enKey
			else:			
				FightScenePlayers.fightScenePlayerData.get(i).potential += 5 * Global.enKey
			body.get_node("AudioStreamPlayer2D").stream = load("res://Audio/SE/回复.ogg")
			body.get_node("AudioStreamPlayer2D").play()
			body.get_node("effect").visible = true
			body.get_node("effect").play("potentialBall")
			if !added:
				if get_tree().current_scene.name == "灵力储存场":
					Global.systemMsg.append("全队获得了2潜力点！")
				else:
					Global.systemMsg.append("全队获得了5潜力点！")
					
				
			added = true
			get_tree().current_scene.get_node("CanvasLayer").renderMsg()
		queue_free()
		Global.potentialBalls.get(id).pickUp = true
