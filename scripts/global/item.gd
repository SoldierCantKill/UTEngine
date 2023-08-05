extends Node
class_name Item

signal done

enum e_type {
	heal,
	weapon,
	armor,
	}

var names : Array
var description : String
var type : e_type
var throw_away_text : String = "" : get = get_throw_away_text
#You need 3 values in some arrays (See default items)
#(No, this engine doesn't have OW by default)

func _ready():
	pass

func get_throw_away_text() -> String:
	if(throw_away_text.is_empty()):
		var rng : RandomNumberGenerator = RandomNumberGenerator.new()
		var chance : int = rng.randi_range(0,35)
		if(chance < 29):
			return "* The " +  names[0] + " was thrown away."
		else:
			var throw_away_texts = ["* You bid a quiet farewell to the " + names[0] + ".", "* You put the " + names[0] + " on the ground and gave it a little pat.", "* You threw the " + names[0] + " on the ground like the piece of trash it is.", "* You abandoned the " + names[0] + "."]
			return throw_away_texts.pick_random()
	else:
		return throw_away_text

func use(inventory_slot : int):
	pass

func get_use_text() -> String:
	return ""

func hp_message(amount_gained : int) -> String:
	if(settings.player_save.player.current_hp >= settings.player_save.player.max_hp): 
		return "* Your HP was maxed out."
	return "* You recovered " + str(amount_gained) + " HP!"
