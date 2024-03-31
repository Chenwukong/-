extends AudioStreamPlayer2D

@export var audioStreams : Array = [
	"res://Audio/BGM/战斗-城市.mp3",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var randomIndex = randi() % audioStreams.size()
	self.stream = load("res://Audio/BGM/战斗-城市.mp3")
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Your process logic goes here.
