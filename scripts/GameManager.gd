extends Node

var current_level_index: int = 0
var levels: Array[String] = [
	"res://scenes/Level1.tscn",
	"res://scenes/Level2.tscn",
    "res://scenes/Level3.tscn"
]

func start_game() -> void:
	current_level_index = 0
	load_current_level()

func load_current_level() -> void:
	if current_level_index < levels.size():
		get_tree().change_scene_to_file(levels[current_level_index])
	else:
		print("Игра завершена")

func restart_level() -> void:
	load_current_level()

func next_level() -> void:
	current_level_index += 1
	load_current_level()
