extends Area3D

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    var success := GameManager.task_manager.submit_action("put_helmet")

    if success:
        body.has_helmet = true
        queue_free()
    else:
        GameManager.safety_manager.fail("Каска надета не по порядку")
