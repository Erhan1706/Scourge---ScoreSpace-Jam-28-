extends Control

signal unpause()

@onready var animation_player: AnimationPlayer = $Panel/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_level_toggle_powerup():
	show()
	animation_player.play("show")

func _on_button_1_pressed():
	button_toggle()
	Globals.player_attack += 5
	
func _on_button_2_pressed():
	button_toggle()
	Globals.player_speed += 10

func _on_button_3_pressed():
	button_toggle()

func button_toggle():
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	hide()
	unpause.emit()
	
