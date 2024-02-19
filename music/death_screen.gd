extends CanvasLayer


func _ready():
	var final_score: Label = $Score
	final_score.text = "Score: " + str(Globals.enemies_killed)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

