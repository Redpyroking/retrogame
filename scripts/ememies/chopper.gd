extends "res://scripts/ememies/enemy_base.gd"
@onready var change_direction = $change_direction
@onready var shoot_timer = $shoot_timer
const ENEMY_BULLET = preload("res://scenes/enemies/enemy_bullet.tscn")
var can_shoot = false
@onready var bullet_holder = $bullet_holder
var player_in_range = false
var has_collide = false
var is_chasing = false
@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	randomize()
	initialise()
	set_health()
	change_direction_to_random()
	shoot_timer.start()

func _physics_process(delta):
	if animated_sprite_2d.global_rotation_degrees > 360:
		animated_sprite_2d.global_rotation_degrees = 0
	else:
		if player_in_range:
			animated_sprite_2d.global_rotation_degrees += 2
		else:
			animated_sprite_2d.global_rotation_degrees += 1
	#if ray_cast_2d.is_colliding():
		#change_direction_to_random(true)
	update_health()
	if can_move:
		move_and_slide()
		if is_chasing:
			var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
			velocity = dir * speed

func pick_rnd_vector()->Vector2:
	velocity = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	return velocity

func change_direction_to_random(pick_opposite:bool = false):
	if pick_opposite:
		velocity *= -1
	else:
		velocity = pick_rnd_vector()*speed
	ray_cast_2d.rotation = velocity.normalized().angle_to_point(Vector2.ZERO)
	if randi() % 20 == 0:
		change_direction.wait_time = 0.1
	else:
		change_direction.wait_time = randf_range(1.4,6.4)
	change_direction.start()

func _on_change_direction_timeout():
	change_direction_to_random()

func _on_shoot_timer_timeout():
	var e = ENEMY_BULLET.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	if player_in_range:
		bullet_holder.add_child(e)
	e.global_position = global_position
	e.set_velocity(global_position - player.global_position)
	shoot_timer.wait_time = randf_range(1,4)
	shoot_timer.start()

func _on_detect_area_area_entered(area):
	speed = 30
	player_in_range = true

func _on_detect_area_area_exited(area):
	speed = 20
	player_in_range = false

func _on_player_chase_area_area_entered(area):
	is_chasing = true
	shoot_timer.stop()

func _on_player_chase_area_area_exited(area):
	is_chasing = false
	shoot_timer.start()

func _on_nav_timer_timeout():
	makepath()

func makepath():
	navigation_agent_2d.target_position = player.global_position
