extends Node
class_name BattleRoom

var heart : Heart = null
var hud_manager : HudManager = null
var camera : Camera2D = null

func _ready():
	settings.scene = self
	hud_manager = add_object(load("uid://cdhye7ndiak02"))
	heart = add_object(load("res://objects/battle/heart.tscn"))
	camera = add_object(load("res://objects/global/scene_cam.tscn"))
	camera.position = Vector2(320,240)

func add_object(object : Variant, object_position : Vector2 = Vector2.ZERO) -> Node:
	var obj = object.instantiate()
	obj.position = object_position
	add_child(obj)
	return obj
	
