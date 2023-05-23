extends Node2D

@onready var game : SubViewport = $game/sub_viewport
var starting_scene = ("res://scenes/battles/battle_example.tscn")
var camera_intensity : float = 0
var camera_shake_t : float = 0
signal fade_done

func _ready() -> void:
	vars.display = self
	change_scene(starting_scene, false)

func change_scene(path : String, black_screen = true) -> void:
	for i in game.get_children():
		i.queue_free()
	var scene = load(path).instantiate()
	game.add_child(scene)
	vars.scene = scene
	fade_out(.3)

func fade_out(time : float):
	$fade_overlay.color = Color(0,0,0,1)
	var tween = get_tree().create_tween()
	tween.tween_property($fade_overlay, "color", Color(0,0,0,0), time)
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
		if camera_intensity > 0:
			camera_shake_t += 30 * delta
		else:
			pass
			#vars.scene_cam.offset = Vector2.ZERO
		if camera_shake_t >= 1:
			camera_shake_t -= 1
			camera_intensity -= 1
			vars.scene_cam.offset = Vector2(camera_intensity * [1, -1].pick_random(), camera_intensity * [1, -1].pick_random()) + Vector2(320,240)
