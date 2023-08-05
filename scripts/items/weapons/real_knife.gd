extends Weapon
class_name RealKnife

func _init():
	names = ["Real Knife", "RealKnife", "RealKnife"]
	description = "* \"Real Knife\" - Weapon AT 99\n* Here we are"
	attack = 99
	attack_eye = load("res://objects/battle/attack_eye/true_knife_attack_eye.tscn")

func get_use_text() -> String:
	if(!vars.hud_manager.serious_mode):
		return "(enable:z)(enable:x)(sound:mono2)* About time.(pc)"
	else:
		return "(enable:z)(enable:x)(sound:mono2)* About time.(pc)"
