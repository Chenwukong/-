extends Sprite2D

@export var speed = 400

# 存放所有云图片的数组
var clouds = []

# 屏幕的宽度
var screen_width
var oriPosition
var trigger = false
func _ready():
	# 获取屏幕宽度
	screen_width = ProjectSettings.get_setting("display/window/size/width")
	oriPosition = position
var deltas
func _process(delta):
		
		deltas = delta
		if Global.onFight:
			visible = false
		else:
			visible = true
			
		if !trigger:	
			position.x -= speed * delta
		else:
			for i in $"..".get_children():
				var playerPos = $"../../player".position
				speed =1000

				if i.position.x >= playerPos.x:
					i.position.x += speed * deltas
				else:
					i.position.x -= speed * deltas
				$"../../cloudTimer".start()
			
	
		if position.x + texture.get_size().x < 0:
			position.x = oriPosition.x



func moveCloud():
	trigger = true
	for i in $"..".get_children():
		print(i)
		var playerPos = $"../../player".position
		speed = 600

		if i.position.x > playerPos.x:
			i.position.x += speed * deltas
		$"../../cloudTimer".start()
		


func _on_cloud_timer_timeout():
	visible = false
