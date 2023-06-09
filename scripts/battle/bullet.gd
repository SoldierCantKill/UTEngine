extends Node2D
class_name Bullet

signal event_hit
enum e_type {
	none,
	unhittable,
	blue,
	orange,
	}
enum e_curse {
	none,
	karma,
	}
@onready var area2d : Area2D :
	set(value):
		area2d = value
		area2d.area_exited.connect(func(area): if(vars.player_heart not in area2d.get_overlapping_bodies()): was_colliding = false)
var damage : float = 5
var karma : float = 1
var auto_change_color = true :
	set(value):
		auto_change_color = value
		if(value):
			change_color()
var type : e_type = 0 :
	set(value):
		type = value
		if(auto_change_color):
			change_color()
var curse : e_curse = 0
var was_colliding
var x : float = 0
var y : float = 0
var speed : float = 0
var rotation_speed : float = 0
var masked : bool = true : 
	set(value):
		masked = value
		show_behind_parent = value
var duration = -1

func _ready():
	vars.attack_manager.delete_bullets.connect(func(): queue_free())

func change_color():
	match(type):
		e_type.blue:
			modulate = Color(.26,.89,1,modulate.a)
		e_type.orange:
			modulate = Color(1,.63,.25,modulate.a)
		_:
			modulate = Color.WHITE

func hit():
	if(can_get_hit()):
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

func can_get_hit():
	if(vars.debug.enabled): return false
	if(!visible): return false
	
	match(type):
		e_type.unhittable:
			return false
		e_type.none:
			return true
		e_type.blue:
			if(vars.player_heart.is_moving()): return true
		e_type.orange:
			if(!vars.player_heart.is_moving()): return true
	return false

func _physics_process(delta):
	global_position += Vector2(x,y) * speed * delta
	rotation_degrees += rotation_speed * delta
	duration_tick(delta)

func duration_tick(delta):
	if(duration != -1):
		duration -= delta
		if(duration <= 0):
			queue_free()
