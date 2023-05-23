extends Node
class_name Bullet

enum e_type {
	none,
	blue,
	orange,
}

var damage : float = 5
var karma : float = 1
var type : e_type = 0

func _ready():
	vars.attack_manager.attack_done.connect(func(): queue_free())

func hit():
	if(vars.player_heart.i_timer <= 0):
		vars.player_heart.hurt(damage)
