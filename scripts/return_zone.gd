extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    if not body.has_toolbox:
        return

    var success := GameManager.task_manager.submit_action("return_toolbox")

    if success:
        GameManager.next_level()
    else:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
