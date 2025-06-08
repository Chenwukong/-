@tool
extends CanvasLayer

# 导出变量以便在编辑器中设置
@export var player_path: NodePath
@export var background_texture: Texture2D
@export var overlay_texture: Texture2D
@export var wipe_radius: float = 50.0
@export var auto_setup: bool = true:
	set(value):
		auto_setup = value
		if Engine.is_editor_hint() and auto_setup:
			setup_wipe_system()

@onready var wipe_viewport: SubViewport = $WipeViewport
@onready var wipe_canvas: Node2D = $WipeViewport/WipeCanvas
@onready var background: Sprite2D = $WipeViewport/WipeCanvas/Background
@onready var overlay: Sprite2D = $WipeViewport/WipeCanvas/Overlay
@onready var wipe_display: Sprite2D = $WipeDisplay

var player: Node2D

func _ready():
	if Engine.is_editor_hint():
		return
	
	# 设置纹理
	background.texture = background_texture
	overlay.texture = overlay_texture
	
	# 设置视口大小
	var viewport_size = get_viewport().size
	wipe_viewport.size = viewport_size
	background.position = viewport_size / 2
	overlay.position = viewport_size / 2
	wipe_display.position = Vector2.ZERO
	
	# 获取玩家节点
	if player_path:
		player = get_node(player_path)
	
	# 设置显示纹理
	wipe_display.texture = wipe_viewport.get_texture()
	
	# 设置初始位置
	update_wipe_position()

func _process(delta):
	if Engine.is_editor_hint() or !player:
		return
	
	update_wipe_position()

func update_wipe_position():
	# 获取玩家在视口中的位置
	var player_screen_pos = get_viewport().get_canvas_transform() * player.global_position
	
	# 转换为UV坐标
	var viewport_size = wipe_viewport.size
	var uv_x = player_screen_pos.x / viewport_size.x
	var uv_y = player_screen_pos.y / viewport_size.y
	
	# 更新着色器参数
	var material = overlay.material as ShaderMaterial
	material.set_shader_parameter("wipe_center", Vector2(uv_x, uv_y))
	material.set_shader_parameter("wipe_radius", wipe_radius / viewport_size.x)

# 编辑器工具函数
func setup_wipe_system():
	# 确保所有节点存在
	if !has_node("WipeViewport"):
		var viewport = SubViewport.new()
		viewport.name = "WipeViewport"
		viewport.size = Vector2(1920, 1080) # 默认大小
		viewport.transparent_bg = true
		add_child(viewport)
		viewport.owner = get_tree().edited_scene_root
	
	if !has_node("WipeViewport/WipeCanvas"):
		var canvas = Node2D.new()
		canvas.name = "WipeCanvas"
		$WipeViewport.add_child(canvas)
		canvas.owner = get_tree().edited_scene_root
	
	if !has_node("WipeViewport/WipeCanvas/Background"):
		var bg = Sprite2D.new()
		bg.name = "Background"
		$WipeViewport/WipeCanvas.add_child(bg)
		bg.owner = get_tree().edited_scene_root
	
	if !has_node("WipeViewport/WipeCanvas/Overlay"):
		var overlay_node = Sprite2D.new()
		overlay_node.name = "Overlay"
		$WipeViewport/WipeCanvas.add_child(overlay_node)
		overlay_node.owner = get_tree().edited_scene_root
	
	if !has_node("WipeDisplay"):
		var display = Sprite2D.new()
		display.name = "WipeDisplay"
		display.centered = false
		add_child(display)
		display.owner = get_tree().edited_scene_root
	
	# 设置默认纹理
	if background_texture:
		$WipeViewport/WipeCanvas/Background.texture = background_texture
	
	if overlay_texture:
		$WipeViewport/WipeCanvas/Overlay.texture = overlay_texture
	
	# 设置显示纹理
	$WipeDisplay.texture = $WipeViewport.get_texture()
