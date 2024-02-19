extends CharacterBody2D

signal shoot(pos, direction)
signal health_change(health)
signal player_death()
@export var speed: int = 150
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_poly: CollisionPolygon2D = $CollisionPolygon2D
@onready var anim_player: AnimationPlayer  = $AnimationPlayer

var can_attack : bool = true
var last_direction: bool = true 
var vulnerable: bool = true
var health: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.speed_changed.connect(changeSpeed)

func changeSpeed(new_speed): 
	speed = new_speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if health > 0: move_and_slide()
	Globals.player_pos = global_position
	
	movementAnimation()
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("Shoot") and can_attack and health > 0: 
		var marker = $Marker2D
		shoot.emit(marker.global_position, player_direction)
		$AttackTimer.start()

		checkMouseFlip()
		anim_player.play("attack")
		
		can_attack = false

func checkMouseFlip():
	if get_global_mouse_position().x > global_position.x:
		animation_player.flip_h = false
	elif get_global_mouse_position().x < global_position.x:
		animation_player.flip_h = true


func hit():
	if vulnerable:
		vulnerable = false
		health -= 1
		$AudioStreamPlayer.play()
		health_change.emit(health)
		if health == 0:
			animation_player.stop()
			animation_player.play("death")
			$DeathTimer.start()
			return
		animation_player.stop()
		animation_player.play("damage")
		$InvulTimer.start()
		await animation_player.animation_finished
		


func movementAnimation():
	if !vulnerable or health == 0 or !can_attack: return
	elif Input.is_action_pressed("Left"):
		animation_player.flip_h = true
		animation_player.play("walk_right")
		last_direction = true
	elif Input.is_action_pressed("Right"):
		animation_player.flip_h = false
		animation_player.play("walk_right")
		last_direction = false
	else:
		# If true then use right else use left idle animation 
		if last_direction: animation_player.flip_h = true
		else: animation_player.flip_h = false
		animation_player.play("idle_right")

func _on_shoot_timer_timeout():
	can_attack = true 

func _on_invul_timer_timeout():
	vulnerable = true

func _on_death_timer_timeout():
	queue_free()
	player_death.emit()

func _on_dmg_area_entered(body):
	if "hit" in body:
		body.hit()
	
