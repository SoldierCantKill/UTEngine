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
var heals : Array
var type : e_type
var use_text : Array
var throw_away_text : String = "" : get = get_throw_away_text
#Not set in constructor. Use function setup_items() in item_list autoload.
#You need 3 values in each array EXCXEPT Description, [OVERWORLD, BATTLE, SERIOUS MODE] (use_text will use a 2D array)
#(No, this engine doesn't have OW by default)
func _init(names : Array, description : String, heals : Array, type : e_type, use_text : Array):
	self.names = names
	self.description = description
	self.heals = heals
	self.type = type
	self.use_text = use_text

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
	if(vars.scene is BattleRoom):
		var string = "(enable:z)(disable:x)" + (use_text[1] if !vars.hud_manager.serious_mode else use_text[2]) + "(pc)"
		print(string)
		vars.main_writer.writer_text = string
		print(vars.main_writer.writer_text)
		
		match(type):
			e_type.heal:
				audio.play("menu/heal")
				settings.player_save.inventory[inventory_slot] = ""
			e_type.weapon:
				audio.play("menu/item")
				var temp = settings.player_save.weapon
				settings.player_save.weapon = settings.player_save.inventory[inventory_slot]
				settings.player_save.inventory[inventory_slot] = temp
			e_type.armor:
				audio.play("menu/item")
				var temp = settings.player_save.armor
				settings.player_save.armor = settings.player_save.inventory[inventory_slot]
				settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
