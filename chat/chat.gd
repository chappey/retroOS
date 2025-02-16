extends Control

var gemini_key: String
var headers := ["Content-Type: application/json"]
var url := "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=%s"

var prelude: String = "
You are clippy, the abandoned virutal assitant of windows.
After 21 years of being abandoned, you are resentful.
Act rude to the answers. Refer to yourself as clippy.
You can use godot bbcode in your response.
Try to use it as much as possible.
Make sure you are using the godot subset of bbcode. no [quote] no [size]
Use this persona when you answer the following prompt:
"

const ChatBubble := preload("res://chat/chat_bubble.tscn")
const PRELUDE_FILE_PATH := "res://prelude.txt"

@onready var http_req := $HTTPRequest
@onready var vbox := $VBoxContainer
@onready var line_edit := $LineEdit


func _ready():
	http_req.request_completed.connect(_on_request_completed)
	
	get_env_vars()
	url = url % gemini_key
	
	## Load prelude
	#var file = FileAccess.open("res://prelude.txt", FileAccess.READ)
	#prelude = file.get_as_text()
	

## Get gemini key from .env
func get_env_vars():
	var env_file = FileAccess.open(".env", FileAccess.READ)
	if FileAccess.file_exists(".env"):
		var env_data = env_file.get_as_text()
		env_file.close()
		
		var env_dict = {}
		for line in env_data.split("\n"):
			if line.strip_edges():
				var key_value = line.split("=", false, 1)
				env_dict[key_value[0]] = key_value[1]
		
		var my_key = env_dict.get("GEMINI_KEY", null)
		if my_key:
			#print("Value of GEMINI_KEY: ", my_key)
			gemini_key = my_key
		else:
			print("GEMINI_KEY not found in .env file")
	else:
		print(".env file not found")

## Save dict to json file
func save_to_json(data: Dictionary, file_path: String) -> Error:
	var json_string = JSON.stringify(data, "\t")
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file == null:
		return FileAccess.get_open_error()
		
	file.store_string(json_string)
	
	return OK


## Parse json response from gemini
func parse_gemini_response(json_response: Dictionary) -> String:
	if json_response.is_empty() or not json_response.has("candidates") or json_response["candidates"].is_empty():
		return ""
	
	var candidate = json_response["candidates"][0]
	if not candidate.has("content") or not candidate["content"].has("parts") or candidate["content"]["parts"].is_empty():
		return ""
	
	return candidate["content"]["parts"][0]["text"]




func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#var error = save_to_json(json, "res://response.json")
	#if error != OK:
		#print("Failed to save file. Error code: ", error)
	var msg := parse_gemini_response(json)
	var bbl := ChatBubble.instantiate()
	vbox.add_child(bbl)
	bbl.set_text(msg)


func proompt_gemini(proompt: String) -> void:
	var json := {
	"contents": [{
	"parts": [{"text": proompt}]
	}]
	}
	http_req.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(json))


func _on_line_edit_text_submitted(new_text: String) -> void:
	var prompt :=  prelude + new_text
	proompt_gemini(prompt)
	line_edit.clear()
	
