extends Node
class_name Item

enum e_type {
	heal,
	weapon,
	armor,
	}

var names : Array
var description : Array
var heals : Array
var type : e_type
var use_text : Array
var throw_away_text : Array = [] : get = get_throw_away_text
#Not set in constructor. Use function setup_items() in item_list autoload.
#You need 3 values in each array EXCXEPT Description, [OVERWORLD, BATTLE, SERIOUS MODE] (use_text will use a 2D array)
func _init(names : Array, description : Array, heals : Array, type : e_type, use_text : Array):
	self.names = names
	self.description = description
	self.heals = heals
	self.type = type
	self.use_text = use_text

func get_throw_away_text() -> Array:
	if(throw_away_text.is_empty()):
		var rng : RandomNumberGenerator = RandomNumberGenerator.new()
		var chance : int = rng.randi_range(0,35)
		if(chance < 29):
			return ["The " +  names[0] + " was thrown away."]
		else:
			var throw_away_texts = [["You bid a quiet farewell to the " + names[0] + "."], ["You put the " + names[0] + " on the ground and gave it a little pat."], ["You threw the " + names[0] + " on the ground like the piece of trash it is."], ["You abandoned the " + names[0] + "."]]
			return throw_away_texts.pick_random()
	else:
		return throw_away_text
