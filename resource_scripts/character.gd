extends Resource

class_name Character

@export var id_name:String
@export var alias :String
@export var dex:String
@export_multiline var description:String
@export var ability:Ability
@export var animation:Texture
@export var max_health:int
@export var current_health:int
@export var move_bullet:Move

func full_heal():
	current_health = max_health
