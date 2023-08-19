extends Bullet
class_name BGasterBlaster

signal done

@onready var spr := $sprite
@onready var laser := $laser
@onready var laser_main := $laser/main
@onready var laser_top := $laser/top
@onready var laser_top2 := $laser/top2
@onready var laser_hitbox := $laser/area
@onready var laser_hitbox_col := $laser/area/collision

var state := 0
var wait_time := 0.0
var blast_time := 0.0
var blast_size := 0.0
var end_position := Vector2(320, 240)
var end_rotation := -90.0

var leaving_speed := 0.0
var blast_timer := 0.0

func _init():
	curse = e_curse.karma
	damage = 10
	karma = 2

func _ready():
	super._ready()
	audio.stop_sound("battle/gaster_blaster")
	audio.play("battle/gaster_blaster", audio.global_volume, 1.2)

func _process(delta):
	match(state):
		0:
			position.x += floor((end_position.x - position.x) * 0.33333) * (delta * 30)
			position.y += floor((end_position.y - position.y) * 0.33333) * (delta * 30)
			if(position.x < end_position.x): position.x += 60 * delta
			if(position.y < end_position.y): position.y += 60 * delta
			if(position.x > end_position.x): position.x -= 60 * delta
			if(position.y > end_position.y): position.y -= 60 * delta
			if(abs(position.x - end_position.x)) < 3.0: position.x = end_position.x
			if(abs(position.y - end_position.y)) < 3.0: position.y = end_position.y
			rotation_degrees += floor((end_rotation - rotation_degrees) * 0.33333) * (delta * 30)
			if(rotation_degrees < end_rotation): rotation_degrees += 60 * delta
			if(rotation_degrees > end_rotation): rotation_degrees -= 60 * delta
			if abs(rotation_degrees - end_rotation) < 3.0: rotation_degrees = end_rotation
			if(
			abs(position.x - end_position.x) < 0.1 &&
			abs(position.y - end_position.y) < 0.1 &&
			abs(end_rotation - rotation_degrees) < 0.01
				):
					state = 1
		1:
			if(wait_time <= 0):
				spr.play()
				for i in range(2):
					await spr.frame_changed
				spr.animation_finished.connect(func(): if(!spr.animation.contains("_loop")): spr.play(spr.animation + "_loop"))
				state = 2
			else:
				wait_time -= 60 * delta
		2:
			if(blast_timer <= blast_time):
				if(blast_timer == 0):
					laser.visible = true
					laser_hitbox_col.disabled = false
					audio.stop_sound("battle/gaster_blast")
					audio.play("battle/gaster_blast",audio.global_volume,1.2)
					if scale.x >= 1: vars.display.screen_shake(5)
			
			if(blast_timer < 10):
				blast_size += floor((35.0 * spr.scale.x) * 0.125) * delta * 30
				leaving_speed += 60 * delta
			else: leaving_speed += 120 * delta
			
			if blast_timer > 10 + blast_time:
				blast_size *= pow(0.8, delta * 30)
				if blast_size <= 2: queue_free()
				laser.modulate.a -= 3 * delta
				if laser.modulate.a <= 0.8: laser_hitbox_col.disabled = true
			
			position -= Vector2(0, leaving_speed).rotated(rotation) * delta * 30
			
			var laser_siner: float = (sin(blast_timer * 0.66667 / 2) * blast_size) * 0.25
			var xscale: float = spr.scale.x * 0.5
			var rr: float = (randf() * 2) - (randf() * 2)
			var rr2: float = (randf() * 2) - (randf() * 2)
			
			laser_main.size = Vector2(blast_size + laser_siner, 1000)
			laser_main.position = Vector2(-laser_main.size.x + rr2, (70 * xscale) + rr)
			
			laser_top.size = Vector2((blast_size * .8) + laser_siner, 5.5)
			laser_top.position = Vector2(-laser_top.size.x + rr2, (60 * xscale) + rr)
			
			laser_top2.size = Vector2((blast_size * .5) + laser_siner, 5.5)
			laser_top2.position = Vector2(-laser_top2.size.x + rr2, (50 * xscale) + rr)
			
			laser_hitbox_col.shape.extents = Vector2((blast_size * 3.0) * .25, 1000)
			laser_hitbox_col.position = laser_main.position + laser_main.size
		
			blast_timer += 60 * delta
