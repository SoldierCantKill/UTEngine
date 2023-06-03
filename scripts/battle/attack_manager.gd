extends Node
class_name AttackManager

var turn_num = 0
var attacks = [load("res://scripts/attacks/attack_example.gd")]

var current_attack : Attack = null
signal attack_done
@onready var masks = get_node("buffer/masks")

func set_writer_text():
	pass

func pre_attack():
	pass

func heal_attack():
	pass

func bullet(bullet_path : Variant, position : Vector2, x : float, y : float, speed : float, rotation_speed : float, masked = true) -> Bullet:
	var bullet = bullet_path.instantiate()
	bullet.masked = masked
	bullet.x = x
	bullet.y = y
	bullet.speed = speed
	bullet.rotation_speed = speed
	masks.add_child(bullet)
	bullet.global_position = position
	return bullet

func bone(position : Vector2, x : float, y : float, speed : float, rotation_speed : float, masked = true) -> Bullet:
	var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
	bone.masked = masked
	bone.x = x
	bone.y = y
	bone.speed = speed
	bone.rotation_speed = speed
	masks.add_child(bone)
	bone.global_position = position
	return bone

func gaster_blaster(start_position : Vector2, end_positon : Vector2, end_rotation : float, scale : Vector2, masked = false) -> Bullet:
	var gaster_blaster = preload("res://objects/battle/bullets/sans/gaster_blaster.tscn").instantiate()
	gaster_blaster.masked = false
	gaster_blaster.scale = scale
	gaster_blaster.end_positon = end_positon
	gaster_blaster.end_rotation = end_rotation
	masks.add_child(gaster_blaster)
	gaster_blaster.global_position = start_position
	return gaster_blaster

func bone_stab(position : Vector2, length : float, height : float, wait_time : float, up_time : float, masked = true) -> Bullet:
	var bone_stab = preload("res://objects/battle/bullets/sans/bone_stab.tscn").instantiate()
	bone_stab.length = length
	bone_stab.height = height
	bone_stab.wait_time = wait_time
	bone_stab.up_time = up_time
	bone_stab.masked = masked
	masks.add_child(bone_stab)
	bone_stab.global_position = position
	return bone_stab

func throw(direction : float = 0, fall_speed : float = 500) -> void:
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	await get_tree().create_timer(get_process_delta_time()).timeout
	vars.heart.sprite.rotation = deg_to_rad(direction)
	self.fall_speed = fall_speed
	vars.player_heart.thrown = true
