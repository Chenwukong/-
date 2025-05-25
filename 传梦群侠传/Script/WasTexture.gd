extends TextureRect
tool
class_name WasTexture

export var WDFName:String
export var WASAddr:int = 0
export var autoPlay:bool = true setget _autoPlay
export var frameTime:float = 0.12
export var reload:bool = true setget _reload

func _autoPlay(va):
	autoPlay = va
	set_process(va)

func _reload(va):
	reload = va
	self.loadWAS(self.WDFName,self.WASAddr)
	
var wdf:WDF
var was:WAS
var finfo =  {
	Uid = 0,
	FileOffset = 0,
	FileSize = 0,
	FileSpace = 0,
	FileType = 0
}
# 当前帧
var frame_now = 0
# 开始帧
var frame_begin = 0
# 结束帧
var frame_end = 0
# 方向数
var frame_dirNum = 0
# 帧数
var frame_frameNum = 0
# 宽度
var frame_width = 0
# 高度
var frame_height = 0
# 差异
var frame_sub = 0
# 时间累积
var frame_time_deltal = 0
# 提速
var frame_apped_speed = 0
# 帧率
var frame_fps = 0.1
# 当前方向
var frame_direction = -1

# 已载入数量
var frame_beLoad = 0

# 置提速
func set_apped_speed(sp):
	self.frame_apped_speed = sp

# 取中间
func get_between():
	return ceil((float(frame_end)-float(frame_begin))/2)

# 取间隔
func get_space():
	return frame_end-frame_begin

# 置差异
func set_frame_sub(sub):
	self.frame_sub = sub

# 置高亮
func set_light(light:bool):
	self.modulate = Color(-13158601) if light else Color()

# 取当前帧
func get_frame_now():
	return frame_now
	
# 取开始帧
func get_frame_begin():
	return frame_begin

# 取结束帧
func get_frame_end():
	return frame_end
	
# 置区域(不显示全)
func set_frame_rect(x,y,w,h):
	self.region_rect = Rect2(x,y,w,h)

# 置方向
func set_frame_direction(dir):
	if self.frame_direction == dir && dir!=0:
		return
	if dir > self.frame_dirNum:
		self.frame_direction = 0
	else:
		self.frame_direction = dir
	self.frame_begin = self.frame_direction * self.frame_frameNum
	self.frame_end = self.frame_frameNum + self.frame_begin -1
	self.frame_now = self.frame_begin
	self.updateTexture()
	
func _init(name_wdf= "",addr_was=0):
	self.WDFName = name_wdf
	self.WASAddr = addr_was
	
func _ready():	
	self.loadWAS(self.WDFName,self.WASAddr)
	self.set_process(autoPlay)

func clear():
	self.wdf = null
	self.was = null
	self.frameCache.clear()
	self.frame_now = 0
	self.frame_beLoad = 0
	self.frame_begin = 0
	self.frame_end = 0
	self.frame_dirNum = 0
	self.frame_direction = 0
	self.autoPlay = false
	
func loadWAS(wdfName,wasAddr):
	self.WDFName = wdfName
	self.WASAddr = wasAddr
	if wdfName == "":
		return
	self.clear()
	self.wdf = WDFManager.getIns().getWdf(wdfName)
	finfo = wdf.getFinfo(wasAddr)
	if finfo == null:
		return
	self.was = WAS.new(self.wdf._fp,finfo.FileOffset,finfo.FileSize)
	self.frame_dirNum = self.was.direction
	self.frame_frameNum = self.was.frame
	self.frame_width = self.was.width
	self.frame_height = self.was.height
	self.set_frame_direction(4)

func _process(dt):
	if self.frame_apped_speed!=0:
		dt = dt*frame_apped_speed
	self.frame_time_deltal += dt
	if self.frame_time_deltal>self.frame_fps:
		self.frame_now += 1
		if self.frame_now> self.frame_end-self.frame_sub:
			self.frame_now = self.frame_begin
		self.frame_time_deltal = 0
		self.updateTexture()
	
func showPos(x,y):
	pass

var frameCache = {}
# 更新纹理
func updateTexture():
	if was==null || !self.was.canRead:
		return
	var im:Image
	if self.frameCache.get(self.frame_now,null) != null:
		im = self.frameCache[self.frame_now]
	else:
		im = self.was.get_image(self.frame_now)
		self.frameCache[self.frame_now] = im
	if self.texture is ImageTexture:
		self.texture.create_from_image(im)
	else:
		var imt:ImageTexture = ImageTexture.new()
		imt.create_from_image(im)
		self.texture = imt
	var texOffset = self.was.list_offset[self.frame_now]
	# self.offset = Vector2(0-texOffset.x,0-texOffset.y)
