extends Node3D

@onready var fail_label: Label = $CanvasLayer/FailLabel
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer

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

func show_fail_message() -> void:
    fail_label.visible = true
    fail_label.modulate.a = 1.0
    anim.play("fail_fade")
