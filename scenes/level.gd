extends Node2D

var ballastic_projectile_scene: PackedScene = preload("res://scenes/projectiles/ballastic_projectile.tscn")

func _on_ship_ballastic_fired(pos: Vector2, initial_velocity: Vector2, _rotation: float):
	var ballastic = ballastic_projectile_scene.instantiate() as RigidBody2D
	$Projectiles.add_child(ballastic)
	ballastic.initialize(pos, _rotation, initial_velocity)
