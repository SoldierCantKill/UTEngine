extends Node
class_name Item

signal done

enum e_type {
	heal,
	weapon,
	armor,
	}

#@onready var main_writer = vars.main_writer
var names : Array = [] #You need 3 values in this arrays (See default items)
var throw_away_text : String = "" : get = get_throw_away_text

func _ready():
	pass

func use(inventory_slot : int):
	pass

func info(inventory_slot : int):
	pass

func drop(inventory_slot : int):
	pass

func get_use_text() -> String:
	return ""

func get_info_text() -> String:
	return ""

func get_throw_away_text() -> String:
	if(throw_away_text.is_empty()):
		var rng : RandomNumberGenerator = RandomNumberGenerator.new()
		var chance : int = rng.randi_range(29,35)
		if(chance < 29):
			return "(enable:z)(enable:x)(sound:mono2)* The " +  names[0] + " was thrown\n  away.(pc)"
		else:
			var throw_away_texts = ["(enable:z)(enable:x)(sound:mono2)* You bid a quiet farewell to the\n  " + names[0] + ".(pc)", "(enable:z)(enable:x)(sound:mono2)* You put the " + names[0] + "\n  on the ground and gave\n  it a little pat.(pc)", "(enable:z)(enable:x)(sound:mono2)* You threw the " + names[0] + "\n  on the ground like the\n  piece of trash it is.(pc)", "(enable:z)(enable:x)(sound:mono2)* You abandoned the " + names[0] + ".(pc)"]
			return throw_away_texts.pick_random()
	else:
		return throw_away_text

func hp_message(amount_gained : int) -> String:
	if(settings.player_save.player.current_hp >= settings.player_save.player.max_hp): 
		return "* Your HP was maxed out."
	return "* You recovered " + str(amount_gained) + " HP!"
