extends Node

#GLOBAL
var display : Control = null
var scene = null
var scene_cam

#BATTLE
var hud_manager : HudManager = null
var player_heart : PlayerHeart = null
var battle_box : BattleBox = null
var main_writer : Writer = null
var attack_manager : AttackManager = null
var enemies : Node2D = null
