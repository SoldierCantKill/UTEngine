extends Node2D
class_name Debug

@onready var text := $text
var enabled := false
var time_elasped := 0.01

func _ready():
	vars.debug = self
	visible = false

func _process(delta):
	time_elasped += (time_elasped * (delta / time_elasped))
	debug()

func debug():
	if(Input.is_action_just_pressed("debug") && settings.debug_enabled):
		enabled = !enabled
		visible = enabled
	if(visible):
		if(Input.is_action_pressed("turn_changer")):
			if(Input.is_action_just_pressed("right")):
				if(is_instance_valid(vars.attack_manager)):
					(vars as vars).attack_manager.turn_num += 1
			if(Input.is_action_just_pressed("left")):
					(vars as vars).attack_manager.turn_num -= 1
		if(Input.is_action_just_pressed("reset_attack")):
			if(is_instance_valid(vars.attack_manager)):
				if(is_instance_valid((vars as vars).attack_manager.current_attack)):
					(vars as vars).attack_manager.reset_attack()
		if(Input.is_action_just_pressed("end_attack")):
			if(is_instance_valid((vars as vars).attack_manager.current_attack)):
				(vars as vars).attack_manager.current_attack.end_attack()
				(vars as vars).attack_manager.delete_bullets.emit()
		text.visible = true
		var string = "Engine By Soldier\n"
		string += "HP = Infinite\n"
		string += str("FPS = " + str(Engine.get_frames_per_second())) + "\n"
		string += str("Timer = " + str(snapped(time_elasped, 0.01))) + "\n"
		if(is_instance_valid(vars.attack_manager)):
			if(!is_instance_valid(vars.attack_manager.current_attack)):
				string += "Status : Not Attacking\n"
				string += "Attack Counter : 0\n"
			else:
				string += "Status : Attacking\n"
				string += "Attack Counter : " + str(int((vars as vars).attack_manager.current_attack.current_frames)) + "\n"
			string += "Current Turn : " + str((vars as vars).attack_manager.turn_num) + "\n"
			string += "Bullet Instances: " + str((vars as vars).attack_manager.masks.get_child_count() - 2) + "\n"
		text.text = string
		
