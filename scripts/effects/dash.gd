extends Sprite2D

func _ready():
	ghosting()

func set_property(tx_pos,tx_scale,tx_flip_h):
	global_position = tx_pos + Vector2(0,-2)
	scale = tx_scale
	flip_h = tx_flip_h

func ghosting():
	#fade visiblity
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self,"self_modulate",Color(1,1,1,0),0.45)
	await  tween_fade.finished
	queue_free()
