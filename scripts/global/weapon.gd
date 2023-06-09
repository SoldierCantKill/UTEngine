extends Item
class_name Weapon

var attack_eye = null
var attack : float = 0
var defense : float = 0

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = (use_text[1] if !vars.hud_manager.serious_mode else use_text[2])
		audio.play("menu/item")
		var temp = settings.player_save.player.weapon
		settings.player_save.player.weapon = settings.player_save.inventory[inventory_slot]
		settings.player_save.inventory[inventory_slot] = temp
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
