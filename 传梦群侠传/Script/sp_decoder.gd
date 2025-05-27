# extends Resource
class_name SPDecoder

# 读取文件到字符组
static func readFileToBytes(filename : String) -> PackedByteArray :
	return FileAccess.get_file_as_bytes(filename)


# 判断是否是SP格式
static func isSP(bytes : PackedByteArray) -> bool :
	return bytes.decode_u16(0) == 0x5053

# SP帧信息
class SPFrame :
	# 锚点
	var kx : int
	var ky : int
	# 宽高
	var width : int
	var height : int
	# 隔行
	var interlaced : bool
	# 行偏移组
	var offsets_of_line : PackedInt32Array
	# 深拷贝
	func copy():
		var dup = SPFrame.new()
		dup.kx = self.kx
		dup.ky = self.ky
		dup.width = self.width
		dup.height = self.height
		dup.interlaced = self.interlaced
		dup.offsets_of_line = self.offsets_of_line.duplicate()
		return dup


# SP信息
class SPInfo :
	var directions_count : int
	var frames_count_per_direction : int
	var kx : int
	var ky : int
	var width : int
	var height : int
	# 深拷贝
	func copy():
		var dup = SPInfo.new()
		dup.directions_count = self.directions_count
		dup.frames_count_per_direction = self.frames_count_per_direction
		dup.kx = self.kx
		dup.ky = self.ky
		dup.width = self.width
		dup.height = self.height
		return dup
	
# 调色板数量
const k256 = 256

# 转换5位到8位
static func convert5bitTo8bit(five_bit : int) -> int :
	return (five_bit << 3) - (1 if five_bit else 0)

# 转换5位到8位
static func convert6bitTo8bit(six_bit : int) -> int :
	return (six_bit << 2) - (1 if six_bit else 0)



# 解析SP概要
static func parseBytesToSp(bytes : PackedByteArray, info : SPInfo, palette : PackedColorArray, frames : Array[SPFrame]) -> void :
	var length_of_info = bytes.decode_u16(2)
	# 解析SPInfo
	info.directions_count = bytes.decode_u16(4)
	info.frames_count_per_direction = bytes.decode_u16(6)
	info.width = bytes.decode_u16(8)
	info.height = bytes.decode_u16(10)
	info.kx = bytes.decode_s16(12)
	info.ky = bytes.decode_s16(14)
	# 解析调色板
	# print("解析调色板")
	palette.resize(k256)
	var color565 : int
	for i in k256 :
		# RGB565转RGBA8888
		color565 = bytes.decode_u16(length_of_info + 4 + i * 2)
		palette[i].r8 = convert5bitTo8bit((color565 & 0xF800) >> 11)
		palette[i].g8 = convert6bitTo8bit((color565 & 0x07E0) >> 5)
		palette[i].b8 = convert5bitTo8bit(color565 & 0x001F)
	
	# 解析SP帧信息
	# print("解析SP帧信息")
	var frames_count = info.directions_count * info.frames_count_per_direction
	frames.resize(frames_count)
	var frame = SPFrame.new()
	var offset : int
	var offset_of_pline : int
	var temp : int
	for i in frames_count :
		offset = bytes.decode_u32(length_of_info + 4 + 512 + i * 4)
		if offset != 0 :
			offset += length_of_info + 4
			frame.kx = bytes.decode_s32(offset)
			frame.ky = bytes.decode_s32(offset + 4)
			frame.width = bytes.decode_s32(offset + 8)
			frame.height = bytes.decode_s32(offset + 12)
			# 解析SP帧的行偏移
			offset_of_pline = bytes.decode_u32(offset + 16)
			offset_of_pline = 2 if (offset_of_pline == 1 || offset_of_pline == 2) else 0
			frame.offsets_of_line.resize(frame.height)
			for k in frame.height :
				temp = bytes.decode_u32(offset + 16 + (k + offset_of_pline) * 4)
				frame.offsets_of_line[k] = offset + temp
			# 解析SP帧是否隔行
			frame.interlaced = true
			for k in range(1, frame.height, 2) :
				if bytes[frame.offsets_of_line[k]] != 0 :
					frame.interlaced = false
					break
		else :
			frame.kx = 0
			frame.ky = 0
			frame.width = 0
			frame.height = 0
			
		frames[i] = frame.copy()




# 解析SP帧到像素
static func parserFrameToPixels(bytes : PackedByteArray, palette : PackedColorArray, frame : SPFrame) -> PackedColorArray :
	var check : int
	var repeat : int
	var alpha : int
	var color : Color
	var ipalette : int
	var index : int
	var ipixel : int
	var i : int
	var pixels = PackedColorArray()
	pixels.resize(frame.width * frame.height)
	for k in frame.height :
		index = frame.offsets_of_line[k]
		ipixel = k * frame.width
		if bytes[index] == 0 :
			if frame.interlaced && ((k % 2) == 1):
				for j in frame.width :
					pixels[ipixel + j] = pixels[ipixel + j - frame.width]
			else :
				for j in frame.width :
					pixels[ipixel + j].a8 = 0
			continue
		i = 0
		while i < frame.width :
			check = bytes[index]
			# print("check ", check)
			index += 1
			if check == 0 :
				for j in range(0, frame.width - i) :
					pixels[ipixel + j].a8 = 0
				break
				
			repeat = check & 0x3F
			match ((check >> 6) & 3) :
				0 :
					repeat = (check & 0x1F)
					if (check & 0x20) != 0 :
						alpha = repeat
						ipalette = bytes[index]
						index += 1
						pixels[ipixel] = palette[ipalette]
						pixels[ipixel].a8 = convert5bitTo8bit(alpha)
						i += 1
						ipixel += 1
					else :
						alpha = bytes[index]
						index += 1
						ipalette = bytes[index]
						index += 1
						color = palette[ipalette]
						color.a8 = convert5bitTo8bit(alpha)
						for j in repeat :
							pixels[ipixel + j] = color
						i += repeat
						ipixel += repeat
					# 操蛋，没人告诉我不用break
					# break
				1 :
					for j in repeat :
						pixels[ipixel + j] = palette[bytes[index + j]]
						pixels[ipixel + j].a8 = 0xFF
					index += repeat
					i += repeat
					ipixel += repeat
					# break
				2 :
					ipalette = bytes[index]
					index += 1
					color = palette[ipalette]
					color.a8 = 0xFF
					for j in repeat :
						pixels[ipixel + j] = color
					i += repeat
					ipixel += repeat
					# break
				3 :
					if repeat == 0 :
						if k > 0 && pixels[ipixel - 1].r8 == 0 && pixels[ipixel - 1].g8 == 0 && pixels[ipixel - 1].b8 == 0 :
							# 黑点
							pixels[ipixel - i] = pixels[ipixel - frame.width]
						else :
							# 边缘
							pixels[ipixel - 1].a8 = 0xFF
						index += 2
					else :
						for j in repeat :
							pixels[ipixel + j].a8 = 0
						i += repeat
						ipixel += repeat
					# break
	return pixels
		


# 解析SP帧到图像纹理
static func parserFrameToImageTexture(bytes : PackedByteArray, palette : PackedColorArray, frame : SPFrame) -> ImageTexture :
	
	var pixels = parserFrameToPixels(bytes, palette, frame)
	var datas = PackedByteArray()
	datas.resize(pixels.size() * 4)
	for i in pixels.size() :
		datas[i * 4 + 0] = pixels[i].r8
		datas[i * 4 + 1] = pixels[i].g8
		datas[i * 4 + 2] = pixels[i].b8
		datas[i * 4 + 3] = pixels[i].a8
		
	var image = Image.create_from_data(frame.width, frame.height, false, Image.FORMAT_RGBA8, datas)
	return ImageTexture.create_from_image(image)



# 读取SP文件并解析第一帧到图像纹理
static func 解析第一帧到图像纹理(filename : String) -> ImageTexture :
	var bytes = readFileToBytes(filename)
	if bytes.is_empty() or not isSP(bytes) : 
		return null
	var info = SPInfo.new()
	var palette = PackedColorArray()
	var frames : Array[SPFrame] = []
	parseBytesToSp(bytes, info, palette, frames)
	return parserFrameToImageTexture(bytes, palette, frames[0])
