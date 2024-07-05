extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var max_health = 5
@export var speed:int
var health:int
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var healthbar = $healthbar
@onready var label = $healthbar/Label
@onready var sprite_material = $AnimatedSprite2D.material
@onready var player = $"../../player"
var can_move = true

func _ready():
	initialise()
	set_health()

func initialise():
	animated_sprite_2d.play("default")
	velocity.x = -speed
	$explosion.connect("animation_finished",_on_explosion_animation_finished)

func set_health():
	health = max_health
	healthbar.max_value = health
	healthbar.value = health
	label.text = str(health) + "/" + str(max_health)

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if ray_cast_2d.is_colliding():
		animated_sprite_2d.scale.x *= -1
		$explosion.scale.x *= -1
		ray_cast_2d.scale.x *= -1
		velocity.x *= -1
	if can_move:
		move_and_slide()
	update_health()


func hit(value:int =1):
	$hurt_sound.play()
	sprite_material.set_shader_parameter("color_opacity",1)
	healthbar.show()
	health -= value
	if health < 1:
		sprite_material.set_shader_parameter("color_opacity",1)
		destroy()
		return
	await get_tree().create_timer(0.2).timeout
	if $freeze_timer.is_stopped():
		sprite_material.set_shader_parameter("color_opacity",0)

func update_health():
	healthbar.value = health
	label.text = str(health) + "/" + str(max_health)

var burn_count = 3

func burn():
	if burn_count > 0:
		$burn_timer.wait_time = 1
		$burn_timer.start()

func freeze():
	$freeze_timer.start()
	can_move = false
	$ice_particle.emitting = true
	sprite_material.set_shader_parameter("color_opacity",1)
	sprite_material.set_shader_parameter("main_color",Color(0, 0.58, 1))
	$freeze_sound.play()

func _on_burn_timer_timeout():
	hit()
	if burn_count > 0:
		$burn_timer.wait_time =1
		$burn_timer.start()
		$fire_particle.emitting = true
		burn_count -= 1
		if !$burn_sound.playing:
			$burn_sound.play()
	else:
		burn_count = 3
		$burn_timer.stop()
		$fire_particle.emitting = false
		$burn_sound.stop()

func _on_freeze_timer_timeout():
	velocity.x = speed * -ray_cast_2d.scale.x
	$freeze_timer.wait_time = 3
	sprite_material.set_shader_parameter("color_opacity",0)
	sprite_material.set_shader_parameter("main_color",Color(1, 1, 1))
	can_move = true

func destroy():
	velocity = Vector2.ZERO
	sprite_material.set_shader_parameter("color_opacity",1)
	$explosion.show()
	$explosion.play("default")
	$exposion_sound.play()

func _on_explosion_animation_finished():
	queue_free()
