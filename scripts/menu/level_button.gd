extends TouchScreenButton

@export var level:int = 0
@onready var label = $Label
@export var unlock = false

func _ready():
	label.text = str(level)
	set_lock_display()
	check_level()

func set_lock_display():
	if unlock:
		modulate = Color("ffffff")
		label.show()
	else:
		modulate = Color("6b6b6b")
		label.hide()

func check_level():
	if Global.current_unlocked_level >= level:
		unlock = true
	set_lock_display()
