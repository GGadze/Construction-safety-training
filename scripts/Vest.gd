extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    var success := GameManager.task_manager.submit_action("put_vest")

    if success:
        body.has_vest = true
        queue_free()
    else:
        GameManager.safety_manager.fail("Жилет надет не по порядку")
