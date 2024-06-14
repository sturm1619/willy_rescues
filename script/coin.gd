extends Area2D

signal coin_collected
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("spin")


func _on_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("coin_collected")
		queue_free()
#
