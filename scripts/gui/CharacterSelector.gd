extends TextureButton

@onready var animated_sprite_2d = $AnimatedSprite2D
var dex_number:String = "001"
var resource = null

func _physics_process(delta):
	animated_sprite_2d.play(dex_number)

