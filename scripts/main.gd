extends Control

func _ready():
    $CenterContainer/VBoxContainer/ButtonStart.pressed.connect(_on_start)
    $CenterContainer/VBoxContainer/ButtonExit.pressed.connect(_on_exit)

func _on_start():
    GameManager.start_game()

func _on_exit():
    get_tree().quit()
