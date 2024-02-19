extends Node2D
class_name ParentLevel

signal toggle_powerup()

var laser_scene: PackedScene = preload("res://scenes/projectile.tscn") 
var bat_enemy: PackedScene = preload("res://scenes/bat.tscn")
var ghost_enemy: PackedScene = preload("res://graphics/ui/ghost.tscn")

var cur_lvl: int = 1

func bat_spawn():
	if len($Enemies.get_children()) > 100: return
	var bat = bat_enemy.instantiate() as CharacterBody2D	
	bat.position = Globals.player_pos + Vector2(500,0).rotated(randi_range(0, 2* PI))
	$Enemies.add_child(bat)
	bat.connect("collisionPlayer", hitPlayer)
	

	
func ghost_spawn():
	if len($Enemies.get_children()) > 50: return
	var ghost = ghost_enemy.instantiate() as CharacterBody2D
	# bat.position = selectedSpawn.global_position
	ghost.position = Globals.player_pos + Vector2(400,0).rotated(randi_range(0, 2* PI))
	$Enemies.add_child(ghost)
	ghost.connect("collisionPlayer", hitPlayer)	
	
func hitPlayer(body):
	body.hit()
	
func shoot(pos, direction):
	var laser = laser_scene.instantiate() as Area2D
	laser.position = pos
	laser.rotation_degrees = rad_to_deg(direction.angle()) + 90
	laser.direction = direction
	$Projectiles.add_child(laser)


#func _on_player_shoot(pos, direction):
	#shoot(pos, direction)

func _on_bat_timer_timeout():
	bat_spawn()

func _on_ui_lvl_up():
	cur_lvl += 1
	var bat_timer: Timer = $Enemies/BatTimer
	var ghost_timer: Timer = $Enemies/GhostTimer
	
	if bat_timer.wait_time > 0.1:
		bat_timer.wait_time -= 0.1
	
	
	if cur_lvl == 3: 
		ghost_timer.start()
	elif cur_lvl > 3 and ghost_timer.wait_time > 1:
		ghost_timer.wait_time -= 0.5
		if cur_lvl % 2 == 0:
			Globals.ghost_health += 10
			
		
func _on_ghost_timer_timeout():
	ghost_spawn()


func _on_player_player_death():
	print(Globals.enemies_killed)
	get_tree().change_scene_to_file("res://music/death_screen.tscn")

