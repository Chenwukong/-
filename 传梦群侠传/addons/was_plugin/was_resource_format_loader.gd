# extends ResourceFormatLoader

# 可以用不上
class_name WASResourceFormatLoader


func _init():
	print("was init")


# 识别的文件扩展名
func _get_recognized_extensions() -> PackedStringArray:
	return ["was", "tcp"]

# 判断是否处理该类型资源
func _handles_type(type) -> bool:
	return type == "Texture2D"

# 返回资源类型
func _get_resource_type(path) -> String:
	return "Texture2D"


# 加载资源的核心方法
func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
	print("_load ", path)
	var ifile = FileAccess.open(path, FileAccess.READ)
	if not ifile.is_open():
		print("open fail: ", path)
		return null
	var signature = ifile.get_buffer(2)
	ifile.close()
	if SPDecoder.isSP(signature):
		return SPDecoder.readSPFrame0ToImageTexture(path)
	else :
		if RPDecoder.isRP(signature):
			return RPDecoder.readRPFrame0ToImageTexture(path)
	return null
