extends Area2D
class_name Interactable

signal event_called

func event():
	event_called.emit()
