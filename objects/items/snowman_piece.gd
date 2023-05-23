extends Healable
class_name SnowmanPiece

func _init():
	names = ["Snowman Piece","SnowPiece","SnowPiece"]
	description = "* \"Snowman Piece\" - Heals 45 HP\n* Please take this to the\n  ends of the earth."
	heals = [45,45,45]
	type = Item.e_type.heal
	use_text = ["* You ate the Snowman Piece.\n" + str(hp_message(45)), "* You ate the Snowman Piece.\n" + str(hp_message(45)), "* You ate the Snowman Piece.\n" + str(hp_message(45))]
