extends Node3D

@onready var fail_label: Label = $CanvasLayer/FailLabel
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var start_panel: Control = $CanvasLayer/StartPanel
@onready var toolbox_item: Node3D = $ToolBox
@onready var player: CharacterBody3D = $Player

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
    
    player.equip_helmet()
    player.equip_vest()
    
    if GameManager.pending_load_data.has("task_index"):
        GameManager.task_manager.current_task_index = GameManager.pending_load_data["task_index"]
        
        start_panel.visible = false
        
        # Если ящик уже в руках у игрока, удаляем его из мира
        if player.has_toolbox:
            if is_instance_valid(toolbox_item):
                toolbox_item.queue_free()
        
        GameManager.pending_load_data = {}
        
        get_tree().paused = false
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    else:
        start_panel.visible = true

func show_fail_message() -> void:
    fail_label.visible = true
    fail_label.modulate.a = 1.0
    anim.play("fail_fade")
