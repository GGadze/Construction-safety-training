extends Node

const SAVE_PATH = "user://savegame.json"

var current_level_index: int = 0
var levels: Array[String] = [
    "res://scenes/Level1.tscn",
    "res://scenes/Level2.tscn",
	"res://scenes/Level3.tscn"
]

@onready var task_manager: TaskManager = TaskManager.new()
@onready var safety_manager: SafetyManager = SafetyManager.new()

var pending_load_data: Dictionary = {}

func _ready() -> void:
    add_child(task_manager)
    add_child(safety_manager)
    # Паузу нужно обрабатывать даже если игра на паузе
    process_mode = Node.PROCESS_MODE_ALWAYS 

func start_game() -> void:
    current_level_index = 0
    pending_load_data = {} # Очищаем данные, это новая игра
    load_current_level()

# --- СИСТЕМА СОХРАНЕНИЙ ---

func save_game():
    # 1. Собираем данные
    var player = get_tree().get_first_node_in_group("Player")
    if not player:
        print("Ошибка: Игрок не найден для сохранения")
        return
    
    var save_dict = {
        "level_index": current_level_index,
        "task_index": task_manager.current_task_index,
        "player_data": player.get_save_data() # Этот метод мы создадим у игрока
    }
    
    # 2. Записываем в файл
    var json_string = JSON.stringify(save_dict)
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_string(json_string)
        print("Игра сохранена")
        
func load_game():
    if not FileAccess.file_exists(SAVE_PATH):
        return # Файла нет
        
    # 1. Читаем файл
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    var json_string = file.get_as_text()
    var json = JSON.new()
    var parse_result = json.parse(json_string)
    
    if parse_result == OK:
        var data = json.get_data()
        
        # 2. Запоминаем данные, чтобы применить их когда сцена загрузится
        pending_load_data = data
        
        # 3. Загружаем нужный уровень
        current_level_index = data["level_index"]
        load_current_level()
        # ВАЖНО: Мы не применяем позицию тут, потому что сцена еще не загрузилась.
        # Это сделает сам игрок в своем _ready()
    else:
        print("Ошибка чтения сохранения")

func has_save_file() -> bool:
    return FileAccess.file_exists(SAVE_PATH)

# --- УПРАВЛЕНИЕ УРОВНЯМИ ---

func restart_level() -> void:
    # Очищаем временные данные загрузки, чтобы уровень 
    # начался с чистого листа, а не с последнего сохранения
    pending_load_data = {} 
    
    # Снимаем паузу, если она была (например, при вызове из меню провала)
    get_tree().paused = false 
    
    # Перезагружаем текущую сцену
    load_current_level()

func load_current_level() -> void:
    get_tree().paused = false 
    if current_level_index < levels.size():
        get_tree().change_scene_to_file(levels[current_level_index])

func next_level() -> void:
    current_level_index += 1
    # При переходе на след уровень старые сейв-данные не нужны
    pending_load_data = {} 
    load_current_level()
