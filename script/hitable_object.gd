extends Node2D

@onready var health_bar = $CanvasLayer/HealthBar #access healthbar scene

@export var spawnPoint = false
var health_house = 5

func _ready():
	health_bar.init_health(health_house) #link healthbar to enemyhealth


func _on_area_2d_area_entered(area):
	print("Player hit house")
	health_house -= 1
	print(health_house)
	health_bar.health = health_house
	if health_house <= 0:
		queue_free()
	
	


