extends Node
@onready var player = get_parent()
var start_shield_timer = false
@onready var barrier = $"../barrier"
var shield_animation_finished = false

func _ready():
	player = get_parent()
	if player.shielding:
		shielding()

func enrage():
	var modifier =  player.character.max_health - player.character.current_health
	if modifier == 0:
		player.move_bullet_damage_modifier = 1
	else:
		player.move_bullet_damage_modifier = modifier

func shielding(value= true):
	if player.velocity == Vector2.ZERO and value:
		if !start_shield_timer:
			player.get_node("ShieldTimer").start()
			start_shield_timer = true
	else:
		start_shield_timer = false
		player.shielding = false
		player.get_node("ShieldTimer").stop()

	barrier.visible = player.shielding
	barrier.rotation += 0.04
	if barrier.rotation > 360:
		barrier.rotation = 1

func set_shield_animation(value:bool=true):
	shield_animation_finished = value

func dash():
	if Input.is_action_just_pressed("dash"):
		player.get_node("dash_timer").start()
		player.can_move = false
		player.can_dash = true

func _on_shield_timer_timeout():
	player.shielding = true

	start_shield_timer = false

func _on_dash_timer_timeout():
	player.can_move = true
	player.can_dash = false

func thorn():
	player.set_spike()

func gravityflip():
	if (player.is_on_ceiling() or player.is_on_floor()) and Input.is_action_just_pressed("dash"):
		player.flip_gravity()

func _on_player_shooted():
	shielding(false)

func _on_player_character_is_updated():
	barrier.hide()
