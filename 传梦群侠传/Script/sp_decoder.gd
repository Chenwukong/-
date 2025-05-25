extends Resource
class_name SPDecoder

# 读取文件到字符组
static func readFileToBytes(filename : String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(filename)

# 判断是否是SP格式
static func isSP(bytes : PackedByteArray) -> bool:
	return bytes.decode_u16(0) == 0x5053

# SP帧信息
class SPFrame:
	var kx : int
	var ky : int
	var width : int
	var height : int
	var interlaced : bool
	var offsets_of_line : PackedInt32Array = PackedInt32Array()

# SP信息
class SPInfo:
	var directions_count : int
	var frames_count_per_direction : int
	var kx : int
	var ky : int
	var width : int
	var height : int

# 调色板数量
const k256 = 256

# 解析SP概要
static func parseBytesToSp(bytes : PackedByteArray, info : SPInfo, palette : PackedColorArray, frames : Array) -> void:
	var length_of_info = bytes.decode_u16(2)
	
	# 解析SPInfo
	info.directions_count = bytes.decode_u16(4)
	info.frames_count_per_direction = bytes.decode_u16(6)
	info.width = bytes.decode_u16(8)
	info.height = bytes.decode_u16(10)
	info.kx = bytes.decode_s16(12)
	info.ky = bytes.decode_s16(14)

	# 解析调色板
	palette.resize(k256)
	for i in k256:
		var color565 = bytes.decode_u16(length_of_info + 4 + i * 2)
		var r = (color565 & 0xF800) >> 11
		var g = (color565 & 0x07E0) >> 5
		var b = (color565 & 0x001F)
		palette[i] = Color8(r << 3, g << 2, b << 3, 0)

	# 解析帧信息
	var frames_count = info.directions_count * info.frames_count_per_direction
	for i in frames_count:
		var frame = SPFrame.new()
		var offset = bytes.decode_u16(length_of_info + 4 + 512 + i * 4)
		if offset != 0:
			offset += length_of_info + 4
			frame.kx = bytes.decode_s32(offset)
			frame.ky = bytes.decode_s32(offset + 4)
			frame.width = bytes.decode_s32(offset + 8)
			frame.height = bytes.decode_s32(offset + 12)

			# 行偏移处理
			var offset_of_pline = bytes.decode_s32(offset + 16)
			offset_of_pline = 2 if (offset_of_pline == 1 or offset_of_pline == 2) else 0

			frame.offsets_of_line.resize(frame.height)
			for k in frame.height:
				frame.offsets_of_line[k] = offset + bytes.decode_u32(offset + 16 + (k + offset_of_pline) * 4)

			# 判断隔行
			frame.interlaced = true
			for k in range(0, frame.height, 2):
				if bytes[frame.offsets_of_line[k]] != 0:
					frame.interlaced = false
					break
		else:
			frame.kx = 0
			frame.ky = 0
			frame.width = 0
			frame.height = 0
			frame.offsets_of_line = PackedInt32Array()
		
		frames.append(frame)

# 转换 5bit 到 8bit
static func conver5bitTo8bit(five_bit : int) -> int:
	return (five_bit << 3) - (1 if five_bit else 0)

# 解析帧到像素数组
static func parserFrameToPixels(bytes : PackedByteArray, palette : PackedColorArray, frame : SPFrame, pixels : PackedColorArray) -> void:
	for k in frame.height:
		var index = frame.offsets_of_line[k]
		var ipixel = k * frame.width
		if bytes[index] == 0:
			if frame.interlaced and (k % 2) == 1:
				for i in frame.width:
					pixels[ipixel + i] = pixels[ipixel + i - frame.width]
			else:
				for i in frame.width:
					pixels[ipixel + i].a8 = 0
			continue

		var i = 0
		while i < frame.width:
			var check = bytes[index]
			index += 1
			if check == 0:
				for j in range(i, frame.width):
					pixels[ipixel + j].a8 = 0
				break

			var repeat = check & 0x3F
			match (check >> 6) & 3:
				0:
					repeat = check & 0x1F
					if check & 0x20:
						var alpha = repeat
						var ipalette = bytes[index]
						index += 1
						pixels[ipixel + i] = palette[ipalette]
						pixels[ipixel + i].a8 = conver5bitTo8bit(alpha)
						i += 1
					else:
						var alpha = bytes[index]
						index += 1
						var ipalette = bytes[index]
						index += 1
						var temp = palette[ipalette]
						temp.a8 = conver5bitTo8bit(alpha)
						for j in range(repeat):
							pixels[ipixel + i + j] = temp
						i += repeat
					break
				1:
					for j in range(repeat):
						var ipalette = bytes[index + j]
						pixels[ipixel + i + j] = palette[ipalette]
						pixels[ipixel + i + j].a8 = 0xFF
					index += repeat
					i += repeat
					break
				2:
					var ipalette = bytes[index]
					index += 1
					var temp = palette[ipalette]
					temp.a8 = 0xFF
					for j in range(repeat):
						pixels[ipixel + i + j] = temp
					i += repeat
					break
				3:
					if repeat == 0:
						if k > 0 and pixels[ipixel - 1].r8 == 0 and pixels[ipixel - 1].g8 == 0 and pixels[ipixel - 1].b8 == 0:
							pixels[ipixel - i] = pixels[ipixel - frame.width]
						else:
							pixels[ipixel - 1].a8 = 0xFF
						index += 2
					else:
						for j in range(repeat):
							pixels[ipixel + i + j].a8 = 0
						i += repeat
					break

# 解析帧为图像纹理
static func parserFrameToImageTexture(bytes : PackedByteArray, palette : PackedColorArray, frame : SPFrame) -> ImageTexture:
	var pixels = PackedColorArray()
	pixels.resize(frame.width * frame.height)
	parserFrameToPixels(bytes, palette, frame, pixels)
	var image = Image.create_from_data(frame.width, frame.height, false, Image.FORMAT_RGBA8, pixels)
	return ImageTexture.create_from_image(image)

# 读取文件并解析第 0 帧
static func readSPFrame0ToImageTexture(filename : String) -> ImageTexture:
	var bytes = readFileToBytes(filename)
	if bytes.is_empty() or not isSP(bytes):
		return null
	var info = SPInfo.new()
	var palette = PackedColorArray()
	var frames = []  # ✅ 不使用 Array[SPFrame]
	parseBytesToSp(bytes, info, palette, frames)
	return parserFrameToImageTexture(bytes, palette, frames[0])

