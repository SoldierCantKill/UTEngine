extends Node2D

@onready var text = $text
var next_scene = load("res://scenes/battles/example_battles/battle_example.tscn")

func _ready():
	vars.scene_cam = get_node("camera")
	audio.play("menu/snd_logo")
	await get_tree().create_timer(3).timeout
	text.visible = true

func _process(delta):
	if(Input.is_action_just_pressed("confirm")):
		#vars.display.change_scene(next_scene,true) # Enable if you want to go to battle
		vars.display.change_room(settings.player_save.data.player_room,-1,false) # Enable if you want to go to room
