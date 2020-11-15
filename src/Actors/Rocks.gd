extends Actor


onready var stomp_area: Area2D = $StompArea2D


func _ready() -> void:
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	_velocity.x *= -1 if is_on_wall() else 1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y 
	if is_on_floor():
		_velocity.y = -500 

func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
