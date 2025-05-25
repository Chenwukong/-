extends Reference

class_name WDF

# ---  基础变量
var _fp:File
var _flen:int
var _loaded:bool = true
var _wdfPath:String = ""
var _errTag:String = ""
var bitc:Code

# ---  wdf内容变量
const FILETYPE = [ "未知","was","mp3","jpg","tag","wav","bmp","lua"]
var wdfhead={
	#文件标识符
	Flag = 0,
	#文件数量
	FileSum = 0,
	#文件列表地址
	Offset = 0
}

# 文件信息列表
var filelist=[]
# 文件类型列表
var fileexs=[]

# 保存文件地址
func _init(tpath:String):
	_wdfPath = tpath
	bitc = Code.new()
# 读取内容结构
func readData():
	_fp = File.new()
	
	if !_fp.file_exists(_wdfPath):
		_errTag = _wdfPath+"文件不存在"
		_loaded = false
		return
	
	var err =_fp.open(_wdfPath, File.READ)
	if err!=OK:
		_errTag = _wdfPath+"打开失败,错误码==>"+str(err)
		_loaded = false
		return
		
	_flen = _fp.get_len()
	if _flen == 0:
		_errTag = _wdfPath+"文件长度有错误,不能打开一个空的文件"
		_loaded = false
		return
	
	wdfhead.Flag = bitc.get_u32( _fp.get_32())
	wdfhead.FileSum = bitc.get_u32(_fp.get_32())
	wdfhead.Offset = bitc.get_32(_fp.get_32())
	
	var filesum = wdfhead.FileSum
	filelist.resize(filesum)
	
	_fp.seek(wdfhead.Offset)
	var filebuf = StreamPeerBuffer.new()
	
	for i in range(filesum):
		filebuf.data_array = _fp.get_buffer(16)
		var info = _getFInfo()
		info.Uid = bitc.get_u32( filebuf.get_32())
		info.FileOffset = bitc.get_u32( filebuf.get_32())
		info.FileSize = bitc.get_u32( filebuf.get_32())
		info.FileSpace = bitc.get_u32( filebuf.get_32())
		info.FileType = 0
		filelist[i] = info
		
	fileexs.resize(filesum)
	
	for i in range(filesum):
		var offSet = filelist[i].FileOffset
		var fExs = _getFileExs()
		_fp.seek(offSet)
		fExs.Hdw = _fp.get_buffer(2)
		_fp.get_32() #向后移动4个字节
		fExs.Sst = _fp.get_buffer(4)
		_fp.seek(_fp.get_position()-2)
		fExs.Nst = _fp.get_buffer(4)
		_fp.seek(filelist[i].FileOffset + filelist[i].FileSize - 6)
		fExs.Dss = _fp.get_buffer(4)
		_fp.seek(filelist[i].FileOffset + filelist[i].FileSize - 3)
		fExs.Dsg = _fp.get_buffer(3)
		_fp.seek(filelist[i].FileOffset + 4)
		fExs.Sss = _fp.get_buffer(2)
		fileexs[i] = fExs
		filelist[i].FileType = _get_file_type(fExs)
		
		
func getFinfo(uid):
	for i in range(filelist.size()):
		var info = filelist[i]
		if info.Uid == uid:
			return info
	
	return null
	
func _get_file_type(esdate):
	if bitc.buf_2_16(esdate.Hdw) == 0x5053:
		# was/tcp文件  "PS"
		return 1
	elif bitc.buf_2_16(esdate.Hdw) == 0x4D42:
		# bmp文件  BM   42 4D
		return 6
	elif bitc.buf_2_32(esdate.Sst) == 0x49464A10:
		# jpg文件  "FIFJ"
		return 3
	elif bitc.buf_2_32(esdate.Dss) == 0x454C4946:
		# tga文件  "ELIF"
		return 4
	elif bitc.buf_2_16(esdate.Hdw) == 0x4952 && bitc.buf_2_32(esdate.Nst) == 0x45564157:
		# wav文件RIFF | WAVE  52 49 46 46  | 57 41 56 45
		return 5
	elif ((esdate.Dsg[0] == 0x11) && (esdate.Dsg[1] == 0) && (esdate.Dsg[2] == 0) && (bitc.buf_2_16(esdate.Sss) == 0x1000) || (bitc.buf_2_16(esdate.Sss) == 0x0f00)):
		# 
		return 7
	elif bitc.buf_2_16(esdate.Hdw) == 0x00FF:
		# mp3文件
		return 2
	else:
		return 0
	
	
	
#  文件类型定义
#  1 was/tcp/wap/tca    头两个字节        SP    53 50
#  2 mp3                头两个字节              FF / FF
#  3 jpg                第七个字节开始    JFIF  10 4A 46 49
#  4 TGA                倒数六字节        FILE  46 49 4C 45
#  5 WAV                头四个字节 | 第九个字节开始    RIFF | WAVE  52 49 46 46  | 57 41 56 45
#  6 BMP                头两个字节        BM   42 4D
#  7 lua脚本	     		第三字节开始  00 00 00 10 或 00 00 00 0F   倒数三个字节 11 00 00 
#  0 未知
func _getFileExs():
	return {
		Hdw = [], # 头两个字节
		Sst = [], # 第七个字节开始的四个字节
		Nst = [], # 第九个字节开始的四个字节
		Dss = [], # 倒数六个字节开始的四个字节
		Sss = [], # 第五个字节开始的二个字节
		Dsg = []  # 倒数三个字节
	}
	
		
func _getFInfo():
	return {
		Uid = 0,
		FileOffset = 0,
		FileSize = 0,
		FileSpace = 0,
		FileType = 0
	}
