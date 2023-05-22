extends RichTextLabel
class_name Writer

var order = {}

#--------- PROPERTIES ----------
var writer_text = "" :
	set(value):
		text = value
		visible_characters = 0
		parse()
		
		if(!writing):
			write()
			writing = true

var caller = functions #Incase you want to call any functions from the writer.
var optional_references = [] #Incase you need to reference objects in the writer.

var writing = false

var timeout := 0.0
var can_write := true

var speed = 0.03333333
var paused = false
signal unpaused
signal done
var z_enabled = true
var x_enabled = true

#Just here so Devs can know the options they have
const choice_properties = ["delay:time", "speed:time", "font:name", "size:num", "func_funcname:[param param param]", "enable:z or x", "disable:z or x"]
const callable_properties = ["pause", "clear", "pc", "func_funcname"]

var fonts = {
	"sans" : "res://assets/fonts/sans.ttf"
	}
#--------- PROPERTIES ----------
func parse():
	var removed_chars = 0
	var added_bb_code = 0
	order.clear()
	var property_regex = RegEx.create_from_string("\\(([^\\)]*)\\)")
	if(property_regex.search_all(text).size() >= 1):
		for i in property_regex.search_all(text):
			var temp = i.get_string(1).split(":")
			while(temp.size() < 2):
				temp.append("")
				
			var property = temp[0]
			var value = temp[1]
			if property in ["delay", "speed"]: value = float(value)
			elif property in ["face"]: value = value.split("/"); value[1] = int(value[1])
			elif property in ["enable", "disable"]: value = String(value)
			elif property in ["func"]: value = StringName(value)
			elif property in ["font","size"]:
				var start_index = i.get_start() - 1 - removed_chars + added_bb_code
				var bb_code_add = ""
				
				var temp_string = text.substr(start_index + 3 + len(i.get_string(1)),len(text))
				match(property):
					"font":
						bb_code_add = "[font=" + str(fonts[String(value)]) + "]"
					"size":
						bb_code_add = "[font_size=" + str(value) + "]"
				removed_chars += len(i.get_string(0))
				added_bb_code += len(bb_code_add)
				text = text.substr(0,start_index + 1) + bb_code_add + temp_string
				start_index = clampi(start_index, 0, 9999999)
				continue
			
			var start_index = i.get_start() - 1 - removed_chars + added_bb_code
			removed_chars += len(i.get_string(0))
			
			text = text.substr(0,start_index + 1) + text.substr(start_index + 3 + len(i.get_string(1)),len(text))
			
			start_index = clampi(start_index, 0, 9999999)
			if(!order.has(str(start_index - added_bb_code))):
				order[str(start_index - added_bb_code)] = []
			order[str(start_index - added_bb_code)].append([property, value])
			
			if(property in ["clear", "pc"]):
				break

func write():
	can_write = false
	if(text.is_empty() && order.is_empty()):
		done.emit()
		return
	if(visible_characters < len(text)):
		visible_characters += 1
	await writer_event(clampi(visible_characters - 1, 0, 9999999))
	can_write = true

func writer_event(index):
	var remove = []
	var wait_for_speed := true
	if(order.has(str(index))):
		for i in order[str(index)]:
			remove.append(i)
			if(i[0] == "delay"):
				wait_for_speed = false
				await get_tree().create_timer(i[1]).timeout
			elif(i[0] == "speed"):
				speed = i[1]
			elif(i[0] == "pause"):
				paused = true
				await unpaused
			elif(i[0] == "clear"):
				writer_text = text.right(-(index + 1))
				visible_characters = 0
			elif(i[0] == "pc"):
				paused = true
				await unpaused
				writer_text = text.right(-(index + 1))
				visible_characters = 0
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
						if(j[0] == "pause"):
							found = true
							visible_characters = int(i) + 1
							writer_event(visible_characters - 1)
							break
				if(!found):
					visible_characters = len(text)
	
	timeout += delta
	if(timeout >= speed && !paused && can_write):
		write()
		timeout = 0

func _ready():
	done.connect(func(): writing = false)
