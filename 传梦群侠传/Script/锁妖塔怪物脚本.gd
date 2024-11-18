extends CharacterBody2D

@export var monster_name: String

var speed = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	changeDir()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randi_range(0,400) == 0:
		changeDir()
#	if $AnimatedSprite2D.animation_finished:
#		velocity = Vector2.ZERO
	move_and_slide()
func changeDir():
	if Global.onFight:
		return
	var dir = randi_range(0,3)
	if dir == 0:
		velocity = Vector2(-1, 1) * speed
		$AnimatedSprite2D.play(monster_name + "左下")
	elif dir == 1:
		velocity = Vector2(1, 1) * speed
		$AnimatedSprite2D.play(monster_name + "右下")
	elif dir == 2:
		velocity = Vector2(1, -1) * speed
		$AnimatedSprite2D.play(monster_name + "右上")
	elif dir == 3:
		velocity = Vector2(-1, -1) * speed
		$AnimatedSprite2D.play(monster_name + "左上")
	


func _on_animated_sprite_2d_animation_finished():
	velocity = Vector2.ZERO


func _on_area_2d_area_entered(area):
	velocity = Vector2.ZERO
	if Global.onTalk:
		return
	if area.name == "playerTouch" and area.get_parent().velocity.x != 0:
		if get_tree().current_scene.name == "花果山":
			get_parent().get_parent().touchFight()
		else:
			get_parent().touchFight()
		self.queue_free()
