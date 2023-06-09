extends Resource
class_name PlayerSave

var player = {
	name = "rose",
	lv = 19,
	current_hp = 92,
	current_kr = 0,
	max_hp = 92,
	atk = 10,
	def = 10,
	weapon = "real_knife",
	armor = "heart_locket",
	}

var inventory : Array = [ #Don't erase indexes from this Array!!!!
	"butterscotch_pie",
	"snowman_piece",
	"butterscotch_pie",
	"snowman_piece",
	"snowman_piece",
	"butterscotch_pie",
	"snowman_piece",
	"butterscotch_pie",
	]

var data = {
	
	}

func get_weapon() -> Weapon:
	return ut_items.items[player.weapon]
	
func get_armor() -> Armor:
	return ut_items.items[player.weapon]

func get_item(index : int) -> Item:
	return ut_items.items[inventory[index]]
