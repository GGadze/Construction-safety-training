extends Node3D

func _ready() -> void:
	var tasks: Array[Task] = []

	var task1 := Task.new()
	task1.description = "Надень каску"
	task1.required_action = "put_helmet"

	var task2 := Task.new()
	task2.description = "Надень жилет"
	task2.required_action = "put_vest"

	var task3 := Task.new()
	task3.description = "Пройди в рабочую зону"
	task3.required_action = "enter_work_zone"

	tasks.append(task1)
	tasks.append(task2)
	tasks.append(task3)

	GameManager.task_manager.set_tasks(tasks)
