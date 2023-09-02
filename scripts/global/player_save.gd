extends Resource
class_name PlayerSave

@export var player = {
	name = "Chara",
	lv = 19,
	current_hp = 92,
	current_kr = 0,
	max_hp = 92,
	atk = 10,
	def = 10,
	exp = 50000,
	weapon = "real_knife",
	armor = "heart_locket",
	gold = 0,
	kills = 0,
	}

@export var inventory : Array = [ #Don't erase indexes from this Array!!!!
	"butterscotch_pie",
	"snowman_piece",
	"butterscotch_pie",
	"snowman_piece",
	"snowman_piece",
	"butterscotch_pie",
	"snowman_piece",
	"butterscotch_pie",
	]


#Data that saves when you save the game. Will be resetted if you reset.
@export var data = {
	genocide = false,
	player_room = 0,
	place_name = "--",
	animation = "down",
	position = Vector2(-380,20),
	time = 0.0,
	}

func get_weapon() -> Weapon:
	return ut_items.items[player.weapon]
	
func get_armor() -> Armor:
	return ut_items.items[player.armor]

func get_item(index : int) -> Item:
	return ut_items.items[inventory[index]]

func get_inventory_size() -> int:
	for i in len(inventory):
		if(inventory[i] == ""):
			return i
	return len(inventory)
