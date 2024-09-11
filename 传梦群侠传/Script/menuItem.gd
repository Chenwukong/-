extends TextureRect

var players = []
var playerIndex = 0
var description
# Called when the node enters the scene tree for the first time.
func _ready():
	if $itemName.text in FightScenePlayers.keyItem:
		description= FightScenePlayers.keyItem.get($itemName.text).info.description
	elif  $itemName.text in FightScenePlayers.consumeItem:
		description = FightScenePlayers.consumeItem.get($itemName.text).info.description
	elif  $itemName.text in FightScenePlayers.bagArmorItem:
		description = FightScenePlayers.bagArmorItem.get($itemName.text).info.description
	elif $itemName.text in FightScenePlayers.battleItem:
		description = FightScenePlayers.battleItem.get($itemName.text).info.description

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
				
func _on_button_button_down():
	if Global.onMenuItemUsing:
		return 
	Global.itemPlayerIndex = 0
	Global.itemPlayers = []
	print(9999999999)
	for i in $"../../../../..".bagMenuItems.size():
		if $"../../../../..".bagMenuItems[i] == self:
			$"../../../../..".itemSelectIndex = i
#	for i in Global.onTeamPlayer.size():
#		Global.itemPlayers.append($"../../../../角色表".get_node("itemPlayer"+str(i+1)))	
#		get_node("../../../../角色表/itemPlayer"+str(i+1)+"/hpText/hpBar/hpValue").text = str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).currHp) +"/"+str(FightScenePlayers.fightScenePlayerData.get(Global.onTeamPlayer[i]).hp)
			
	if $itemName.text in FightScenePlayers.consumeItem:
		Global.onItemSelect = false
		Global.onMenuItemUsing = true
		$"../../../../角色表".visible = true
	if $itemName.text in FightScenePlayers.keyItem:
		if FightScenePlayers.keyItem.get($itemName.text).info.effect != null:
			Global.onItemSelect = false
			Global.onMenuItemUsing = true
			$"../../../../角色表".visible = true			
	Global.currMenuItem = $itemName.text
	$"../../../../../../subSound".stream = load("res://Audio/SE/002-System02.ogg")
	$"../../../../../../subSound".play()
	
