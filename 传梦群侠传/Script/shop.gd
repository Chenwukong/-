extends CanvasLayer

signal buy_signal
signal sell_signal
signal confirm_buy_signal
signal confirm_cancel_signal

func _ready():
	$Panel/shopTop/Button.pressed.connect(_on_button_button_down)
	$Panel/shopTop/Button2.pressed.connect(_on_button_2_button_down)
	$Panel/buyButton/cancel.pressed.connect(_on_cancel_button_down)
	$Panel/buyButton/buy.pressed.connect(_on_buy_button_down)
	
	
func _on_button_button_down():
	emit_signal("buy_signal")


func _on_button_2_button_down():
	emit_signal("sell_signal")


func _on_texture_button_button_down():
	$".".visible = false
	get_parent().onShop = false
	get_parent().onBuy = false
	get_parent().onSale = false
	get_parent().onItemPicked = false
	get_parent().onSaleItemPicked = false
	get_parent().get_node("player").canMove = true
		


func _on_cancel_button_down():
	emit_signal("confirm_cancel_signal")


func _on_buy_button_down():
	emit_signal("confirm_buy_signal")
