extends Resource

class_name Item

@export var id_name:String
@export var alias :String
@export var dex:String
@export_multiline var description:String
@export var ability:String
enum ITEM_RARITY {Common,Rare,Epic,Legendary}
@export var rarity = ITEM_RARITY.Common
@export var texture:Texture

