extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    var success := GameManager.task_manager.submit_action("finish_level")

    if success:
        var level := get_parent() as Node
        level.end_game()
    else:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
