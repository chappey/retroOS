extends Control

const GRID_SIZE = 3
var board = []  # Stores quantum superpositions
var turn = 1  # 1 for Player X, -1 for Player O

func _ready():
	# Initialize the 3x3 board with empty lists
	for x in range(GRID_SIZE):
		board.append([])
		for y in range(GRID_SIZE):
			board[x].append([])
			# Assign each button its (x, y) position and reference to the board
			var cell = get_node("GridContainer").find_child("Cell_" + str(x) + "_" + str(y), true, false)
			if cell:
				cell.x = x
				cell.y = y
				cell.board_ref = self  # Assign board reference

	update_ui()

func make_move(x, y):
	# Ensure board[x][y] is always an array
	if board[x][y] == null:
		board[x][y] = []

	# Store the quantum move
	var move_id = str(turn) + "_" + str(x) + "_" + str(y)
	board[x][y].append(move_id)

	# Print the board state to debug what's happening
	#print_board()

	if check_cycle():
		collapse_board()
	else:
		turn *= -1  # Switch turns

	update_ui()
	
func print_board():
	print("Current Board State:")
	for row in board:
		print(row)


func update_ui():
	var grid = get_node("GridContainer")
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var cell = grid.find_child("Cell_" + str(x) + "_" + str(y), true, false)
			if cell:
				var move_text = ""
				for move in board[x][y]:
					move_text += "X" if move.split("_")[0] == "1" else "O"
					move_text += "\n"
				cell.text = move_text  # Display moves

func check_cycle():
	var visited = {}  # Keep track of visited moves
	var stack = []  # Stack for DFS cycle detection

	# Scan the board for potential cycles
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			for move in board[x][y]:
				if move in visited:
					continue
				if _dfs(move, visited, stack):
					return true  # A cycle was detected!

	return false  # No cycles found

func _dfs(move, visited, stack):
	if stack == null or typeof(stack) != TYPE_ARRAY:
		stack = []  # Ensure stack is a valid array

	if move in stack:
		return true  # A cycle is detected

	stack.append(move)
	visited[move] = true

	var x = int(move.split("_")[1])  # Extract X coordinate
	var y = int(move.split("_")[2])  # Extract Y coordinate

	for linked_move in board[x][y]:  # Check all moves in this cell
		if linked_move != move and _dfs(linked_move, visited, stack):
			return true

	# Ensure stack is an array before calling `pop()`
	if typeof(stack) == TYPE_ARRAY and stack.size() > 0:
		stack.pop_back()  # Safely remove the last element

	return false

func collapse_board():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			if len(board[x][y]) > 1:  # If multiple moves exist
				var collapse_choice = board[x][y].pick_random()  # Pick one move randomly
				board[x][y] = [collapse_choice]  # Remove all other moves

	update_ui()
	check_game_end()

func check_winner():
	for i in range(GRID_SIZE):
		# Check rows (must contain exactly 1 move in each cell)
		if len(board[i][0]) == 1 and len(board[i][1]) == 1 and len(board[i][2]) == 1:
			if board[i][0][0].split("_")[0] == board[i][1][0].split("_")[0] and board[i][1][0].split("_")[0] == board[i][2][0].split("_")[0]:
				return board[i][0][0].split("_")[0]  # Return "1" (X) or "-1" (O)

		# Check columns
		if len(board[0][i]) == 1 and len(board[1][i]) == 1 and len(board[2][i]) == 1:
			if board[0][i][0].split("_")[0] == board[1][i][0].split("_")[0] and board[1][i][0].split("_")[0] == board[2][i][0].split("_")[0]:
				return board[0][i][0].split("_")[0]

	# Check diagonals
	if len(board[0][0]) == 1 and len(board[1][1]) == 1 and len(board[2][2]) == 1:
		if board[0][0][0].split("_")[0] == board[1][1][0].split("_")[0] and board[1][1][0].split("_")[0] == board[2][2][0].split("_")[0]:
			return board[0][0][0].split("_")[0]

	if len(board[0][2]) == 1 and len(board[1][1]) == 1 and len(board[2][0]) == 1:
		if board[0][2][0].split("_")[0] == board[1][1][0].split("_")[0] and board[1][1][0].split("_")[0] == board[2][0][0].split("_")[0]:
			return board[0][2][0].split("_")[0]

	return null  # No winner yet

func check_game_end():
	var winner = check_winner()
	if winner != null:
		#print("Player", "X" if winner == "1" else "O", "wins!")  # Debugging
		$Label.text = "Player " + ("X" if winner == "1" else "O") + " Wins!"
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()  # Restart game after 2 seconds
