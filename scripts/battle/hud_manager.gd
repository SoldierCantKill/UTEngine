extends Node
class_name HudManager

var mode : int = 0
var button_index : int = 0
var enemy_index : int = 0
var item_index : int = 0
var item_page : int = 1

var show_kr_text : bool = true #only 
var serious_mode : bool = true

@onready var display : Dictionary = {
	name_text = $display/name,
	lv_text = $display/lv,
	hp = $display/hp,
	kr = $display/kr,
	health_text = $display/health,
	max_health_bar = $display/hp_bar_max,
	current_health_bar = $display/hp_bar_current,
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
			var location : Vector2 = Vector2(102 if col < 1 else 342, 274 + row * 31)
			var text : RichTextLabel = create_text.call(location)
			display.item_texts.append(text)
#			text.text = "* Pie"
	display.page_text = create_text.call(Vector2(391,338))
	
	display_update()
	
	if(settings.player_save.player.max_hp < 92): #Display hud is formatted a little different when in sans battle.
		display.name_text.position = Vector2(30,400)
		display.lv_text.position = display.name_text.position + Vector2(display.name_text.get_parsed_text().length() * 22.5,0)
		display.hp.position = display.lv_text.position + Vector2(124,5)
		display.max_health_bar.position = display.hp.position + Vector2(31, -5)
		display.current_health_bar.position = display.hp.position + Vector2(31, -5)
		if(show_kr_text):
			display.kr.position = display.max_health_bar.position + Vector2(display.max_health_bar.size.x + 9,5)
			display.kr.visible = true
		else:
			display.kr.position = display.max_health_bar.position + Vector2(display.max_health_bar.size.x - 26,5)
			display.kr.visible = false
		display.health_text.position = display.kr.position + Vector2(40, -5)
	else:
		display.name_text.position = Vector2(30,400)
		display.lv_text.position = display.name_text.position + Vector2(display.name_text.get_parsed_text().length() * 21.75,0)
		display.hp.position = display.lv_text.position + Vector2(107,5)
		display.max_health_bar.position = display.hp.position + Vector2(31, -5)
		display.current_health_bar.position = display.hp.position + Vector2(31, -5)
		if(show_kr_text):
			display.kr.position = display.max_health_bar.position + Vector2(display.max_health_bar.size.x + 9,5)
			display.kr.visible = true
		else:
			display.kr.position = display.max_health_bar.position + Vector2(display.max_health_bar.size.x - 26,5)
			display.kr.visible = false
		display.health_text.position = display.kr.position + Vector2(40, -5)

func _process(delta):
	inputs()
	display_update()
	hud_mode_update()
	heart_update()

func display_update():
	display.name_text.text = settings.player_save.player.name
	display.lv_text.text = "LV " + str(settings.player_save.player.lv)
	display.health_text.text = str(settings.player_save.player.current_hp) + " / " + str(settings.player_save.player.max_hp)
	display.max_health_bar.size = Vector2(settings.player_save.player.max_hp * 1.2,21)
	display.current_health_bar.size = Vector2(settings.player_save.player.max_hp * 1.2,21)
	display.outline_health_bar.position = display.max_health_bar.position - Vector2(2,2)
	display.outline_health_bar.size = display.max_health_bar.size + Vector2(4,4)
	
func hud_mode_update():
	for i in display.item_texts:
		i.text = ""
	display.page_text.text = ""
	display.page_text.visible = false
	match(mode):
		0:
			for i in range(display.buttons.size()):
				if i != button_index:
					display.buttons[i].frame = 0
				else:
					display.buttons[i].frame = 1
		1:
			for i in range(vars.enemies.get_children().size()):
				display.item_texts[i * 2].text = "* " + vars.enemies.get_child(i).enemy_name
		2:
			match(button_index):
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

func heart_update() -> void:
	match(mode):
		0:
			vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
		1:
			vars.player_heart.global_position = display.item_texts[enemy_index * 2].global_position + Vector2(-28, 17)
		2:
			if(button_index != 3):
				vars.player_heart.global_position = display.item_texts[item_index].global_position + Vector2(-28, 17)
			else:
				vars.player_heart.global_position = display.item_texts[item_index * 2].global_position + Vector2(-28, 17)

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
					vars.main_writer.clear_text()
					mode = 1 if(button_index == 0 || button_index == 1) else 2
				else:
					if(settings.player_save.inventory[0] != ""):
						vars.main_writer.clear_text()
						mode = 1 if(button_index == 0 || button_index == 1) else 2
				item_index = 0
				item_page = 1
			return
				
	match(button_index):
		0:
			if(Input.is_action_just_pressed("exit")):
						reset()
		1:
			match(mode):
				1:
					var enemy_array : Array = vars.enemies.get_children()
					var last_string_index : Callable = func() -> int:
						for i in range(3):
							if(display.item_texts[i*2].text == ""):
								return i
						return display.item_texts.size() - 1
					if(Input.is_action_just_pressed("up")):
						audio.play("menu/menu_move")
						enemy_index = wrapi(enemy_index + 2,0,enemy_array.size())
					
					if(Input.is_action_just_pressed("down")):
						audio.play("menu/menu_move")
						enemy_index = wrapi(enemy_index - 2,0,enemy_array.size())
					if(Input.is_action_just_pressed("confirm")):
						reset()
					if(Input.is_action_just_pressed("exit")):
						reset()
					print(enemy_index)
		2:
			var new_x : int = 0
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				if((item_index + 1) % 2 != 0):
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
					item_index -= 1
				else:
					if(settings.player_save.inventory[4] != "" && item_page == 2):
						item_index += 1
						item_page = 1
					else:
						item_index += 1
			
			var last_string_index = func() -> int:
				for i in range(display.item_texts.size()):
					if(display.item_texts[i].text == ""):
						return i
				return display.item_texts.size() - 1
			
			if(Input.is_action_just_pressed("up")):
				audio.play("menu/menu_move")
				if(item_index - 2 < 0):
					item_index = last_string_index.call() + 1 - (item_index + 1) % 2
				item_index -= 2
			
			if(Input.is_action_just_pressed("down")):
				audio.play("menu/menu_move")
				if(item_index + 2 >= last_string_index.call()):
					item_index = -1 - (item_index + 1) % 2
				item_index += 2
			if(Input.is_action_just_pressed("confirm")):
				audio.play("menu/menu_select")
				eat()
			if(Input.is_action_just_pressed("exit")):
				reset()
		3:
			if(Input.is_action_just_pressed("exit")):
				reset()

func reset():
	vars.player_heart.heart_mode = 0
	vars.player_heart.sprite.rotation = 0
	mode = 0
	item_index = 0
	vars.battle_box.reset_box_size
	vars.player_heart.visible = true
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false
	if vars.battle_box.margin != vars.battle_box.target:
		await vars.battle_box.resize_finished
	vars.attack_manager.set_writer_text()

func disable():
	mode = -1
	item_index = 0
	vars.player_heart.visible = false
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false

# ACTIONS WHEN PRESSING CONFIRM
# ... So you can override them.

func eat():
	disable()
	var item = ut_items.items[settings.player_save.inventory[item_index + (item_page - 1) * 4]]
	item.use(item_index + (item_page - 1) * 4)
	await item.done
	reset()
