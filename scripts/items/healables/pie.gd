extends Healable
class_name Pie


func _init():
	names = ["Butterscotch Pie", "ButtsPie", "Pie"]
	heals = [99,99,99]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You ate the Pie.\n* Your HP was fully maxed out.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Pie.\n* Your HP was fully maxed out.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie, one slice.(pc)"
