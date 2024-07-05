extends "res://scripts/ememies/enemy_base.gd"
@onready var ground_ray_cast_2d = $groundRayCast2D

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if ray_cast_2d.is_colliding() or !ground_ray_cast_2d.is_colliding():
		animated_sprite_2d.scale.x *= -1
		$explosion.scale.x *= -1
		ray_cast_2d.scale.x *= -1
		velocity.x *= -1
		ground_ray_cast_2d.position.x *= -1
	if can_move:
		move_and_slide()
	update_health()
