# Carlos revision

extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

var jumping : bool = false
var attacking : bool = false
var moving : bool = false



func _ready():
	anim.play("Idle")


func jump(delta):
	if is_on_floor():
		jumping = false
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if jumping:
		return

	if Input.is_action_pressed("ui_accept"):
		jumping = true
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

func attack():
	if Input.is_action_pressed("Attack"):
		attacking = true
	if attacking:
		anim.play("Attack")
		#anim.animation_set_next("Attack", "Idle")

func move():
	moving = false
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true

	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false

	if direction:
		moving = true
		attacking = false
		velocity.x = direction * SPEED
		if velocity.y == 0 and moving and (anim.get_current_animation() != "Run" and anim.get_current_animation() != "Jump" and anim.get_current_animation() != "Attack"):
			anim.play("Run")

	# if not moving and anim.get_current_animation() != "Idle" and (anim.get_current_animation() != "Attack" or not attacking):
	# 	velocity.x = 0
	# 	if velocity.y == 0:
	# 		anim.play("Idle")


func idle():
	if not attacking and not jumping and not moving:
		velocity.x = 0
		if velocity.y == 0:
			anim.play("Idle")
	

func _physics_process(delta):
	jump(delta)
	attack()
	move()
	idle()
	move_and_slide()

