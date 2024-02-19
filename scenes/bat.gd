extends CharacterBody2D

signal collisionPlayer(body)

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

const SPEED = 100.0
var health: int = 10

func _physics_process(delta):
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().name == "Player":
			collisionPlayer.emit(collision.get_collider())

func makepath():
	nav_agent.target_position = Globals.player_pos

func _on_nav_timer_timeout():
	makepath() # Replace with function body.

func hit(): 
	health -= Globals.player_attack
	if health <= 0:
		Globals.enemies_killed += 1
		queue_free()
		
