extends Attack

var a_vars : vars = vars

func _init():
	frames = 500

func pre_attack():
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	a_vars.battle_box.set_box_size([244,250,399,390])
	await get_tree().process_frame
	a_vars.player_heart.visible = true
	a_vars.player_heart.global_position = Vector2(321, 375)

func start_attack():
	vars.player_heart.input_enabled = true
	attack_started = true
	bones_part_one()
	gb_part_one()
#	for i in range(6):
#		a_vars.attack_manager.gaster_blaster(0,Vector2(-100 + i * 75,-100),Vector2(150 + i *75,100),0,Vector2(1,1),0,0 + i * 10,false)
	

func bones_part_one():
	a_vars.attack_manager.bone(0,Vector2(150,254),2,0,120,0,50,0,true)
	a_vars.attack_manager.bone(0,Vector2(130,254),2,0,120,0,55,0,true)
	a_vars.attack_manager.bone(0,Vector2(110,254),2,0,120,0,60,0,true)
	a_vars.attack_manager.bone(0,Vector2(90,254),2,0,120,0,65,0,true)
	a_vars.attack_manager.bone(0,Vector2(70,254),2,0,120,0,60,0,true)
	a_vars.attack_manager.bone(0,Vector2(50,254),2,0,120,0,55,0,true)
	a_vars.attack_manager.bone(0,Vector2(30,254),2,0,120,0,50,0,true)
	
	a_vars.attack_manager.bone(0,Vector2(-50,254),2,0,120,0,50,0,true)
	a_vars.attack_manager.bone(0,Vector2(-70,254),2,0,120,0,55,0,true)
	a_vars.attack_manager.bone(0,Vector2(-90,254),2,0,120,0,60,0,true)
	a_vars.attack_manager.bone(0,Vector2(-110,254),2,0,120,0,65,0,true)
	a_vars.attack_manager.bone(0,Vector2(-130,254),2,0,120,0,60,0,true)
	a_vars.attack_manager.bone(0,Vector2(-150,254),2,0,120,0,55,0,true)
	a_vars.attack_manager.bone(0,Vector2(-170,254),2,0,120,0,50,0,true)
	
	a_vars.attack_manager.bone(0,Vector2(400,384),-2,0,120,-50,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(420,384),-2,0,120,-55,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(440,384),-2,0,120,-60,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(460,384),-2,0,120,-65,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(480,384),-2,0,120,-60,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(500,384),-2,0,120,-55,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(520,384),-2,0,120,-50,0,0,true)
	
	a_vars.attack_manager.bone(0,Vector2(700,384),-2,0,120,-50,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(720,384),-2,0,120,-55,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(740,384),-2,0,120,-60,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(760,384),-2,0,120,-65,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(780,384),-2,0,120,-60,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(800,384),-2,0,120,-55,0,0,true)
	a_vars.attack_manager.bone(0,Vector2(820,384),-2,0,120,-50,0,0,true)
	
	await get_tree().create_timer(1.8).timeout
	a_vars.attack_manager.throw(270,750)
	await get_tree().create_timer(.5).timeout
	a_vars.attack_manager.bone_stab(0,Vector2(244,255),130,50,30,30,90,true)
	await get_tree().create_timer(.55).timeout
	a_vars.attack_manager.throw(90,750)
	await get_tree().create_timer(.9).timeout
	a_vars.attack_manager.throw(0,750)
	await get_tree().create_timer(.1).timeout
	a_vars.attack_manager.bone_stab(0,Vector2(250,384),144,60,30,30,0,true)
	
	await get_tree().create_timer(.5).timeout
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.red
	for i in range(11):
		var bone = a_vars.attack_manager.bone(0,Vector2(244 + i * 14,396),0,0,0,0,0,0,true)
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_top",-65,2.5)
	for i in range(11):
		var bone = a_vars.attack_manager.bone(0,Vector2(244 + i * 14,244),0,0,0,0,0,0,true)
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_bottom",65,2.5)
	for i in range(11):
		var bone = a_vars.attack_manager.bone(0,Vector2(238,256 + i * 14),0,0,0,0,0,0,true)
		bone.rotation_degrees = -90
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_bottom",70,2.7)
	for i in range(11):
		var bone = a_vars.attack_manager.bone(0,Vector2(405,256 + i * 14),0,0,0,0,0,0,true)
		bone.rotation_degrees = -90
		var tween = get_tree().create_tween()
		tween.tween_property(bone, "offset_top",-70,2.7)
	await get_tree().create_timer(2.5).timeout
	a_vars.attack_manager.delete_bullets.emit()
	await a_vars.attack_manager.black_screen(.15)

func gb_part_one():
#	vars.attack_manager.gaster_blaster(Vector2(-100,-100),Vector2(150,100),20,Vector2(.8,1),false)
	for i in range(18):
		a_vars.attack_manager.gaster_blaster(0,Vector2(-100,-100),Vector2(150,100),-i * 20,Vector2(1,1),false)
		await get_tree().create_timer(.05).timeout
	await get_tree().create_timer(.3).timeout
	for i in range(18):
		a_vars.attack_manager.gaster_blaster(0,Vector2(500,-100),Vector2(380,100),-i * 20,Vector2(1,1),false)
		await get_tree().create_timer(.05).timeout
	await get_tree().create_timer(.3).timeout
	for i in range(5):
		a_vars.attack_manager.gaster_blaster(0,Vector2(200,-100),Vector2(280,100),30 - i * 20,Vector2(1,1),false)
		await get_tree().create_timer(.1).timeout

