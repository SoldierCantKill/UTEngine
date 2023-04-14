extends RichTextLabel


signal text_index_finished
var can_text_index_finished : bool = false
signal text_finished
var can_text_finished : bool = false
signal text_close
signal text_next

var active : bool = false
var is_writing : bool = false

var overworld_border : CanvasItem = null
var character_face : CanvasItem = null

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
	"Mono" : "res://Fonts/main_mono.ttf",
	"Sans" : "res://Fonts/sans.ttf",
	"DT_Sans" : "res://Fonts/main.ttf",
	"Papyrus" : "res://Fonts/papyrus-font-undertale.ttf",
	}

var sounds = {
	"None" : [""],
	"Mono1" : ["Characters/SND_TXT1"],
	"Mono2" : ["Characters/SND_TXT2"],
	"Sans" : ["Characters/sans"],
	"Toriel" : ["Characters/toriel"],
	"Papyrus" : ["Characters/papyrus"],
	"Flowey2" : ["Characters/snd_floweytalk2"]
	}

var character_faces = {
	"Toriel" : {"Speak1" : "res://Animations/Talking/Toriel/Speak1.tres"}
	}

func _init()  -> void:
	bbcode_enabled = true

func _ready()  -> void:
	text_index_finished.connect(SpriteIdle)
	var tremble_resource = RichTextEffect.new()
	tremble_resource.set_script(load("res://assets/effects/tremble.gd"))
	custom_effects.append(tremble_resource)

func SetOptions(continue_enabled : bool, skip_enabled : bool, dialouge_mode : bool)  -> void:
	self.continue_enabled = continue_enabled #Z
	self.skip_enabled = skip_enabled #X
	self.dialouge_mode = dialouge_mode #Dusttrust animation cutscene #5559

#You'll need to make it unskippable and uncontinuable using SetOptions().
func MessageText(text : Array, sound : String = "Mono1", font : String = "Mono", font_size : int = 31, speed : float = 0.033333)  -> void:
	self.text = ""
	text_array = text
	self.speed = speed
	self.sound = sound
	add_theme_font_override("normal_font", load(fonts[font]))
	add_theme_font_size_override("normal_font_size", font_size)
	text_index = -1
	Reset()

func OWText(text : Array, pos : String = "Bottom", sound : String = "Mono1", font : String = "Mono", font_size : int = 31, speed : float = 0.033333)  -> void:
	if(is_instance_valid(character_face)):
		character_face.sprite_frames = null
	BoxToggle(true, pos)
	self.text = ""
	text_array = text
	self.speed = speed
	self.sound = sound
	add_theme_font_override("normal_font", load(fonts[font]))
	add_theme_font_size_override("normal_font_size", font_size)
	text_index = -1
	Reset()
	
func CharacterText(text : Array, character : String, expression : String, pos : String = "Bottom", sound : String = "Mono1", font : String = "Mono", font_size = 31, speed : float = 0.033333)  -> void:
	if(is_instance_valid(character_face)):
		character_face.sprite_frames = load(str(character_faces[character][expression]))
	BoxToggle(true, pos)
	self.text = ""
	text_array = text
	self.speed = speed
	self.sound = sound
	add_theme_font_override("normal_font", load(fonts[font]))
	add_theme_font_size_override("normal_font_size", font_size)
	text_index = -1
	Reset()

func BoxToggle(visible : bool, pos : String = "Bottom"):
	if(is_instance_valid(overworld_border) && is_instance_valid(character_face)):
		overworld_border.visible = visible
		overworld_border.global_position = Vector2(35, 325) if pos == "Bottom" else Vector2(35, 30) if pos == "Top" else Vector2(0, 0)
		if(!character_face.sprite_frames):
			position = Vector2(27.5,20)
		else:
			position = Vector2(143,20)

func SpriteTalk():
	if(is_instance_valid(character_face)):
		character_face.animation = "speaking"
		character_face.play()

func SpriteIdle():
	if(is_instance_valid(character_face)):
		character_face.animation = "idle"
		character_face.play()

func _process(delta) -> void:
	if(is_writing):
		speed_timer += (temp_speed * (delta / temp_speed))
		if speed_timer >= temp_speed:
			speed_timer = 0
			temp_speed = speed
			Write()
		if(Input.is_action_just_pressed("exit") && skip_enabled && text != ""):
			
			is_writing = false
			visible_characters = -1
			
	if(text_array != [] && active):
		if(Input.is_action_just_pressed("confirm") && continue_enabled):
			if(visible_characters == get_parsed_text().length() || visible_characters == -1):
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout
				Reset()
				
		if(visible_characters == get_parsed_text().length() || visible_characters == -1):
			if(can_text_index_finished):
				can_text_index_finished = false
				text_index_finished.emit()
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout
					Reset()
		if(visible_characters == get_parsed_text().length() || visible_characters == -1):
			if(text == text_array[text_array.size() - 1].replace("&", "") && can_text_finished):
				can_text_finished = false
				text_finished.emit()
				if(dialouge_mode):
					await get_tree().create_timer(dialouge_timer).timeout

func Write() -> void:
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
		
		if(IsValidChar(char_index - 1)):
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

func IsValidChar(num : int) -> bool:
	return num > -1 && num < unformattedtext.length()

func Clear()  -> void: #Can be called by the developer
	active = false
	BoxToggle(false)
	is_writing = false
	text_index = 0
	sound_index = 0
	text = ""
	text_array = []

func Reset()  -> void: #Should only be called via this script.
	await get_tree().create_timer(get_process_delta_time()).timeout
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
		SpriteTalk()
		text_next.emit()
	else:
		Clear()
		text_close.emit()
