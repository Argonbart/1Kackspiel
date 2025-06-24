class_name Poop
extends StaticBody2D


# exports
@export_category("Falling Force")
@export var falling_force_x: float = -20.0
@export var falling_force_y: float = 4.0
@export var falling_force_dropoff_x: float = 0.3
@export_category("Nodes")
@export var poop_color_sprite: Sprite2D
@export var poop_sprite: AnimatedSprite2D
@export var poop_area: Area2D

# variables
var hit_ground: bool = false


func _ready() -> void:
	connect("tree_exited", explode_on_impact)


# movement
func _physics_process(delta):
	
	if hit_ground:
		return
	
	position += Vector2(falling_force_x * pow(-1, Globals.invert_direction), falling_force_y)
	falling_force_x -= falling_force_dropoff_x
	if falling_force_x < 0.0:
		falling_force_x = 0.0
	
	move_and_collide(Vector2(0.0, 1.0) * delta)


func set_color(new_color: Color):
	poop_color_sprite.self_modulate = new_color


func explode_on_impact():
	for child in get_children():
		if child.get_groups().has("ice"):
			print("ice explosion")
			hit_ground = true
			child.explode()


func _on_poop_area_area_entered(area: Area2D):
	if area.get_groups().has("umbrella"):
		area.queue_free()
	if area.get_groups().has("hat"):
		area.queue_free()
	if area.get_groups().has("ground"):
		hit_ground = true
		poop_area.set_deferred("monitoring", false)
		await get_tree().create_timer(10.0).timeout
		queue_free()
