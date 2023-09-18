extends Area2D
class_name RoomChanger

enum e_tp_animation {up,down,left,right}

@onready var player_spawn := $player_spawn

@export var changer := 0
@export var to_room := 0
@export var to_changer := 0
@export_enum("up","down","left","right") var animation_when_tp_here = "down"


func _ready():
	add_to_group("room_changers")
	body_entered.connect(on_body_entered)

func on_body_entered(body):
	if(body == vars.player_character):
		vars.player_character.input_enabled = false
		vars.display.change_room(to_room,to_changer)
