extends Node2D

func _ready():
	for i in get_children():
		if i is TouchScreenButton and i.has_method("check_level"):
			i.connect("pressed",change_level.bind(i.name))
	check_all_levels()

func change_level(lv_name):
	if FileAccess.file_exists("res://scenes/levels/"+ lv_name +".tscn"):
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/levels/"+ lv_name +".tscn")

func check_all_levels():
	for i in get_children():
		if i.has_method("check_level"):
			i.check_level()

func _on_home_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
