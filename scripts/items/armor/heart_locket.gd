extends Armor
class_name HeartLocket

func _init():
	names = ["Heart Locket","<--Locket","H.Locket"]
	description = "* \"The Locket\" - Armor DF 99\n* You can feel it beating."
	defense = 99

func get_use_text() -> String:
	if(!vars.hud_manager.serious_mode):
		return "(enable:z)(enable:x)(sound:mono2)* Right where it belongs.(pc)"
	else:
		return "(enable:z)(enable:x)(sound:mono2)* Right where it belongs.(pc)"
