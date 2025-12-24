extends Node
class_name SafetyManager

func fail(reason: String) -> void:
    print("НАРУШЕНИЕ: ", reason)

    var level := get_tree().current_scene
    if level.has_method("show_fail_message"):
        level.show_fail_message()

    await get_tree().create_timer(1.5).timeout
    GameManager.restart_level()
