extends Control


var commendButtons
var fightScenePlayer
var currPlayer
var deltas

func _ready():
	commendButtons = get_tree().get_nodes_in_group("battleCommendButton")
	fightScenePlayer =  get_tree().get_nodes_in_group("fightScenePlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltas = delta
	for i in fightScenePlayer:
		if !is_instance_valid(i):
			return
		if Global.onAttackingList and Global.onAttackingList[0] == i.name:
			Global.currPlayer = i
		
func _on_attack_button_button_down():
	#Global.onAttackPicking = true
	pass
	
	
	
#	attacks()
#	if Global.currPlayer.name != "姜韵":
#		move()
	
	
func _on_defense_button_button_down():
	pass # Replace with function body.


func _on_magic_button_button_down():
	pass # Replace with function body.


func _on_item_button_button_down():
	pass # Replace with function body.


func attacks():
	Global.currPlayer.attack(deltas)
func move():
	Global.currPlayer.moveCharacter(deltas * 4.5)
