extends Panel

func _process(delta: float) -> void:
    if visible:
        get_tree().paused = true
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_end_pressed() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/Main.tscn")
    queue_free()
