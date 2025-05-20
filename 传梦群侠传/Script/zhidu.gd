extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var image = WasDecoder.new().decode_was("res://Pictures/攻击.was")
	if image:
		var texture = ImageTexture.create_from_image(image)
		$Sprite2D.texture = texture  # 替换你自己的节点路径

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
