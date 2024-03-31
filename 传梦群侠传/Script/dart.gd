extends Node2D

var players
var currPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dart_area_area_entered(area):
	#print(area.get_parent(),Global.currUsingItemPlayer.target, Global.target, Global.itemControlType)
	if area.is_in_group("enemy"):
		if Global.itemControlType == "mouse" and Global.currUsingItemPlayer.target == area.get_parent():
			area.get_parent().currHp -= Global.currUsingItem.info.value
			area.get_parent().get_node("hpControl/hpLabel").text = str(Global.currUsingItem.info.value)
			area.get_parent().get_node("hpControl").visible = true
			area.get_parent().get_node("hpAnimation").play("hpDrop")
			Global.usingDart = false
			area.get_parent().self_modulate = "#ffffff"
			queue_free()
			Global.onItemUsing = false
		elif Global.itemControlType == "keyboard" and Global.target == area.get_parent():
			area.get_parent().currHp -= Global.currUsingItem.info.value
			area.get_parent().get_node("hpControl/hpLabel").text = str(Global.currUsingItem.info.value)
			area.get_parent().get_node("hpControl").visible = true
			area.get_parent().get_node("hpAnimation").play("hpDrop")
			Global.usingDart = false
			area.get_parent().self_modulate = "#ffffff"
			queue_free()
			Global.onItemUsing = false
