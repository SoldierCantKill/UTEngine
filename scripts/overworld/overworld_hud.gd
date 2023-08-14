extends Node2D
class_name OverworldHud

@onready var player_save : PlayerSave = settings.player_save

var mode := -1 :
	set(value):
		refresh_hud()
		mode = value
	
var selection_index := 0
var item_index := 0
var choice_index := 0

@onready var choices = {
	$selection_border/item : $item,
	$selection_border/stat : $stat,
	}
@onready var item_texts = [$item/item_border/item_0, $item/item_border/item_1, $item/item_border/item_2, $item/item_border/item_3, $item/item_border/item_4, $item/item_border/item_5, $item/item_border/item_6, $item/item_border/item_7]
@onready var item_choices = {
	$item/item_border/use : use,
	$item/item_border/info : info,
	$item/item_border/drop : drop
}

@onready var heart = $heart


func close():
	vars.player_character.input_enabled = true
	mode = -1
	for i in choices.values():
		i.visible = false
	visible = false

func open():
	mode = 0
	selection_index = 0
	item_index = 0
	choice_index = 0
	heart.visible = true
	vars.player_character.input_enabled = false
	audio.play("menu/menu_move")
	visible = true
	refresh_hud()

func _process(delta):
	inputs()
	if(visible):
		update_heart_position()

func inputs():
	match(mode):
		-1:
			if(Input.is_action_just_pressed("hud_toggle") && vars.player_character.input_enabled):
				vars.overworld_hud.open()
		0:
			if(Input.is_action_just_pressed("confirm")):
				if(!(selection_index == 0 && player_save.get_inventory_size() == 0)):
					audio.play("menu/menu_select")
					mode = 1
					choices.values()[selection_index].visible = true
			if(Input.is_action_just_pressed("up")):
				audio.play("menu/menu_move")
				selection_index = wrapi(selection_index - 1,0,len(choices.keys()))
			if(Input.is_action_just_pressed("down")):
				audio.play("menu/menu_move")
				selection_index = wrapi(selection_index + 1,0,len(choices.keys()))
			if(Input.is_action_just_pressed("exit") || Input.is_action_just_pressed("hud_toggle")):
				await get_tree().process_frame
				close()
		1:
			if(selection_index == 0):
				if(Input.is_action_just_pressed("up")):
					audio.play("menu/menu_move")
					item_index = wrapi(item_index - 1,0,player_save.get_inventory_size())
				if(Input.is_action_just_pressed("down")):
					audio.play("menu/menu_move")
					item_index = wrapi(item_index + 1,0,player_save.get_inventory_size())
				if(Input.is_action_just_pressed("confirm")):
					audio.play("menu/menu_select")
					mode = 2
			if(Input.is_action_just_pressed("exit")):
				mode = 0
				for i in choices.values():
					i.visible = false
				item_index = 0
				choice_index = 0
		2:
			if(selection_index == 0):
				if(Input.is_action_just_pressed("left")):
					audio.play("menu/menu_move")
					choice_index = wrapi(choice_index - 1,0,3)
				if(Input.is_action_just_pressed("right")):
					audio.play("menu/menu_move")
					choice_index = wrapi(choice_index + 1,0,3)
				if(Input.is_action_just_pressed("confirm")):
					item_choices.values()[choice_index].call()
				if(Input.is_action_just_pressed("exit")):
					mode = 1
					choice_index = 0

func update_heart_position():
	heart.visible = true
	match(mode):
		0:
			heart.global_position = choices.keys()[selection_index].global_position + Vector2(-28,8)
		1:
			match(selection_index):
				0:
					heart.global_position = item_texts[item_index].global_position + Vector2(-24,8)
				1:
					heart.visible = false
		2:
			match(selection_index):
				0:
					heart.global_position = item_choices.keys()[choice_index].global_position + Vector2(-24,7)
		3:
			heart.visible = false

func refresh_hud():
	if(is_instance_valid(vars.player_character)):
		if(vars.player_character.get_position_on_screen().y >= 240):
			$short_stat_border.position = Vector2(32,322)
		else:
			$short_stat_border.position = Vector2(32,52)
	var new_line_str = func(array : Array) -> String:
		var string := ""
		for i in array:
			string += str(i) + "\n"
		return string
	
	#SELECTION
	if(player_save.get_inventory_size() == 0):
		get_node("selection_border/item").self_modulate.a = .5
	
	#SHORT STAT
	get_node("short_stat_border/name").text = player_save.player.name
	get_node("short_stat_border/short_names").text = new_line_str.call(["lv","hp","g"])
	get_node("short_stat_border/short_values").text = new_line_str.call([player_save.player.lv,str(player_save.player.current_hp) + "/" + str(player_save.player.max_hp),player_save.player.gold])
	
	#ITEM
	for i in item_texts:
		i.text = ""
	
	for i in player_save.get_inventory_size():
		item_texts[i].text = player_save.get_item(i).names[0]
	
	#STAT
	get_node("stat/stat_border/name").text = "\"%s\"" %[player_save.player.name]
	get_node("stat/stat_border/lv").text = "LV  %d" %[player_save.player.lv]
	get_node("stat/stat_border/hp").text = "HP  %d / %s" %[(player_save.player.current_hp + player_save.player.current_kr),player_save.player.max_hp]
	get_node("stat/stat_border/at").text = "AT  %d (%d)" %[(player_save.player.atk - 10),player_save.get_weapon().attack]
	get_node("stat/stat_border/df").text = "DF  %d (%d)" %[(player_save.player.def - 10),player_save.get_armor().defense]
	get_node("stat/stat_border/exp").text = "EXP: %d" %[player_save.player.exp]
	get_node("stat/stat_border/next").text = "NEXT: %d" %[(functions.exp_for_lv(player_save.player.lv) - player_save.player.exp)]
	get_node("stat/stat_border/weapon").text = "WEAPON: %s" %[player_save.get_weapon().names[0]]
	get_node("stat/stat_border/armor").text = "ARMOR: %s" %[player_save.get_armor().names[0]]
	get_node("stat/stat_border/gold").text = "GOLD: %d" %[player_save.player.gold]
	get_node("stat/stat_border/kills").visible = player_save.data.genocide
	get_node("stat/stat_border/kills").text = "KILLS: %d" %[player_save.player.kills]

func use():
	mode = 3
	for i in choices.values():
		i.visible = false
	audio.play("menu/menu_select")
	var item = settings.player_save.get_item(item_index)
	item.use(item_index)
	await item.done
	close()

func info():
	mode = 3
	for i in choices.values():
		i.visible = false
	audio.play("menu/menu_select")
	var item = settings.player_save.get_item(item_index)
	item.info(item_index)
	await item.done
	close()

func drop():
	mode = 3
	for i in choices.values():
		i.visible = false
	audio.play("menu/menu_select")
	var item = settings.player_save.get_item(item_index)
	item.drop(item_index)
	await item.done
	close()
