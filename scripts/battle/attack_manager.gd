extends Node
class_name AttackManager

var turn_num = 0
var attacks = [load("res://scripts/battle/attacks/attack_base.gd")]
var heal_attacks = [load("res://scripts/battle/attacks/attack_base.gd")]

var current_attack : Attack = null
signal delete_bullets
signal attack_done
@onready var masks = get_node("buffer/masks")

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

func bullet(bullet_path : Variant, position : Vector2, x : float, y : float, speed : float, rotation_speed : float, masked = true, duration : float = -1) -> Bullet:
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

func bone(position : Vector2, x : float, y : float, speed : float, offset_top: float, offset_bottom : float, rotation_speed : float, masked = true, duration : float = -1) -> Bullet:
	var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
	bone.masked = masked
	bone.duration = duration
	bone.x = x
	bone.y = y
	bone.speed = speed
	bone.rotation_speed = rotation_speed
	bone.global_position = position
	masks.add_child(bone)
	bone.offset_top = offset_top
	bone.offset_bottom = offset_bottom
	return bone

func platform(position : Vector2, x : float, y : float, speed : float, platform_type = Platform.e_platform_type.stick, masked = false, duration : float = -1) -> Bullet:
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

func gaster_blaster(start_position : Vector2, end_position : Vector2, end_rotation : float, scale : Vector2, masked = false) -> Bullet:
	var gaster_blaster = preload("res://objects/battle/bullets/sans/gaster_blaster.tscn").instantiate()
	gaster_blaster.masked = false
	gaster_blaster.scale = scale
	#gaster_blaster.blast_time = 60
	#gaster_blaster.blast_timer = 60
	gaster_blaster.end_position = end_position
	gaster_blaster.end_rotation = end_rotation
	gaster_blaster.global_position = start_position
	masks.add_child(gaster_blaster)
	return gaster_blaster

func bone_stab(position : Vector2, length : float, height : float, wait_time : float, up_time : float, bone_rotation : float, masked = true) -> Bullet:
	var bone_stab = preload("res://objects/battle/bullets/sans/bone_stab.tscn").instantiate()
	bone_stab.visible = false
	bone_stab.length = length
	bone_stab.bone_height = height
	bone_stab.wait_time = wait_time
	bone_stab.up_time = up_time
	bone_stab.masked = masked
	bone_stab.global_position = position
	masks.add_child(bone_stab)
	bone_stab.bone_rotation = bone_rotation
	await get_tree().process_frame
	bone_stab.visible = true
	return bone_stab

func throw(direction : float = 0, fall_speed : float = 500) -> void:
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	await get_tree().process_frame
	vars.player_heart.sprite.rotation = deg_to_rad(direction)
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
