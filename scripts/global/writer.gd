extends RichTextLabel
class_name Writer

var order = {}

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

var writing = false

var timeout := 0.0
var can_write := false

var current_sound := "none"
var order_changed := false
var sound_index := 0
var speed = 0.03333333
var paused = false
signal unpaused
signal done
var z_enabled = true
var x_enabled = true

#Just here so Devs can know the options they have, you can use either : or =
const choice_properties = ["delay:time", "speed:time", "font:name", "audio:audio_to_play","music:music_to_play", "size:num","sound:name", "bb:bbcode", "func_funcname:[array of params]", "enable:z or x", "disable:z or x"]
const callable_properties = ["pause", "clear", "pc", "func_funcname"]
const silent_chars  = [' ']

var fonts = {
	"mono" : "res://assets/fonts/main_mono.ttf",
	"sans" : "res://assets/fonts/sans.ttf",
	}
var sounds = {
	"mono1" : ["characters/SND_TXT1"],
	"mono2" : ["characters/SND_TXT2"],
	"papyrus" : ["characters/papyrus"],
	"sans" : ["characters/sans"],
	"none" : [],
	}
#--------- PROPERTIES ----------
func _ready():
	done.connect(func(): writing = false)
	custom_effects.append(load("res://assets/effects/tremble.tres"))

func parse():
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
			elif(property in ["face"]): value = value.split("/"); value[1] = int(value[1])
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
				start_index = clampi(start_index, 0, 9999999)
				continue
			elif(property in ["bb"]):
				var start_index = i.get_start() - 1 - removed_chars + added_bb_code
				var bb_code_add = ""
				var temp_string = text.substr(start_index + 3 + len(i.get_string(1)),len(text))
				bb_code_add = value
				removed_chars += len(i.get_string(0))
				added_bb_code += len(bb_code_add)
				text = text.substr(0,start_index + 1) + bb_code_add + temp_string
				start_index = clampi(start_index, 0, 9999999)
				continue
				
				
			var start_index = i.get_start() - 1 - removed_chars + added_bb_code
			removed_chars += len(i.get_string(0))
			text = text.substr(0,start_index + 1) + text.substr(start_index + 3 + len(i.get_string(1)),len(text))
			start_index = clampi(start_index, 0, 9999999)
			if(!order.has(str(max(start_index - added_bb_code,0)))):
				order[str(max(start_index - added_bb_code,0))] = []
			order[str(max(start_index - added_bb_code,0))].append([property, value])
			if(property in ["clear", "pc"]):
				break
	order_changed = false

func write():
	can_write = false
	if(text.is_empty() && order.is_empty()):
		done.emit()
		return
	await writer_event(max(visible_characters - 1,0))
	if(visible_characters < len(get_parsed_text())):
		sound_index = wrapi(sound_index,0,sounds[current_sound].size())
		if(get_parsed_text()[visible_characters] not in silent_chars):
			if(current_sound != "none"):
				audio.play(sounds[current_sound][sound_index])
		sound_index = wrapi(sound_index+1,0,sounds[current_sound].size())
		visible_characters += 1
	if(order.has(str(visible_characters))):
		if(order[str(visible_characters)] not in ["pause", "pc"]):
			print("PAUSED")
			can_write = true
	else:
		can_write = true

func writer_event(index):
	var remove = []
	var wait_for_speed := true
	if(order.has(str(index))):
		for i in order[str(index)]:
			if(!str(index) in order):
				break
			if(!order[str(index)].has(i)):
				break
			remove.append(i)
			if(i[0] == "delay"):
				wait_for_speed = false
				var temp = x_enabled
				x_enabled = false
				await get_tree().create_timer(i[1]).timeout
				x_enabled = temp
			elif(i[0] == "speed"):
				speed = i[1]
			elif(i[0] == "pause"):
				paused = true
				await unpaused
			elif(i[0] == "sound"):
				current_sound = i[1].to_lower()
			elif(i[0] == "clear"):
				if(text.find("(clear)") != -1):
					var str = text.substr(index + 1,text.find("(pc)"))
					writer_text = str
				else:
					writer_text = ""
				visible_characters = 0
			elif(i[0] == "pc"):
				paused = true
				await unpaused
				if(text.find("(pc)") != -1):
					var str = text.substr(index + 1,text.find("(pc)"))
					writer_text = str
				else:
					writer_text = ""
				visible_characters = 0
			elif(i[0] == "audio"):
				audio.play(i[1])
			elif(i[0] == "music"):
				audio.play_music(i[1])
			elif(i[0] == "enable"):
				set(i[1].to_lower() + "_enabled", true)
			elif(i[0] == "disable"):
				set(i[1].to_lower() + "_enabled", false)
			elif(caller.has_method(i[0].split("func_")[1])):
				if(i[1].is_empty()):
					Callable(caller,i[0].split("func_")[1]).call()
				else:
					Callable(caller,i[0].split("func_")[1]).bind(str_to_var(i[1])).call()
	for i in remove:
		order.erase(i)
	if(wait_for_speed): await get_tree().create_timer(speed).timeout
	return

func _process(delta):
	if(Input.is_action_just_pressed("confirm") && z_enabled):
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
							visible_characters = int(i)
							#writer_event(max(visible_characters - 1,0))
							break
				if(!found):
					visible_characters = len(text)
					#writer_event(max(len(text) - 1,0))
	
	timeout += delta
	if(timeout >= speed && !paused && can_write):
		write()
		timeout = 0

func clear_text():
	writer_text = ""
	visible_characters = 0

