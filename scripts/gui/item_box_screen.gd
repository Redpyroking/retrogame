extends PanelContainer

@onready var grid_container = $MarginContainer/PanelContainer/GridContainer
@export var item_inventory:Resource
@onready var item_selector:PackedScene = load("res://scenes/gui/item_selector.tscn")
var current_item_select
@onready var item_texture = $InfoContainer/PanelContainer/Control/ItemTexture

func _ready():
	for i in item_inventory.inventory:
		var c = item_selector.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
		grid_container.add_child(c)
		c.dex_number = i.dex
		c.resource = i
	for i in grid_container.get_children():
		i.connect("pressed",set_selected_character.bind(i))

func set_selected_character(character_selector):
	for i in grid_container.get_children():
		if i != item_selector:
			i.button_pressed = false
		else:
			set_character_info(i.resource)
			current_item_select = i.resource
	$InfoContainer/PanelContainer/Control/Button.show()

func set_character_info(item:Resource):
	item_texture.texture = item.animation


func _on_button_pressed():
	pass # Replace with function body.
