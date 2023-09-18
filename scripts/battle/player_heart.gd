extends CharacterBody2D
class_name PlayerHeart

enum e_heart_mode {
	red,
	blue
	}

signal thrown_impact

var auto_change_color := true
var input_enabled := false
var heart_mode : e_heart_mode = e_heart_mode.red :
	set(value):
		heart_mode = value
		fall_speed = 0.0
		fall_gravity = 0.0
		jump_input = false
		if(auto_change_color):
			change_heart_color()
@onready var sprite = $sprite
@onready var hitbox = $hitbox
var speed := 2.0
const static_speed := 60.0 #Used to multiply with speed
var i_frames := 60.0 #Invincibility frames
var i_timer := 0.0
var karma_i_frames := 2.0
var karma_i_timer := 0.0
var karma_tick_timer := 0.0 #Ticks karma away depending on how much karma you have.
var move_input := Vector2.ZERO
var jump_direction := Vector2.ZERO
var jump_input := false
var thrown := false
var throw_dmg := false
var floor_snap := false
var fall_speed := 0.0
var fall_gravity := 0.0
var angle := 0
var auto_color := true

func _ready():
	floor_stop_on_slope = true

func hurt(damage : float):
	audio.play("battle/hurt")
	settings.player_save.player.current_hp = max(settings.player_save.player.current_hp - damage, 0)
	i_timer = i_frames
	vars.display.screen_shake(3)

func hurt_kr(damage):
	audio.play("battle/hurt")
	karma_i_timer = karma_i_frames
	if(settings.player_save.player.current_hp > 1):
		if(settings.player_save.player.current_kr <= 40):
			settings.player_save.player.current_kr = max(0,settings.player_save.player.current_kr + damage)
			settings.player_save.player.current_hp = max(1,settings.player_save.player.current_hp - (damage + 1))
		else:
			settings.player_save.player.current_hp = max(0,settings.player_save.player.current_hp - 1)
	else:
		if(settings.player_save.player.current_kr > 0):
			settings.player_save.player.current_kr = max(0,settings.player_save.player.current_kr - 1)
		else:
			settings.player_save.player.current_hp = 0

func _process(delta : float):
	check_hit()
	check_death()
	tick(delta)

func tick(delta):
	i_timer -= delta * 60
	if(i_timer <= 0):
		modulate.a = 1
	else:
		modulate.a = wrapf(modulate.a + delta * 2,0,1)
	karma_i_timer -= delta * 60
	karma_tick_timer += delta * 60
	if(karma_tick_timer > 1):
		if(settings.player_save.player.current_kr >= 40):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 2):
		if(settings.player_save.player.current_kr >= 30 && settings.player_save.player.current_kr <= 39):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 5):
		if(settings.player_save.player.current_kr >= 20 && settings.player_save.player.current_kr <= 29):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 15):
		if(settings.player_save.player.current_kr >= 10 && settings.player_save.player.current_kr <= 19):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 30):
		if(settings.player_save.player.current_kr>= 1 && settings.player_save.player.current_kr <= 9):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0

func check_hit():
	for i in $hitbox.get_overlapping_areas():
		if(i.owner is Bullet):
			i.owner.hit()

func _physics_process(delta):
	inputs(delta)

func change_heart_color():
	match(heart_mode):
		e_heart_mode.red:
			sprite.self_modulate = Color(1,0,0,sprite.self_modulate.a)
		e_heart_mode.blue:
			sprite.self_modulate = Color(0,0,1,sprite.self_modulate.a)

func inputs(delta):
	var temp_speed = speed
	var move_input = Vector2.ZERO
	var move_x = 0.0
	var move_y = 0.0
	if(input_enabled):
		move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		move_y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		if(Input.is_action_pressed("exit")):
			temp_speed /= 2
	match(heart_mode):
		e_heart_mode.red:
			sprite.rotation = deg_to_rad(0)
			velocity = Vector2(move_x, move_y) * temp_speed * static_speed
			move_and_slide()
			move_input = velocity
		e_heart_mode.blue:
			var angle = round(rad_to_deg($sprite.rotation))
			if(fall_speed < 240.0 && fall_speed > 15.0): fall_gravity = 540.0
			if(fall_speed <= 15.0 && fall_speed > -30.0): fall_gravity = 180.0
			if(fall_speed <= -30.0 && fall_speed > -120): fall_gravity = 450.0
			if(fall_speed <= -120.0): fall_gravity = 180.0
			
			if(!is_on_floor()):
				fall_speed += fall_gravity * delta
			else:
				if(!jump_input && !thrown):
					fall_speed = 0.0
				
			if(angle == 0 || angle == 180):
				if(input_enabled):
					jump_input = Input.is_action_pressed("up") if(angle == 0) else Input.is_action_pressed("down")
				move_input = Vector2(move_x * temp_speed * static_speed, fall_speed * (-1 if(angle == 180) else 1))
				jump_direction = Vector2.UP if(angle == 0) else Vector2.DOWN
				
			if(angle == 90 || angle == 270):
				if(input_enabled):
					jump_input = Input.is_action_pressed("left") if(angle == 270) else Input.is_action_pressed("right")
				move_input = Vector2(fall_speed * (-1 if(angle == 90) else 1), move_y * (temp_speed * static_speed))
				jump_direction = Vector2.LEFT if(angle == 270) else Vector2.RIGHT
			
			up_direction = jump_direction
			velocity = move_input
			move_and_slide()
			
			if(!is_on_ceiling()):
				if(is_on_floor() && jump_input && !thrown):
					floor_snap = false
					fall_speed = -180.0
				elif(!jump_input && fall_speed <= -30.0):
					fall_speed = -30.0
			else:
				if(!thrown):
					fall_speed = 0.0
			
			velocity = Vector2.ZERO
			move_and_slide()
			
			if(is_on_floor()):
				if(thrown):
					thrown = false
					vars.display.screen_shake(floor(abs(fall_speed / 30.0 / 3.0)))
					audio.play("battle/impact")
					thrown_impact.emit()

func check_death():
	if(settings.player_save.player.current_hp <= 0):
		settings.death_position = global_position
		vars.display.change_scene(preload("res://scenes/game_over.tscn"))

func is_moving():
	match(heart_mode):
		e_heart_mode.red:
			var move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			var move_y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
			if(move_y != 0 || move_x != 0):
				return true
		e_heart_mode.blue:
			var move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			var angle = round(rad_to_deg(sprite.rotation))
			if(fall_speed < 240.0 && fall_speed > 15.0): fall_gravity = 540.0
			if(fall_speed <= 15.0 && fall_speed > -30.0): fall_gravity = 180.0
			if(fall_speed <= -30.0 && fall_speed > -120): fall_gravity = 450.0
			if(fall_speed <= -120.0): fall_gravity = 180.0
			
			if(angle == 0 || angle == 180):
				jump_input = Input.is_action_pressed("up") if(angle == 0) else Input.is_action_pressed("down")
			if(angle == 90 || angle == 270):
				jump_input = Input.is_action_pressed("left") if(angle == 270) else Input.is_action_pressed("right")
			
			if(jump_input != false || move_x != 0 || fall_speed > 1):
				return true
			return false
	return false
