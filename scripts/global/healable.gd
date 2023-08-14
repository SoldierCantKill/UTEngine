extends Item
class_name Healable

var heals : Array

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/heal")
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[1] if !vars.hud_manager.serious_mode else heals[2]
		set_hp(amount_gained)
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/heal")
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[0]
		set_hp(amount_gained)
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

func set_hp(amount_gained : int):
	if(settings.player_save.player.current_hp > settings.player_save.player.max_hp): return
	if(settings.player_save.player.current_hp + settings.player_save.player.current_kr > settings.player_save.player.max_hp):
		settings.player_save.player.current_kr = 0
		return
	settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp) - settings.player_save.player.current_kr
