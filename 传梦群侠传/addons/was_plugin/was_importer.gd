@tool
extends EditorImportPlugin

class_name WASEditorImportPlugin

func _get_importer_name():
	return "SP_RP"

func _get_visible_name():
	return "SP_RP"

func _get_recognized_extensions() -> PackedStringArray:
	return ["was", "tcp"]

func _get_save_extension():
	return "tres"

func _get_resource_type():
	return "Texture2D"

func _get_preset_count():
	return 1
	
func _get_priority() -> float :
	return 1.0
	
func _get_import_order() -> int :
	return 0

func _get_preset_name(preset_index):
	return "sprp_preset"

func _get_import_options(path, preset_index) -> Array[Dictionary]:
	return []

func _import(source_file, save_path, options, platform_variants, gen_files):
	var ifile = FileAccess.open(source_file, FileAccess.READ)
	if not ifile.is_open():
		return null
	var signature = ifile.get_buffer(2)
	ifile.close()
	var image : Image = null
	if SPDecoder.isSP(signature):
		image = SPDecoder.readSPFrame0ToImage(source_file)
	else :
		if RPDecoder.isRP(signature) :
			image = RPDecoder.readRPFrame0ToImage(source_file)
	if image :
		var err = ResourceSaver.save(ImageTexture.create_from_image(image), save_path + "." + _get_save_extension())
		if err != OK :
			print(save_path, " 导入失败: ", err)

