extends Bullet
class_name BoneStab

@onready var pivot_offset = $pivot_offset
@onready var bones = $pivot_offset/bones
@onready var warning = $pivot_offset/warning

var bone_height : float = 50
var length : float = 72
var wait_time : float = 30
var up_time : float = 60
var state := 0
var t : float = 0
var bone_rotation : float:
	set(value):
		bone_rotation = value
		pivot_offset.rotation_degrees = value

func _init():
	curse = e_curse.karma
	damage = 5
	karma = 1

func _ready():
	super._ready()
	area2d = $pivot_offset/area
	audio.play("battle/warning")
	warning.size.x = ceil(length) - ceil(fmod(length,12))
	warning.offset_top = -bone_height
	bones.size.x = ceil(length) - ceil(fmod(length,12))
	bones.offset_bottom = bone_height + 12
	for i in range(ceil(length / 12) - ceil(fmod(length,12))):
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
	pivot_offset.pivot_offset = warning.size / 2
	for i in area2d.get_children():
		i.position.y = (bones.offset_bottom + bones.offset_top) / 2
		i.shape.size.y = bones.size.y
	if(state == 0):
		t += 60 * delta
		if(t >= wait_time):
			t = 0
			state = 1
			warning.visible = false
			var tween = get_tree().create_tween()
			audio.play("battle/bonestab")
			var distance = bones.global_position.distance_to(bones.global_position - Vector2(0,bone_height)) / 150
			tween.tween_property(bones,"position:y",-bone_height,distance).set_trans(Tween.TRANS_SINE)
			tween.finished.connect(func(): state = 2)
	elif(state == 2):
		t += 60 * delta
		if(t >= up_time):
			state = 3
			var tween = get_tree().create_tween()
			var distance = bones.global_position.distance_to(bones.global_position + Vector2(0,bone_height)) / 150
			tween.tween_property(bones,"position:y",2,distance).set_trans(Tween.TRANS_SINE)
			tween.finished.connect(func(): queue_free())
