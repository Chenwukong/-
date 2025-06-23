extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("npcBody/npcShape").disabled = true
	get_node("npcBody/CollisionPolygon2D").disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
