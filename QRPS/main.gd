extends Node2D

@onready var rock_slider = $RockSlider
@onready var paper_slider = $PaperSlider
@onready var scissors_slider = $ScissorsSlider
@onready var confirm_button = $ConfirmButton
@onready var opponent_label = $OpponentMoveLabel
@onready var outcome_label = $OutcomeLabel

var player_probabilities = {"Rock": 0.0, "Paper": 0.0, "Scissors": 0.0}
var choices = ["Rock", "Paper", "Scissors"]

func _ready():
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	# Get player's probability values
	var total = rock_slider.value + paper_slider.value + scissors_slider.value
	if total == 0:
		outcome_label.text = "Choose valid probabilities!"
		return
	
	# Normalize probabilities to sum to 1
	player_probabilities["Rock"] = rock_slider.value / total
	player_probabilities["Paper"] = paper_slider.value / total
	player_probabilities["Scissors"] = scissors_slider.value / total

	# Collapse player's move based on probability distribution
	var player_move = quantum_collapse(player_probabilities)
	
	# AI opponent also selects a move (random superposition)
	var opponent_probabilities = generate_random_superposition()
	var opponent_move = quantum_collapse(opponent_probabilities)

	# Display opponent move
	opponent_label.text = "Opponent chose: " + opponent_move

	# Determine outcome
	var result = determine_winner(player_move, opponent_move)
	outcome_label.text = result

func quantum_collapse(probabilities: Dictionary) -> String:
	# Simulate quantum measurement based on probability distribution
	var random_number = randf()
	var cumulative_prob = 0.0
	
	for choice in choices:
		cumulative_prob += probabilities[choice]
		if random_number < cumulative_prob:
			return choice
	return "Rock"  # Fallback (should not happen)

func generate_random_superposition() -> Dictionary:
	var r = randf()
	var p = randf()
	var s = randf()
	var total = r + p + s
	return {
		"Rock": r / total,
		"Paper": p / total,
		"Scissors": s / total
	}

func determine_winner(player: String, opponent: String) -> String:
	if player == opponent:
		return "It's a tie!"
	elif (player == "Rock" and opponent == "Scissors") or \
		 (player == "Paper" and opponent == "Rock") or \
		 (player == "Scissors" and opponent == "Paper"):
		return "You win!"
	else:
		return "You lose!"
