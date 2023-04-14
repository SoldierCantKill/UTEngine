#PUT ALL EXISTING ITEMS IN YOUR GAME HERE

extends Node

@onready var items : Dictionary = {
	#HEAL ITEMS
	"butterscotch_pie" : Item.new(["Butterscotch Pie", "ButtsPie", "Pie"], ["* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie, one slice."] ,[99,99,99], Item.e_type.heal, [["* You ate the Pie.\n* Your HP was fully maxed out."],["* You ate the Pie.\n* Your HP was fully maxed out."],["* You ate the Pie.\n* Your HP was fully maxed out."]]),
	"snowman_piece" : Item.new(["Snowman Piece","SnowPiece","SnowPiece"], ["* \"Snowman Piece\" - Heals 45 HP\n* Please take this to the\n  ends of the earth."] ,[45,45,45], Item.e_type.heal, [["* You ate the SnowPiece.\n" + str(HpMessage(45))], ["* You ate the SnowPiece.\n" + str(HpMessage(45))], ["* You ate the SnowPiece.\n" + str(HpMessage(45))]]),
	}


func _ready():
	setup_items()

#In undertale the throwaway text is usally random and equip texts are the same 
#but for some items there are an exception.
func setup_items():
	pass

func HpMessage(amount_gained : int) -> String:
	if(settings.player_save.player.current_hp >= settings.player_save.player.max_hp): 
		return "* Your HP was maxed out."
	return "* You recovered " + str(amount_gained) + " HP!"
