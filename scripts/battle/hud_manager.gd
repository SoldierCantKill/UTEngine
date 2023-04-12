extends Node
class_name HudManager

var mode = 0
var button_index = 0
var item_index = 0
@onready var buttons : Array = $buttons.get_children()

func _process(delta):
	display_update()
	hud_mode_update()
	inputs()

func display_update():
	pass

func hud_mode_update():
	match(mode):
		0:
			for i in range(buttons.size()):
				if i != button_index:
					buttons[i].frame = 0
				else:
					buttons[i].frame = 1

func inputs():
	match(mode):
		0:
			if(Input.is_action_just_pressed("right")):
				button_index = wrapi(button_index + 1, 0, buttons.size())
			if (Input.is_action_just_pressed("left")):
				button_index = wrapi(button_index - 1, 0, buttons.size())
			if (Input.is_action_just_pressed("confirm")):
				mode = 1

func reset():
	mode = 0
	item_index = 0
