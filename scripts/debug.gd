extends Node2D

@onready var text = $text
var enabled = false

func _ready():
	vars.debug = self
	visible = false

func _process(delta):
	if(Input.is_action_just_pressed("debug")):
		enabled = !enabled
		visible = enabled
	if(visible):
		if(Input.is_action_pressed("turn_changer")):
			if(Input.is_action_just_pressed("right")):
				if(is_instance_valid(vars.attack_manager)):
					vars.attack_manager.turn_num += 1
			if(Input.is_action_just_pressed("left")):
					vars.attack_manager.turn_num -= 1
		var string = "[rainbow]Debug"
		string += "\nFPS : " + str(Engine.get_frames_per_second())
		if(is_instance_valid(vars.attack_manager)):
			string += "\nTurn : " + str(vars.attack_manager.turn_num)
			text.text = string
