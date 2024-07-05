extends CharacterBody2D

const SPEED = 100.0
const DASH_SPEED = 300.0
var jump_velocity = -330.0
@export var character:Character
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D
@onready var move:PackedScene = preload("res://scenes/move.tscn")
@onready var animation_player = $AnimationPlayer
var move_bullet_damage_modifier = 1
var facing_dir = 1
var attack_dir_by_enemy = 1 #check from which direction enemy has attack
var health:int
var ability:Ability
var shielding = false
var can_move = true
var has_spike = false
var can_dash = false
var can_duplicate = false
var direction = 0
var is_hurt = false
@onready var bullet_button = $"../../CanvasLayer/ActionButton/bullet"
@onready var ghost_effect:PackedScene = load("res://scenes/effect/ghost_sprite.tscn")
@onready var sprite_material = $Sprite2D.material
signal character_is_updated
@onready var cooldown_display = $"../../CanvasLayer/ActionButton/bullet/Label"
@onready var coyote_timer = $coyote_timer
@onready var jump_buffer = $jump_buffer

var is_jumping:bool = false

func _ready():
	update_character()
	health = character.current_health
	ability = character.ability

func update_character():
	sprite_2d.play(character.dex)
	health = character.current_health
	bullet_button.texture_normal = character.move_bullet.texture

func _physics_process(delta):
	# Add the gravity.
	if can_move:
		velocity.y += gravity * delta
		if is_jumping and velocity.y > 0:
			is_jumping = false
		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			sprite_2d.play(character.dex)
		else:
			if is_hurt:
				velocity.x = -attack_dir_by_enemy * SPEED * 2
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				sprite_2d.stop()
				sprite_2d.frame = 0
		var was_on_floor_or_ceiling = is_on_floor() or is_on_ceiling()
		move_and_slide()
		var just_left_ledge = was_on_floor_or_ceiling and \
		not (is_on_floor() or is_on_ceiling()) and !is_jumping
		if just_left_ledge:
			coyote_timer.start()
		if is_on_floor() and !jump_buffer.is_stopped():
			jump_buffer.stop()
			jump()
	elif !can_move and can_dash:
		dash()
	has_spike = false
	set_ability()
	update_character()
	cooldown_display.text = str(bullet_cooldown.time_left).pad_decimals(2)
	if bullet_cooldown.time_left == 0:
		cooldown_display.hide()
	else:
		cooldown_display.show()

func dash():
	if !$dash_sound.playing:
		$dash_sound.play()
	velocity.x = facing_dir * DASH_SPEED
	velocity.y = 0
	sprite_2d.play(character.dex)
	move_and_slide()
	var g = ghost_effect.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	$dash_sprite_holder.add_child(g)
	g.set_property(global_position,global_scale,sprite_2d.flip_h)


func _input(event):
	if !can_move:
		return false
	if event.is_action_pressed("ui_left") or direction == -1:
		sprite_2d.flip_h = true
		facing_dir = -1
	elif event.is_action_pressed("ui_right") or direction == 1:
		sprite_2d.flip_h = false
		facing_dir = 1
	if event.is_action_pressed("ui_accept"):
		create_bullet(facing_dir)
	if event.is_action_pressed("ui_up"):
		if is_on_floor() or !coyote_timer.is_stopped():
			jump()
			coyote_timer.stop()
		else:
			jump_buffer.start()

func jump():
	$jump.play()
	velocity.y = jump_velocity
	is_jumping = true

func create_bullet(new_facing_dir):
	var m = move.instantiate()
	get_parent().get_node("bulletholder").add_child(m)
	m.move = character.move_bullet
	m.global_position = global_position
	m.damage = character.move_bullet.damage * move_bullet_damage_modifier
	m.set_texture(character.move_bullet.texture)
	m.set_movement(new_facing_dir)

func hit(value=1):
	if !shielding and !can_dash:
		$hurt.play()
		is_hurt = true
		animation_player.play("hit")
		health -= value
		character.current_health -= value
		velocity.y = jump_velocity
		await get_tree().create_timer(0.2).timeout
		is_hurt = false
	if health < 1:
		get_tree().reload_current_scene()

func heal(value=1):
	if health < character.max_health:
		health += value
		character.current_health += value

func _on_character_change_screen_update_character(current_character):
	character = current_character
	update_character()
	emit_signal("character_is_updated")

func set_ability():
	$ability_manager.call_deferred(character.ability.id_name)
	if character.ability.id_name != "enrage":
		move_bullet_damage_modifier = 1

func set_spike():
	has_spike= true

func flip_gravity():
	gravity *= -1
	scale.y *= -1
	jump_velocity *= -1

func _on_hitbox_body_entered(body):
	hit()
	if body.global_position.x < global_position.x:
		attack_dir_by_enemy = -1
	else:
		attack_dir_by_enemy = 1
	if body is CharacterBody2D:
		if can_dash and !body.can_move:
			body.hit(5)
			sprite_material.set_shader_parameter("color_opacity",1)
			await get_tree().create_timer(0.3).timeout
			sprite_material.set_shader_parameter("color_opacity",0)
		elif has_spike or can_dash:
			body.hit()
			sprite_material.set_shader_parameter("color_opacity",1)
			await get_tree().create_timer(0.3).timeout
			sprite_material.set_shader_parameter("color_opacity",0)

func _on_hitbox_area_entered(area):
	hit()
	area.destroy()

func _on_left_pressed():
	direction = -1

func _on_right_pressed():
	direction = 1

func _on_left_released():
	direction = 0

func _on_right_released():
	direction = 0

var can_shoot = true
@onready var bullet_cooldown = $bullet_cooldown
signal shooted
func _on_bullet_pressed():
	if can_shoot:
		create_bullet(facing_dir)
		bullet_cooldown.wait_time = character.move_bullet.ammo_cooldown
		bullet_cooldown.start()
		can_shoot = false
		bullet_button.modulate = Color(0.322, 0.322, 0.322)
		emit_signal("shooted")

func _on_bullet_cooldown_timeout():
	can_shoot = true
	bullet_button.modulate = Color(1, 1, 1)

func _on_trophy_area_entered(area):
	get_tree().set_deferred("reload_current_scene",null)
