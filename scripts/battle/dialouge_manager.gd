extends Node
class_name DialougeManager

signal done

func _ready():
	pass

func start():
	done.emit()
