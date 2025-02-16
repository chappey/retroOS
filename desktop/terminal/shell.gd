extends Node


func term_print() -> void:
	pass


func cmd_bbprint() -> void:
	pass


func cmd_exit() -> void:
	pass

func cmd_echo() -> void:
	pass

func cmd_ls() -> void:
	pass



# Define the available commands and their corresponding functions
var commands = {
	"echo": Callable(self, "cmd_echo"),
	"ls": Callable(self, "cmd_ls"),
	"cd": Callable(self, "cmd_cd"),
	"exit": Callable(self, "cmd_exit")
}



# Current working directory
var cwd = "/"

func _ready():
	print("Welcome to the GDScript shell!")
	print("Type 'help' for a list of available commands.")
	print("Type 'exit' to quit.")

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		parse_command(get_line())

func get_line():
	return Input.get_line_ascii()

func parse_command(line):
	var args = line.split(" ")
	var cmd = args[0]
	
	if cmd in commands:
		commands[cmd].call_func(args)
	else:
		print("Unknown command: ", cmd)

func cmd_echo(args):
	if len(args) > 1:
		print(PoolStringArray(args).join(" "))

func cmd_ls(_args):
	print("Listing files in ", cwd)
	# Implement your ls command logic here

#func cmd_cd(args):
	#if len(args) > 1:
		#var new_dir = args[1]
		#if new_dir == "/":
			#cwd = "/"
		#elif new_dir == "..":
			#var parts = cwd.split("/")
			#cwd = "/".join(parts[:-2]) + "/"
		#else:
			#cwd = cwd.rstrip("/") + "/" + new_dir
		#print("Changed directory to ", cwd)
	#else:
		#print("Usage: cd <directory>")

func cmd_exit(_args):
	print("Exiting...")
	get_tree().quit()
