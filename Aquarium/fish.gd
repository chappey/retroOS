extends Sprite2D

var direction = "right";
var rng = RandomNumberGenerator.new()
var speed_change_interval = rng.randf_range(0, 1200);
var new_speed: int = 1;
var curr_speed: int = 1;
var speed_changed = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# update y and x direction.
	if position.x > 1300:
		direction = "left";
		position.y = rng.randf_range(0, 650.0);
		flip_h = true;
		speed_changed = false;
	elif position.x < -100:
		direction = "right";
		position.y = rng.randf_range(0, 650.0);
		flip_h = false;
		speed_changed = false;
		
	
	# move
	if direction == "right":
		if position.x > speed_change_interval && speed_changed == false:
			new_speed = rng.randi_range(1, 5);
			speed_changed = true;
			speed_change_interval = rng.randf_range(0, 1200);
		if curr_speed < new_speed:
			curr_speed += 0.5;
		elif curr_speed > new_speed:
			curr_speed -= 0.5;
		position.x += new_speed;	
	else: 
		if position.x < speed_change_interval && speed_changed == false:
			new_speed = rng.randi_range(1, 5);
			speed_changed = true;
			speed_change_interval = rng.randf_range(0, 1200);
		if curr_speed < new_speed:
			curr_speed += 0.5;
		elif curr_speed > new_speed:
			curr_speed -= 0.5;
		position.x -= new_speed;
