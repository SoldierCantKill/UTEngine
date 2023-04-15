extends Node
class_name BattleRoom

var enemies : Node2D

func _ready():
	var add_object : Callable = func(object, object_position : Vector2 = Vector2.ZERO) -> Node:
		object.position = object_position
		add_child(object)
		return object
	vars.scene = self
	vars.hud_manager = add_object.call(load("res://objects/battle/hud_manager.tscn").instantiate())
	vars.battle_box = add_object.call(load("res://objects/battle/battle_box.tscn").instantiate(),Vector2(34,254))
	vars.battle_box.name = "battle_box"
	var writer : RichTextLabel = RichTextLabel.new()
	add_child(writer)
	writer.set_script(load("res://scripts/global/writer.gd"))
	writer.scroll_active = false
	writer.autowrap_mode = TextServer.AUTOWRAP_OFF
	writer.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	writer.clip_contents = false
	writer.name = "battle_writer"
	enemies = add_object.call(Node2D.new(), Vector2(0,0))
	enemies.name = "enemies"
	vars.player_heart = add_object.call(load("res://objects/battle/player_heart.tscn").instantiate())
	vars.scene_cam = add_object.call(load("res://objects/global/scene_cam.tscn").instantiate(), Vector2(320,240))
