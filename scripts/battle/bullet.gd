extends Node2D
class_name Bullet

signal event_hit

enum e_type {
	none,
	blue,
	orange,
	}

enum e_curse {
	none,
	karma,
	}

@onready var area2d : Area2D = $Area2D
var damage : float = 5
var karma : float = 1
var type : e_type = 0
var curse : e_curse = 0
var was_colliding

var x : float = 0
var y : float = 0
var speed : float = 0
var rotation_speed : float = 0

func _ready():
	vars.attack_manager.attack_done.connect(func(): queue_free())
	area2d.area_exited.connect(func(): if(vars.player_heart not in area2d.get_overlapping_bodies()): was_colliding = false)
	var was_colliding

func hit():
	match(curse):
		e_curse.none:
			if(vars.player_heart.i_timer <= 0):
				event_hit.emit()
				vars.player_heart.hurt(damage)
		e_curse.karma:
			if(vars.player_heart.karma_i_timer <= 0):
				event_hit.emit()
				if(!was_colliding):
					was_colliding = true
					vars.player_heart.hurt_kr(damage) #takes 5 damage gains 6 kr
				else:
					vars.player_heart.hurt_kr(karma) #takes 1 damage gains 2 kr

func _physics_process(delta):
	global_position += Vector2(x,y) * speed * delta
	rotation_degrees += rotation_speed * delta
