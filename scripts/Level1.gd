extends Node3D

@onready var fail_label: Label = $CanvasLayer/FailLabel
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer
# Ссылки на объекты в мире (убедись, что имена совпадают с деревом сцены)
@onready var helmet_item: Node3D = $Helmet 
@onready var vest_item: Node3D = $Vest
@onready var player: CharacterBody3D = $Player
@onready var start_panel: Control = $CanvasLayer/StartPanel

func _ready() -> void:
    # 1. Настройка задач (как и было)
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
    
    # 2. ПРОВЕРКА: Это новая игра или загрузка?
    # Мы проверяем pending_load_data, либо просто смотрим на состояние игрока
    
    if GameManager.pending_load_data.has("task_index"):
        # --- ЭТО ЗАГРУЗКА ---
        
        # А. Восстанавливаем прогресс задач
        GameManager.task_manager.current_task_index = GameManager.pending_load_data["task_index"]
        
        # Б. Скрываем стартовую панель, так как игрок её уже видел
        start_panel.visible = false
        
        # В. Удаляем предметы с карты, если они уже есть у игрока
        # (Так как Player._ready() уже сработал, у него уже выставлены has_helmet/has_vest)
        if player.has_helmet:
            if is_instance_valid(helmet_item):
                helmet_item.queue_free()
                
        if player.has_vest:
            if is_instance_valid(vest_item):
                vest_item.queue_free()
        
        # Г. Очищаем данные загрузки, так как мы их применили
        GameManager.pending_load_data = {}
        
        # 1. Снимаем паузу (на всякий случай, если она осталась)
        get_tree().paused = false 
    
    # 2. Захватываем мышь (курсор исчезнет и зафиксируется в центре)
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        
    else:
        # --- ЭТО НОВАЯ ИГРА (или просто переход на уровень) ---
        start_panel.visible = true

func show_fail_message() -> void:
    fail_label.visible = true
    fail_label.modulate.a = 1.0
    anim.play("fail_fade")
