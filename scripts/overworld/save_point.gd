extends Node2D

@onready var sprite := $sprite
@onready var area : Interactable = $area
@onready var selection_border := $CanvasLayer/selection_border
@onready var text_container := $CanvasLayer/selection_border/text_container
@onready var player_save = settings.player_save
@onready var heart = $CanvasLayer/selection_border/heart
@onready var options = [$CanvasLayer/selection_border/text_container/save,$CanvasLayer/selection_border/text_container/return]
var mode := -1
var selection_index := 0

func _ready():
	sprite.play()
	area.event_called.connect(on_event)

func _process(delta):
	hud_update()

func _physics_process(delta):
	inputs()

func inputs():
	match(mode):
		0:
			if(Input.is_action_just_pressed("left")):
				audio.play("menu/menu_move")
				selection_index = wrapi(selection_index - 1,0,2)
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				selection_index = wrapi(selection_index + 1,0,2)
			if(Input.is_action_just_pressed("confirm")):
				match(selection_index):
					0:
						audio.play("menu/save")
						mode = 1
						settings.save_game()
						refresh()
					1:
						close()
			if(Input.is_action_just_pressed("exit")):
				close()
		1:
			if(Input.is_action_just_pressed("confirm")):
				close()
			if(Input.is_action_just_pressed("exit")):
				close()
		

func hud_update():
	match(mode):
		0:
			heart.visible = true
			heart.global_position = options[selection_index].global_position + Vector2(-28,6)
			text_container.modulate = Color.WHITE
		1:
			heart.visible = false
			text_container.modulate = Color.YELLOW

func on_event():
	audio.play("menu/heal")
	player_save.player.current_hp = max(player_save.player.current_hp,player_save.player.max_hp)
	open()

func open():
	selection_index = 0
	mode = 0
	refresh()
	vars.player_character.input_enabled = false
	selection_border.visible = true
	

func close():
	mode = -1
	selection_border.visible = false
	await get_tree().physics_frame
	vars.player_character.input_enabled = true

func refresh():
	var old_player_save = ResourceLoader.load("user://saved.tres").duplicate()
	text_container.get_node("name").text = str(old_player_save.player.name)
	text_container.get_node("lv").text = "LV %d" %[old_player_save.player.lv]
	text_container.get_node("place").text = (vars.scene as OverworldRoom).get_place_text()
	var minutes = floorf(old_player_save.data.time / 60)
	if(minutes >= 10):
		minutes = str(minutes)
	else:
		minutes = "0" + str(minutes)
	var seconds = floorf(fmod(old_player_save.data.time,60))
	if(seconds >= 10):
		seconds = str(seconds)
	else:
		seconds = "0" + str(seconds)
	text_container.get_node("time").text = "%s:%s"%[minutes,seconds]
