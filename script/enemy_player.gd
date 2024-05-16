extends CharacterBody2D



const SPEED = 200.0
const ATTACK_RANGE = 50.0
const MOV_RANGE = 100.0
const GRAVITY = 500.0  # Adjust this value as needed

@onready var healthbar = $HealthBar #access healthbar scene

@onready var anim = get_node("AnimationPlayer")
var jumping : bool = false
var attacking : bool = false
var moving : bool = false
var hurting : bool = false
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_health = 5


func _ready():
	anim.play("Idle")
	healthbar.init_health(player_health) #link healthbar to enemyhealth
#print("Enemy ready")  # Confirm that the enemy script initializes.

func jump(delta):
	if is_on_floor():
		jumping = false
		velocity.y = 0  # Reset the vertical velocity when on the floor

	if jumping:
		velocity.y -= 10 * delta  # Apply an upward force when jumping

func attack(player_position):
	if global_position.distance_to(player_position) < ATTACK_RANGE:
		anim.play("Attack")

func move_towards_player(player_position):
	var direction_to_player = (player_position - global_position).normalized()
	velocity.x = direction_to_player.x * SPEED  # Update horizontal velocity towards the player
	anim.play("Run")
	$AnimatedSprite2D.flip_h = global_position.x > player_position.x

func idle():
	velocity = Vector2.ZERO  # Reset velocity to zero after applying gravity
	anim.play("Idle")


func _physics_process(delta):
	#var testing : bool = false
	#if testing:
		#print("testing")
	var players = get_tree().get_nodes_in_group("players")
	var player_position = players[0].global_position
		
	if hurting and anim.get_current_animation() != "Hit":
		anim.play("Hit")
		velocity.x = -(player_position - global_position).normalized().x * 50.0
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity continuously when not on the floor
	
	if not hurting:
		if players.size() > 0:
			var distance_to_player = global_position.distance_to(player_position)
			if distance_to_player < ATTACK_RANGE:
				attack(player_position)
			elif distance_to_player < MOV_RANGE:
				move_towards_player(player_position)
			else:
				idle()
		else:
			idle()

	move_and_slide()  # Apply sliding with gravity

func _on_area_2d_area_entered(area):
	#Sprint("Enemy takes damage")
	#print(area)
	player_health -= 1
	#print(player_health, "health left")
	healthbar.health = player_health
	hurting = true
	velocity = Vector2.ZERO
	if player_health <= 0:
		queue_free()
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Hit":
		#print("animation finished")
		hurting = false
		idle()
