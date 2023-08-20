extends Node2D
class_name DisplayManager

signal fade_done
signal start_room

@onready var border = $border
@onready var game = $game
@onready var game_viewport := $game/container/sub_viewport
@onready var border_viewport := $border/container/sub_viewport
@onready var camera := $camera
@onready var border_camera := $border/container/sub_viewport/camera

var starting_scene = load("res://scenes/main_menu.tscn") #if you are gonna use this for rooms, do not use a save system.
var camera_intensity := 0.0
var camera_shake_t := 0.0

func _ready() -> void:
	vars.display = self
	#change_room(settings.player_save.data.player_room,-1)
	change_scene(starting_scene, false)

func change_scene(path : Variant, fadeout = true) -> Node:
	for i in game_viewport.get_children():
		i.queue_free()
	var scene = path.instantiate()
	vars.scene = scene
	game_viewport.add_child(scene)
	if(fadeout):
		fade_out(.3)
	border_viewport.world_2d = game_viewport.world_2d
	await get_tree().process_frame
	start_room.emit()
	return scene

func change_room(to_room : int, to_changer : int, fades : bool = true):
	if(fades):
		await fade_in(.3)
	for i in game_viewport.get_children():
		i.queue_free()
	var room = OverworldRoom.rooms[to_room].instantiate() #change_scene(,true)
	vars.scene = room
	settings.player_save.data.player_room = to_room
	game_viewport.add_child(room)
	if(fades):
		fade_out(.3)
	border_viewport.world_2d = game_viewport.world_2d
	if(to_changer != -1):
		for i in room.room_changers:
			if(i.to_changer == to_changer):
				print(i)
				settings.player_save.data.position = i.player_spawn.global_position
	start_room.emit()
	return room

func fade_out(time : float):
	$fade_overlay.color = Color(0,0,0,1)
	var tween = get_tree().create_tween()
	tween.tween_property($fade_overlay, "color", Color(0,0,0,0), time)
	await tween.finished
	fade_done.emit()

func fade_in(time : float):
	$fade_overlay.color = Color(0,0,0,0)
	var tween = get_tree().create_tween()
	tween.tween_property($fade_overlay, "color", Color(0,0,0,1), time)
	await tween.finished
	fade_done.emit()

func screen_shake(amount : float) -> void:
	camera_intensity = amount

func _process(delta):
	if(is_instance_valid(vars.scene_cam)):
		border_camera.global_position = vars.scene_cam.global_position
		border_camera.offset = vars.scene_cam.offset
		border_camera.limit_top = vars.scene_cam.limit_top
		border_camera.limit_bottom = vars.scene_cam.limit_bottom
		border_camera.limit_left = vars.scene_cam.limit_left
		border_camera.limit_right = vars.scene_cam.limit_right
		border_camera.zoom = vars.scene_cam.zoom
		if camera_intensity > 0:
			camera_shake_t += 60 * delta
		else:
			pass
		if camera_shake_t >= 1:
			camera_shake_t -= delta * 60
			camera_intensity -= delta * 60
			vars.scene_cam.offset = Vector2(camera_intensity * [1, -1].pick_random(), camera_intensity * [1, -1].pick_random()) + Vector2(320,240)
