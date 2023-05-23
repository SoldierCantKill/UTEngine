extends Node
class_name AttackManager

var current_attack : Attack = null

func set_writer_text():
	vars.main_writer.writer_text = "(disable:z)(sound:mono2)*(color=red) THIS(delay:1) IS SOME REAL TEXT"

func start_attack():
	current_attack = Attack.new()
	current_attack.set_script(load("res://scripts/attacks/attack_example.gd"))
	add_child(current_attack)
	current_attack.pre_attack()
