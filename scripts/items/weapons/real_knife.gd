extends Weapon
class_name RealKnife

func _init():
	names = ["Real Knife", "RealKnife", "RealKnife"]
	description = "* \"Real Knife\" - Weapon AT 99\n* Here we are"
	attack = 99
	use_text = ["(enable:z)(enable:x)(sound:mono2)* About time.(pc)","(enable:z)(enable:x)(sound:mono2)* About time.(pc)","(enable:z)(enable:x)(sound:mono2)* About time.(pc)"]
	attack_eye = load("res://objects/battle/attack_eye/true_knife_attack_eye.tscn")
