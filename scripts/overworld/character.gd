extends CharacterBody2D
class_name Character

@onready var sprite := AnimatedSprite2D.new()
@onready var warning_sprite := AnimatedSprite2D.new()
@onready var collision := CollisionShape2D.new()
@onready var ray_cast

var sprite_frames : SpriteFrames :
	set(value):
		sprite_frames = value
		sprite.set_sprite_frames(value)
var x := 0.0
var y := 0.0
var speed := 210.0
var ray_cast_range := 15.0
var auto_sprite_update := true
var snap_camera := true
var cutscene := false :
	set(value):
		cutscene = value
		if(value):
			x = 0.0
			y = 0.0
var input_enabled := true :
	set(value):
		input_enabled = value
		if(!value):
			x = 0.0
			y = 0.0

func _init(sprite_frames):
	var add_sprite_frames = func():
		if(!is_node_ready()):
			await ready
		self.sprite_frames = sprite_frames
		set_warning_position()
	add_sprite_frames.call()

func _ready():
	platform_floor_layers = 0
	add_child(sprite)
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(21,10)
	collision.position = Vector2(.5,10)
	add_child(collision)
	warning_sprite.visible = false
	warning_sprite.set_sprite_frames(load("res://assets/sprite_frames/overworld/characters/character_alert.tres"))
	add_child(warning_sprite)

func setup_player():
	ray_cast = RayCast2D.new()
	ray_cast.position = Vector2(0,5)
	ray_cast.scale.x = 10
	ray_cast.target_position = Vector2(0,ray_cast_range)
	ray_cast.collide_with_areas = true
	ray_cast.collide_with_bodies = false
	ray_cast.hit_from_inside = true
	add_child(ray_cast)
	vars.main_writer.unpaused.connect(func(): input_enabled = false)
	vars.main_writer.done.connect(func(): input_enabled = true)

func set_warning_position():
	var texture := sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	warning_sprite.position = Vector2(texture.get_size().x - 10,-15)

func _process(delta):
	if(vars.player_character == self):
		settings.player_save.data.position = global_position
		if(snap_camera):
			camera_movement()
	if(auto_sprite_update):
		sprite_update()

func _physics_process(delta):
	if(vars.player_character == self && input_enabled && !cutscene):
		inputs()
	velocity = Vector2(x,y) * speed
	move_and_slide()
	if(is_instance_valid(ray_cast)):
		var target_rotation = 0.0
		match(sprite.animation):
			"up":
				target_rotation = 180.0
			"down":
				target_rotation = 0.0
			"left":
				target_rotation = 90.0
			"right":
				target_rotation = 270.0
		ray_cast.rotation_degrees = target_rotation

func inputs():
	x = 0
	y = 0
	if(Input.is_action_pressed("right")): x = 1.0
	if(Input.is_action_pressed("left")): x = -1.0
	if(Input.is_action_pressed("down")): y = 1.0
	if(Input.is_action_pressed("up")): y = -1.0
	if(Input.is_action_just_pressed("confirm")):
		if(ray_cast.get_collider() is Interactable):
			ray_cast.get_collider().event()

func camera_movement():
	vars.scene_cam.global_position = global_position
	if(is_instance_valid(vars.scene_cam)):
		(vars as vars).scene_cam.limit_top = -vars.scene.get_room_size().y / 2
		(vars as vars).scene_cam.limit_bottom = vars.scene.get_room_size().y / 2
		(vars as vars).scene_cam.limit_left = -vars.scene.get_room_size().x / 2
		(vars as vars).scene_cam.limit_right = vars.scene.get_room_size().x / 2

func sprite_update():
	if(velocity != Vector2.ZERO):
		if(!sprite.is_playing()):
			sprite.play()
	else:
		sprite.stop()
	match(sprite.animation):
		"up":
			if(y > 0):
				sprite.play("down")
			elif(y == 0 && x > 0):
				sprite.play("right")
			elif(y == 0 && x < 0):
				sprite.play("left")
		"down":
			if(y < 0):
				sprite.play("up")
			elif(y == 0 && x > 0):
				sprite.play("right")
			elif(y == 0 && x < 0):
				sprite.play("left")
		"left":
			if(x > 0):
				sprite.play("right")
			elif(x == 0 && y > 0):
				sprite.play("down")
			elif(x == 0 && y < 0):
				sprite.play("up")
		"right":
			if(x < 0):
				sprite.play("left")
			elif(x == 0 && y > 0):
				sprite.play("down")
			elif(x == 0 && y < 0):
				sprite.play("up")

func get_position_on_screen() -> Vector2:
	return Vector2(320,240) + global_position - vars.scene_cam.get_screen_center_position()
