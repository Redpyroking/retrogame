extends CanvasLayer

@onready var time_label = $time_label
var time:float = 0.0
var minute:int = 0
func _physics_process(delta):
	time += delta
	time_label.text = str(minute)+'.'+str(time).pad_decimals(2)
	if time > 59.9:
		time = 0.0
		minute += 1
