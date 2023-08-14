extends Armor
class_name HeartLocket

func _init():
	names = ["The Locket","<--Locket","H.Locket"]
	defense = 99

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* Right where it belongs.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* Right where it belongs.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"The Locket\" - Armor DF 99\n* You can feel it beating.(pc)"
