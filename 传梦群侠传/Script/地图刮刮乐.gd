extends TextureRect

# 获取玩家节点 - 请根据你的场景结构修改路径
@onready var player =  $"../player" 

var mask_image: Image
var mask_texture: ImageTexture
@export var brush_size = 100  # 刮除半径
@export var cover_texture: Texture2D  # 在检查器中拖入你的JPG图片

func _ready():
	# 设置JPG图片作为纹理
	if cover_texture:
		texture = cover_texture

	# 等待下一帧再初始化，确保size属性已准备好
	call_deferred("setup_mask")
	call_deferred("setup_shader")

func setup_mask():
	# 等待确保size已准备好
	if size == Vector2.ZERO:
		call_deferred("setup_mask")
		return

	# 创建遮罩图像
	mask_image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	mask_image.fill(Color.BLACK)  # 初始为黑色（不透明）

	mask_texture = ImageTexture.new()
	mask_texture.set_image(mask_image)

func setup_shader():
	# 确保mask_texture已创建
	if mask_texture == null:
		call_deferred("setup_shader")
		return

	# 加载shader - 请确保shader文件路径正确
	var shader_path = "res://shader/刮刮乐.gdshader"
	if not ResourceLoader.exists(shader_path):
		print("警告：找不到shader文件，使用简单的材质替代")
		return

	var shader = load(shader_path)
	if shader == null:
		print("错误：无法加载shader")
		return

	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("mask_texture", mask_texture)

	material = shader_material

func _process(_delta):
	if player == null or mask_image == null:
		return

	# 获取玩家的世界位置
	var player_pos = player.global_position
	# 转换为相对于这个节点的本地坐标
	var local_pos = player_pos - global_position

	# 检查玩家是否在刮刮乐区域内
	if Rect2(Vector2.ZERO, size).has_point(local_pos):
		scratch_at_position(local_pos)

func scratch_at_position(pos: Vector2):
	var center_x = int(pos.x)
	var center_y = int(pos.y+50)
	var radius = brush_size / 2.2

	# 计算刮除区域的边界
	var min_x = max(0, center_x - radius)
	var max_x = min(mask_image.get_width() - 1, center_x + radius)
	var min_y = max(0, center_y - radius)
	var max_y = min(mask_image.get_height() - 1, center_y + radius)

	# 在圆形区域内将像素设置为白色（透明）
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var dx = x - center_x
			var dy = y - center_y
			var distance_sq = dx * dx + dy * dy

			# 只在圆形范围内刮除
			if distance_sq <= radius * radius:
				mask_image.set_pixel(x, y, Color.WHITE)

	# 更新纹理
	mask_texture.update(mask_image)

# 重置刮刮乐（用于测试）
func reset_scratch():
	mask_image.fill(Color.BLACK)
	mask_texture.update(mask_image)

# 输入处理（用于测试）
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:  # R键重置
				reset_scratch()
				print("刮刮乐已重置")
