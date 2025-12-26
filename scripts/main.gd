extends Control

@onready var continue_btn = $CenterContainer/VBoxContainer/ButtonContinue

func _ready():
    $CenterContainer/VBoxContainer/ButtonStart.pressed.connect(_on_start)
    $CenterContainer/VBoxContainer/ButtonExit.pressed.connect(_on_exit)
    continue_btn.pressed.connect(_on_continue)
    
    # Проверяем доступность кнопки
    if GameManager.has_save_file():
        continue_btn.disabled = false
    else:
        continue_btn.disabled = true
        # Или continue_btn.visible = false, если хочешь скрыть

func _on_start():
    GameManager.start_game()

func _on_continue():
    GameManager.load_game()

func _on_exit():
    get_tree().quit()
