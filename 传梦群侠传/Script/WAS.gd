extends Resource

class_name WAS

var canRead: bool = true
var was: StreamPeerBuffer
var fLen: int
var headLen: int
var direction: int
var frame: int
var width: int
var height: int
var centerX: int
var centerY: int
var list_color: Array
var list_dev: Array
var list_size: Array
var list_offset: Array


func _init(_fp:File,offset,lens):
	fLen = lens

	var tstream = StreamPeerBuffer.new()
	was = StreamPeerBuffer.new()
	_fp.seek(offset)
	was.data_array = _fp.get_buffer(fLen)

	if was.get_u16() != 0x5053:
		canRead = false
		was.clear()
		return

	headLen = was.get_u16()
	direction = was.get_u16()
	frame = was.get_u16()
	width = was.get_u16()
	height = was.get_u16()
	centerX = was.get_u16()
	centerY = was.get_u16()

	was.seek(headLen + 4)
	list_color.resize(256)
	list_dev.resize(direction * frame + 1)
	list_size.resize(direction * frame)
	list_offset.resize(direction * frame)

	var bufs = was.get_data(512)[1]
	tstream.data_array = PoolByteArray(bufs)
	tstream.seek(0)

	for i in range(0, 256):
		list_color[i] = shortRGB(tstream.get_u16())

	bufs = was.get_data(direction * frame * 4)[1]
	tstream.data_array = PoolByteArray(bufs)
	tstream.seek(0)

	for i in range(0, direction * frame):
		list_dev[i] = tstream.get_u32()

	list_dev[direction * frame] = fLen

	for i in range(0, direction * frame):
		if list_dev[i] == 0:
			continue
		was.seek(4 + headLen + list_dev[i])
		list_offset[i] = Vector2(was.get_32(), was.get_32())
		list_size[i] = Vector2(was.get_32(), was.get_32())
	tstream.clear()
	pass

func get_image(idx):
	var mbitmap: Image
	if list_dev[idx] == 0:
		return null
	var _width = list_size[idx].x
	var _height = list_size[idx].y

	if _width <= 0 || _height <= 0:
		return null
	var mbuf = StreamPeerBuffer.new()
	mbuf.resize(_height*4)

	var hexlist:Array = []
	hexlist.resize(_height+1)

	was.seek(4+headLen+list_dev[idx]+16)
	mbuf.data_array = PoolByteArray(was.get_data(_height*4)[1])
	mbuf.seek(0)

	for i in range(0,_height):
		hexlist[i] = mbuf.get_u32()

	hexlist[_height] = list_dev[idx+1]

	if hexlist[_height] == 0:
		hexlist[_height] = fLen-4-headLen

	mbitmap = Image.new()
	mbitmap.create(_width,_height,false,Image.FORMAT_RGBA8)
	mbitmap.lock()

	for i in range(0,_height):
		var pos = i*_width
		var poslen = pos+_width
		var dx = 0
		var _len = hexlist[i+1]-hexlist[i]
		was.seek(4+headLen+list_dev[idx]+hexlist[i])
		mbuf.resize(_len)
		mbuf.seek(0)
		var tbuf = was.get_data(_len)[1]
		mbuf.data_array = PoolByteArray(tbuf)
		var bt = mbuf.get_u8()
		
		var ofs = 4+headLen+list_dev[idx]

		# WAS__MagicAnimaction
		if i>0 && bt==0 && pos==(poslen-_width):
			var tpos = was.get_position()
			was.seek(ofs+hexlist[i-1])
			var flag = was.get_u8()
			was.seek(tpos)
			if flag != 0:
				for j in range(0,_width):
					mbitmap.set_pixel(j,i,mbitmap.get_pixel(j,i-1))

		while(bt>0):
			match (bt>>6)&3:
				0: #63
					if bt<32:
						var _alpha = mbuf.get_u8()*8
						var colind = mbuf.get_u8()
						if _alpha>=0&&colind>=0&&colind<256:
							for _j in range(bt & 31):
								if dx>=_width: continue
								mbitmap.set_pixel(dx,i,Color(list_color[colind]<<8|_alpha))
								dx+=1
					else:
						var _alpha = (bt & 31)*8
						var colind = mbuf.get_u8()
						if _alpha>=0 && colind >=0 && colind < 256:
							if dx>=_width: continue
							mbitmap.set_pixel(dx,i,Color(list_color[colind]<<8 | _alpha))
							dx+=1
				1: #64-127
					for _j in range(bt&63):
						if dx >= _width : continue
						var colind = mbuf.get_u8()
						if colind >=0 && colind < 256:
							mbitmap.set_pixel(dx,i,Color(list_color[colind]<<8 | 255))
							dx += 1
				2: #128-191
					var colind = mbuf.get_u8()
					if colind>=0 && colind < 256:
						for _j in range(bt&63):
							if dx>_width: continue
							mbitmap.set_pixel(dx,i,Color(list_color[colind] << 8 | 255))
							dx += 1
				3: #192-255
					dx += (bt&63)
				#end match
			bt = mbuf.get_u8()
			#end while
		#end for
	mbitmap.unlock()
	return mbitmap

func shortRGB(R565):
	var rcol: int
	var b0 = R565 & 255
	var b1 = (R565 >> 8) & 255
	var r = b1 & 248
	var g = ((b1 << 5) | ((b0 & 224) >> 3)) & 255
	var b = b0 << 3
	r = (r | ((r & 63) >> 3)) & 255
	g = (g | ((g & 15) >> 2)) & 255
	b = (b | ((b & 63) >> 3)) & 255
	rcol = (r << 16) | (g << 8) | b
	return rcol
