extends CanvasLayer

var hintOut =  false
# Called when the node enters the scene tree for the first time.
func _ready():
	renderMsg()
	$position/mapName.text = get_tree().current_scene.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.onPhone:
		$phoneButtons.visible = true
		$"../player".get_node("RayCast2D").enabled = false
		$"../player".get_node("RayCast2D2").enabled = false
	else:
		$"../player".get_node("RayCast2D").enabled = true
		$"../player".get_node("RayCast2D2").enabled = false
		$phoneButtons.visible = false	
	$questHint/Label2.text = Global.questHint
	if Global.systemMsg.size() > 6:
		Global.systemMsg.pop_front()
		var msgs = get_tree().get_nodes_in_group("msgText")
		for i in msgs:
			i.queue_free()
		renderMsg()	

func renderMsg():
	var msgs = get_tree().get_nodes_in_group("msgText")
	for i in msgs:
		i.queue_free()	
	for msg in Global.systemMsg:
		var msgText = Label.new()
		msgText.text = msg
		msgText.add_to_group("msgText")
		msgText.add_theme_font_size_override("font_size", 65)
		msgText.size = Vector2(1, 4)
		get_node("msgBox/VBoxContainer").add_child(msgText)	


func _on_hint_button_button_down():
	
	if !hintOut:
		hintOut = true
		$questHint.visible = true
	else:
		hintOut = false
		$questHint.visible = false


func _on_menut_button_mouse_entered():
	$menutButton/Label2.visible = true
	Global.onButton = true

func _on_menut_button_mouse_exited():
	$menutButton/Label2.visible = false
	Global.onButton = false

func _on_hint_button_mouse_entered():
	$hintButton/Label.visible = true
	Global.onButton = true

func _on_hint_button_mouse_exited():
	$hintButton/Label.visible = false
	Global.onButton = false


func _on_warn_timer_timeout():
	pass # Replace with function body.
