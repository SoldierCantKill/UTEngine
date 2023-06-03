extends Node
class_name DialougeManager

signal done

func start():
	var enemy = vars.enemies.get_child(0)
	enemy.speech_bubble.visible = true
	enemy.speech_writer.writer_text = "(font:mono)(sound:mono1)how are you?(pc)"
	await enemy.speech_writer.done
	enemy.speech_bubble.visible = false
	done.emit()
