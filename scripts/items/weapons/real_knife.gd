extends Weapon
class_name RealKnife

func _init():
	names = ["Real Knife", "RealKnife", "RealKnife"]
	attack = 99
	attack_eye = load("res://objects/battle/attack_eye/true_knife_attack_eye.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* About time.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* About time.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Real Knife\" - Weapon AT 99\n* Here we are(pc)"
