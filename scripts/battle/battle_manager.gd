extends Node
class_name BattleRoom

var heart : Heart = null
var hud_manager : HudManager = null

func _ready():
	settings.scene = self
	hud_manager = add_object(load("uid://cdhye7ndiak02"))
	add_child(hud_manager)
	heart = add_object(load("res://objects/battle/heart.tscn"))
	add_child(heart)

func add_object(object : Variant, object_position : Vector2 = Vector2.ZERO) -> Node:
	var obj = object.instantiate()
	obj.position = object_position
	return obj
	
