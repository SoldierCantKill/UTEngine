extends Healable
class_name SnowmanPiece

func _init():
	names = ["Snowman Piece","SnowPiece","SnowPiece"]
	description = "* \"Snowman Piece\" - Heals 45 HP\n* Please take this to the\n  ends of the earth."
	heals = [45,45,45]
	type = Item.e_type.heal
	use_text = ["(enable:z)(enable:x)(sound:mono2)* You ate the Snowman Piece.(delay:3)\n" + str(hp_message(45)) + "(pc)", "(enable:z)(enable:x)(sound:mono2)* You ate the Snowman Piece.(delay:3)\n" + str(hp_message(45)) + "(pc)", "(enable:z)(enable:x)(sound:mono2)* You ate the Snowman Piece.(delay:3)\n" + str(hp_message(45)) + "(pc)"]
