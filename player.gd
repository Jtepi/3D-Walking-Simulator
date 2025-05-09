extends CharacterBody3D

@export var speed: float = 5.0
@export var rotation_speed: float = 2.0
@export var mouse_sensitivity: float = 0.002
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var y_velocity: float = 0.0

var can_move := false

@onready var start_menu: CanvasLayer = $"../StartMenu" 
@onready var player: Node = $Player 

# Triggered when the Start button is pressed
func _on_start_button_pressed():
	start_menu.visible = false
	can_move = true  

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_menu.visible = true

func _physics_process(delta):
	if not can_move:
		return

	var direction = Vector3.ZERO
	var forward = -transform.basis.z
	var right = transform.basis.x
	
	# WASD movement input
	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_back"):
		direction -= forward

	if Input.is_action_pressed("move_left"):
		rotate_y(rotation_speed * delta)
	if Input.is_action_pressed("move_right"):
		rotate_y(-rotation_speed * delta)

	direction = direction.normalized()
	var movement = direction * speed

	if not is_on_floor():
		y_velocity -= gravity * delta
	else:
		y_velocity = 0.0

	movement.y = y_velocity
	velocity = movement
	move_and_slide()
	
	# Restarting game if player falls 
	if global_position.y < -10:
		get_tree().reload_current_scene()
		
