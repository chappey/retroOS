extends Button

var x = 0  # The row position in the grid
var y = 0  # The column position in the grid
var board_ref = null  # Reference to Board.gd (assigned in Board.gd)

func _ready():
	# Connect the button click event to trigger a move
	connect("pressed", _on_button_pressed)

func _on_button_pressed():
	if board_ref:
		board_ref.make_move(x, y)  # Call Board.gd to make a move
	else:
		print("Error: board_ref is NULL for Cell_", x, "_", y)
