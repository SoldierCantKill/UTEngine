extends CharacterBody2D
class_name PlayerHeart

enum heart_mode_type {
	red,
	blue
}

var input_enabled = false

var heart_mode : heart_mode_type = heart_mode_type.red

@onready var sprite = $sprite
@onready var animation_player = $animation_player
@onready var hitbox = $hitbox


var speed : float = 2

var i_frames : int = 60 #Invincibility frames
var i_timer : float = 60

var karma_i_frames : float = 2
var karma_i_timer : float = karma_i_frames

var karma_tick_timer : float = 0

var move_input : Vector2 = Vector2.ZERO
var jump_direction : Vector2 = Vector2.ZERO
var jump_input : bool = false
var thrown = false
var throw_dmg : bool = false
var floor_snap : bool = false

var fall_speed : float = 0
var fall_gravity : float = 0
var angle : int = 0

var auto_color : bool = true


func hurt(damage):
	animation_player.play("hurt")
	audio.play("battle/hurt")
	settings.player_save.player.current_hp = max(settings.player_save.player.current_hp - damage, 0)
	i_timer = i_frames
	vars.display.screen_shake(3)
	
func _process(delta):
	i_timer -= delta * 60
	if(i_timer <= 0):
		animation_player.stop()
		modulate.a = 1
	check_hit()
	check_death()
	
func check_hit():
	for i in $hitbox.get_overlapping_areas():
		if(i.owner is Bullet):
			i.owner.hit()

func _physics_process(delta):
	inputs(delta)

func inputs(delta):
	if(input_enabled):
		var temp_speed = speed
		var move_input = Vector2.ZERO
		var move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		var move_y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		if Input.is_action_pressed("exit"):
			temp_speed /= 2
		match(heart_mode):
			heart_mode_type.red:
				sprite.rotation = deg_to_rad(0)
				velocity = Vector2(move_x, move_y) * (temp_speed * 75)
				move_and_slide()
				move_input = velocity
			heart_mode_type.blue:
					var angle = round(rad_to_deg($sprite.rotation))
				
					if fall_speed < 240.0 and fall_speed > 15.0: fall_gravity = 540.0
					if fall_speed <= 15.0 and fall_speed > -30.0: fall_gravity = 180.0
					if fall_speed <= -30.0 and fall_speed > -120: fall_gravity = 450.0
					if fall_speed <= -120.0: fall_gravity = 180.0
					
					fall_speed += fall_gravity * delta
					
					if angle == 0 or angle == 180:
						jump_input = Input.is_action_pressed("up") if angle == 0 else Input.is_action_pressed("down")
						move_input = Vector2(move_x * (speed * 75), fall_speed * (-1 if angle == 180 else 1))
						jump_direction = Vector2.UP if angle == 0 else Vector2.DOWN
					
					if angle == 90 or angle == 270:
						jump_input = Input.is_action_pressed("left") if angle == 270 else Input.is_action_pressed("right")
						move_input = Vector2(fall_speed * (-1 if angle == 90 else 1), move_y * (speed * 75))
						jump_direction = Vector2.LEFT if angle == 270 else Vector2.RIGHT
					
					if !is_on_floor(): floor_snap = false
					if is_on_floor() or (is_on_ceiling() and fall_speed <= 0.0):
						if thrown:
							thrown = false
							vars.display.ScreenShake(floor(abs(fall_speed / 30.0 / 3.0)))
							audio.play("Battle/impact")
						
						fall_speed = 0
						if is_on_floor() and jump_input:
							floor_snap = false
							fall_speed = -180.0
					elif !jump_input and fall_speed <= -30.0: fall_speed = -30.0
					
					set_velocity(move_input)
					# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `jump_direction * -2 if floor_snap else Vector2.ZERO`
					set_up_direction(jump_direction)
					set_floor_stop_on_slope_enabled(true)
					move_and_slide()
					move_input = velocity
					if is_on_floor() and not floor_snap: floor_snap = true

func check_death():
	if(settings.player_save.player.current_hp <= 0):
		print("DEAD")
