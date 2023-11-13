extends RigidBody2D

const speed = 750

func initialize(pos: Vector2, _rotation: float, initial_velocity: Vector2):
	position = pos
	rotation = _rotation
	
	# Add speed to the current Y velocity, regardless of direction. This is then
	# negated as if it was always being fired "upwards". This is then corrected
	# with the rotated call
	initial_velocity.y = -(abs(initial_velocity.y) + speed)
	linear_velocity = initial_velocity.rotated(_rotation)
