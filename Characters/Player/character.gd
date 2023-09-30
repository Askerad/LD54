extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

#var _airtime: float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# timer for the coyote jump
var Jump_buffer = null
@export var delay = 0.3

func _ready():
	Jump_buffer = Timer.new()
	Jump_buffer.one_shot = true
	Jump_buffer.wait_time = delay
	add_child(Jump_buffer)
	

func jump():
		velocity.y = JUMP_VELOCITY
		if !Input.is_action_pressed("ui_accept"):
			jump_cut()

func jump_cut():
	Jump_buffer.stop()
	if velocity.y < -100:
			velocity.y = -100

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			print("jump classique")
			jump()
		else:
			print("space in space")
			Jump_buffer.start()
	if is_on_floor():
		if !Jump_buffer.is_stopped():
			Jump_buffer.stop()
			jump()
	if Input.is_action_just_released("ui_accept"):
		jump_cut()
	# Handle Jump.
	
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)

	move_and_slide()
