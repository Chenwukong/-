@tool
extends EditorPlugin

var map_importer = null
func _enter_tree():
	print("从插件添加 MAP 加载器")
	map_importer = MAPEditorImportPlugin.new()
	self.add_import_plugin(map_importer)


func _exit_tree():
	print("从插件移除 MAP 加载器")
	if map_importer :
		self.remove_import_plugin(map_importer)


