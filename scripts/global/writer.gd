extends RichTextLabel
class_name Writer

signal text_index_finished
var can_text_index_finished : bool = false
signal text_finished
var can_text_finished : bool = false
signal text_close
signal text_next

var active : bool = false
var is_writing : bool = false

var text_array : Array
var unformattedtext : String
var text_index : int = 0
var sound_index : int = 0
var char_index : int = -1
var font : String
var sound : String
var speed_timer : float = 0
var speed : float
var temp_speed : float

var continue_enabled : bool = true # Z
var skip_enabled : bool = true # X

var dialouge_mode : bool = false #This still works if continute and skip are enabled... BEWARE!
var dialouge_timer : float = 3

var fonts = {
	"Mono" : "res://assets/fonts/main_mono.ttf",
	"Sans" : "res://assets/fonts/sans.ttf",
	"DT_Sans" : "res://assets/fonts/main.ttf",
	"Papyrus" : "res://assets/fonts/papyrus-font-undertale.ttf",
	}

var sounds = {
	"None" : [""],
	"Mono1" : ["characters/SND_TXT1"],
	"Mono2" : ["characters/SND_TXT2"],
	"Sans" : ["characters/sans"],
	"Toriel" : ["characters/toriel"],
	"Papyrus" : ["characters/papyrus"],
	"Flowey2" : ["characters/snd_floweytalk2"]
	}

func _init()  -> void:
	bbcode_enabled = true

func _ready()  -> void:
	var tremble_resource = RichTextEffect.new()
	tremble_resource.set_script(load("res://assets/effects/tremble.gd"))
	custom_effects.append(tremble_resource)

func set_options(continue_enabled : bool, skip_enabled : bool, dialouge_mode : bool)  -> void:
	self.continue_enabled = continue_enabled #Z
	self.skip_enabled = skip_enabled #X
	self.dialouge_mode = dialouge_mode #Dusttrust animation cutscene #5559

#You'll need to make it unskippable and uncontinuable using SetOptions().
func message_text(text : Array, sound : String = "Mono2", font : String = "Mono", font_size : int = 31, speed : float = 0.033333)  -> void:
	self.text = ""
	text_array = text
	self.speed = speed
	self.sound = sound
	add_theme_font_override("normal_font", load(fonts[font]))
	add_theme_font_size_override("normal_font_size", font_size)
	text_index = -1
	reset()

func _process(delta) -> void:
	if(is_writing):
		speed_timer += (temp_speed * (delta / temp_speed))
		if speed_timer >= temp_speed:
			speed_timer = 0
			temp_speed = speed
			write()
		if(Input.is_action_just_pressed("exit") && skip_enabled && text != ""):
			
			is_writing = false
			visible_characters = -1
			
	if(text_array != [] && active):
		if(Input.is_action_just_pressed("confirm") && continue_enabled):
			if(visible_characters == get_parsed_text().length() || visible_characters == -1):
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout
				reset()
				
		if(visible_characters == get_parsed_text().length() || visible_characters == -1):
			if(can_text_index_finished):
				can_text_index_finished = false
				text_index_finished.emit()
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout
					reset()
		if(visible_characters == get_parsed_text().length() || visible_characters == -1):
			if(text == text_array[text_array.size() - 1].replace("&", "") && can_text_finished):
				can_text_finished = false
				text_finished.emit()
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout

func write() -> void:
	char_index += 1
	if char_index >= unformattedtext.length() - 1:
		is_writing = false
	if !(
			unformattedtext[char_index] == "" or
			unformattedtext[char_index] == " " or
			unformattedtext[char_index] == "^" or
			unformattedtext[char_index] == "!" or
			unformattedtext[char_index] == "?" or
			unformattedtext[char_index] == "," or
			unformattedtext[char_index] == ":" or
			unformattedtext[char_index] == "/" or
			unformattedtext[char_index] == "\\" or
			unformattedtext[char_index] == "|" or
			unformattedtext[char_index] == "*" or
			unformattedtext[char_index] == "~"
		):
		if (unformattedtext[char_index] == '&'):
			temp_speed = .25
			return
		
		if(is_valid_char(char_index - 1)):
			if(unformattedtext[char_index - 1] != '~'):
				if(sounds[sound][0] != ""):
					audio.play(sounds[sound][0])
			else:
				return
		else:
			if(sounds[sound][0] != ""):
					audio.play(sounds[sound][0])
		#sound_index = wrapi(sound_index + 1, 0, sounds[sound].size())
	visible_characters += 1

func is_valid_char(num : int) -> bool:
	return num > -1 && num < unformattedtext.length()

func clear_text()  -> void: #Can be called by the developer
	active = false
	is_writing = false
	text_index = 0
	sound_index = 0
	text = ""
	text_array = []

func reset()  -> void: #Should only be called via this script.
	await get_tree().process_frame
	is_writing = true
	text_index += 1
	sound_index = 0
	char_index = -1
	visible_characters = 0
	temp_speed = speed
	if text_array.size() > text_index:
		text = text_array[text_index]
		unformattedtext = get_parsed_text()
		text = text.replace("&", "")
		text = text.replace("~", "")
		can_text_index_finished = true
		can_text_finished = true
		active = true
		text_next.emit()
	else:
		clear_text()
		text_close.emit()
