extends CanvasLayer

@onready var play_button: Button = $Buttons/PlayButton
@onready var quit_button: Button = $Buttons/QuitButton
# Called when the node enters the scene tree for the first time.
var level: PackedScene = preload("res://scenes/level.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	$AnimationPlayer.play("transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	$AnimationPlayer.play_backwards("transition") # to transition back from the black screen
	await $AnimationPlayer.animation_finished
