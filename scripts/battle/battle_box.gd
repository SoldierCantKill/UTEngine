#WARNING!!!!!!!!!! Change the battlebox color with the shader material. NOT THE MODULATE!!!

extends NinePatchRect
class_name BattleBox

@onready var target : Array = [offset_left, offset_top, offset_right, offset_bottom]
@onready var outline : NinePatchRect = $outline
var margin : Array 
var resize_spd : float = 600
var emit_resize = false
signal resize_finished
@onready var collisions : Array = [$collisions/left, $collisions/up, $collisions/right, $collisions/down]

func _ready():
	pass

func _process(delta : float) -> void:
	outline.size = size + Vector2(6,6)
	outline.self_modulate.a = material.get_shader_parameter("fgopacity")
	margin = [offset_left, offset_top, offset_right, offset_bottom]
	var spd = resize_spd * delta

	for i in 4:
		if abs(margin[i] - target[i]) <= spd: margin[i] = target[i]
		elif margin[i] > target[i]: margin[i] -= spd
		else: margin[i] += spd

	if margin == target and !emit_resize:
		emit_signal("resize_finished")
		emit_resize = true
	elif margin != target and emit_resize:
		emit_resize = false

	offset_left = margin[0]
	offset_top = margin[1]
	offset_right = margin[2]
	offset_bottom = margin[3]


	pivot_offset = size / 2.0
	$corner_bottom.position = size - Vector2(5, 5)

	collisions[0].shape.size = Vector2(5,size.y)
	collisions[0].position = collisions[0].shape.size / 2
	collisions[1].shape.size = Vector2(size.x, 5)
	collisions[1].position = collisions[1].shape.size / 2
	collisions[2].shape.size = Vector2(5,size.y)
	collisions[2].position = collisions[2].shape.size / 2 + Vector2(size.x - 5,0)
	collisions[3].shape.size = Vector2(size.x, 5)
	collisions[3].position = collisions[3].shape.size / 2 + Vector2(0,size.y - 5)

#OLD WAY OF MANAGING COLLISIONS
#	collisions[0].shape.extents = Vector2(480, 640)
#	collisions[1].shape.extents = Vector2(640, 480)
#	collisions[2].shape.extents = collisions[0].shape.extents
#	collisions[3].shape.extents = collisions[1].shape.extents
#
#	collisions[0].position = Vector2(-collisions[0].shape.extents.x + 5, collisions[0].shape.extents.y - 480)
#	collisions[1].position = Vector2(size.x / 2.0, -collisions[1].shape.extents.y + 5)
#	collisions[2].position = Vector2(size.x + collisions[2].shape.extents.x - 5, collisions[2].shape.extents.y - 480)
#	collisions[3].position = Vector2(size.x / 2.0, size.y + collisions[1].shape.extents.y - 5)

func set_box_size(target : Array, resize_spd : float = 500) -> void:
	self.resize_spd = resize_spd
	self.target = target
	emit_resize = false

func reset_box_size(resize_spd = 500) -> void:
	self.resize_spd = resize_spd
	target = [34, 254, 609, 395]
	emit_resize = false

func insta_box_size(target : Array) -> void:
	self.target = target
	offset_left = target[0]
	offset_top = target[1]
	offset_right = target[2]
	offset_bottom = target[3]
	resize_finished.emit()
