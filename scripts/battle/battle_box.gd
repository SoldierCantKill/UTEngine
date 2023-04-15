extends NinePatchRect
class_name BattleBox

var target = [offset_left, offset_top, offset_right, offset_bottom]
var margin
var resize_spd = 600
var emit_resize = false

signal resize_finished
@onready var collisions = [$collisions/left, $collisions/up, $collisions/right, $collisions/down]

func _process(delta : float) -> void:
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

	collisions[0].shape.extents = Vector2(480, 640)
	collisions[1].shape.extents = Vector2(640, 480)
	collisions[2].shape.extents = collisions[0].shape.extents
	collisions[3].shape.extents = collisions[1].shape.extents

	collisions[0].position = Vector2(-collisions[0].shape.extents.x + 5, collisions[0].shape.extents.y - 480)
	collisions[1].position = Vector2(size.x / 2.0, -collisions[1].shape.extents.y + 5)
	collisions[2].position = Vector2(size.x + collisions[2].shape.extents.x - 5, collisions[2].shape.extents.y - 480)
	collisions[3].position = Vector2(size.x / 2.0, size.y + collisions[1].shape.extents.y - 5)

func SetSize(target : Array, resize_spd : float = 550) -> void:
	self.resize_spd = resize_spd
	self.target = target
	emit_resize = false

func ResetSize(resize_spd = 300) -> void:
	self.resize_spd = resize_spd
	target = [34, 254, 609, 395]
	emit_resize = false

func InstaSet(target : Array) -> void:
	self.target = target
	offset_left = target[0]
	offset_top = target[1]
	offset_right = target[2]
	offset_bottom = target[3]
	resize_finished.emit()
