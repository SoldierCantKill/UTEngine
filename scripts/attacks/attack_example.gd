extends Node
class_name Attack

var attack_started := false
var current_frames := 0.0
var frames := 120.0
signal attack_finished

func pre_attack():
	vars.battle_box.set_box_size([244,254,399,394],500)
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(321, 324)

func start_attack():
	vars.player_heart.input_enabled = true
	attack_started = true
	var bullet = vars.attack_manager.bullet(load("res://objects/battle/bullets/test_bullet.tscn"), Vector2(321, 374))
	var bullet_kr = vars.attack_manager.bullet(load("res://objects/battle/bullets/test_bullet_kr.tscn"), Vector2(270, 374))
	bullet.event_hit.connect(end_attack)

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
