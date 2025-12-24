extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    if not body.has_helmet or not body.has_vest:
        GameManager.safety_manager.fail("Вход в рабочую зону без СИЗ")
        return

    var success := GameManager.task_manager.submit_action("enter_work_zone")

    if success:
        GameManager.next_level()
    else:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
