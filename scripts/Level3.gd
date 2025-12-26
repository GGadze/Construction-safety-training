extends Node3D

@onready var fail_label: Label = $CanvasLayer/FailLabel
@onready var finish_panel: Panel = $CanvasLayer/FinishPanel
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var start_panel: Control = $CanvasLayer/StartPanel
@onready var player: CharacterBody3D = $Player

var crane_stopped: bool = false

func _ready() -> void:
    var tasks: Array[Task] = []

    var task1 := Task.new()
    task1.description = "Останови работу крана"
    task1.required_action = "stop_crane"

    var task2 := Task.new()
    task2.description = "Пройди под грузом"
    task2.required_action = "pass_under_load"
    
    var task3 := Task.new()
    task3.description = "Останови работу крана"
    task3.required_action = "stop_crane"

    var task4 := Task.new()
    task4.description = "Пройди под грузом"
    task4.required_action = "pass_under_load"
    
    var task5 := Task.new()
    task5.description = "Пройди в конечную зону"
    task5.required_action = "finish_level"

    tasks.append(task1)
    tasks.append(task2)
    tasks.append(task3)
    tasks.append(task4)
    tasks.append(task5)

    GameManager.task_manager.set_tasks(tasks)
    
    player.equip_helmet()
    player.equip_vest()
    
    if GameManager.pending_load_data.has("task_index"):
        var saved_index = GameManager.pending_load_data["task_index"]
        GameManager.task_manager.current_task_index = saved_index
        
        if start_panel: start_panel.visible = false
        
        # Если задача 1 выполнена (индекс > 0), кран уже должен быть остановлен
        if saved_index > 0:
            set_crane_stopped()
        
        # Если у тебя несколько разных кранов, здесь можно добавить логику:
        # if saved_index > 2: stop_second_crane()
        
        GameManager.pending_load_data = {}
        
        get_tree().paused = false
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    else:
        if start_panel: start_panel.visible = true

func show_fail_message() -> void:
    fail_label.visible = true
    fail_label.modulate.a = 1.0
    anim.play("fail_fade")

func set_crane_stopped() -> void:
    crane_stopped = true
    print("Кран остановлен")
    
func end_game() -> void:
    finish_panel.visible = true
