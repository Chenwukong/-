extends CharacterBody2D

# 变量
@export var speed: float = 280.0
@export var target: NodePath = "" # 用于指定玩家节点

func _ready():
	pass

# 每帧更新怪物位置
func _process(delta: float):
	if Global.onFight or Global.onTalk or Global.menuOut:
		return
	# 获取到玩家位置
	var player_position = $"../player".global_position

	# 计算方向并移动怪物
	var direction = (player_position - global_position).normalized()

	# 计算移动向量
	velocity = direction * speed

	# 使用 move_and_slide() 移动
	move_and_slide()

	# 判断是否到达玩家位置附近
#	if global_position.distance_to(player_position) < 5.0:
#		self.position = Vector2(-937, 3010)
