extends Node

var player_save : PlayerSave = null
var death_position : Vector2 = Vector2.ZERO
var debug_enabled := true #Disable in public builds

func _ready():
	start()
	reset_game()

func start() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	DisplayServer.window_set_mode(0)
	get_viewport().size = Vector2(640,480)

func reset_game():
	player_save = PlayerSave.new()
	save_game()

func load_game():
	if(ResourceLoader.exists("user://saved.tres")):
		player_save = ResourceLoader.load("user://saved.tres").duplicate()
	else:
		reset_game()

func save_game():
	ResourceSaver.save(player_save, "user://saved.tres")

func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		audio.stop_music()
		audio.stop_all_sounds()
		vars.display.change_scene(vars.display.starting_scene)
		await get_tree().process_frame
		load_game()
	if Input.is_action_just_pressed("fullscreen") && !Input.is_action_pressed("alt"):
		toggle_resolution()

func toggle_resolution():
	match(DisplayServer.window_get_mode()):
		0:
			DisplayServer.window_set_mode(4)
			get_viewport().size = Vector2(1920,1080)
			DisplayServer.window_set_position(Vector2(Vector2(DisplayServer.screen_get_size() / 2) - Vector2(get_viewport().size / 2)))
		4:
			DisplayServer.window_set_mode(3)
			DisplayServer.window_set_mode(0)
			get_viewport().size = Vector2(640,480)
