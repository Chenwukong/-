extends RayCast2D

@onready var right = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	$"死亡地带/left"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	print(right.is_colliding())
	if right.is_colliding():
		print(123)
