extends TextureRect

@onready var player = $"../../ObjectLayer/player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		size.x = player.health * 64
