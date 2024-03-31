extends AnimatedSprite2D
@export var id = ""

# Called when the node enters the scene tree for the first time.
func _ready():
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
	if !Global.atNight or Global.potentialBalls.get(id).pickUp:
		self.visible = false
	else:
		self.visible = true

func _on_area_2d_body_entered(body):
	if Global.atNight and Global.potentialBalls.get(id).pickUp == false:
		for i in FightScenePlayers.fightScenePlayerData:
			FightScenePlayers.fightScenePlayerData.get(i).potential += 5
			body.get_node("AudioStreamPlayer2D").stream = load("res://Audio/SE/回复.ogg")
			body.get_node("AudioStreamPlayer2D").play()
			body.get_node("effect").visible = true
			body.get_node("effect").play()
		queue_free()
		Global.potentialBalls.get(id).pickUp = true
