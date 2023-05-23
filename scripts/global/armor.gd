extends Item
class_name Armor

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var string = "(enable:z)(disable:x)(sound:mono2)" + (use_text[1] if !vars.hud_manager.serious_mode else use_text[2]) + "(pc)"
		vars.main_writer.writer_text = string
		audio.play("menu/item")
		var temp = settings.player_save.weapon
		settings.player_save.weapon = settings.player_save.inventory[inventory_slot]
		settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
