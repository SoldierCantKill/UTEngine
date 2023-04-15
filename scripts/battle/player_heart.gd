extends CharacterBody2D
class_name PlayerHeart

enum heart_mode_type {
	red,
	blue
}

var input_enabled = false

var heart_mode : heart_mode_type = heart_mode_type.red

@onready var sprite = $sprite
@onready var hit_animation = $hit_animation

var speed : float = 2

var invincibility_frames : int = 60
var invincibility_timer : float = invincibility_frames
var karma_frames : float = 2
var karma_timer : float = karma_frames


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
