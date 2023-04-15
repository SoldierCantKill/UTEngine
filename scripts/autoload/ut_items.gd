#PUT ALL EXISTING ITEMS IN YOUR GAME HERE

extends Node

@onready var items : Dictionary = {
	#HEAL ITEMS
	"butterscotch_pie" : Item.new(["Butterscotch Pie", "ButtsPie", "Pie"], ["* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie, one slice."] ,[99,99,99], Item.e_type.heal, [["* You ate the Pie.\n* Your HP was fully maxed out."],["* You ate the Pie.\n* Your HP was fully maxed out."],["* You ate the Pie.\n* Your HP was fully maxed out."]]),
	"snowman_piece" : Item.new(["Snowman Piece","SnowPiece","SnowPiece"], ["* \"Snowman Piece\" - Heals 45 HP\n* Please take this to the\n  ends of the earth."] ,[45,45,45], Item.e_type.heal, [["* You ate the Snowman Piece.\n" + str(hp_message(45))], ["* You ate the Snowman Piece.\n" + str(hp_message(45))], ["* You ate the Snowman Piece.\n" + str(hp_message(45))]]),
	}


func _ready():
	setup_items()

#In undertale the throwaway text is usally random and equip texts are the same 
#but for some items there are an exception.
func setup_items():
	pass

func hp_message(amount_gained : int) -> String:
	if(settings.player_save.player.current_hp >= settings.player_save.player.max_hp): 
		return "* Your HP was maxed out."
	return "* You recovered " + str(amount_gained) + " HP!"

func sort_inventory():
	while (true):
		var found1 = false
		for i in range(settings.player_save.inventory.size() - 1, 0, -1):
			if(settings.player_save.inventory[i] != "" && settings.player_save.inventory[i - 1] == ""):
				var temp = settings.player_save.inventory[i]
				settings.player_save.inventory[i] = settings.player_save.inventory[i-1]
				settings.player_save.inventory[i-1] = temp
				if i != settings.player_save.inventory.size() - 1:
					found1 = true
		if !found1:
			break
