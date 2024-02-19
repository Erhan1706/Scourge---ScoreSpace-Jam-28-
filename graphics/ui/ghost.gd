extends CharacterBody2D

signal collisionPlayer(body)

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 80.0

var vulnerable: bool = true
var health: int = 30 

func _ready():
	animation_sprite.play("spawn")
	Globals.ghost_health_changed.connect(change_health)

func hit():
	if vulnerable:
		vulnerable = false
		health -= Globals.player_attack
		if health <= 0:
			call_deferred("disable_hitbox")
			animation_sprite.stop()
			animation_sprite.play("death")
			$NavTimer.stop()
			$DeathTimer.start()
			Globals.enemies_killed += 1
			
func disable_hitbox():
	$CollisionShape2D.disabled = true

func _process(delta):
	movement_animation()

func movement_animation():
	if global_position.x < Globals.player_pos.x:
		animation_sprite.flip_h = true
	else: 
		animation_sprite.flip_h = false
	if !vulnerable and health > 0:
		animation_sprite.play("idle")


func _physics_process(delta):
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * SPEED

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().name == "Player":
			collisionPlayer.emit(collision.get_collider())
			animation_sprite.play("attack")

func makepath():
	nav_agent.target_position = Globals.player_pos

func _on_nav_timer_timeout():
	makepath() # Replace with function body.

func _on_hit_timer_timeout():
	vulnerable = true

func _on_death_timer_timeout():
	queue_free()

func change_health(value):
	health = value
