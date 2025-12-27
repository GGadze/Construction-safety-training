extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 5.0
@export var mouse_sensitivity: float = 0.003

@onready var camera_pivot: Node3D = $CameraPivot
@onready var anim_player: AnimationPlayer = $Visual/BaseCharacter/AnimationPlayer

var has_helmet: bool = false
var has_vest: bool = false
var has_toolbox := false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
    var input_dir = Vector3.ZERO

    if Input.is_action_pressed("move_forward"):
        input_dir.z -= 1
    if Input.is_action_pressed("move_backward"):
        input_dir.z += 1
    if Input.is_action_pressed("move_left"):
        input_dir.x -= 1
    if Input.is_action_pressed("move_right"):
        input_dir.x += 1

    input_dir = input_dir.normalized()

    var direction = (global_transform.basis * input_dir).normalized()

    if direction != Vector3.ZERO:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = lerp(velocity.x, 0.0, 0.1)
        velocity.z = lerp(velocity.z, 0.0, 0.1)

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_velocity
    if is_on_floor():
        if velocity.length() > 0.1:
            if anim_player.current_animation != "walking/mixamo_com":
                anim_player.play("walking/mixamo_com")
        else:
            if anim_player.current_animation != "idle/mixamo_com":
                anim_player.play("idle/mixamo_com")
                
    move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * mouse_sensitivity)
        camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
        camera_pivot.rotation.x = clamp(
            camera_pivot.rotation.x,
            deg_to_rad(-40),
            deg_to_rad(40)
        )

func equip_helmet():
    has_helmet = true
    %HelmetVisual.visible = true
    GameManager.task_manager.submit_action("put_helmet")

func equip_vest():
    has_vest = true
    %VestVisual.visible = true
    GameManager.task_manager.submit_action("put_vest")
    
func pick_toolbox():
    has_toolbox = true
    %ToolBoxVisual.visible = true
    GameManager.task_manager.submit_action("pick_toolbox")

func _ready():
    # Проверяем, есть ли отложенные данные для загрузки
    if GameManager.pending_load_data.has("player_data"):
        apply_save_data(GameManager.pending_load_data["player_data"])
        
        # Восстанавливаем прогресс заданий здесь же или в скрипте уровня
        # Но так как TaskManager глобальный, нам нужно просто обновить индекс
        if GameManager.pending_load_data.has("task_index"):
            GameManager.task_manager.current_task_index = GameManager.pending_load_data["task_index"]

# Метод упаковки данных
func get_save_data() -> Dictionary:
    return {
        "pos_x": global_position.x,
        "pos_y": global_position.y,
        "pos_z": global_position.z,
        "rot_y": rotation.y, # Сохраняем поворот тела
        "pivot_x": camera_pivot.rotation.x, # Сохраняем наклон головы
        "has_helmet": has_helmet,
        "has_vest": has_vest,
        "has_toolbox": has_toolbox
    }

# Метод распаковки данных
func apply_save_data(data: Dictionary):
    global_position = Vector3(data["pos_x"], data["pos_y"], data["pos_z"])
    rotation.y = data["rot_y"]
    camera_pivot.rotation.x = data["pivot_x"]
    
    # Восстанавливаем экипировку
    if data["has_helmet"]:
        equip_helmet()
    if data["has_vest"]:
        equip_vest()
    if data["has_toolbox"]:
        pick_toolbox()
