extends Area2D

var texture_active = preload("res://assets/levers/lever_01_03.png")

func _on_body_entered(body: PhysicsBody2D) -> void:
	change()

func change() -> void:
	PlayerData.active = true
	$Sprite.set_texture(texture_active)
