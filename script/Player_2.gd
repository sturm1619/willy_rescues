# Carlos revision

extends CharacterBody2D

class_name Player

var player_health = 20
@export var maxHealth = 20

const SPEED = 200.0
const JUMP_VELOCITY = -350.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")
@onready var healthbar = $CanvasLayer/HealthBar2

var jumping : bool = false
var attacking : bool = false
var moving : bool = false
var hurting : bool = false
var attack_button_cooling_down : bool = false

const air_speed_top : float = 50.0
var air_accel : float = 0.0


func _on_area_2d_area_entered(_area):
	print("Player enemy house")
	player_health -= 1
	print(player_health)
	if player_health < 0:
		queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack" or "Attack&Run":
		attacking = false 
	if anim_name == "Hit":
		hurting = false

func _ready():
	healthbar.init_health(player_health)
	anim.play("Idle")
	add_to_group("players")
	

func jump():
	if is_on_floor():
		jumping = false
		air_accel = 0
	
	if not is_on_floor():
		if velocity.y > -50 and anim.get_current_animation() == "Jump" and anim.get_current_animation() != "Hit":
			anim.play("Fall")

	if jumping:
		return

	if Input.is_action_pressed("ui_accept"):
		jumping = true
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

func attack():
	if not Input.is_action_pressed("Attack"):
		attack_button_cooling_down = false
	if Input.is_action_pressed("Attack") and not attack_button_cooling_down:
		attacking = true
	if attacking and not (moving or hurting or anim.get_current_animation() == "Attack&Run"):
		attack_button_cooling_down = true
		anim.play("Attack")
		velocity.x = 0
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
		velocity.x = direction * SPEED
		
		if is_on_floor() and moving and not (jumping or attacking or hurting) and anim.get_current_animation() != "Attack" and anim.get_current_animation() != "Run":
			if not attacking:
				anim.play("Run")
		if is_on_floor() and moving and attacking and not (jumping or hurting) and anim.get_current_animation() != "Attack":
			attack_button_cooling_down = true
			anim.play("Attack&Run")
			velocity.x = 0

	# if not moving and anim.get_current_animation() != "Idle" and (anim.get_current_animation() != "Attack" or not attacking):
	# 	velocity.x = 0
	# 	if velocity.y == 0:
	# 		anim.play("Idle")


func idle():
	#if not (jumping and moving and hurting): 
	if not jumping and not moving:
		velocity.x = 0
		if velocity.y == 0 and not attacking or hurting:
			anim.play("Idle")
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if hurting and anim.get_current_animation() != "Hit":
		anim.play("Hit")
		
	if anim.get_current_animation() != "Hit":
		jump()
		attack()
		move()
		idle()
	move_and_slide()

func _on_area_2d_area_entered_health(_area):
	#print("willy takesh damage")
	player_health -= 1
	#print(player_health, "health left")
	healthbar.health = player_health
	if player_health < 0:
		queue_free()
	velocity = Vector2.ZERO
	hurting = true
