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
	elif(vars.scene is OverworldRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/item")
		var temp = settings.player_save.player.armor
		settings.player_save.player.armor = settings.player_save.inventory[inventory_slot]
		settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()

func info(inventory_slot : int):
	vars.main_writer.writer_text = get_info_text()
	await vars.main_writer.done
	done.emit()

func drop(inventory_slot : int):
	vars.main_writer.writer_text = get_throw_away_text()
	settings.player_save.inventory[inventory_slot] = ""
	await vars.main_writer.done
	ut_items.sort_inventory()
	done.emit()
