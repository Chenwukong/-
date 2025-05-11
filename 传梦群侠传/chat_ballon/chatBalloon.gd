extends CanvasLayer


@onready var balloon = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var portrait = $Balloon/TextureRect
@onready var mainPortrait = $Balloon/TextureRect2
@onready var 小二portrait = $Balloon/TextureRect4
@onready var 敖雨portrait = $"Balloon/敖雨rect"

@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		character_label.visible = not dialogue_line.character.is_empty()
		if dialogue_line.character == "时追云惊" or dialogue_line.character == "时追云怒" or dialogue_line.character == "时追云红眼" or dialogue_line.character == "时追云红眼怒" or dialogue_line.character == "时追云哀" or dialogue_line.character == "时追云喜":
			character_label.text = "时追云"
		elif dialogue_line.character == "姜韵喜" or dialogue_line.character == "姜韵" or dialogue_line.character == "姜韵怒" or dialogue_line.character == "姜韵哀" or dialogue_line.character == "姜韵恐" or dialogue_line.character == "姜韵哭":
			character_label.text = "姜韵"
		elif dialogue_line.character == "敖阳怒" or dialogue_line.character == "敖阳"  or dialogue_line.character == "敖阳哀":
			character_label.text = "敖阳"			
		elif dialogue_line.character == "凌若昭哭" or dialogue_line.character == "凌若昭哀"  or dialogue_line.character == "凌若昭怒" or dialogue_line.character == "凌若昭喜" :
			character_label.text = "凌若昭"				
		elif dialogue_line.character == "小二真身":
			character_label.text = "小二"				
		elif dialogue_line.character == "水云仙"  or dialogue_line.character == "水云仙哀" or dialogue_line.character == "水云仙哭" or dialogue_line.character == "水云仙死":
			character_label.text = "水云仙"					
			
		else:
			character_label.text = tr(dialogue_line.character, "dialogue")
		if dialogue_line.character == "<null>":
			character_label.text = ""
			mainPortrait.visible = false
			portrait.visible = false 
		var name = dialogue_line.character.to_lower()
	
	
		if name == "关重七" or name == "玄武" or name == "小姜韵" or name == "小追云"or name == "时追云" or name == "时追云惊" or name == "时追云红眼"or name == "时追云红眼怒" or name == "时追云怒" or name == "时追云喜" or name == "时追云哀"  or name == "姜韵" or name == "姜韵喜" or name == "姜韵怒" or name == "姜韵哭" or name == "姜韵哀" or name == "姜韵恐" or name == "凌若昭" or name == "凌若昭哀" or name == "凌若昭怒" or name == "凌若昭喜" or name == "凌若昭哭"   or name == "上官冕" or name == "水云仙"  or name == "水云仙哀"  or name == "水云仙哭" or name == "水云仙死"                                                          :
			var portraitPath = "res://portrait/" + dialogue_line.character.to_lower() + ".png"	
			mainPortrait.visible = true
			mainPortrait.texture = load(portraitPath)
			portrait.visible = false
			敖雨portrait.visible = false
			小二portrait.visible = false
			%Balloon.texture = load("res://Pictures/对话框2.png")
			%CharacterLabel.position = Vector2(598,80)
		elif name == "小二"   or name == "虎范" or name == "白虎" :
			var portraitPath = "res://portrait/" + dialogue_line.character.to_lower() + ".png"	
			敖雨portrait.visible = false
			小二portrait.visible = true
			小二portrait.texture = load(portraitPath)
			portrait.visible = false			 
			mainPortrait.visible = false
			%Balloon.texture = load("res://Pictures/对话框2.png")
			%CharacterLabel.position = Vector2(598, 80)
		elif name == "敖雨" or name == "朱雀":
			var portraitPath = "res://portrait/" + dialogue_line.character.to_lower() + ".png"	
			敖雨portrait.visible = true
			敖雨portrait.texture = load(portraitPath)
			小二portrait.visible = false
			portrait.visible = false			 
			mainPortrait.visible = false	
			%Balloon.texture = load("res://Pictures/对话框2.png")
			%CharacterLabel.position = Vector2(598, 80)			
		elif name == "小男孩"or name == "小追云" :
			var portraitPath = "res://portrait/" + dialogue_line.character.to_lower() + ".png"	
			敖雨portrait.visible = true
			敖雨portrait.texture = load(portraitPath)
			敖雨portrait.scale.x = 0.15
			敖雨portrait.scale.y = 0.13
			小二portrait.visible = false
			portrait.visible = false			 
			mainPortrait.visible = false	
			%Balloon.texture = load("res://Pictures/对话框2.png")
			%CharacterLabel.position = Vector2(598, 80)
			敖雨portrait.position = Vector2(493,-139)
		else:
			var portraitPath = "res://portrait/" + dialogue_line.character.to_lower() + ".png"
			portrait.visible = true
			portrait.texture = load(portraitPath)
			敖雨portrait.visible = false
			小二portrait.visible = false
			mainPortrait.visible = false
			%Balloon.texture = load("res://Pictures/对话框1.png")
			
			%CharacterLabel.position = Vector2(150,80)

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _process(delta):
	if Global.onBigPicture:
		mainPortrait.visible = false
		portrait.visible = false
		敖雨portrait.visible = false
		小二portrait.visible = false
		%CharacterLabel.visible = false
		%Balloon.self_modulate = "ffffff00"
		$"黑边".visible = true
		$Balloon/Dialogue.position = Vector2(100,237)

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# If the user clicks on the balloon while it's typing then skip typing
#	if dialogue_label.is_typing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
#		get_viewport().set_input_as_handled()
#		dialogue_label.skip_typing()
#		return
	if event.is_action_pressed("ui_cancel"):
		return
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
