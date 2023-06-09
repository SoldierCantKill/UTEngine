extends Attack

func _init():
	frames = 500

func pre_attack():
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	vars.battle_box.set_box_size([244,254,399,394])
	await get_tree().process_frame
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(321, 375)

func start_attack():
	vars.player_heart.input_enabled = true
	attack_started = true
	bones_part_one()
	gb_part_one()

func bones_part_one():
	vars.attack_manager.bone(Vector2(150,258),2,0,125,0,50,0,true)
	vars.attack_manager.bone(Vector2(130,258),2,0,125,0,55,0,true)
	vars.attack_manager.bone(Vector2(110,258),2,0,125,0,60,0,true)
	vars.attack_manager.bone(Vector2(90,258),2,0,125,0,65,0,true)
	vars.attack_manager.bone(Vector2(70,258),2,0,125,0,60,0,true)
	vars.attack_manager.bone(Vector2(50,258),2,0,125,0,55,0,true)
	vars.attack_manager.bone(Vector2(30,258),2,0,125,0,50,0,true)
	
	vars.attack_manager.bone(Vector2(-50,258),2,0,125,0,50,0,true)
	vars.attack_manager.bone(Vector2(-70,258),2,0,125,0,55,0,true)
	vars.attack_manager.bone(Vector2(-90,258),2,0,125,0,60,0,true)
	vars.attack_manager.bone(Vector2(-110,258),2,0,125,0,65,0,true)
	vars.attack_manager.bone(Vector2(-130,258),2,0,125,0,60,0,true)
	vars.attack_manager.bone(Vector2(-150,258),2,0,125,0,55,0,true)
	vars.attack_manager.bone(Vector2(-170,258),2,0,125,0,50,0,true)
	
	vars.attack_manager.bone(Vector2(400,390),-2,0,125,-50,0,0,true)
	vars.attack_manager.bone(Vector2(420,390),-2,0,125,-55,0,0,true)
	vars.attack_manager.bone(Vector2(440,390),-2,0,125,-60,0,0,true)
	vars.attack_manager.bone(Vector2(460,390),-2,0,125,-65,0,0,true)
	vars.attack_manager.bone(Vector2(480,390),-2,0,125,-60,0,0,true)
	vars.attack_manager.bone(Vector2(500,390),-2,0,125,-55,0,0,true)
	vars.attack_manager.bone(Vector2(520,390),-2,0,125,-50,0,0,true)
	
	vars.attack_manager.bone(Vector2(700,390),-2,0,125,-50,0,0,true)
	vars.attack_manager.bone(Vector2(720,390),-2,0,125,-55,0,0,true)
	vars.attack_manager.bone(Vector2(740,390),-2,0,125,-60,0,0,true)
	vars.attack_manager.bone(Vector2(760,390),-2,0,125,-65,0,0,true)
	vars.attack_manager.bone(Vector2(780,390),-2,0,125,-60,0,0,true)
	vars.attack_manager.bone(Vector2(800,390),-2,0,125,-55,0,0,true)
	vars.attack_manager.bone(Vector2(820,390),-2,0,125,-50,0,0,true)
	
	await get_tree().create_timer(1.8).timeout
	vars.attack_manager.throw(270,500)
	await get_tree().create_timer(.5).timeout
	vars.attack_manager.bone_stab(Vector2(280,321),300,50,10,3,-90,true)
	await get_tree().create_timer(.55).timeout
	vars.attack_manager.throw(90,500)
	await get_tree().create_timer(.1).timeout
	vars.attack_manager.bone_stab(Vector2(50,321),300,60,10,5,90,true)
	await get_tree().create_timer(.8).timeout
	vars.attack_manager.throw(0,500)
	await get_tree().create_timer(.1).timeout
	vars.attack_manager.bone_stab(Vector2(280,321),300,60,25,10,-90,true)
	vars.attack_manager.bone_stab(Vector2(244,394),300,60,25,10,0,true)
	
	await get_tree().create_timer(.5).timeout
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.red
	for i in range(11):
		var bone = vars.attack_manager.bone(Vector2(244 + i * 14,400),0,0,0,0,0,0,true)
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_top",-65,2.5)
	for i in range(11):
		var bone = vars.attack_manager.bone(Vector2(244 + i * 14,248),0,0,0,0,0,0,true)
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_bottom",65,2.5)
	for i in range(11):
		var bone = vars.attack_manager.bone(Vector2(238,260 + i * 14),0,0,0,0,0,0,true)
		bone.rotation_degrees = -90
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_bottom",70,2.7)
	for i in range(11):
		var bone = vars.attack_manager.bone(Vector2(405,260 + i * 14),0,0,0,0,0,0,true)
		bone.rotation_degrees = -90
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_top",-70,2.7)
	await get_tree().create_timer(2.5).timeout
	vars.attack_manager.delete_bullets.emit()
	await vars.attack_manager.black_screen(1)

func gb_part_one():
	for i in range(18):
		vars.attack_manager.gaster_blaster(Vector2(-100,-100),Vector2(150,100),-i * 20,Vector2(.8,1),false)
		await get_tree().create_timer(.05).timeout
	await get_tree().create_timer(.3).timeout
	for i in range(18):
		vars.attack_manager.gaster_blaster(Vector2(500,-100),Vector2(380,100),-i * 20,Vector2(.8,1),false)
		await get_tree().create_timer(.05).timeout
	await get_tree().create_timer(.3).timeout
	for i in range(5):
		vars.attack_manager.gaster_blaster(Vector2(200,-100),Vector2(280,100),30 - i * 20,Vector2(.8,1),false)
		await get_tree().create_timer(.1).timeout

