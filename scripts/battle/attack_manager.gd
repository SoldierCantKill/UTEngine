extends Node
class_name AttackManager

var current_attack : Attack = null
signal attack_done
@onready var masks = get_node("buffer/masks")

func set_writer_text():
	vars.main_writer.writer_text = "(disable:z)(sound:mono2)*(color=red) THIS(delay:.7)(sound:sans)(font:sans)(color:white)(size:24) is some real text."

func pre_attack():
	current_attack = Attack.new()
	current_attack.set_script(load("res://scripts/attacks/attack_example.gd"))
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())

func bullet(bullet_path : Variant, position : Vector2, masked = true) -> Bullet:
	var bullet = bullet_path.instantiate()
	bullet.show_behind_parent = masked
	bullet.global_position = position
	masks.add_child(bullet)
	return bullet
