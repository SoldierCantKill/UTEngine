#Credit to Scarm for enter tree function

extends Node

var AUDIO_PATH: String = "res://assets/audio/" #CANNOT USE UIDS FOR THIS!!!!
var references = {}
var global_volume = .05
var volume_store = global_volume
var music : Node = null
var current_sounds = []

func _enter_tree() -> void:
	var dir: DirAccess = DirAccess.open(AUDIO_PATH)
	if dir:
		dir.list_dir_begin()
		var dir_name: String = dir.get_next()
		
		while dir_name != "": if dir.current_is_dir():
			var group: Node = Node.new()
			group.name = dir_name
			add_child(group)
			
			import_audio(str(AUDIO_PATH + dir_name), group)
			dir_name = dir.get_next()

func import_audio(dir_name: String, group: Node):
	var file: DirAccess = DirAccess.open(dir_name)
	var group_name: String = str(group.name)
	if file:
		file.list_dir_begin()
		var file_name: String = file.get_next()
		while file_name != "": if !file.current_is_dir():
			var base_name: String = file_name.get_basename().get_basename() #Only works for .import files
			if file_name.get_extension() == "import":
				file_name = file_name.split(".import")[0]
				var node: Node = null
				var node_name: String = base_name
				if base_name.ends_with("_2d"): node = AudioStreamPlayer2D.new(); node_name = node_name.trim_suffix("_2d")
				elif base_name.ends_with("_3d"): node = AudioStreamPlayer3D.new(); node_name = node_name.trim_suffix("_3d")
				else: node = AudioStreamPlayer.new()
				node.name = node_name
				node.stream = load(dir_name.path_join(file_name))
				group.add_child(node)
				references[group_name.path_join(node_name)] = node
				
			file_name = file.get_next()

func play(sound : String, volume : float = global_volume, pitch : float = 1) -> Node:
	var n: Node = references[sound]
	current_sounds.append(n)
	n.finished.connect(func x(): current_sounds.erase(n))
	n.volume_db = linear_to_db(volume)
	n.pitch_scale = pitch
	n.play()
	return n

func stop_sound(sound : String):
	references[sound].stop()
	
func stop_all_sounds():
	for i in current_sounds:
		i.stop()

#This function exists for you can easily manage music.
func play_music(sound : String, volume : float = global_volume, pitch : float = 1) -> Node:
	var n: Node = references[sound]
	n.volume_db = linear_to_db(volume)
	n.pitch_scale = pitch
	n.play()
	music = n
	return n

func pause_music():
	if(is_instance_valid(music)):
		music.stream_paused = true

func resume_music():
	if(is_instance_valid(music)):
		music.play()

func stop_music():
	if(is_instance_valid(music)):
		music.stop()

func mute_volume():
	volume_store = global_volume
	global_volume = 0.000000001
	for i in current_sounds:
		i.volume = linear_to_db(global_volume)

func unmute_volume():
	global_volume = volume_store
	for i in current_sounds:
		i.volume_db = linear_to_db(global_volume)
