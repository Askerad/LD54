extends CharacterBody2D

@export var delay = 0.3
@export var wall_delay = 0.3
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var wall_jump_delay = 2
#var _airtime: float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var wall_grabbed = 0
var wall_jumped = 0

var Jump_buffer = null
var wall_jump_timer = null
var wall_stance_timer = null

func _ready():
	#set timers for the functions
	Jump_buffer = Timer.new()
	Jump_buffer.one_shot = true
	Jump_buffer.wait_time = delay
	add_child(Jump_buffer)
	
	wall_stance_timer = Timer.new()
	wall_stance_timer.one_shot = true
	wall_stance_timer.wait_time= wall_delay
	add_child(wall_stance_timer)

	wall_jump_timer = Timer.new()
	wall_jump_timer.one_shot = true
	wall_jump_timer.wait_time= wall_jump_delay
	add_child(wall_jump_timer)
	
func jump():
		velocity.y = JUMP_VELOCITY
		#cut if jump button is released before max velocity
		if !Input.is_action_pressed("ui_accept"):
			jump_cut()

func wallgrab(direction):
	if is_on_wall() and direction and !is_on_floor() and wall_grabbed == 0:
		wall_grabbed = 1
		wall_stance_timer.start()
	if !wall_stance_timer.is_stopped():
		velocity.y = 0
		if Input.is_action_just_pressed("ui_accept"):
			wall_stance_timer.stop()
			wall_jump(direction)
		#print ("I touched da wall")	

func wall_jump(direction):
	wall_jumped = 1
	wall_jump_timer.start()
	velocity.y = JUMP_VELOCITY
	velocity.x = -direction * SPEED + (direction * -2000)
	

func jump_cut():
	Jump_buffer.stop()
	if velocity.y < -100:
			velocity.y = -100

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		wall_grabbed = 0
		
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			#print("jump classique")
			jump()
		else:
			#print("space in space")
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
	if direction and wall_jumped == 0:
		wall_jumped = 1
		velocity.x = lerp(velocity.x, direction * SPEED, 0.15)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		
	#will activate if player is in the air 
	wallgrab(direction)	
	if is_on_wall() and direction and !is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		wall_jump(direction)
	
	if wall_jump_timer.is_stopped:
		wall_jumped = 0

	move_and_slide()
