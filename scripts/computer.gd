extends Area2D

@onready var character_change_screen = $"../../../CanvasLayer/CharacterChangeScreen"
@onready var action_button = $"../../../CanvasLayer/ActionButton"
@onready var computer_button = $"../../../CanvasLayer/computerButton"

var able_to_interact = false

func interact():
	character_change_screen.visible = not character_change_screen.visible
	action_button.visible = not action_button.visible

func _input(event):
	if event.is_action_pressed("open_box")\
	and able_to_interact:
		interact()

func _on_area_entered(area):
	if  area:
		able_to_interact = true
		
		computer_button.show()
	pass # Replace with function body.

func _on_area_exited(area):
	able_to_interact = false
	computer_button.hide()
	pass # Replace with function body.
