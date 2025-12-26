extends Control

func _ready():
    visible = false # Скрыто по умолчанию
    $VBoxContainer/ResumeButton.pressed.connect(_on_resume)
    $VBoxContainer/SaveButton.pressed.connect(_on_save)
    $VBoxContainer/ExitButton.pressed.connect(_on_exit)

func _input(event):
    if event.is_action_pressed("ui_cancel"): # По умолчанию Escape
        toggle_pause()

func toggle_pause():
    visible = !visible
    get_tree().paused = visible
    
    if visible:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    else:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume():
    toggle_pause()

func _on_save():
    GameManager.save_game()
    # Опционально: Вывести надпись "Saved!"

func _on_exit():
    toggle_pause() # Снимаем паузу перед выходом
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    get_tree().change_scene_to_file("res://scenes/Main.tscn") # Путь к твоему меню
