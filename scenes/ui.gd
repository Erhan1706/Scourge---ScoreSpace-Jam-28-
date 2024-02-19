extends CanvasLayer

signal lvl_up

var player_health: int = 3
@onready var heart_animation: AnimationPlayer = $"Health Bar/HeartAnimationPlayer"
@onready var lvl_bar: ProgressBar = $LevelProgress/ProgressBar
@onready var score: Label = $Score/ScoreNum
@onready var lvl: Label = $LevelProgress/Level

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("enemy_killed", update_level)

func update_level():
	lvl_bar.value += 1
	var cur_score: int  = int(score.text) + 1
	score.text = str(cur_score) 
	if lvl_bar.value >= lvl_bar.max_value:
		lvl_bar.value = 0
		lvl_bar.max_value += 10
		lvl.text = str(int(lvl.text) + 1)
		lvl_up.emit()
		

func _on_player_health_change(health):
	if player_health == 3:
		heart_animation.play("heart3")
	if player_health == 2:
		heart_animation.play("heart2")
	if player_health == 1:
		heart_animation.play("heart1")
	player_health = health
