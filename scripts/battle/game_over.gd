extends Node2D


var heart_shards: Array[Node] = []
var heart_shard_anim: AnimatedTexture = load("res://assets/sprites/battle/heart/heart_shard.tres")


func _ready() -> void:
	audio.stop_music()
	audio.stop_all_sounds()
	
	$heart.position = settings.death_position
	await get_tree().create_timer(0.666667).timeout
	
	$heart.frame = 1
	audio.play("Battle/break")
	await get_tree().create_timer(1.33333).timeout
	
	$heart.visible = false
	audio.play("Battle/break2")
	
	for i in 5:
		var obj: Sprite2D = Sprite2D.new()
		obj.texture = heart_shard_anim
		obj.modulate = $heart.modulate
		obj.position = $heart.position
		
		obj.rotation_degrees = randi() % 360
		obj.set_meta("vx", 180 * cos(obj.rotation))
		obj.set_meta("vy", 180 * sin(obj.rotation))
		
		add_child(obj)
		heart_shards.append(obj)
	
	await get_tree().create_timer(4).timeout
	# Add returning code here. For now it just sends you back to the starting scene.
	vars.display.change_scene(vars.display.starting_scene, true)


func _process(delta: float) -> void:
	if !heart_shards.is_empty(): for i in heart_shards:
		var vx: float = i.get_meta("vx")
		var vy: float = i.get_meta("vy")
		
		i.position += Vector2(vx, vy) * delta
		i.rotation_degrees += 300 * delta
		
		i.set_meta("vx", vx + cos(rotation + deg_to_rad(90)) * 300 * delta)
		i.set_meta("vy", vy + sin(rotation + deg_to_rad(90)) * 300 * delta)
