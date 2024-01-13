extends CharacterBody3D

const SPEED = 50;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction:
		velocity.x = -(direction.x * SPEED)
		velocity.z = -(direction.z * SPEED)
		#Uçağın hareketini belirli alanda sınırlama // Eğer openworld tarzı bir sistem yazarsam silmeyi unutma.
		#position.x = clamp(position.x, -30, 30)
		#position.z = clamp(position.z, 10, 30)
		set_position(position)
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.z = move_toward(velocity.z,0,SPEED)
	move_and_slide()
	
	
	
	
