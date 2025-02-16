extends MenuBar

@onready var file_menu := $PopupMenu
@onready var box := get_node("../CSGBox3D")

var is_rainbow = false
var red = 0
var blue = 0
var green = 0

func rainbow():
	if is_rainbow:
		if red >= 1:
			red = 0
		if blue >= 1:
			blue = 0
		if green >= 1:
			green = 0
		red += .001
		blue += .005
		green += .009
	
		box.material_override.albedo_color = Color(red,blue,green)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file_menu.add_item("color red" , 0)
	file_menu.add_item("color green" , 1)
	file_menu.add_item("color blue" , 2)
	file_menu.add_item("color rainbow" , 3)
	file_menu.id_pressed.connect(_on_pressed) # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rainbow()

func _on_pressed(id):
	print(id)
	match id:
		0:
			box.material_override.albedo_color = Color(.5,0,0)
		1:
			box.material_override.albedo_color = Color(0,1,0)
		2:
			box.material_override.albedo_color = Color(.1,.1,1)
		3:
			if !is_rainbow:
				is_rainbow = true
			else: is_rainbow = false
