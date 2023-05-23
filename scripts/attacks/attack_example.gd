extends Node
class_name Attack


func pre_attack():
	vars.battle_box.set_box_size([244,254,399,394],500)
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(321, 324)
