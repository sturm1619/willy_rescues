extends Node2D

@export var spawnPoint = false


func _on_area_2d_area_entered(area):
	print("Player entered the checkpoint area.")
	get_tree().change_scene_to_file("res://scene/level/level_2.tscn")
