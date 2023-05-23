extends Healable
class_name Pie


func _init():
	names = ["Butterscotch Pie", "ButtsPie", "Pie"]
	description = "* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie, one slice."
	heals = [99,99,99]
	type = Item.e_type.heal
	use_text = ["* You ate the Pie.\n* Your HP was fully maxed out.","* You ate the Pie.\n* Your HP was fully maxed out.","* You ate the Pie.\n* Your HP was fully maxed out."]
