extends RichTextEffect

var bbcode = "tremble"

func _process_custom_fx(char_fx):
	var freq = char_fx.env.get("freq", 0.0)
	var chance = char_fx.env.get("chance", 0)
	
	randomize()
	
	var randomBool: = bool(randi() % 101 < chance)
	var randomVector : = Vector2( randf_range(-freq, freq), randf_range(-freq, freq) )
	
	if randomBool: char_fx.offset = randomVector
	return true
