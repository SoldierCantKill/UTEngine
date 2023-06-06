extends Node

#GLOBAL
var display = null
var scene = null
var scene_cam = null
var debug : Node2D = null

#BATTLE
var hud_manager : HudManager = null
var dialouge_manager : DialougeManager = null
var player_heart : PlayerHeart = null
var battle_box : BattleBox = null
var main_writer : Writer = null
var attack_manager : AttackManager = null
var enemies : Node2D = null
var black_screen : ColorRect = null
