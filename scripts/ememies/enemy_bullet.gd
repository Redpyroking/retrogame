extends Area2D

var speed = 40
var motion = Vector2.ZERO

func set_velocity(parent_velocity):
	motion = -parent_velocity.normalized()

func _physics_process(delta):
	position += motion *speed* delta

func _on_body_entered(body):
	if body is TileMap:
		destroy()

func destroy():
	$CollisionShape2D.set_deferred("disabled",true)
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished():
	queue_free()
	pass # Replace with function body.
