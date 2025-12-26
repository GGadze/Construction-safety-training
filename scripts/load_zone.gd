extends Area3D

var triggered := false

func _on_body_entered(body: Node) -> void:
    if body.name != "Player":
        return

    if triggered:
        return
    triggered = true

    var level := get_parent() as Node

    if not level.crane_stopped:
        GameManager.safety_manager.fail("Нахождение под грузом при работающем кране")
        return

    var success := GameManager.task_manager.submit_action("pass_under_load")

    if not success:
        GameManager.safety_manager.fail("Нарушен порядок выполнения заданий")
