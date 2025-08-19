extends AnimatedSprite2D
@export var id = ""
var added = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if id in Global.petFoodBalls:
		pass
	else:
		if id == "":
			var index = 0
			for child in get_tree().get_nodes_in_group("petFoodBall"):
				index += 1
				id = get_tree().current_scene.name + str(index)
		Global.petFoodBalls[id] = {"pickUp": false}
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if id in Global.petFoodBalls:
		pass
	else:
		Global.petFoodBalls[id] = {"pickUp": false}
	if Global.petFoodBalls.get(id).pickUp:
		self.visible = false
	else:
		self.visible = true

func _on_area_2d_body_entered(body):
	if !body.get_node("effect"):
		return
	if Global.petFoodBalls.get(id).pickUp == false:
		FightScenePlayers.petFoodBall += 1
		FightScenePlayers.totalPetFoodBall += 1
		body.get_node("effect").visible = true
		body.get_node("effect").play("potentialBall")
		if !added:
			Global.systemMsg.append("获得了1灵宠力！")
			Global.playsound("res://Audio/SE/heal 1.ogg")
		added = true
		get_tree().current_scene.get_node("CanvasLayer").renderMsg()
		queue_free()
		Global.petFoodBalls.get(id).pickUp = true
