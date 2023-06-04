#PUT ALL EXISTING ITEMS IN YOUR GAME HERE
extends Node

@onready var items : Dictionary = {
	#HEAL ITEMS
	"butterscotch_pie" : Pie.new(),
	"snowman_piece" : SnowmanPiece.new(),
	}

@onready var weapons : Dictionary = {
	"real_knife" : RealKnife.new()
}

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
