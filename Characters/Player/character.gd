extends CharacterBody2D

enum PlayerStates {
	Running,
	Jumping,
	Falling,
	Walljumping,
	Dashing
}



@export var delay = 0.3
@export var wall_delay = 0.3
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var wall_jump_delay = 2
#var _airtime: float = 0.0

#var for including the animated sprite
@onready var _animatedSprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_dash = 1

var wall_grabbed = 0
var wall_jumped = 0

@export var wall_jump_timer: Timer;
var wall_stance_timer = null
var state: PlayerStates = PlayerStates.Running;
@onready var minimum_jump_timer = $MinimumJumpTimer
@onready var jump_buffer = $JumpBufferTimer
@onready var dash_time = $DashingTimer
@onready var wj_ray_right = $WJRayRight
@onready var wj_ray_left = $WJRayLeft

func _ready():

	wall_stance_timer = Timer.new()
	wall_stance_timer.one_shot = true
	wall_stance_timer.wait_time= wall_delay
	add_child(wall_stance_timer)

#	wall_jump_timer = Timer.new()
#	wall_jump_timer.one_shot = true
#	wall_jump_timer.wait_time= wall_jump_delay
#	add_child(wall_jump_timer)

func dashing(direction):
	dash_time.start()
	state = PlayerStates.Dashing
	
func jump():
		minimum_jump_timer.start();
		velocity.y = JUMP_VELOCITY
		state = PlayerStates.Jumping
	

func wallgrab(direction):
	if is_on_wall() and direction and !is_on_floor() and wall_grabbed == 0:
		wall_grabbed = 1
		wall_stance_timer.start()
	if !wall_stance_timer.is_stopped():
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			wall_stance_timer.stop()
			wall_jump(direction)
		#print ("I touched da wall")	

func wall_jump(direction):
	wall_jumped = 1
	wall_jump_timer.start()
	velocity.y = JUMP_VELOCITY
	velocity.x = -direction * SPEED + (direction * -250)
	

func jump_cut():
	#_animatedSprite.play("fall_stable")
	jump_buffer.stop()
	if velocity.y < -100:
			velocity.y = -100

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")

	#Gravity Handling
	if not is_on_floor():
		velocity.y += gravity * delta

	if jump_buffer.time_left > 0 and is_on_floor():
		state =  PlayerStates.Jumping
		jump()

	match state:
		PlayerStates.Running: 
			if can_dash == 0:
				can_dash = 1
			print(_animatedSprite.is_flipped_h())
			if direction:
				$GPUParticles2D.emitting = true;
				_animatedSprite.play("running")
				velocity.x = lerp(velocity.x, direction * SPEED, 0.15)
				if Input.is_action_pressed("left"):
					_animatedSprite.flip_h = true
					$GPUParticles2D.rotation_degrees= 0;
				else:
					_animatedSprite.flip_h = false
					$GPUParticles2D.rotation_degrees= 180;
			else:
				$GPUParticles2D.emitting = false;
				_animatedSprite.play("idle")
				velocity.x = lerp(velocity.x, 0.0, 0.2)
			if Input.is_action_pressed("jump"):
				if is_on_floor():
					#print("jump classique")
					jump()
			if Input.is_action_just_pressed("dash") and can_dash == 1:
				can_dash = 0
				dashing(direction)
			
		PlayerStates.Jumping:
			$GPUParticles2D.emitting = false;
			
			_animatedSprite.play("Jumping")
			if velocity.x <= 0:
				_animatedSprite.flip_h = true
			else:
				_animatedSprite.flip_h = false
			velocity.x = lerp(velocity.x, direction * SPEED, 0.05)
			
			if velocity.y > 0:
				#print("FALLING")
				jump_cut();
				state = PlayerStates.Falling
				
			if not minimum_jump_timer.time_left and not Input.is_action_pressed("jump"):
				#print("CUT")
				jump_cut();
				state = PlayerStates.Falling
				
			if is_on_wall() and Input.is_action_just_pressed("jump"):
				_animatedSprite.flip_h = true
				wall_jump_timer.start();
				state = PlayerStates.Walljumping;
				if wj_ray_left.is_colliding(): wall_jump(-1);
				if wj_ray_right.is_colliding(): wall_jump(1);
				
			
			if is_on_floor() and not jump_buffer.time_left: 
				state = PlayerStates.Running
			if Input.is_action_just_pressed("dash") and can_dash == 1:
				can_dash = 0
				dashing(direction)
			pass
			
		PlayerStates.Falling:
			_animatedSprite.play("falling")
			$GPUParticles2D.emitting = false;
			velocity.x = lerp(velocity.x, direction * SPEED, 0.05)
			if velocity.x < 0:
					_animatedSprite.flip_h = true
			else:
				_animatedSprite.flip_h = false
			
			if is_on_wall() and !is_on_floor():
				_animatedSprite.play("wall_grabbing")
			elif !is_on_wall() and !is_on_floor():
				_animatedSprite.play("falling")
			
			if Input.is_action_pressed("jump"):
				jump_buffer.start()
				
			if is_on_wall() and Input.is_action_just_pressed("jump"):
				wall_jump_timer.start();
				state = PlayerStates.Walljumping;
				if wj_ray_left.is_colliding(): wall_jump(-1);
				if wj_ray_right.is_colliding(): wall_jump(1);	
			
			if is_on_floor() and not jump_buffer.time_left: 
				state = PlayerStates.Running
			if Input.is_action_just_pressed("dash") and can_dash == 1:
				can_dash = 0
				dashing(direction)
		
		PlayerStates.Walljumping:
			$GPUParticles2D.emitting = false;
			if wall_jump_timer.is_stopped():
				state = PlayerStates.Falling
				
			if is_on_floor() and not jump_buffer.time_left: 
				state = PlayerStates.Running
			
		PlayerStates.Dashing:
			velocity.y = 0
			if _animatedSprite.is_flipped_h():
				velocity.x = -1000
			else:
				velocity.x = 1000
			print(velocity.x)
			print (dash_time.time_left)
			if dash_time.is_stopped() and is_on_floor():
				can_dash = 1
				state = PlayerStates.Running
			if dash_time.is_stopped() and !is_on_floor():
				state = PlayerStates.Falling
			

	move_and_slide()

