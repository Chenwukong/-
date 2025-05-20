# 文件：was_decoder.gd
extends Node

class_name WasDecoder

# 自定义 RGBA 结构体
class RGBA:
	var r: int
	var g: int
	var b: int
	var a: int
	func _init(_r := 0, _g := 0, _b := 0, _a := 255):
		r = _r
		g = _g
		b = _b
		a = _a
	func duplicate():
		return RGBA.new(r, g, b, a)

# 将5位Alpha值转换为8位
func rgba5to8(value: int) -> int:
	return int((value * 255) / 31)

# 按位或颜色
func or_color(c1: RGBA, c2: RGBA) -> RGBA:
	return RGBA.new(c1.r | c2.r, c1.g | c2.g, c1.b | c2.b, c1.a | c2.a)

# 解码一行像素
func decode2line(line: int, width: int, pdata: Array, palette: Array, pitch: int, datas: Array):
	var i = 0
	while i < width:
		if pdata.is_empty():
			break
		var check = pdata.pop_front()
		if check == 0:
			for k in range(i, width):
				datas[k].a = 0
			break

		var repeat = check & 0x3F
		var mode = (check >> 6) & 3

		match mode:
			0:
				repeat = check & 0x1F
				if check & 0x20:
					var color = palette[pdata.pop_front()].duplicate()
					color.a = rgba5to8(repeat)
					datas[i] = color
					i += 1
				else:
					var alpha = pdata.pop_front()
					var base_color = palette[pdata.pop_front()].duplicate()
					base_color.a = rgba5to8(alpha)
					for j in range(repeat):
						datas[i + j] = base_color.duplicate()
					i += repeat

			1:
				for j in range(repeat):
					var color = palette[pdata[j]].duplicate()
					datas[i + j] = or_color(color, RGBA.new(0,0,0,255))
				pdata = pdata.slice(repeat)
				i += repeat

			2:
				var color = palette[pdata.pop_front()].duplicate()
				var temp = or_color(color, RGBA.new(0,0,0,255))
				for j in range(repeat):
					datas[i + j] = temp.duplicate()
				i += repeat

			3:
				if repeat == 0:
					if line > 0 and or_color(datas[i - 1], RGBA.new(0,0,0,255)) == RGBA.new(0,0,0,255):
						datas[i - 1] = datas[i - pitch].duplicate()
					else:
						datas[i - 1].a = 255
					pdata = pdata.slice(2)
				else:
					for j in range(repeat):
						datas[i + j].a = 0
					i += repeat

# 主解码函数：返回 Godot Image 对象
func decode_was(file_path: String) -> Image:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("无法打开文件: %s" % file_path)
		return null

	# 示例头部结构（你可以根据实际调整）
	file.seek(8)
	var width = file.get_16()
	var height = file.get_16()
	var frame_count = file.get_16()
	var palette_offset = file.get_32()
	var frame_data_offset = file.get_32()
	
	# 读取调色板（256个 RGBA）
	file.seek(palette_offset)
	var palette: Array = []
	for i in range(256):
		var r = file.get_8()
		var g = file.get_8()
		var b = file.get_8()
		var a = file.get_8()
		palette.append(RGBA.new(r, g, b, a))

	# 读取图像像素数据（这里只处理第一个帧）
	file.seek(frame_data_offset)
	var line_data: Array = []
	for i in range(height):
		var line_size = file.get_16()
		var line_bytes = []
		for j in range(line_size):
			line_bytes.append(file.get_8())
		line_data.append(line_bytes)

	# 解码像素
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	for y in range(height):
		var datas := []
		for _i in range(width):
			datas.append(RGBA.new(0, 0, 0, 0))
		var pdata = line_data[y].duplicate()
		decode2line(y, width, pdata, palette, width, datas)
		for x in range(width):
			var c = datas[x]
			image.set_pixel(x, y, Color(c.r / 255.0, c.g / 255.0, c.b / 255.0, c.a / 255.0))

	return image
