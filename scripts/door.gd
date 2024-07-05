extends Area2D

const LEVEL_SELECTOR = preload("res://scenes/menu/level_selector.tscn")

func _on_area_entered(area):
	if area:
		Global.current_unlocked_level += 1
		await  get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/menu/level_selector.tscn")
