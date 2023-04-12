extends Node
class_name BattleRoom

var hud_manager : HudManager = null

func _ready():
	hud_manager = load("uid://cdhye7ndiak02").instantiate()
	add_child(hud_manager)
