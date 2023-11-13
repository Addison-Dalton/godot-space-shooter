extends CharacterBody2D

var speed: int = 5
var rotation_speed: float = 0.5

var can_fire_ballastic_projectile: bool = true
var next_ballastic_marker_index = 0

signal on_ballastic_fired(position: Vector2, rotation: float, starting_speed: int)

func _process(delta):
	handle_movement()
	fire_ballastic_projectile()
	
func handle_movement():
	handle_engine_particles()
	if (Input.is_action_pressed("turn_left")):
		rotation_degrees -= rotation_speed
		var turn_left_engines = $Engines/YawEngineParticlesLeft.get_children()
		emit_engine_particles(turn_left_engines)
	if (Input.is_action_pressed("turn_right")):
		rotation_degrees += rotation_speed
		var turn_right_engines = $Engines/YawEngineParticlesRight.get_children()
		emit_engine_particles(turn_right_engines)


	var input_direction = Input.get_vector("strafe_left", "strafe_right", "forward", "reverse").rotated(rotation)
	velocity += input_direction * speed
	move_and_slide()
	#print("The current velocity is %s." % velocity)

func fire_ballastic_projectile():
	if (Input.is_action_pressed("primary_action") && can_fire_ballastic_projectile):
		$BallasticProjectileTimer.start()
		var ballastic_markers = $BallasticStartPositions.get_children()
		var selected_marker = ballastic_markers[(next_ballastic_marker_index + 1) % ballastic_markers.size()]

		on_ballastic_fired.emit(selected_marker.global_position, velocity, rotation)
		
		can_fire_ballastic_projectile = false
		next_ballastic_marker_index += 1
		# to keep the index from getting too big
		if (next_ballastic_marker_index == 11):
			next_ballastic_marker_index = 0

func on_ballastic_timer_timeout():
	can_fire_ballastic_projectile = true
	
func handle_engine_particles():
	if (Input.is_action_pressed("turn_left")):
		var turn_left_engines = $Engines/YawEngineParticlesLeft.get_children()
		emit_engine_particles(turn_left_engines)

	if (Input.is_action_pressed("turn_right")):
		var turn_right_engines = $Engines/YawEngineParticlesRight.get_children()
		emit_engine_particles(turn_right_engines)

	if (Input.is_action_pressed("forward")):
		var main_engine_particles = $Engines/MainEngineSmokeParticles
		main_engine_particles.emitting = true

	if (Input.is_action_pressed("reverse")):
		var retro_engines = $Engines/RetrogradeEngineParticles.get_children()
		emit_engine_particles(retro_engines)

	# The strafe engines are "reversed". The left side engines push the ship right and vice-versa
	if (Input.is_action_pressed("strafe_left")):
		var strafe_left_engines = $Engines/StrafeEngineParticlesR.get_children()
		emit_engine_particles(strafe_left_engines)

	if (Input.is_action_pressed("strafe_right")):
		var strafe_right_engines = $Engines/StrafeEngineParticlesL.get_children()
		emit_engine_particles(strafe_right_engines)
	
func emit_engine_particles(engines):
	for i in engines.size():
		engines[i].emitting = true
