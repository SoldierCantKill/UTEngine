extends Node
class_name Attack

var attack_started := false
var current_frames := 0.0
var frames := 120.0
signal attack_finished

func pre_attack():
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	vars.battle_box.set_box_size([244,254,399,394],500)
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(321, 324)

func start_attack():
	vars.player_heart.input_enabled = true
	attack_started = true

func end_attack():
	vars.hud_manager.reset()
	attack_finished.emit()
	queue_free()

func _process(delta):
	if(attack_started):
		current_frames += delta * 60
		if(current_frames > frames):
			current_frames = 0
			end_attack()
