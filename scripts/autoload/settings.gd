extends Node

var player_save : PlayerSave = null
var death_position : Vector2 = Vector2.ZERO

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
		player_save = ResourceLoader.load("user://saved.tres")
	else:
		reset_game()

func save_game():
	ResourceSaver.save(player_save, "user://saved.tres")

func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		vars.display.change_scene(vars.display.starting_scene)
