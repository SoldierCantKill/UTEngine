extends Item
class_name Healable

var heals : Array

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = (use_text[1] if !vars.hud_manager.serious_mode else use_text[2])
		audio.play("menu/heal")
		settings.player_save.inventory[inventory_slot] = ""
		var amount_amount = heals[1] if !vars.hud_manager.serious_mode else heals[2]
		settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_amount - settings.player_save.player.current_kr, settings.player_save.player.max_hp  - settings.player_save.player.current_kr)
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
