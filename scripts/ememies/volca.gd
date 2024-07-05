extends "res://scripts/ememies/enemy_base.gd"

const ENEMY_BULLET = preload("res://scenes/enemies/enemy_bullet.tscn")
var can_fire = true
var is_on_screen = false
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

func shoot_player():
	randomize()
	if is_on_screen:
		if can_fire:
			var e = ENEMY_BULLET.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
			get_parent().get_parent().get_node("bulletholder").add_child(e)
			e.top_level = true
			e.global_position = global_position
			e.set_velocity(global_position - player.global_position)
			can_fire = false
			$firing_time.start()

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if player.global_position.x > global_position.x:
		animated_sprite_2d.scale.x = -1
		$explosion.scale.x = -1
	else:
		animated_sprite_2d.scale.x = 1
		$explosion.scale.x = 1
	if can_move:
		move_and_slide()
	if randi() % 100 == 0 and is_on_floor():
		velocity.y = -400
	update_health()

func _on_visible_on_screen_notifier_2d_screen_entered():
	is_on_screen = true
	$firing_time.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	is_on_screen = false

func _on_firing_time_timeout():
	can_fire = true
	$firing_time.wait_time = randi_range(1,2)
	shoot_player()
