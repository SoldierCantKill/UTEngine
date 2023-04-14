extends Node
class_name BattleRoom

var enemies : Node2D

func _ready():
	var add_object : Callable = func(object : Node2D, object_position : Vector2 = Vector2.ZERO) -> Node:
		object.position = object_position
		add_child(object)
		return object
	vars.scene = self
	vars.hud_manager = add_object.call(load("uid://cdhye7ndiak02").instantiate())
	vars.player_heart = add_object.call(load("res://objects/battle/player_heart.tscn").instantiate())
	vars.scene_cam = add_object.call(load("res://objects/global/scene_cam.tscn").instantiate())
	vars.scene_cam.global_position = Vector2(320,240)
	enemies = add_object.call(Node2D.new(), Vector2(0,0))

	
