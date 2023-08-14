extends Bullet
class_name BVectorSlash

@onready var warning := $warning
@onready var slash := $slash
@onready var collision := $slash/area_2d/collision

var wait_time := 60
var warning_size := 3
var slash_size := 6.0
var stop_rotation_after := true
var state := 0
var t := 0.0
var warning_color_t := 0.0

func _init():
	curse = e_curse.karma
	damage = 5
	karma = 2

func _ready():
	area2d = $slash/area_2d
	collision.disabled = true
	warning.visible = true
	slash.visible = false
	warning.offset_top = -10000
	warning.offset_bottom = 10000
	slash.offset_left = -warning_size
	slash.offset_top = -10000
	slash.offset_right = warning_size
	slash.offset_bottom = 10000
	audio.play("battle/warning")

func change_color():
	match(type):
		e_type.blue:
			slash.modulate = Color(.26,.89,1,modulate.a)
		e_type.orange:
			slash.modulate = Color(1,.63,.25,modulate.a)
		_:
			slash.modulate = Color.WHITE

func _process(delta):
	if(state == 0):
		t += 60 * delta
		warning_color_t += 60 * delta
		if(warning_color_t > 3):
			warning_color_t = 0
			warning.self_modulate = Color.YELLOW if(warning.self_modulate == Color.RED) else Color.RED
		if(t >= wait_time):
			t = 0
			state = 1
			warning.visible = false
			slash.visible = true
			collision.disabled = false
			if(stop_rotation_after):
				rotation_speed = 0
			audio.play("battle/dt_sword_sound",audio.global_volume,1)
	elif(state == 1):
		slash.offset_left -= (slash_size / 6 * delta * 30)
		slash.offset_right += (slash_size / 6 * delta * 30)
		collision.shape.size = slash.size
		collision.position = slash.size / 2
		if(slash_size - slash.offset_right <= 1): state = 2
	elif(state == 2):
		slash.offset_left += (slash_size / 7 * delta * 30)
		slash.offset_right -= (slash_size / 7 * delta * 30)
		collision.shape.size = slash.size
		collision.position = slash.size / 2
		if(slash.offset_right <= 0): queue_free()
