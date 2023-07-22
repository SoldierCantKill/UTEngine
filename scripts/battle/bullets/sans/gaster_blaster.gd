#CREDIT TO SCARM FOR ORIGINAL GB CODE (Modified)
extends Bullet

signal done

@onready var spr: Node = $sprite
@onready var laser: Node = $laser
@onready var laser_main: Node = $laser/main
@onready var laser_top: Node = $laser/top
@onready var laser_top2: Node = $laser/top2
@onready var laser_hitbox: Node = $laser/area
@onready var laser_hitbox_col: Node = $laser/area/collision

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
	karma = 1

func _ready():
	super._ready()
	audio.stop_sound("battle/gaster_blaster")
	audio.play("battle/gaster_blaster", audio.global_volume, 1.2)

func _process(delta):
	match(state):
		0:
			position.x += (end_position.x - position.x) / 6.0 * (delta * 60)
			position.y += (end_position.y - position.y) / 6.0 * (delta * 60)
			rotation_degrees += (end_rotation - rotation_degrees) / 6.0 * (delta * 60)
			if(
			abs(position.x - end_position.x) < 5 &&
			abs(position.y - end_position.y) < 5 &&
			abs(end_rotation - rotation_degrees) < 1
				):
					state = 1
		1:
			if(wait_time <= 0):
				spr.play()
				for i in range(3):
					await spr.frame_changed
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
					if spr.scale.x >= 1: vars.display.screen_shake(5)
			else:
				leaving_speed += 120 * delta
			if(blast_timer < 5):
				blast_size += floor((35.0 * spr.scale.x) * 0.125) * delta * 30
			if blast_timer > 5 + blast_time:
				blast_size *= pow(0.8, delta * 30)
				laser.modulate.a -= 3 * delta
				if laser.modulate.a <= 0.8: laser_hitbox_col.disabled = true
			blast_timer += 60 * delta
			
			position -= Vector2(0, leaving_speed).rotated(rotation) * delta * 30
			
			var laser_siner: float = (sin(blast_timer / 1.5) * blast_size) * 0.25
			var xscale: float = spr.scale.x * 0.5
			var rr: float = (randf() * 2) - (randf() * 2)
			var rr2: float = (randf() * 2) - (randf() * 2)
			
			laser_main.size = Vector2(blast_size + laser_siner, 1000)
			laser_main.position = Vector2(-laser_main.size.x + rr2, (70 * xscale) + rr)
			laser_top.size = Vector2((blast_size * 0.8) + laser_siner, 5.5)
			laser_top.position = Vector2(-laser_top.size.x + rr2, (60 * xscale) + rr)
			laser_top2.size = Vector2((blast_size * 0.5) + laser_siner, 5.5)
			laser_top2.position = Vector2(-laser_top2.size.x + rr2, (50 * xscale) + rr)
			laser_hitbox_col.shape.extents = Vector2((blast_size * 3.0) * 0.25, 1000)
			laser_hitbox_col.position = laser_main.position + laser_main.size
		
			
