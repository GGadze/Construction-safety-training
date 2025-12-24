extends Node
class_name TaskManager

var tasks: Array[Task] = []
var current_task_index: int = 0

func set_tasks(new_tasks: Array[Task]) -> void:
    tasks = new_tasks
    current_task_index = 0

func get_current_task() -> Task:
    if current_task_index < tasks.size():
        return tasks[current_task_index]
    return null

func submit_action(action: String) -> bool:
    var task := get_current_task()
    if task == null:
        return false

    if task.required_action == action:
        task.completed = true
        current_task_index += 1
        return true
    else:
        return false

func is_all_tasks_completed() -> bool:
    return current_task_index >= tasks.size()
