extends Item
class_name Armor

var defense : float = 1

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = (use_text[1] if !vars.hud_manager.serious_mode else use_text[2])
		audio.play("menu/item")
		var temp = settings.player_save.player.armor
		settings.player_save.player.armor = settings.player_save.inventory[inventory_slot]
		settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
