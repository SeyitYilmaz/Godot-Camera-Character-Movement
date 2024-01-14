extends Node3D
#########################
# Zoom Params
#########################
@export_range (0, 1000) var min_zoom : int = 10
@export_range (0, 1000) var max_zoom : int = 90
@export_range (0, 1000, 0.1) var zoom_speed : float = 10
@export_range (0, 1, 0.1) var zoom_speed_dump : float = 0.5

#########################
# Camera Movement Params
#########################
@export_range(0, 1000) var movement_speed : float
@export_range(0, 90) var min_elevation_angle : int = 10
@export_range(0, 90) var max_elevation_angle : int = 90
@export_range(0, 1000) var rotation_speed : float = 10
@export var allow_rotation : bool = true

var zoom_direction = 0
var last_mouse_position = Vector2()
var is_rotating = false
var sensitivity = 1000

@onready var main_camera = $RotationPitchPivot/Camera
@onready var pitch_node = $RotationPitchPivot
func _ready():
	pass

func _process(delta):
	_move(delta)
	_rotate(delta)
	_zoom(delta)

func _move(delta: float) -> void:
	var velocity = Vector3()
	
	if Input.is_action_pressed("camera_forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		velocity += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		velocity += transform.basis.x
	velocity = velocity.normalized()
	position += velocity * delta * movement_speed
		
func _rotate(delta: float) -> void:
	if not is_rotating or not allow_rotation:
		return
	var displacement = _get_mouse_displacement()
	_rotate_left_right(delta, displacement.x)
	_pitch_rotation(delta, displacement.y)
	
		
func _zoom(delta: float) -> void:
	var new_zoom = clamp(
		main_camera.position.z + zoom_speed * delta * zoom_direction,
		min_zoom,
		max_zoom)
	main_camera.position.z = new_zoom
	zoom_direction = 0

func _unhandled_input(event: InputEvent) ->void:

	if event.is_action_pressed("camera_rotate"):
		is_rotating = (true)
		last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		is_rotating = false
	if event.is_action_pressed("camera_zoom_in"):
		zoom_direction = -1
	if event.is_action_pressed("camera_zoom_out"):
		zoom_direction = 1

func _get_mouse_displacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - last_mouse_position
	last_mouse_position = current_mouse_position
	return displacement
	
	
func _rotate_left_right(delta: float, val: float)-> void:
	rotation_degrees.y -= val * delta * rotation_speed;
	
func _pitch_rotation(delta: float, val: float) -> void:
	var new_pitch = pitch_node.rotation_degrees.x - val * delta * rotation_speed
	new_pitch = clamp(
		new_pitch,
		-max_elevation_angle,
		-min_elevation_angle
	)
	pitch_node.rotation_degrees.x = new_pitch
