extends Bullet
class_name BBoneStab

@onready var pivot_offset = $pivot_offset
@onready var bones = $pivot_offset/bones
@onready var warning = $pivot_offset/warning

var bone_height := 50.0
var length := 72.0
var wait_time := 30.0
var up_time := 60.0
var state := 0
var racket := 6
var t := 0.0
var warning_color_t := 0.0
var bone_rotation := 0:
	set(value):
		bone_rotation = value
		pivot_offset.rotation_degrees = value

func _init():
	curse = e_curse.karma
	damage = 5
	karma = 2

func _ready():
	super._ready()
	area2d = $pivot_offset/area
	audio.play("battle/warning")
	warning.size.x = length#ceil(length) - ceil(fmod(length,12))
	warning.offset_top = -bone_height
	bones.size.x = length + fmod(length,12)
	bones.offset_top = warning.offset_bottom + 2
	bones.offset_bottom = bone_height + 12
	var bone_count = ceil(bones.size.x / 12)
	for i in range(bone_count):
		var collision = CollisionShape2D.new()
		area2d.add_child(collision)
		collision.shape = RectangleShape2D.new()
		collision.position.y = bones.size.y / 2
		collision.shape.size = Vector2(6,bones.size.y)
		collision.position.x = 6 + i * 12

func change_color():
	match(type):
		e_type.blue:
			bones.modulate = Color(.26,.89,1,modulate.a)
		e_type.orange:
			bones.modulate = Color(1,.63,.25,modulate.a)
		_:
			bones.modulate = Color.WHITE

func _process(delta: float) -> void:
	match(int(bone_rotation)):
		0:
			pivot_offset.pivot_offset = Vector2(0,0)
		90:
			pivot_offset.pivot_offset = Vector2(warning.size.y,warning.size.y) + Vector2(-bone_height,-bone_height)
		180:
			pivot_offset.pivot_offset = warning.size / 2 + Vector2(0,-bone_height)
		270:
			pivot_offset.pivot_offset = Vector2(warning.size.x,warning.size.x) / 2 + Vector2(0,-bone_height)
	for i in area2d.get_children():
		i.position.y = (bones.offset_bottom + bones.offset_top) / 2
		i.shape.size.y = bones.size.y
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
			audio.play("battle/bonestab")
	elif(state == 1):
		bones.position.y -= (ceil(bone_height / 3.0)) * (delta * 30)
		if(bones.position.y <= -bone_height):
			t = 0
			state = 2
			bones.position = Vector2(0,-bone_height)
	elif(state == 2):
		t += 60 * delta
		if(t >= up_time):
			bones.position.y += (ceil(bone_height / 4.0)) * (delta * 30)
		else:
			if racket > 0: racket -= delta * 30
			else: racket = 0
			var rr: = (randf() * racket) - (randf() * racket)
			var rr2: = (randf() * racket) - (randf() * racket)
			bones.position = Vector2(rr, -bone_height + rr2)
		if(bones.position.y >= 2):
			queue_free()
