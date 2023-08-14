extends RichTextLabel
class_name Writer

var order := {}

#--------- PROPERTIES ----------
var writer_text = "" :
	set(value):
		text = value
		visible_characters = 0
		parse()
		
		if(!can_write):
			can_write = true

var caller = functions #Incase you want to call any functions from the writer.
var optional_references = [] #Incase you need to reference objects in the writer.

var writing := false

var timeout := 0.0
var can_write := false

var current_sound := "none"
var order_changed := false
var sound_index := 0
var speed := 0.03333333
var paused := false
var delaying : = false
var can_emit_type_done := true
signal delay_done
signal unpaused
signal done
signal line_start
signal type_done
signal cleared
signal type
signal event
var z_enabled := true
var x_enabled := true

var player_character : Character
var border
var face : AnimatedSprite2D

#Just here so Devs can know the options they have, you can use either : or =
const choice_properties = ["delay:time", "speed:time", "font:name", "audio:audio_to_play","music:music_to_play", "size:num","sound:name", "bb:bbcode", "func_funcname:[array of params]", "enable:z or x", "disable:z or x"]
const callable_properties = ["pause", "clear", "pc", "func_funcname"]
const silent_chars  = [' ']

var fonts = {
	"mono" : "res://assets/fonts/main_mono.ttf",
	"sans" : "res://assets/fonts/sans_fixed.tres",
	"papyrus" : "res://assets/fonts/papyrus.ttf",
	}
var sounds = {
	"mono1" : ["characters/SND_TXT1"],
	"mono2" : ["characters/SND_TXT2"],
	"papyrus" : ["characters/papyrus"],
	"sans" : ["characters/sans"],
	"none" : [],
	}

var faces = {
	"none" : null,
	"toriel" : {"glad" : [load("res://assets/sprite_frames/overworld/faces/toriel/glad.tres"), Vector2(2,2)]},
	"sans" : {"normal" : [load("res://assets/sprite_frames/overworld/faces/sans/normal.tres"),Vector2(.2,.2)]}
}
#--------- PROPERTIES ----------
func _ready():
	done.connect(func(): writing = false)
	custom_effects.append(load("res://assets/effects/tremble.tres"))

func adjust_border_position():
	if(is_instance_valid(face)):
		match(face.sprite_frames == null):
			false:
				global_position = face.global_position + Vector2(73,-50)
			true:
				global_position = face.global_position - Vector2(43,50) 

func set_font(new_font : String, new_font_size : int):
	add_theme_font_override("normal_font", load(fonts[new_font]))
	add_theme_font_size_override("normal_font_size", new_font_size)

func get_font_size() -> int:
	return get_theme_font_size("custom_fonts/normal_font")

func parse():
	delaying = false
	var removed_chars = 0
	var added_bb_code = 0
	order_changed = true
	order.clear()
	var property_regex = RegEx.create_from_string("\\(([^\\)]*)(?:(?:\\:|=)([^\\)]*))?\\)")
	if(property_regex.search_all(text).size() >= 1):
		for i in property_regex.search_all(text):
			var temp = [i.get_string(1)]
			if(i.get_string(1).find(":") != -1):
				temp = i.get_string(1).split(":")
			elif(i.get_string(1).find("=") != -1):
				temp = i.get_string(1).split("=")
				
			while(temp.size() < 2):
				temp.append("")
			var property = temp[0]
			var value = temp[1]
			if(property in ["delay", "speed"]): value = float(value)
			elif(property in ["face"]): 
				if(value == "none"):
					value = String(value)
				else:
					value = value.split("/");
			elif(property in ["enable", "disable","sound","audio","music"]): value = String(value)
			elif(property in ["func"]): value = StringName(value)
			elif(property in ["font","size","color"]):
				var start_index = i.get_start() - 1 - removed_chars + added_bb_code
				var bb_code_add = ""
				var temp_string = text.substr(start_index + 3 + len(i.get_string(1)),len(text))
				match(property):
					"font":
						bb_code_add = "[font=" + str(fonts[String(value)]) + "]"
					"size":
						bb_code_add = "[font_size=" + str(value) + "]"
					"color":
						bb_code_add = "[color=" + str(value) + "]"
				removed_chars += len(i.get_string(0))
				added_bb_code += len(bb_code_add)
				text = text.substr(0,start_index + 1) + bb_code_add + temp_string
				continue
			elif(property in ["bb"]):
				var start_index = i.get_start() - 1 - removed_chars + added_bb_code
				var bb_code_add = ""
				var temp_string = text.substr(start_index + 3 + len(i.get_string(1)),len(text))
				bb_code_add = "[" + value + "]"
				removed_chars += len(i.get_string(0))
				added_bb_code += len(bb_code_add)
				text = text.substr(0,start_index + 1) + bb_code_add + temp_string
				continue
				
			
			var start_index = i.get_start() - 1 - removed_chars + added_bb_code
			removed_chars += len(i.get_string(0))
			text = text.substr(0,start_index + 1) + text.substr(start_index + 3 + len(i.get_string(1)),len(text))
			if(!order.has(str(max(start_index - added_bb_code,-99)))):
				order[str(max(start_index - added_bb_code,-99))] = []
			order[str(max(start_index - added_bb_code,-99))].append([property, value])
			if(property in ["clear", "pc"]):
				break
		line_start.emit()
		unpaused.emit()
	order_changed = false
	can_emit_type_done = true
	timeout = speed

func write():
	can_write = false
	if(text.is_empty() && order.is_empty()):
		done.emit()
		return
	await writer_event(max(visible_characters - 1,-1))
	if(order_changed):
		return
	if(visible_characters < len(get_parsed_text())):
		sound_index = wrapi(sound_index,0,sounds[current_sound].size())
		if(get_parsed_text()[visible_characters] not in silent_chars):
			if(current_sound != "none"):
				audio.play(sounds[current_sound][sound_index])
		sound_index = wrapi(sound_index+1,0,sounds[current_sound].size())
		visible_characters += 1
		type.emit()
	if(order.has(str(visible_characters))):
		if(order[str(visible_characters)] not in ["pause", "pc"]):
			can_write = true
	else:
		can_write = true

func writer_event(index):
	var remove = []
	if(order.has(str(index))):
		for i in order[str(index)]:
			if(!str(index) in order):
				break
			if(!order[str(index)].has(i)):
				break
			remove.append(i)
			if(i[0] == "delay"):
				delaying = true
				var delay_func = func():
					var t = 0.0
					while(true):
						t += get_process_delta_time()
						if(!delaying || t >= i[1]): delay_done.emit(); return
						await get_tree().process_frame
				delay_func.call_deferred()
				await delay_done
			elif(i[0] == "speed"):
				speed = i[1]
				delaying = true
				var delay_func = func():
					var t = 0.0
					while(true):
						t += get_process_delta_time()
						if(!delaying || t >= i[1]): delay_done.emit(); return
						await get_tree().process_frame
				delay_func.call_deferred()
				await delay_done
			elif(i[0] == "pause"):
				type_done.emit()
				paused = true
				await unpaused
			elif(i[0] == "sound"):
				current_sound = i[1].to_lower()
			elif(i[0] == "clear"):
				cleared.emit()
				if(text.find("(clear)") != -1):
					var str = text.substr(text.find(get_parsed_text().substr(index + 1,text.find("(pc)"))),len(text))
					writer_text = str
					await line_start
				else:
					writer_text = ""
				visible_characters = 0
			elif(i[0] == "pc"):
				type_done.emit()
				paused = true
				await unpaused
				cleared.emit()
				if(text.find("(pc)") != -1):
					var str = text.substr(text.find(get_parsed_text().substr(index + 1,text.find("(pc)"))),len(text))
					writer_text = str
					await line_start
				else:
					writer_text = ""
				visible_characters = 0
			elif(i[0] == "event"):
				event.emit()
				for connection in event.get_connections():
					event.disconnect(connection["callable"])
			elif(i[0] == "audio"):
				audio.play(i[1])
			elif(i[0] == "music"):
				audio.play_music(i[1])
			elif(i[0] == "enable"):
				set(i[1].to_lower() + "_enabled", true)
			elif(i[0] == "disable"):
				set(i[1].to_lower() + "_enabled", false)
			elif(i[0] == "face"):
				if(is_instance_valid(face)):
					if(i[1] is String):
						if(i[1] == "none"):
							face.set_sprite_frames(null)
					else:
						face.set_sprite_frames(faces[i[1][0]][i[1][1]][0])
						face.scale = faces[i[1][0]][i[1][1]][1]
					adjust_border_position()
					face.play()
			elif(i[0].contains("func_")):
				if(caller.has_method(i[0].split("func_")[1])):
					if(i[1].is_empty()):
						Callable(caller,i[0].split("func_")[1]).call()
					else:
						Callable(caller,i[0].split("func_")[1]).bind(str_to_var(i[1])).call()
	for i in remove:
		order.erase(i)
	timeout = 0
	return

func _process(delta):
	if(Input.is_action_just_pressed("confirm") && z_enabled && paused):
		paused = false
		unpaused.emit()
	if(Input.is_action_just_pressed("exit") && x_enabled):
		if(!paused):
			if(visible_characters != len(text) && visible_characters != -1):
				var found = false
				for i in order:
					for j in order[i]:
						if(j[0] in ["pause", "pc"]):
							found = true
							visible_characters = int(i) + 1
							break
				if(!found):
					visible_characters = len(text)
				delaying = false
	
	timeout += delta
	if(timeout >= speed && !paused && can_write):
		write()
		timeout = 0

func clear_text():
	writer_text = ""
	visible_characters = 0

