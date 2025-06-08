extends ColorRect

@onready var sword = get_node("../Sword")
var mask_image: Image
var mask_texture: ImageTexture
var is_scratching = false
@export var brush_size = 300

# 动态brush size相关变量
var current_brush_size: float
var animation_progress: float = 0.0

# 撕裂散开效果变量
var is_tearing = false
var tear_progress: float = 0.0
var tear_speed: float = 200.0  # 撕裂速度
var sword_slash_line: Array[Vector2] = []  # 记录剑气划过的路径
var center_line_x: float = 0.0  # 撕裂的中心线位置

# 性能优化变量
var frame_counter = 0
var update_interval = 3
var scratch_buffer: Array[Dictionary] = []

func _ready():
	color = Color.BLACK
	current_brush_size = brush_size
	setup_mask()
	setup_shader()
	connect_sword()

func setup_mask():
	mask_image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	mask_image.fill(Color.BLACK)
	
	mask_texture = ImageTexture.new()
	mask_texture.set_image(mask_image)
	print("创建mask纹理完成")

func setup_shader():
	var shader_path = "res://shader/刮刮乐.gdshader"
	if not ResourceLoader.exists(shader_path):
		print("错误：找不到shader文件 ", shader_path)
		return
	
	var shader = load(shader_path)
	if shader == null:
		print("错误：无法加载shader")
		return
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	
	material = shader_material
	print("Shader应用成功")

func connect_sword():
	var anim_player = sword.get_node("AnimationPlayer")
	anim_player.animation_started.connect(_on_animation_started)
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_started(anim_name):
	if anim_name == "划破黑暗":
		brush_size = 300
		is_scratching = true
		animation_progress = 0.0
		sword_slash_line.clear()  # 清空路径记录
		print("开始刮除")

func _on_animation_finished(anim_name):
	if anim_name == "划破黑暗":
		is_scratching = false
		process_scratch_buffer()
		animation_progress = 1.0
		
		# 计算撕裂中心线
		calculate_center_line()
		
		# 开始撕裂效果
		start_tear_effect()
		print("刮除结束，开始撕裂效果")

func calculate_center_line():
	"""计算剑气划过路径的中心线"""
	if sword_slash_line.size() > 0:
		# 简单方法：取路径中点的X坐标作为中心线
		var mid_index = sword_slash_line.size() / 2
		center_line_x = sword_slash_line[mid_index].x
	else:
		# 默认屏幕中心
		center_line_x = size.x / 2
	
	print("撕裂中心线位置: ", center_line_x)

func start_tear_effect():
	"""开始撕裂散开效果"""
	is_tearing = true
	tear_progress = 0.0

func _process(delta):
	frame_counter += 1
	
	if is_scratching:
	
		update_animation_progress()
		update_current_brush_size()
		
		var sword_pos = sword.global_position
		var local_pos = sword_pos - global_position
		
		if Rect2(Vector2.ZERO, size).has_point(local_pos):
			# 记录剑气路径
			sword_slash_line.append(local_pos)
			
			scratch_buffer.append({
				"position": local_pos,
				"brush_size": current_brush_size
			})
	
	# 处理撕裂效果
	if is_tearing:
		tear_progress += tear_speed * delta
		#apply_tear_effect()  # 使用对角撕裂效果
		
		# 撕裂完成检查 - 基于对角线距离
		var max_diagonal = Vector2(size.x, size.y/2).length()
		if tear_progress >= max_diagonal:
			is_tearing = false
			print("撕裂效果完成")
	
	# 定期批量处理划痕
	if frame_counter % update_interval == 0:
		process_scratch_buffer()

func apply_diagonal_tear_effect():
	"""基于斜向划痕的撕裂效果 - 左上角向左上散去，右下角向右下散去"""
	var tear_distance = tear_progress
	
	# 如果有记录的剑气路径，使用路径来判断划痕位置
	if sword_slash_line.size() > 0:
		apply_path_based_tear(tear_distance)
	else:
		# 默认使用对角线划分
		apply_default_diagonal_tear(tear_distance)

func apply_path_based_tear(tear_distance: float):
	"""基于剑气路径的撕裂效果"""
	
	for x in range(mask_image.get_width()):
		for y in range(mask_image.get_height()):
			var current_pos = Vector2(x, y)
			var should_remove = false
			
			# 判断当前像素在划痕的哪一侧
			var is_upper_left = is_point_in_upper_left_region(current_pos)
			
			if is_upper_left:
				# 左上区域 - 从划痕线开始向左上方向扩散消失
				var distance_to_slash_line = get_distance_to_slash_line(current_pos)
				
				# 计算从划痕线向左上方向的扩散距离
				# 使用投影来判断是否在扩散范围内
				var direction_to_top_left = (Vector2(0, 0) - current_pos).normalized()
				var slash_to_point = current_pos - get_nearest_slash_point(current_pos)
				var projection = slash_to_point.dot(direction_to_top_left)
				
				# 只有当点在向左上扩散的方向上才消除
				if projection >= 0 and distance_to_slash_line < tear_distance:
					var wave_offset = sin(x * 0.08 + y * 0.06 + tear_progress * 0.01) * 10
					if distance_to_slash_line + wave_offset < tear_distance:
						should_remove = true
			else:
				# 右下区域 - 从划痕线开始向右下方向扩散消失
				var distance_to_slash_line = get_distance_to_slash_line(current_pos)
				
				# 计算从划痕线向右下方向的扩散距离
				var direction_to_bottom_right = (Vector2(size.x, size.y) - current_pos).normalized()
				var slash_to_point = current_pos - get_nearest_slash_point(current_pos)
				var projection = slash_to_point.dot(direction_to_bottom_right)
				
				# 只有当点在向右下扩散的方向上才消除
				if projection >= 0 and distance_to_slash_line < tear_distance:
					var wave_offset = sin(x * 0.08 + y * 0.06 + tear_progress * 0.01) * 10
					if distance_to_slash_line + wave_offset < tear_distance:
						should_remove = true
			
			if should_remove:
				mask_image.set_pixel(x, y, Color.WHITE)
	
	mask_texture.update(mask_image)

func is_point_in_upper_left_region(point: Vector2) -> bool:
	"""判断点是否在左上区域（基于剑气路径）"""
	if sword_slash_line.is_empty():
		# 如果没有路径记录，使用简单的对角线判断
		return point.y < size.y - point.x * (size.y / size.x)
	
	# 基于剑气路径判断
	# 找到距离当前点最近的剑气路径点
	var min_distance = INF
	var closest_slash_point = Vector2.ZERO
	
	for slash_point in sword_slash_line:
		var distance = point.distance_to(slash_point)
		if distance < min_distance:
			min_distance = distance
			closest_slash_point = slash_point
	
	# 使用向量叉积判断点在路径的哪一侧
	# 假设路径是从右上到左下
	var path_direction = Vector2(-1, 1).normalized()  # 从右上到左下的方向
	var point_to_slash = (point - closest_slash_point).normalized()
	
	# 叉积判断左右
	var cross_product = path_direction.cross(point_to_slash)
	return cross_product > 0  # 大于0表示在左侧（左上区域）

func apply_default_diagonal_tear(tear_distance: float):
	"""默认的对角线撕裂效果 - 从划痕线向两侧扩散"""
	for x in range(mask_image.get_width()):
		for y in range(mask_image.get_height()):
			var current_pos = Vector2(x, y)
			var should_remove = false
			
			# 计算到对角线的距离（从右上到左下的线）
			var diagonal_distance = get_distance_to_diagonal_line(current_pos)
			
			# 使用简单的对角线判断：y < height - x * (height/width)
			var diagonal_y = size.y - x * (size.y / size.x)
			
			if y < diagonal_y:
				# 左上区域 - 从划痕线向左上方向扩散
				if diagonal_distance < tear_distance:
					# 额外检查：确保扩散方向是向左上的
					var center_of_screen = size / 2
					var direction_from_center = (current_pos - center_of_screen).normalized()
					var left_up_direction = Vector2(-1, -1).normalized()
					
					# 如果方向大致向左上，则消除
					if direction_from_center.dot(left_up_direction) > 0.3:
						should_remove = true
			else:
				# 右下区域 - 从划痕线向右下方向扩散
				if diagonal_distance < tear_distance:
					# 额外检查：确保扩散方向是向右下的
					var center_of_screen = size / 2
					var direction_from_center = (current_pos - center_of_screen).normalized()
					var right_down_direction = Vector2(1, 1).normalized()
					
					# 如果方向大致向右下，则消除
					if direction_from_center.dot(right_down_direction) > 0.3:
						should_remove = true
			
			if should_remove:
				mask_image.set_pixel(x, y, Color.WHITE)
	
	mask_texture.update(mask_image)

func get_distance_to_diagonal_line(point: Vector2) -> float:
	"""计算点到对角线的距离"""
	# 对角线从 (size.x, 0) 到 (0, size.y)
	var line_start = Vector2(size.x, 0)
	var line_end = Vector2(0, size.y)
	var line_vec = line_end - line_start
	var point_vec = point - line_start
	
	# 计算点到直线的距离
	var line_length_sq = line_vec.length_squared()
	if line_length_sq == 0:
		return point.distance_to(line_start)
	
	var t = max(0, min(1, point_vec.dot(line_vec) / line_length_sq))
	var projection = line_start + t * line_vec
	return point.distance_to(projection)

func get_distance_to_slash_line(point: Vector2) -> float:
	"""计算点到剑气路径的最短距离"""
	if sword_slash_line.is_empty():
		return get_distance_to_diagonal_line(point)
	
	var min_distance = INF
	for i in range(sword_slash_line.size() - 1):
		var line_start = sword_slash_line[i]
		var line_end = sword_slash_line[i + 1]
		var distance = get_distance_to_line_segment(point, line_start, line_end)
		min_distance = min(min_distance, distance)
	
	return min_distance

func get_distance_to_line_segment(point: Vector2, line_start: Vector2, line_end: Vector2) -> float:
	"""计算点到线段的距离"""
	var line_vec = line_end - line_start
	var point_vec = point - line_start
	
	var line_length_sq = line_vec.length_squared()
	if line_length_sq == 0:
		return point.distance_to(line_start)
	
	var t = max(0, min(1, point_vec.dot(line_vec) / line_length_sq))
	var projection = line_start + t * line_vec
	return point.distance_to(projection)

func get_nearest_slash_point(point: Vector2) -> Vector2:
	"""获取最近的剑气路径点"""
	if sword_slash_line.is_empty():
		return size / 2  # 默认返回屏幕中心
	
	var min_distance = INF
	var nearest_point = sword_slash_line[0]
	
	for slash_point in sword_slash_line:
		var distance = point.distance_to(slash_point)
		if distance < min_distance:
			min_distance = distance
			nearest_point = slash_point
	
	return nearest_point

# 修改原有的apply_tear_effect函数，让它调用新的对角撕裂效果
#func apply_tear_effect():
#	"""应用撕裂效果 - 调用对角撕裂函数"""
#	apply_diagonal_tear_effect()

# 添加一个测试函数来验证效果
#func test_diagonal_scratch():
#	"""测试对角划痕效果"""
#	# 创建一条从右上到左下的划痕
#	var start_pos = Vector2(size.x * 0.8, size.y * 0.2)  # 右上
#	var end_pos = Vector2(size.x * 0.2, size.y * 0.8)    # 左下
#
#	# 清空之前的路径
#	sword_slash_line.clear()
#
#	# 创建模拟的剑气路径
#	var steps = 50
#	for i in range(steps):
#		var t = float(i) / float(steps - 1)
#		var pos = start_pos.lerp(end_pos, t)
#		sword_slash_line.append(pos)
#
#		# 在路径上创建划痕
#		scratch_at_position_with_size(pos, 20)
#
#	mask_texture.update(mask_image)
#
#	# 开始撕裂效果
#	start_tear_effect()
#	print("测试对角划痕撕裂效果")
#
## 在_input函数中添加新的测试键
## 在现有的match语句中添加：
##			KEY_D:  # D键：测试对角撕裂
##				test_diagonal_scratch()
#	"""默认的对角线撕裂效果"""
#	for x in range(mask_image.get_width()):
#		for y in range(mask_image.get_height()):
#			var current_pos = Vector2(x, y)
#			var should_remove = false
#
#			# 使用简单的对角线判断：y < height - x * (height/width)
#			# 这条线从右上角(width, 0)到左下角(0, height)
#			var diagonal_y = size.y - x * (size.y / size.x)
#
#			if y < diagonal_y:
#				# 左上区域 - 向左上散去
#				var distance_to_top_left = current_pos.distance_to(Vector2(0, 0))
#				var max_distance = Vector2(size.x, size.y).distance_to(Vector2(0, 0))
#				var progress = tear_distance / max_distance
#
#				if distance_to_top_left < progress * max_distance:
#					should_remove = true
#			else:
#				# 右下区域 - 向右下散去
#				var distance_to_bottom_right = current_pos.distance_to(Vector2(size.x, size.y))
#				var max_distance = Vector2(0, 0).distance_to(Vector2(size.x, size.y))
#				var progress = tear_distance / max_distance
#
#				if distance_to_bottom_right < progress * max_distance:
#					should_remove = true
#
#			if should_remove:
#				mask_image.set_pixel(x, y, Color.WHITE)
#
#	mask_texture.update(mask_image)
#
## 修改原有的apply_tear_effect函数，让它调用新的对角撕裂效果
#
#	"""测试对角划痕效果"""
#	# 创建一条从右上到左下的划痕
#	var start_pos = Vector2(size.x * 0.8, size.y * 0.2)  # 右上
#	var end_pos = Vector2(size.x * 0.2, size.y * 0.8)    # 左下
#
#	# 清空之前的路径
#	sword_slash_line.clear()
#
#	# 创建模拟的剑气路径
#	var steps = 50
#	for i in range(steps):
#		var t = float(i) / float(steps - 1)
#		var pos = start_pos.lerp(end_pos, t)
#		sword_slash_line.append(pos)
#
#		# 在路径上创建划痕
#		scratch_at_position_with_size(pos, 20)
#
#	mask_texture.update(mask_image)
#
#	# 开始撕裂效果
#	start_tear_effect()
#	print("测试对角划痕撕裂效果")

# 在_input函数中添加新的测试键
# 在现有的match语句中添加：
#			KEY_D:  # D键：测试对角撕裂
#				test_diagonal_scratch()
# 高级撕裂效果 - 带加速度和更流畅的对角线散去
func apply_advanced_tear_effect():
	"""带加速度和曲线的对角撕裂效果"""
	# 使用二次函数让撕裂速度先慢后快
	var progress_curve = pow(tear_progress / 200.0, 1.2)  # 调整曲线形状
	var center_y = size.y / 2
	
	for x in range(mask_image.get_width()):
		for y in range(mask_image.get_height()):
			var should_remove = false
			
			if y < center_y:
				# 上半部分 - 向左上散去，创建扇形效果
				var angle_to_top_left = atan2(-y, -x)  # 到左上角的角度
				var distance_from_origin = Vector2(x, y).length()
				
				# 创建扇形散去效果
				var max_distance = Vector2(size.x, center_y).length()
				var fan_radius = progress_curve * max_distance
				
				# 添加角度限制，让散去更有方向性
				if angle_to_top_left > PI * 0.75 and angle_to_top_left < PI:  # 限制在左上方向
					var wave_factor = 1.0 + sin(distance_from_origin * 0.1 + tear_progress * 0.03) * 0.3
					if distance_from_origin * wave_factor < fan_radius:
						should_remove = true
			else:
				# 下半部分 - 向左下散去
				var relative_y = y - center_y
				var angle_to_bottom_left = atan2(relative_y, -x)  # 到左下角的角度
				var distance_from_bottom_origin = Vector2(x, relative_y).length()
				
				var max_distance = Vector2(size.x, center_y).length()
				var fan_radius = progress_curve * max_distance
				
				# 限制在左下方向
				if angle_to_bottom_left > PI * 0.5 and angle_to_bottom_left < PI * 0.75:
					var wave_factor = 1.0 + sin(distance_from_bottom_origin * 0.1 + tear_progress * 0.03) * 0.3
					if distance_from_bottom_origin * wave_factor < fan_radius:
						should_remove = true
			
			if should_remove:
				mask_image.set_pixel(x, y, Color.WHITE)
	
	mask_texture.update(mask_image)

# 波纹扩散撕裂效果
func apply_ripple_tear_effect():
	"""从剑痕开始的波纹扩散撕裂"""
	if sword_slash_line.is_empty():
		return
	
	var ripple_radius = tear_progress
	
	# 对每个剑痕点进行波纹扩散
	for slash_point in sword_slash_line:
		var center_x = int(slash_point.x)
		var center_y = int(slash_point.y)
		
		# 创建椭圆形扩散（横向更宽）
		var ellipse_width = ripple_radius * 2
		var ellipse_height = ripple_radius * 0.6
		
		for x in range(max(0, center_x - int(ellipse_width)), 
					   min(mask_image.get_width(), center_x + int(ellipse_width))):
			for y in range(max(0, center_y - int(ellipse_height)), 
						   min(mask_image.get_height(), center_y + int(ellipse_height))):
				
				var dx = (x - center_x) / ellipse_width
				var dy = (y - center_y) / ellipse_height
				var distance_normalized = dx * dx + dy * dy
				
				if distance_normalized <= 1.0:
					# 添加一些随机性
					var noise = sin(x * 0.1) * cos(y * 0.1) * 0.3
					if distance_normalized > 0.7 + noise:
						mask_image.set_pixel(x, y, Color.WHITE)
	
	mask_texture.update(mask_image)

func update_animation_progress():
	var anim_player = sword.get_node("AnimationPlayer")
	if anim_player.is_playing():
		var current_animation = anim_player.get_current_animation()
		if current_animation == "划破黑暗":
			var current_time = anim_player.get_current_animation_position()
			var total_time = anim_player.get_current_animation_length()
			animation_progress = current_time / total_time if total_time > 0 else 0.0

func update_current_brush_size():
	var size_multiplier = 1.0 - pow(animation_progress, 1.5) * 0.8
	current_brush_size = brush_size * size_multiplier
	current_brush_size = max(current_brush_size, 10.0)

func process_scratch_buffer():
	if scratch_buffer.is_empty():
		return
	
	for scratch_data in scratch_buffer:
		var pos = scratch_data["position"]
		var brush = scratch_data["brush_size"]
		scratch_at_position_with_size(pos, brush)
	
	mask_texture.update(mask_image)
	scratch_buffer.clear()

func scratch_at_position_with_size(pos: Vector2, brush_radius: float):
	var center_x = int(pos.x)
	var center_y = int(pos.y)
	var radius = brush_radius / 2
	
	var min_x = max(0, center_x - radius)
	var max_x = min(mask_image.get_width() - 1, center_x + radius)
	var min_y = max(0, center_y - radius)
	var max_y = min(mask_image.get_height() - 1, center_y + radius)
	
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var dx = x - center_x
			var dy = y - center_y
			var distance_sq = dx * dx + dy * dy
			
			if distance_sq <= radius * radius:
				mask_image.set_pixel(x, y, Color.WHITE)

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				test_center_scratch()
			KEY_ENTER:
				start_sword_animation()
			KEY_R:
				reset_scratch()

			KEY_1:  # 1键：标准撕裂
				tear_speed = 200.0
			KEY_2:  # 2键：快速撕裂
				tear_speed = 400.0
			KEY_3:  # 3键：慢速撕裂
				tear_speed = 100.0
			KEY_4:  # 4键：测试高级对角撕裂
				if not is_tearing:
					start_tear_effect()
					# 可以在这里切换到高级撕裂模式
			KEY_5:  # 5键：快速对角撕裂
				tear_speed = 500.0
				start_tear_effect()

#func test_tear_effect():
#	"""测试撕裂效果"""
#	# 创建一条垂直的划痕作为测试
#	center_line_x = size.x / 2
#	for y in range(int(size.y * 0.2), int(size.y * 0.8)):
#		mask_image.set_pixel(int(center_line_x), y, Color.WHITE)
#	mask_texture.update(mask_image)
#
#	# 开始撕裂
#	start_tear_effect()
#	print("测试撕裂效果")

func test_center_scratch():
	var center = size / 2
	scratch_at_position_with_size(center, current_brush_size)
	mask_texture.update(mask_image)
	print("中心刮除测试")

func start_sword_animation():
	if sword:
		sword.get_node("AnimationPlayer").play("划破黑暗")
		print("开始剑的动画")

func reset_scratch():
	mask_image.fill(Color.BLACK)
	mask_texture.update(mask_image)
	scratch_buffer.clear()
	sword_slash_line.clear()
	is_tearing = false
	tear_progress = 0.0
	animation_progress = 0.0
	current_brush_size = brush_size
	print("重置刮除效果")

# 自定义撕裂参数
#func set_tear_parameters(speed: float, center_x: float = -1):
#	"""设置撕裂参数"""
#	tear_speed = speed
#	if center_x >= 0:
#		center_line_x = center_x

# 手动触发撕裂效果
#func trigger_tear_from_position(pos: Vector2, speed: float = 200.0):
#	"""从指定位置开始撕裂"""
#	center_line_x = pos.x
#	tear_speed = speed
#	start_tear_effect()
