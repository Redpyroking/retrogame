extends Area2D

var speed:int
var velocity = Vector2(1,0)
var direction = 1
var damage:int
var can_burn = false
var can_freeze = false
var can_steal = false
var can_pierce = false
@export var move:Move
var is_one = false
# Called when the node enters the scene tree for the first time.
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var explosion = $explosion

func _ready():
	randomize()

func set_movement(dir):
	$fire_sound.play()
	direction = dir
	animation_player.play("create")
	explosion.flip_h = bool(dir+1)
	speed = move.speed

func set_texture(texture:Texture):
	$Sprite2D.texture = texture
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += velocity * direction * speed * delta
	if move.additional_function != "":
		$ability_manager.call_deferred(move.additional_function)
	else:
		$ability_manager.call_deferred("set_empty")
	$Sprite2D.global_rotation += 10 * delta
	if $Sprite2D.global_rotation > 360:
		$Sprite2D.global_rotation = 0

func _on_body_entered(body):
	if !body is TileMap:
		body.hit(damage)
		if can_burn:
			body.burn()
		elif can_freeze:
			if randi() % 9 == 0:
				body.freeze()
		elif can_steal:
			get_parent().get_parent().find_child("player").heal()
		if !can_pierce:
			destroy()
		else:
			can_pierce = false
	else:
		destroy()

func destroy():
	$explosion_sound.play()
	speed = 0
	sprite_2d.material.set_shader_parameter("color_opacity",1)
	sprite_2d.material.set_shader_parameter("main_color",Color(1,1,1))
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled",true)
	sprite_2d.hide()
	explosion.show()
	explosion.play("explosion")

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_timer_timeout():
	destroy()
