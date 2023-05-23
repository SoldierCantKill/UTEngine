extends BackBufferCopy

func _process(delta):
	if(is_instance_valid(vars.battle_box)):
		$masks/top_left.global_position = vars.battle_box.get_node("corner_top").global_position
		$masks/top_left.global_rotation = vars.battle_box.get_node("corner_top").global_rotation
		$masks/bottom_right.global_position = vars.battle_box.get_node("corner_bottom").global_position
		$masks/bottom_right.global_rotation = vars.battle_box.get_node("corner_bottom").global_rotation
