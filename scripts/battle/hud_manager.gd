extends Node2D
class_name HudManager

var mode := 0
var button_index := 0
var enemy_index := 0
var item_index := 0
var last_item_index := 0 #Used for checking if you didn't attack the enemy or something
var item_page := 1

var show_kr_text := true
var serious_mode := true

var enemy_health_bars := []
var eye = null #Attack eye

@onready var display : Dictionary = {
	name_text = $display/name,
	lv_text = $display/lv,
	hp = $display/hp,
	kr = $display/kr,
	health_text = $display/health,
	max_health_bar = $display/hp_bar_max,
	current_health_bar = $display/hp_bar_max/hp_bar_current,
	karma_health_bar = $display/hp_bar_max/hp_bar_karma,
	outline_health_bar = $display/hp_bar_outline,
	buttons = $buttons.get_children(),
	item_texts = [],
	page_text = null,
	} 

func _ready():
	setup_hud()

func setup_hud():
	var create_text : Callable = func(position : Vector2):
		var textblock = RichTextLabel.new()
		textblock.add_theme_font_override("normal_font", load("res://assets/fonts/main_mono.ttf"))
		textblock.add_theme_font_size_override("normal_font_size", 31)
		textblock.set("theme_override_colors/font_shadow_color", Color(0.11,0.11,.39,1))
		textblock.set("theme_override_constants/shadow_offset_x", 1)
		textblock.set("theme_override_constants/shadow_offset_y", 1)
		textblock.set("theme_override_constants/shadow_outline_size", 5)
		textblock.position = position
		textblock.size = Vector2(100,100)
		textblock.z_index = 1
		textblock.clip_contents = false
		textblock.scroll_active = false
		textblock.autowrap_mode = TextServer.AUTOWRAP_OFF
		add_child(textblock)
		return textblock
	
	for row in range(3):
		for col in range(2):
			var i = row * 2 + col
			var location : Vector2 = Vector2(100 if col < 1 else 340, 271 + row * 31)
			var text : RichTextLabel = create_text.call(location)
			display.item_texts.append(text)
	display.page_text = create_text.call(Vector2(388,334))
	
	display_update()
	
	if(settings.player_save.player.max_hp < 92): #Display hud is formatted a little different when in sans battle.
		display.name_text.position = Vector2(30,400)
		display.lv_text.position = display.name_text.position + Vector2(len(display.name_text.get_parsed_text()) * 22.5,0)
		display.hp.position = display.lv_text.position + Vector2(107,5)
		display.max_health_bar.position = display.hp.position + Vector2(31, -5)
	else:
		display.name_text.position = Vector2(30,400)# 87.0 
		display.lv_text.position = display.name_text.position + Vector2((len(display.name_text.get_parsed_text()) * 14.25) + 30,0)
		display.hp.position = display.lv_text.position + Vector2(107,5)
		display.max_health_bar.position = display.hp.position + Vector2(31, -5)
	display.kr.visible = show_kr_text

func _process(delta):
	inputs()
	display_update()
	hud_mode_update()
	heart_update()

func display_update():
	display.name_text.text = settings.player_save.player.name
	display.lv_text.text = "LV " + str(settings.player_save.player.lv)
	display.health_text.text = str(settings.player_save.player.current_hp + settings.player_save.player.current_kr) + " / " + str(settings.player_save.player.max_hp)
	display.health_text.self_modulate = Color(1,.14,1,1) if(settings.player_save.player.current_kr > 0) else Color.WHITE
	display.max_health_bar.size = Vector2(settings.player_save.player.max_hp * 1.2,21)
	display.current_health_bar.size = Vector2(settings.player_save.player.current_hp * 1.2,21)
	display.karma_health_bar.size = Vector2((settings.player_save.player.current_hp + settings.player_save.player.current_kr) * 1.2,21)
	
	var bar = display.max_health_bar if(settings.player_save.player.max_hp >= settings.player_save.player.current_hp) else display.current_health_bar
	display.outline_health_bar.position = bar.position - Vector2(2,2)
	display.outline_health_bar.size = bar.size + Vector2(4,4)
	if(show_kr_text):
		display.kr.position = bar.position + Vector2(bar.size.x - 26,5) + Vector2(len(display.kr.get_parsed_text()) * 17.5,0)
	else:
		display.kr.position = bar.position + Vector2(bar.size.x - 26,5)
	display.health_text.position = display.kr.position + Vector2(len(display.kr.get_parsed_text()) * 20, -5)

func hud_mode_update():
	for i in display.item_texts:
		i.text = ""
	display.page_text.text = ""
	display.page_text.visible = false
	for i in enemy_health_bars:
		if(is_instance_valid(i)):
			i.queue_free()
	match(mode):
		-1:
			for i in display.buttons:
				i.frame = 0
		0:
			for i in range(display.buttons.size()):
				if i != button_index:
					display.buttons[i].frame = 0
				else:
					display.buttons[i].frame = 1
		1:
			for i in range(vars.enemies.get_children().size()):
				display.item_texts[i * 2].text = "* " + vars.enemies.get_child(i).enemy_name
				if(vars.enemies.get_child(i).show_health_bar):
					var bar_max : ColorRect = ColorRect.new()
					var bar : ColorRect = ColorRect.new()
					var bar_size := 101
					bar_max.color = Color.RED
					bar_max.size = Vector2(bar_size, 20)
					bar.color = Color(.1,1,.1,1)
					bar.size = Vector2((float(vars.enemies.get_child(i).current_hp) / vars.enemies.get_child(i).max_hp) * bar_size, 20)
					bar_max.add_child(bar)
					add_child(bar_max)
					bar_max.global_position = display.item_texts[i * 2].global_position + Vector2(187,8)
					bar_max.z_index = 1
					enemy_health_bars.append(bar_max)
				
		2:
			match(button_index):
				1:
					for i in range(vars.enemies.get_child(enemy_index).act_options.keys().size()):
						display.item_texts[i].text = "* " + vars.enemies.get_child(enemy_index).act_options.keys()[i]
				2:
					for i in range(4):
						if(settings.player_save.inventory[i + (item_page - 1) * 4] != ""):
							var item = ut_items.items[settings.player_save.inventory[i + (item_page - 1) * 4]]
							display.item_texts[i].text = "* " + item.names[1] if !serious_mode else "* " + item.names[2]
					if(settings.player_save.inventory[4] != ""):
						display.page_text.visible = true
						display.page_text.text = "PAGE " + str(item_page)
					else:
						display.page_text.visible = false
				3:
					display.item_texts[0].text = "* Spare"

func heart_update() -> void:
	match(mode):
		0:
			vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
		1:
			vars.player_heart.global_position = display.item_texts[enemy_index * 2].global_position + Vector2(-28, 17)
		2:
			vars.player_heart.global_position = display.item_texts[item_index].global_position + Vector2(-28, 17)

func inputs():
	match(mode):
		-1:
			return
		0:
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				button_index = wrapi(button_index + 1, 0, display.buttons.size())
			if (Input.is_action_just_pressed("left")):
				audio.play("menu/menu_move")
				button_index = wrapi(button_index - 1, 0, display.buttons.size())
			if (Input.is_action_just_pressed("confirm")):
				audio.play("menu/menu_select")
				if(button_index != 2):
					vars.main_writer.writer_text = ""
					enemy_index = 0
					mode = 1 if(button_index == 0 || button_index == 1) else 2
				else:
					if(settings.player_save.inventory[0] != ""):
						vars.main_writer.writer_text = ""
						enemy_index = 0
						mode = 1 if(button_index == 0 || button_index == 1) else 2
				item_index = 0
				item_page = 1
			return
				
	match(button_index):
		0:
			var enemy_array : Array = vars.enemies.get_children()
			if(Input.is_action_just_pressed("up")):
				if(enemy_array.size() > 1):
					audio.play("menu/menu_move")
				enemy_index = wrapi(enemy_index + 3,0,enemy_array.size())
			
			if(Input.is_action_just_pressed("down")):
				if(enemy_array.size() > 1):
					audio.play("menu/menu_move")
				enemy_index = wrapi(enemy_index - 3,0,enemy_array.size())
			if(Input.is_action_just_pressed("confirm")):
				fight()
			if(Input.is_action_just_pressed("exit")):
				reset()
		1:
			match(mode):
				1:
					var enemy_array : Array = vars.enemies.get_children()
					if(Input.is_action_just_pressed("up")):
						if(enemy_array.size() > 1):
							audio.play("menu/menu_move")
						enemy_index = wrapi(enemy_index + 3,0,enemy_array.size())
					
					if(Input.is_action_just_pressed("down")):
						if(enemy_array.size() > 1):
							audio.play("menu/menu_move")
						enemy_index = wrapi(enemy_index - 3,0,enemy_array.size())
					if(Input.is_action_just_pressed("confirm")):
						audio.play("menu/menu_select")
						mode = 2
					if(Input.is_action_just_pressed("exit")):
						reset()
				2:
					var last_string_index = func() -> int:
						for i in range(display.item_texts.size()):
							if(display.item_texts[i].text == ""):
								return i
						return display.item_texts.size()
					if(Input.is_action_just_pressed("right")):
						audio.play("menu/menu_move")
						if((item_index + 1) % 2 != 0):
							if(item_index + 1 < last_string_index.call()):
								item_index += 1
						else:
							item_index -= 1
					if(Input.is_action_just_pressed("left")):
						audio.play("menu/menu_move")
						if((item_index + 1) % 2 == 0):
							if(item_index - 1 < last_string_index.call()):
								item_index -= 1
						elif(item_index + 1 < last_string_index.call()):
							item_index += 1
					if(Input.is_action_just_pressed("up")):
						audio.play("menu/menu_move")
						if(item_index - 2 < 0):
							if(5 - (item_index + 1) % 2 < last_string_index.call()):
								item_index = 5 - (item_index + 1) % 2
						else:
							item_index -= 2
					if(Input.is_action_just_pressed("down")):
						audio.play("menu/menu_move")
						if(item_index + 2 >= last_string_index.call()):
							item_index = -1 - (item_index + 1) % 2
						item_index += 2
					if(Input.is_action_just_pressed("confirm")):
						check()
					if(Input.is_action_just_pressed("exit")):
						mode = 1
		2:
			var new_x : int = 0
			var last_string_index = func() -> int:
				for i in range(display.item_texts.size()):
					if(display.item_texts[i].text == ""):
						return i
				return display.item_texts.size() - 1
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				if((item_index + 1) % 2 != 0):
					if(item_index + 1 < last_string_index.call()):
						item_index += 1
				else:
					if(settings.player_save.inventory[4] != "" && item_page == 1):
						item_index -= 1
						item_page = 2
						if(settings.player_save.inventory[6] == "" && item_index == 2):
							item_index = 0
					else:
						item_index -= 1
			if(Input.is_action_just_pressed("left")):
				audio.play("menu/menu_move")
				if((item_index + 1) % 2 == 0):
					if(item_index - 1 < last_string_index.call()):
						item_index -= 1
				else:
					if(settings.player_save.inventory[4] != "" && item_page == 2):
						item_index += 1
						item_page = 1
					else:
						if(item_index + 1 < last_string_index.call()):
							item_index += 1
							
			if(Input.is_action_just_pressed("up")):
				audio.play("menu/menu_move")
				if(item_index - 2 < 0):
					if(3 - (item_index + 1) % 2 < last_string_index.call()):
						item_index = 3 - (item_index + 1) % 2
				else:
					item_index -= 2
			if(Input.is_action_just_pressed("down")):
				audio.play("menu/menu_move")
				if(item_index + 2 >= last_string_index.call()):
					item_index = -1 - (item_index + 1) % 2
				item_index += 2
					
			if(Input.is_action_just_pressed("confirm")):
				use()
			if(Input.is_action_just_pressed("exit")):
				reset()
		3:
			if(Input.is_action_just_pressed("confirm")):
				mercy()
				
			if(Input.is_action_just_pressed("exit")):
				reset()

func reset():
	vars.player_heart.heart_mode = 0
	vars.player_heart.visible = false
	vars.player_heart.sprite.rotation = 0
	mode = -1
	item_index = 0
	vars.battle_box.reset_box_size()
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false
	if vars.battle_box.margin != vars.battle_box.target:
		await vars.battle_box.resize_finished
	await get_tree().process_frame
	mode = 0
	vars.player_heart.visible = true
	vars.attack_manager.set_writer_text()

func disable():
	mode = -1
	last_item_index = item_index
	item_index = 0
	vars.player_heart.visible = false
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false

# ACTIONS WHEN PRESSING CONFIRM
# ... So you can override them.

func fight():
	audio.play("menu/menu_select")
	disable()
	eye = ut_items.items[settings.player_save.player.weapon].attack_eye.instantiate()
	eye.enemy = vars.enemies.get_child(enemy_index)
	add_child(eye)

func check():
	audio.play("menu/menu_select")
	vars.enemies.get_child(enemy_index).act_options.values()[item_index].call()

func use():
	audio.play("menu/menu_select")
	var item = settings.player_save.get_item(item_index + (item_page - 1) * 4)
	disable()
	item.use(item_index + (item_page - 1) * 4)
	await item.done
	vars.attack_manager.pre_heal_attack().start_attack()

func mercy():
	audio.play("menu/menu_select")
	disable()
	vars.attack_manager.pre_heal_attack().start_attack()
