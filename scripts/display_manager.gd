extends Node2D
class_name DisplayManager

@onready var game : SubViewport = $game/sub_viewport
var starting_scene = load("res://scenes/battles/battle_example.tscn")
var camera_intensity : float = 0
var camera_shake_t : float = 0
signal fade_done

func _ready() -> void:
	vars.display = self
	change_scene(starting_scene, false)

func change_scene(path : Variant, fadeout = true) -> void:
	for i in game.get_children():
		i.queue_free()
	var scene = path.instantiate()
	game.add_child(scene)
	vars.scene = scene
	if(fadeout):
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
			camera_shake_t += 60 * delta
		else:
			pass
		if camera_shake_t >= 1:
			camera_shake_t -= delta * 60
			camera_intensity -= delta * 60
			vars.scene_cam.offset = Vector2(camera_intensity * [1, -1].pick_random(), camera_intensity * [1, -1].pick_random()) + Vector2(320,240)
