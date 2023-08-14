extends Node2D
class_name OverworldRoom

static var rooms = {
	0 : load("res://scenes/rooms/example_rooms/room_0.tscn"),
	1 : load("res://scenes/rooms/example_rooms/judgement_hall.tscn"),
}


var player_character : Character
var room_sprite
var room_changers : Array[RoomChanger] = []

func _ready():
	vars.main_writer = get_node("overworld_canvas/message_border/overworld_writer")
	vars.overworld_hud = get_node("overworld_canvas/overworld_hud")
	vars.scene_cam = get_node("camera")
	await vars.display.start_room
	player_character = Character.new(load("res://assets/sprite_frames/overworld/characters/frisk.tres"))
	player_character.scale = Vector2(2,2)
	player_character.global_position = settings.player_save.data.position
	add_child(player_character)
	player_character.setup_player()
	vars.player_character = player_character

func go_to_battle_anim(end_location : Vector2):
	audio.stop_music()
	vars.player_character.input_enabled = false
	var black_screen := ColorRect.new()
	black_screen.color = Color.BLACK
	black_screen.position = Vector2(-2500,-2500)
	black_screen.size = Vector2(5000,5000)
	black_screen.z_index = 4096
	add_child(black_screen)
	var heart_sprite := Sprite2D.new()
	heart_sprite.set_texture(load("res://assets/sprites/battle/heart/heart_0.png"))
	heart_sprite.z_index = 4096
	heart_sprite.global_position = vars.player_character.global_position
	heart_sprite.self_modulate = Color(1,0,0,1)
	add_child(heart_sprite)
	await get_tree().create_timer(.1).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(heart_sprite, "global_position", vars.scene_cam.get_screen_center_position() + end_location, .7)
	audio.play("overworld/snd_battlefall")
	await tween.finished

func get_room_size() -> Vector2:
	return room_sprite.get_texture().get_size() * room_sprite.scale

func get_place_text() -> String:
	return ""
