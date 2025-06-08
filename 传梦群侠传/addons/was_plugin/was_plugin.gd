@tool
extends EditorPlugin

var was_loader = null
var was_importer = null
func _enter_tree() -> void:
	print("从插件添加 SP RP 加载器")
	# was_loader = WASResourceFormatLoader.new()
	# ResourceLoader.add_resource_format_loader(was_loader)
	was_importer = WASEditorImportPlugin.new()
	self.add_import_plugin(was_importer)
	

func _exit_tree() -> void:
	print("从插件移除 SP RP 加载器")
	if was_loader:
		ResourceLoader.remove_resource_format_loader(was_loader)
	if was_importer :
		self.remove_import_plugin(was_importer)
