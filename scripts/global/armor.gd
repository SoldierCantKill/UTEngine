extends Item
class_name Armor

var attack : float = 0
var defense : float = 0

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/item")
		var temp = settings.player_save.player.armor
		settings.player_save.player.armor = settings.player_save.inventory[inventory_slot]
		settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
