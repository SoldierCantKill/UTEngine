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
		var string = "[rainbow]Debug\n"
		string += "FPS : " + str(Engine.get_frames_per_second())
		text.text = string
