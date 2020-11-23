extends Actor

export var stomp_impulso: = 600.0	
var esta_vivo = true

func _physics_process(delta: float) -> void:
	var jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction	: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	
	#função de controle para saber quando mover o personagem
	_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)

func get_direction() -> Vector2:
	# quando a função ser acionada, irá fazer a identifação de qual animação realizar e retornar a direção atual
	anim()
	# calculo de movimentação a ser realizado, e identificação se está no chão
	# -1.0 = 0.0 = 1.0
	# se só, esquerda = -1, direita = 1, os dois ao mesmo tempo = 0
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)

func _on_StompDetector_area_entered(area: Area2D) -> void:
	#calculo de stomp ao atingir rocha/inimigo
	_velocity = calcular_stomp(_velocity, stomp_impulso)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	#ativar animação e morte
	esta_vivo = false
	move_and_slide_with_snap(Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, false)
	die()

func calculate_move_velocity(
		velocidade_linear: Vector2,
		direction: Vector2,
		speed: Vector2,
		jump_interrupted: bool
	) -> Vector2:
		
	var velocidade: = velocidade_linear
	velocidade.x = speed.x * direction.x
	
	if direction.y != 0.0:
		velocidade.y = speed.y * direction.y
	
	if jump_interrupted:
		velocidade.y = 0.0
		
	return velocidade

func calcular_stomp(velocidade_linear: Vector2, stomp_impulso: float) -> Vector2:
	var stomp_pulo: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulso
	$AnimatedSprite.play("jump")
	
	return Vector2(velocidade_linear.x, stomp_pulo)
	
func anim() -> void:
	#controle de animação do sprite em movimentação 
	if (esta_vivo && Input.is_action_pressed("move_right") && is_on_floor()):
		$AnimatedSprite.set_flip_h(false)
		$AnimatedSprite.play("walking")
	elif (esta_vivo && Input.is_action_pressed("move_left") && is_on_floor()):
		$AnimatedSprite.set_flip_h(true)
		$AnimatedSprite.play("walking")
	elif (esta_vivo && Input.is_action_pressed("move_right") && !is_on_floor()):
		$AnimatedSprite.play("floating")
		$AnimatedSprite.set_flip_h(false)
	elif (esta_vivo && Input.is_action_pressed("move_left") && !is_on_floor()):
		$AnimatedSprite.play("floating")
		$AnimatedSprite.set_flip_h(true)
	elif (esta_vivo && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right") && !is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (esta_vivo && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right") && is_on_floor()):
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.stop()
func die() -> void:
		$AnimatedSprite.play("dying")
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimatedSprite.play("died")
		yield(get_tree().create_timer(0.5), "timeout")
		PlayerData.deaths += 1
		queue_free()
	

