extends Node
class_name BattleRoom

func _ready():
	vars.scene = self
	vars.attack_manager = $attack_manager
	vars.enemies = $enemies
	vars.hud_manager = $hud_manager
	vars.battle_box = $battle_box
	vars.main_writer = $battle_writer
	vars.player_heart = $player_heart
	vars.hud_manager.reset()
