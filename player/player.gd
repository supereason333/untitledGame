extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_TIME_MAX = 10
const HALF_JUMP_DOWN_VELOCITY = 200 
var jump_time = 0
var is_jumping = false
var full_jump = false
var jump_amount = 1 # double jumps
var jump_left = jump_amount

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_jumping = true
		jump_left -= 1
	elif is_on_floor() :
		is_jumping = false
		jump_left = jump_amount
		jump_time = 0
		full_jump = false

	if is_jumping and Input.is_action_pressed("ui_accept") and jump_time < JUMP_TIME_MAX:
		velocity.y = JUMP_VELOCITY
		jump_time += 1
	elif is_jumping and Input.is_action_just_pressed("ui_accept") and jump_left >= 1: # start of double jump
		jump_left -= 1 
		jump_time = 0
		full_jump = false
	elif jump_left >= 2 and not is_on_floor() and Input.is_action_just_pressed("ui_accept"): # start of double jump after fall
		jump_left -= 2
		is_jumping = true
	elif Input.is_action_just_released("ui_accept"):
		jump_time = JUMP_TIME_MAX
	
	if is_jumping and velocity.y >= 0 and Input.is_action_just_released("ui_accept"):
		full_jump = true

	if is_jumping and not full_jump and Input.is_action_just_released("ui_accept"):
		velocity.y += HALF_JUMP_DOWN_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0 and is_on_floor():
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")
	elif velocity.y < 0:
		anim.play("Jump")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	move_and_slide()
