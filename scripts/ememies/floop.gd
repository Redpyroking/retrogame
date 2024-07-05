extends "res://scripts/ememies/enemy_base.gd"

const JUMP_VELOCITY = -300
@onready var wait_to_jump = $wait_to_jump
var is_jumping = false
var is_on_screen = false

func _ready():
	initialise()
	set_health()
	speed = -speed
	wait_to_jump.wait_time = randf_range(0.5,2.5)
	wait_to_jump.start()

func _physics_process(delta):
	if !is_on_screen:
		return
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = speed
	else:
		is_jumping = false
		velocity.x = 0
		if global_position.x > player.global_position.x:
			animated_sprite_2d.scale.x = 1
			ray_cast_2d.scale.x = 1
			speed = -abs(speed)
		else:
			animated_sprite_2d.scale.x = -1
			ray_cast_2d.scale.x = -1
			speed = abs(speed)
	if ray_cast_2d.is_colliding():
		animated_sprite_2d.scale.x *= -1
		ray_cast_2d.scale.x *= -1
		speed = -speed
	update_health()
	if can_move:
		move_and_slide()

func _on_wait_to_jump_timeout():
	if !is_on_floor():
		wait_to_jump.wait_time = randf_range(0.2,1.5)
		return
	velocity.y = JUMP_VELOCITY
	is_jumping = true
	wait_to_jump.wait_time = randf_range(0.5,2.5)

func _on_visible_on_screen_notifier_2d_screen_entered():
	is_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	is_on_screen = false
