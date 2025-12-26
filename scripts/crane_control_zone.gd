extends Area3D

var triggered := false

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return
        
    if triggered:
        return
    triggered = true

    var success := GameManager.task_manager.submit_action("stop_crane")

    if success:
        var level := get_parent() as Node
        level.set_crane_stopped()
    else:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
