extends Node2D
class_name Bullet

signal event_hit
enum e_type {
	none,
	blue,
	fake_blue,
	orange,
	unhittable,
	}
enum e_curse {
	none,
	karma,
	}
@onready var area2d : Area2D :
	set(value):
		area2d = value
		area2d.area_exited.connect(func(area): if(vars.player_heart.hitbox not in area2d.get_overlapping_areas()): was_colliding = false)
var damage := 5.0
var karma := 1.0
var auto_change_color := true :
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
var was_colliding := false
var x := 0.0
var y := 0.0
var speed := 0.0
var rotation_speed := 0.0
var masked : = true : 
	set(value):
		masked = value
		show_behind_parent = value
var duration := -1.0

var gravity_enabled := false
var gravity_drag := Vector2(randf_range(-120.0,120.0),randf_range(-90.0,50.0))

func _ready():
	vars.attack_manager.delete_bullets.connect(func(): queue_free())

func change_color():
	match(type):
		e_type.blue:
			modulate = Color(.26,.89,1,modulate.a)
		e_type.fake_blue:
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
					event_hit.emit(true)
					vars.player_heart.hurt(damage)
			e_curse.karma:
				if(vars.player_heart.karma_i_timer <= 0):
					event_hit.emit(true)
					if(!was_colliding):
						was_colliding = true
						vars.player_heart.hurt_kr(damage) #takes 5 damage gains 6 kr
					else:
						vars.player_heart.hurt_kr(karma) #takes 1 damage gains 2 kr
	else:
		event_hit.emit(false)

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
		e_type.fake_blue:
			return (Input.is_action_pressed("up") || Input.is_action_pressed("down") || Input.is_action_pressed("left") || Input.is_action_pressed("right"))
		e_type.orange:
			if(!vars.player_heart.is_moving()): return true
	return false

func _physics_process(delta):
	global_position += Vector2(x,y) * speed * delta
	rotation_degrees += rotation_speed * delta
	duration_tick(delta)
	if(gravity_enabled):
		global_position.y += gravity_drag.y * delta
		gravity_drag.y += max(abs(gravity_drag.y),200) * delta * 2
		global_position.x += gravity_drag.x * delta
		rotation_degrees += gravity_drag.x * 2 * delta

func duration_tick(delta):
	if(int(duration) != -1):
		duration -= delta
		if(duration <= 0):
			queue_free()
