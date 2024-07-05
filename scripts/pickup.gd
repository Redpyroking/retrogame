extends Area2D

@export var item_carry:Character
@onready var character_change_screen = $"../../../CanvasLayer/CharacterChangeScreen"

func _ready():
	$Sprite/Image.texture = item_carry.animation

func _on_area_entered(area):
	var character_box:Resource
	character_box = character_change_screen.character_inventory
	character_box.inventory.append(item_carry)
	character_change_screen.update()
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled",true)
	$gold_particle.emitting = true
	$taken_sound.play()

func _on_gold_particle_finished():
	queue_free()
