extends Node3D

@onready var fail_label: Label = $CanvasLayer/FailLabel
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer

func _ready() -> void:
    var tasks: Array[Task] = []

    var task1 := Task.new()
    task1.description = "Возьми ящик с инструментами"
    task1.required_action = "take_toolbox"

    var task2 := Task.new()
    task2.description = "Верни ящик на исходную точку"
    task2.required_action = "return_toolbox"

    tasks.append(task1)
    tasks.append(task2)

    GameManager.task_manager.set_tasks(tasks)

func show_fail_message() -> void:
    fail_label.visible = true
    fail_label.modulate.a = 1.0
    anim.play("fail_fade")
