extends Node2D
class_name Enemy

enum e_dodge {
	none,
	dodge,
}


@onready var sprite = null
@onready var damage_anchor : Node = null
@onready var speech_bubble = $speech_bubble
@onready var speech_writer = $speech_bubble/speech_writer

var enemy_name : String
var current_hp : int
var max_hp : int
var def : float
var dodge : e_dodge
var border_stick : bool = true
var offset : int = 0 #Offset for border stick

var show_health_bar : bool = true

signal done_being_attacked

var act_options = {
	"Check" : check,
	}

func _init(enemy_name : String, hp : int, df : float):
	self.enemy_name = enemy_name
	self.current_hp = hp
	self.max_hp = hp
	self.def = def

func attack(damage : float):
	if(damage > 0):
		match(dodge):
			e_dodge.none:
				attack_normal()
			e_dodge.dodge:
				attack_dodge()
	else:
		attack_no_damage()

func attack_normal():
	await vars.hud_manager.eye.knife.animation_finished
	audio.play("battle/hit")
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * scale.x, 15)
	bar_max.z_index = 5
	bar.z_index = 5
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_max.add_child(bar)
	vars.scene.add_child(bar_max)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	current_hp = clampf(current_hp - damage,0,max_hp)
	get_tree().create_tween().tween_property(bar, "size", Vector2((float(current_hp) / max_hp) * texture.get_size().x * scale.x, 15), .25)
	bar_max.visible = show_health_bar
	var damage_text : RichTextLabel = create_text("[center]"+ str(int(damage)))
	damage_text.self_modulate = Color(1, 0, 0, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,60)
	var damage_move = get_tree().create_tween()
	damage_move.tween_property(damage_text, "global_position", damage_text.global_position - Vector2(0,30),.45).set_trans(Tween.TRANS_LINEAR)
	damage_move.tween_property(damage_text, "global_position", damage_text.global_position,.45).set_trans(Tween.TRANS_LINEAR)
	var pos : Vector2 = position
	var shake_intensity = 15
	for i in range(shake_intensity):
		position.x = pos.x + shake_intensity
		shake_intensity = shake_intensity * -0.8
		await get_tree().create_timer(.05).timeout
	position = pos
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	post_attack()

func attack_dodge():
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * scale.x, 15)
	bar_max.z_index = 5
	bar.z_index = 5
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_max.add_child(bar)
	vars.scene.add_child(bar_max)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	var damage_text : RichTextLabel = create_text("[center]MISS")
	damage_text.self_modulate = Color(.7, .7, .7, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,60)
	bar_max.visible = false
	damage_text.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",global_position - Vector2(100,0), .3).set_trans(Tween.TRANS_LINEAR)
	await vars.hud_manager.eye.knife.animation_finished
	bar_max.visible = show_health_bar
	damage_text.visible = true
	var damage_move = get_tree().create_tween()
	damage_move.tween_property(damage_text, "global_position", damage_text.global_position - Vector2(0,30),.45).set_trans(Tween.TRANS_LINEAR)
	damage_move.tween_property(damage_text, "global_position", damage_text.global_position,.45).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(.9).timeout
	tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",global_position + Vector2(100,0), .3).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	post_attack()

func attack_no_damage():
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * scale.x, 15)
	bar_max.z_index = 5
	bar.z_index = 5
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_max.add_child(bar)
	vars.scene.add_child(bar_max)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_max.visible = show_health_bar
	var damage_text : RichTextLabel = create_text("[center]MISS")
	damage_text.self_modulate = Color(.7, .7, .7, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,60)
	await get_tree().create_timer(.75).timeout
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	post_attack()

func post_attack():
	done_being_attacked.emit()
	if(current_hp <= 0):
		death()
	else:
		vars.attack_manager.pre_attack()
		vars.dialouge_manager.start()
		await vars.dialouge_manager.done
		vars.attack_manager.current_attack.start_attack()

func death():
	var dust_enemy = load("res://objects/battle/dusted_enemy.tscn").instantiate()
	dust_enemy.set_texture(sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame()))
	vars.scene.add_child(dust_enemy)
	dust_enemy.global_position = sprite.global_position
	dust_enemy.Start()
	queue_free()

func create_text(text : String):
	var textblock = RichTextLabel.new()
	textblock.bbcode_enabled = true
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	textblock.size = Vector2(texture.get_size().x * scale.x, 15)
	textblock.add_theme_font_override("normal_font", load("res://assets/fonts/damage.ttf"))
	textblock.add_theme_font_size_override("normal_font_size", 28)
	textblock.set("theme_override_colors/font_outline_color", Color(0,0,0,1))
	textblock.set("theme_override_constants/outline_size", 10)
	textblock.z_index = 1
	textblock.clip_contents = false
	textblock.scroll_active = false
	textblock.autowrap_mode = TextServer.AUTOWRAP_OFF
	owner.add_child(textblock)
	textblock.text = text
	return textblock

func check():
	vars.hud_manager.mode = -1
	vars.player_heart.visible = false
	vars.main_writer.writer_text = "(enable:z)(sound:mono2)* Enemy 1 ATK 1 DEF\n  Example Text.(pc)"
	await vars.main_writer.done
	vars.hud_manager.reset()
