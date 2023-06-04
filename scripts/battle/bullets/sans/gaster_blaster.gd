#CREDIT TO SCARM FOR ORIGINAL GB CODE
extends Bullet

signal done
var state: int = 0
var wait_time: float = 0
var blast_time: float = 0
var blast_size: float = 0
var end_position: Vector2 = Vector2(320, 240)
var end_rotation: float = -90
var leaving_spd: float = 0
var blast_timer: float = 0
@onready var spr: Node = $sprite
@onready var laser: Node = $laser
@onready var laser_main: Node = $laser/main
@onready var laser_top: Node = $laser/top
@onready var laser_top2: Node = $laser/top2
@onready var laser_hitbox: Node = $laser/area
@onready var laser_hitbox_col: Node = $laser/area/collision

func _init():
	curse = e_curse.karma
	damage = 10
	karma = 1

func _ready():
	super._ready()
	audio.stop_sound("battle/gaster_blaster")
	audio.play("battle/gaster_blaster", audio.global_volume, 1.2)

func _process(delta: float) -> void:
	if state == 0:
		global_position.x += floor((end_position.x - global_position.x) / 3.0) * (delta * 30)
		global_position.y += floor((end_position.y - global_position.y) / 3.0) * (delta * 30)
		
		if global_position.x < end_position.x: global_position.x += 60 * delta
		if global_position.y < end_position.y: global_position.y += 60 * delta
		if global_position.x > end_position.x: global_position.x -= 60 * delta
		if global_position.y > end_position.y: global_position.y -= 60 * delta
		
		if abs(global_position.x - end_position.x) < 3.0: global_position.x = end_position.x
		if abs(global_position.y - end_position.y) < 3.0: global_position.y = end_position.y
		
		rotation_degrees += floor((end_rotation - rotation_degrees) / 3.0) * (delta * 30)
		
		if rotation_degrees < end_rotation: rotation_degrees += 60 * delta
		if rotation_degrees > end_rotation: rotation_degrees -= 60 * delta
		
		if abs(rotation_degrees - end_rotation) < 3.0: rotation_degrees = end_rotation
		if (
			abs(global_position.x - end_position.x) < 0.1 and
			abs(global_position.y - end_position.y) < 0.1 and
			abs(end_rotation - rotation_degrees) < 0.01
		): state = 1
	if state == 1 or state == 2:
		if wait_time <= 0:
			if state == 1: wait_time = 3; spr.play()
			if state == 2: spr.frame = 0;
			
			state = 2 if state == 1 else 3
		else: wait_time -= 30 * delta
	if state == 3:
		if blast_timer == 0:
			laser.visible = true
			laser_hitbox_col.disabled = false
			
			audio.stop_sound("battle/gaster_blast")
			audio.play("battle/gaster_blast", audio.global_volume, 1.2)
			
			if spr.scale.x >= 1: vars.display.screen_shake(5)
		
		blast_timer += 30 * delta
		
		if blast_timer < 5:
			blast_size += floor((25.0 * spr.scale.x) * 0.125) * delta * 30
			leaving_spd += 60 * delta
		else: leaving_spd += 120 * delta
		
		if blast_timer > 5 + blast_time:
			blast_size *= pow(0.8, delta * 30)
			if blast_size <= 2:
				done.emit()
				queue_free()
				
			
			laser.modulate.a -= 3 * delta
			if laser.modulate.a <= 0.8: laser_hitbox_col.disabled = true
		
		global_position -= Vector2(0, leaving_spd).rotated(rotation) * delta * 30
		
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
