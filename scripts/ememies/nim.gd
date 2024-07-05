extends "res://scripts/ememies/enemy_base.gd"
@onready var player_detect = $PlayerDetect
const ENEMY_BULLET = preload("res://scenes/enemies/enemy_bullet.tscn")
var can_fire = true

func _ready():
	initialise()
	set_health()
	gravity = 0

func _physics_process(delta):
	if ray_cast_2d.is_colliding():
		animated_sprite_2d.scale.x *= -1
		ray_cast_2d.scale.x *= -1
		velocity.x *= -1
		player_detect.position.x *= -1
	if !player_detect.is_colliding() and can_move:
		move_and_slide()
	update_health()
	detect_player()

func detect_player():
	if player_detect.is_colliding():
		if can_fire:
			var e = ENEMY_BULLET.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
			$bullet_holder.add_child(e)
			e.global_position = global_position
			e.set_velocity(Vector2.UP)
			can_fire = false
			$shoot_timer.start()

func _on_shoot_timer_timeout():
	can_fire = true
