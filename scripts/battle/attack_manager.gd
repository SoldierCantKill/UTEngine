extends Node
class_name AttackManager

func set_writer_text():
	vars.main_writer.set_options(false,true,false)
	vars.main_writer.message_text(["* Test enemy text"])
