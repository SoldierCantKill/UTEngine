extends Node
class_name AttackManager

signal heart_thrown
signal delete_bullets
signal attack_done

@onready var masks = get_node("buffer/masks")

var turn_num = 0
var attacks = [load("res://scripts/battle/attacks/attack_base.gd")]
var heal_attacks = [load("res://scripts/battle/attacks/attack_base.gd")]
var current_attack : Attack = null

func _ready():
	attack_done.connect(func(): delete_bullets.emit())

func set_writer_text():
	pass

func pre_attack() -> Attack:
	current_attack = Attack.new()
	current_attack.set_script(attacks[wrapi(turn_num,0,len(attacks))])
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func pre_heal_attack() -> Attack:
	current_attack = Attack.new()
	current_attack.set_script(heal_attacks.pick_random())
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func pre_custom_attack(attack_script) -> Attack:
	current_attack = Attack.new()
	current_attack.set_script(attack_script)
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func bullet(bullet_path : Variant, type : Bullet.e_type, position : Vector2, x : float, y : float, speed : float,
rotation_speed : float, masked = true, duration : float = -1) -> Bullet:
	var bullet = bullet_path.instantiate()
	bullet.masked = masked
	bullet.duration = duration
	bullet.x = x
	bullet.y = y
	bullet.speed = speed
	bullet.rotation_speed = speed
	bullet.global_position = position
	masks.add_child(bullet)
	return bullet

func bone(type : Bullet.e_type, position : Vector2, x : float, y : float, speed : float,
offset_top: float, offset_bottom : float, rotation_speed : float, masked = true,
duration : float = -1) -> BBone:
	var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
	bone.masked = masked
	bone.duration = duration
	bone.x = x
	bone.y = y
	bone.speed = speed
	bone.rotation_speed = rotation_speed
	bone.global_position = position
	masks.add_child(bone)
	bone.type = type
	bone.offset_top = offset_top
	bone.offset_bottom = offset_bottom
	return bone

func bone_circle(type : Bullet.e_type, position : Vector2, bone_count : int, radius : float,
rotation_speed : float, masked : bool = true, duration : float = -1) -> BBoneCircle:
	var bone_circle = preload("res://objects/battle/bullets/sans/bone_circle.tscn").instantiate()
	bone_circle.masked = masked
	bone_circle.bone_count = bone_count
	bone_circle.radius = radius
	bone_circle.rotation_speed = rotation_speed
	bone_circle.global_position = position
	bone_circle.duration = duration
	masks.add_child(bone_circle)
	bone_circle.type = type
	return bone_circle

func bone_gravity(type : Bullet.e_type, position : Vector2, bone_count : int, offset_bottom : float,
masked : bool = false, duration : float = -1) -> void:
	for i in range(bone_count):
		var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
		bone.duration = duration
		bone.masked = masked
		bone.global_position = position
		masks.add_child(bone)
		bone.type = type
		bone.offset_bottom = offset_bottom
		bone.gravity_enabled = true

func platform(platform_type : BPlatform.e_platform_type, position : Vector2, x : float,
y : float, speed : float, masked = false, duration : float = -1) -> BPlatform:
	var platform = preload("res://objects/battle/bullets/sans/platform.tscn").instantiate()
	platform.masked = masked
	platform.duration = duration
	platform.x = x
	platform.y = y
	platform.speed = speed
	platform.global_position = position
	masks.add_child(platform)
	platform.platform_type = platform_type
	return platform

func gaster_blaster(type : Bullet.e_type, start_position : Vector2, end_position : Vector2,
end_rotation : float, scale : Vector2, wait_time : float = 0, blast_time : float = 0,
masked = false) -> BGasterBlaster:
	var gaster_blaster = preload("res://objects/battle/bullets/sans/gaster_blaster.tscn").instantiate()
	gaster_blaster.masked = false
	gaster_blaster.scale = scale
	gaster_blaster.wait_time = wait_time
	gaster_blaster.blast_time = blast_time
	gaster_blaster.end_position = end_position
	gaster_blaster.end_rotation = end_rotation
	gaster_blaster.global_position = start_position
	masks.add_child(gaster_blaster)
	gaster_blaster.type = type
	return gaster_blaster

func bone_stab(type : Bullet.e_type, position : Vector2, length : float, height : float,
wait_time : float, up_time : float, bone_rotation : float, masked = true) -> Bullet:
	var bone_stab = preload("res://objects/battle/bullets/sans/bone_stab.tscn").instantiate()
	bone_stab.visible = false
	bone_stab.length = length
	bone_stab.bone_height = height
	bone_stab.wait_time = wait_time
	bone_stab.up_time = up_time
	bone_stab.masked = masked
	bone_stab.global_position = position
	masks.add_child(bone_stab)
	bone_stab.type = type
	bone_stab.bone_rotation = bone_rotation
	bone_stab.visible = true
	return bone_stab

func vector_slash(type : Bullet.e_type, position : Vector2, wait_time : float,
starting_rotation : float, rotation_speed : float, stop_rotation_after : bool, masked = false) -> BVectorSlash:
	var vector_slash = preload("res://objects/battle/bullets/sans/vector_slash.tscn").instantiate()
	vector_slash.global_position = position
	vector_slash.wait_time = wait_time
	vector_slash.rotation_degrees = starting_rotation
	vector_slash.stop_rotation_after = stop_rotation_after
	vector_slash.rotation_speed = rotation_speed
	vector_slash.masked = stop_rotation_after
	masks.add_child(vector_slash)
	vector_slash.type = type
	return vector_slash

func throw(direction : float = 0, fall_speed : float = 750) -> void:
	heart_thrown.emit(direction)
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	vars.player_heart.sprite.rotation = deg_to_rad(direction)
	await get_tree().physics_frame
	vars.player_heart.fall_speed = fall_speed
	vars.player_heart.thrown = true

func black_screen(time : float) -> void:
	vars.black_screen.visible = true
	audio.play("battle/noise")
	var volume = audio.global_volume
	if(is_instance_valid(audio.music)):
		volume = audio.music.volume_db
		audio.music.volume_db = linear_to_db(0.00001)
	await get_tree().create_timer(time).timeout
	vars.black_screen.visible = false
	audio.play("battle/noise")
	if(is_instance_valid(audio.music)):
		audio.music.volume_db = volume

func reset_attack():
	if(is_instance_valid(current_attack)):
		var reinstanced_attack = current_attack.duplicate()
		delete_bullets.emit()
		current_attack.queue_free()
		current_attack = reinstanced_attack
		current_attack.attack_finished.connect(func(): attack_done.emit())
		vars.battle_box.resize_finished.connect(start_resetted_attack)
		add_child(current_attack)
		current_attack.pre_attack()

func start_resetted_attack():
	if(is_instance_valid(current_attack)):
		current_attack.start_attack(); vars.battle_box.resize_finished.disconnect(start_resetted_attack)
