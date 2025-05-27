extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$".".texture = SPDecoder.解析第一帧到图像纹理("res://待机.was")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
