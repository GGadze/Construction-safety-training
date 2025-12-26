extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 5.0
@export var mouse_sensitivity: float = 0.003

@onready var camera_pivot: Node3D = $CameraPivot

var has_helmet: bool = false
var has_vest: bool = false
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

    # гравитация
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_velocity

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
    $Visual/HelmetVisual.visible = true
    GameManager.task_manager.submit_action("put_helmet")
    print("Каска надета")

func equip_vest():
    has_vest = true
    $Visual/VestVisual.visible = true
    GameManager.task_manager.submit_action("put_vest")
    print("Жилет надет")
