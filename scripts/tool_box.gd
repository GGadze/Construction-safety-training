extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    var success := GameManager.task_manager.submit_action("take_toolbox")

    if success:
        body.pick_toolbox()
        queue_free()
    else:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
