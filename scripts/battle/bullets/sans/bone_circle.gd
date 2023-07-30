extends Bullet
class_name BBoneCircle

var bones := []
var BONE_PATH = preload("res://objects/battle/bullets/sans/bone.tscn")
const bone_offset_top = -500
var bone_count = 15
var radius := 100

func _ready():
	await get_tree().process_frame
	for i in range(bone_count):
		var bone = BONE_PATH.instantiate()
		add_child(bone)
		bones.append(bone)
		bone.type = type
		var angle = i * (2 * PI / bone_count)
		bone.position.x = radius * cos(angle)
		bone.position.y = radius * sin(angle)
		bone.rotation = angle + 1.65
		bone.offset_top = bone_offset_top
