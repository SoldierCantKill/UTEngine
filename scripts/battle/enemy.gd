extends Node
class_name Enemy

enum e_dodge {
	none,
}

var enemy_name : String
var current_hp : int
var max_hp : int
var def : float
var dodge : e_dodge
var border_stick : bool = true
var offset : int = 0 #Offset for border stick

var show_health_bar : bool

signal done_being_attacked

var act_options = {
	}

func _init(enemy_name : String, hp : int, df : float):
	self.enemy_name = enemy_name
	self.current_hp = hp
	self.max_hp = hp
	self.def = def

func attack(damage : float):
	print("I WAS DAMAGED FOR ", damage)
	await get_tree().create_timer(1).timeout
	done_being_attacked.emit()
	vars.attack_manager.start_attack()
