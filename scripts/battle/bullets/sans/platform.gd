extends Bullet
class_name BPlatform

enum e_platform_type {
	stick,
	slide,
}

var platform_type : e_platform_type = e_platform_type.stick :
	set(value):
		platform_type = value
		if value == 0: color.self_modulate = Color(0, 0.5, 0)
		if value == 1: color.self_modulate = Color(0.5, 0, 0.5)
		stick_collision.disabled = value != 0
		slide_collision.disabled = value != 1

@onready var color: Node = $platform/color
@onready var platform : NinePatchRect = $platform
@onready var stick_collision: Node = $platform/stick/collision
@onready var slide_collision: Node = $platform/slide/collision


func _physics_process(delta):
	position += Vector2(x,y) * speed * delta
	color.size.x = platform.size.x
	var collision_size: Vector2 = platform.size * 0.5
	stick_collision.position = collision_size
	stick_collision.shape.extents = collision_size
	slide_collision.position = collision_size
	slide_collision.shape.extents = collision_size
