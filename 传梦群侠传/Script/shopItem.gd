extends TextureRect
var buyAmount = 1
var shopItems = 1
@export var gold = 0
var description = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	shopItems = get_tree().get_nodes_in_group("shopItem")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Control/num.text = str(buyAmount)	
	shopItems = get_tree().get_nodes_in_group("shopItem")
	
func _on_button_pressed():
	
#	if get_tree().current_scene.onItemPicking:
#		if buyAmount * gold > FightScenePlayers.golds:
#			return

	
	get_tree().current_scene.onSaleItemPicked
	get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = false
	for x in shopItems.size():
		if shopItems[x] == self:
			get_tree().current_scene.itemIndex = x
			if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:
				print( buyAmount * gold,"x", FightScenePlayers.golds)
				if buyAmount * gold > FightScenePlayers.golds:	
					pass	
				else:
					get_tree().current_scene.get_node("shop/Panel/buyButton").visible = true
					#get_tree().current_scene.onBuy = true
					get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = true
			if get_tree().current_scene.onSellPicking or get_tree().current_scene.onSaleItemPicked:
				get_tree().current_scene.get_node("shop/Panel/buyButton").visible = true
				get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = true					
	print(get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible)					
					
					
	$Button.grab_focus()
	
	





func _on_button_1_pressed():
	get_tree().current_scene.addMode = 1

func _on_button_5_pressed():
	get_tree().current_scene.addMode = 5

func _on_button_10_pressed():
	get_tree().current_scene.addMode = 10

func _on_up_button_pressed():
	if get_tree().current_scene.addMode == 1:

		if get_tree().current_scene.onSellPicking:
			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number
				return
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:
			if (buyAmount+1 )* gold > FightScenePlayers.golds:
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return				
				
		buyAmount += 1	
		$golds.text = str(gold * buyAmount)				
	elif get_tree().current_scene.addMode == 5:
		if get_tree().current_scene.onSellPicking:
			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number			
				return		
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:		
			if (buyAmount+5 )* gold > FightScenePlayers.golds :
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return								
		buyAmount += 5
		$golds.text = str(gold * buyAmount)	
	elif get_tree().current_scene.addMode == 10:
		if get_tree().current_scene.onSellPicking:
			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number
				return	
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:			
			if (buyAmount+10 )* gold > FightScenePlayers.golds:
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return								
		buyAmount += 10
		$golds.text = str(gold * buyAmount)		

func _on_down_button_pressed():
	if get_tree().current_scene.addMode == 1:
		buyAmount -= 1			
		if buyAmount < 1:
			buyAmount = 1	
		$golds.text = str(gold * buyAmount)		
	elif get_tree().current_scene.addMode == 5:
		buyAmount -= 5
		if buyAmount < 1:
			buyAmount = 1
		$golds.text = str(gold * buyAmount)				
	elif get_tree().current_scene.addMode == 10:
		buyAmount -= 10
		if buyAmount < 1:
			buyAmount = 1		
		$golds.text = str(gold * buyAmount)				


func _on_clear_pressed():
	buyAmount = 1


func _on_num_text_changed(new_text):
	
	var input_value = 0

	if is_valid_integer(new_text):
		input_value = int(new_text)
		buyAmount = input_value
func is_valid_integer(text):
	return text.match("^-?\\d+$") # Regex for an optional leading '-' followed by one or more digits.


func _on_button_button_down():
#	if get_tree().current_scene.onItemPicking:
#		if buyAmount * gold > FightScenePlayers.golds:
#			return
	
	get_parent().get_parent().get_parent().get_parent().get_node("buyButton").visible = true

	if get_tree().current_scene.onItemPicking:	
		get_tree().current_scene.onItemPicked = false
	elif get_tree().current_scene.onSellPicking:
		get_tree().current_scene.onSaleItemPicked = false
		
	if get_tree().current_scene.onItemPicking:
		if FightScenePlayers.golds >= gold:	
			get_tree().current_scene.onItemPicked = true
			get_tree().current_scene.get_node("shop/Panel/buyButton").visible = true
		else:
			get_tree().current_scene.onItemPicked = false
			get_tree().current_scene.get_node("shop/Panel/buyButton").visible = false		
	elif get_tree().current_scene.onSellPicking:
		get_tree().current_scene.onSaleItemPicked = true
		
		
		
	get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = false
	for x in shopItems.size():
		if shopItems[x] == self:
			get_tree().current_scene.itemIndex = x
			if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:
				if buyAmount * gold > FightScenePlayers.golds:	
					pass	
				else:
					#get_tree().current_scene.get_node("shop/Panel/buyButton").visible = true
					get_tree().current_scene.onBuy = true
					get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = true
			if get_tree().current_scene.onSellPicking or get_tree().current_scene.onSaleItemPicked:
				get_tree().current_scene.get_node("shop/Panel/buyButton").visible = true
				get_tree().current_scene.shopItems[get_tree().current_scene.itemIndex].get_node("Control").visible = true					
					
					
					
	$Button.grab_focus()


func _on_button_10_button_down():
	get_tree().current_scene.addMode = 10


func _on_button_5_button_down():
	get_tree().current_scene.addMode = 5


func _on_button_1_button_down():
	get_tree().current_scene.addMode = 1


func _on_down_button_button_down():
	if get_tree().current_scene.addMode == 1:
		buyAmount -= 1			
		if buyAmount < 1:
			buyAmount = 1	
		$golds.text = str(gold * buyAmount)		
	elif get_tree().current_scene.addMode == 5:
		buyAmount -= 5
		if buyAmount < 1:
			buyAmount = 1
		$golds.text = str(gold * buyAmount)				
	elif get_tree().current_scene.addMode == 10:
		buyAmount -= 10
		if buyAmount < 1:
			buyAmount = 1		
		$golds.text = str(gold * buyAmount)			


func _on_up_button_button_down():
	if get_tree().current_scene.addMode == 1:

		if get_tree().current_scene.onSellPicking or get_tree().current_scene.onSaleItemPicked:

			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number
				return
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:

			if (buyAmount+1 )* gold > FightScenePlayers.golds:
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return				
				
			else:
				buyAmount += 1	
				$golds.text = str(gold * buyAmount)		
						
	elif get_tree().current_scene.addMode == 5:
		if get_tree().current_scene.onSellPicking or get_tree().current_scene.onSaleItemPicked:
			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number			
				return		
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:		
			if (buyAmount+5 )* gold > FightScenePlayers.golds :
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return								
			else:
				buyAmount += 5
				$golds.text = str(gold * buyAmount)	
	elif get_tree().current_scene.addMode == 10:
		if get_tree().current_scene.onSellPicking or get_tree().current_scene.onSaleItemPicked:
			if FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number >= buyAmount:
				buyAmount = FightScenePlayers.bagArmorItem[shopItems[get_tree().current_scene.itemIndex].name].number
				return	
		if get_tree().current_scene.onItemPicking or get_tree().current_scene.onItemPicked:			
			if (buyAmount+10 )* gold > FightScenePlayers.golds:
				buyAmount += floor((FightScenePlayers.golds -buyAmount * gold)/gold)
				$golds.text = str(gold * buyAmount)
				return								
			else:
				buyAmount += 10
				$golds.text = str(gold * buyAmount)		


func _on_clear_button_down():
	buyAmount = 1
