extends Healable
class_name Pie


func _init():
	names = ["Butterscotch Pie", "ButtsPie", "Pie"]
	description = "* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie, one slice."
	heals = [99,99,99]
	type = Item.e_type.heal
	use_text = ["(enable:z)(enable:x)(sound:mono2)* You ate the Pie.(delay:3)\n* Your HP was fully maxed out.(pc)","(enable:z)(enable:x)(sound:mono2)* You ate the Pie.(delay:3)\n* Your HP was fully maxed out.(pc)","(enable:z)(enable:x)(sound:mono2)* You ate the Pie.(delay:3)\n* Your HP was fully maxed out.(pc)"]
