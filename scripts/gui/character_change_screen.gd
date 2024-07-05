extends PanelContainer

signal update_character

@onready var grid_container = $MarginContainer/PanelContainer/GridContainer
@export var character_inventory:Resource
@onready var character_selector:PackedScene = load("res://scenes/gui/character_selector.tscn")
@onready var character_texture = $InfoContainer/CharacterTexture
var current_character_select
@onready var action_button = $"../ActionButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func update():
	for i in grid_container.get_children():
		grid_container.remove_child(i)
	for i in character_inventory.inventory:
		var c = character_selector.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
		grid_container.add_child(c)
		c.dex_number = i.dex
		c.resource = i
	for i in grid_container.get_children():
		if !i.is_connected("pressed",set_selected_character.bind(i)):
			i.connect("pressed",set_selected_character.bind(i))

func set_selected_character(character_selector):
	for i in grid_container.get_children():
		if i != character_selector:
			i.button_pressed = false
		else:
			set_character_info(i.resource)
			current_character_select = i.resource
	$InfoContainer/PanelContainer/Control/Button.show()
	$InfoContainer.show()

func set_character_info(character:Resource):
	character_texture.texture = character.animation
	$InfoContainer/PanelContainer/Control/CharacterName.text = character.alias
	$InfoContainer/PanelContainer/Control/CharacterDescription.text = character.description
	$InfoContainer/PanelContainer/Control/AbilityName.text = character.ability.alias
	$InfoContainer/PanelContainer/Control/AbilityDescription.text = character.ability.description
	$InfoContainer/PanelContainer/Control/BulletTexture.texture = character.move_bullet.texture
	$InfoContainer/PanelContainer/Control/BulletName.text = character.move_bullet.alias
	$InfoContainer/PanelContainer/Control/BulletDescription.text = character.move_bullet.description
	$InfoContainer/PanelContainer/Control/Damage.text = str(character.move_bullet.damage)
	$InfoContainer/PanelContainer/Control/Speed.text = str(character.move_bullet.speed)
	$InfoContainer/PanelContainer/Control/Cooldown.text = str(character.move_bullet.ammo_cooldown)
func _on_button_pressed():
	emit_signal("update_character",current_character_select)
	hide()
	action_button.show()

func _on_heal_button_pressed():
	for i in grid_container.get_children():
		i.resource.full_heal()

func _on_computer_button_pressed():
	visible = not visible
	action_button.visible = not action_button.visible

	if visible:
		$on_sound.play()
	else:
		$off_sound.play()
