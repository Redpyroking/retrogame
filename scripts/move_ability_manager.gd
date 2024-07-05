extends Node

@onready var move:PackedScene = load("res://scenes/move.tscn")
@onready var parent = get_parent()

func burn():
	set_empty()
	get_parent().can_burn = true

func freeze():
	set_empty()
	get_parent().can_freeze = true

func steal():
	set_empty()
	get_parent().can_steal = true

func dupli():
	set_empty()
	get_parent().get_parent()\
	.get_parent().\
	find_child("player").\
	can_duplicate = true

var once_pierce = true
func pierce():
	if once_pierce:
		set_empty()
		get_parent().can_pierce = true
		once_pierce = false

func set_empty():
	get_parent().can_burn = false
	get_parent().can_freeze = false
	get_parent().can_steal = false
	get_parent().can_pierce = false
	get_parent().get_parent()\
	.get_parent().\
	find_child("player").\
	can_duplicate = false
