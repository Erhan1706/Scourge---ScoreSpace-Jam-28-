extends Node

signal enemy_killed
signal attack_changed
signal speed_changed(new_speed)
signal ghost_health_changed(value)
signal set_score(value)

var player_pos: Vector2

var score: int = 0:
	set(value):
		set_score.emit(value)

var enemies_killed: int = 0:
	set(value):
		enemies_killed = value
		enemy_killed.emit()
		
var player_attack: int = 10
	#set(value):
	#	attack_changed.emit()
		
var player_speed: int = 150:
	set(value):
		speed_changed.emit(value)

var player_range: int = 20

var ghost_health: int = 30:
	set(value):
		ghost_health_changed.emit(value)
