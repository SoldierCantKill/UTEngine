extends Bullet
class_name Bone

@onready var sprite := $bone
@onready var collision := $bone/area/collision

@onready var offset_left = sprite.offset_left :
	set(value):
		offset_left = value
		sprite.offset_left = value
@onready var offset_top = sprite.offset_top :
	set(value):
		offset_top = value
		sprite.offset_top = value
@onready var offset_right = sprite.offset_right :
	set(value):
		offset_right = value
		sprite.offset_right = value
@onready var offset_bottom = sprite.offset_bottom :
	set(value):
		offset_bottom = value
		sprite.offset_bottom = value

func _init():
	curse = e_curse.karma
	damage = 5
	karma = 1

func _ready():
	super._ready()
	area2d = $bone/area

func _process(delta):
	sprite.pivot_offset = sprite.size / 2
	collision.position = Vector2(sprite.size.x / 2, sprite.size.y / 2)
	collision.shape.size = Vector2(sprite.size.x * .83333, sprite.size.y)

func _physics_process(delta):
	global_position += Vector2(x,y) * speed * delta
	sprite.rotation_degrees += rotation_speed * delta
	duration_tick(delta)
