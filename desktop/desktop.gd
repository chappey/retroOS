extends Control


@onready var taskbar := $Taskbar
@onready var menu_button := $Taskbar/MenuButton
@onready var game_menu_button := $Taskbar/MenuButton/MenuButton
#@onready menu_button.add_submenu_item("Games", game_menu_button)

enum Progs { PRGS=0, AI=1, TXT_ED=2, CUBE=3, ABOUT=4,}
enum Games {TicTac=0}

@onready var window: Array[Window] = [null, $AIWindow, $TxtEdWindow, $CubeWindow, $AboutWindow, $TicTacWindow]


func _ready() -> void:
	var submenu = PopupMenu.new()
	submenu.set_name("submenu")
	submenu.add_item("Tic Tac Toe",0)
	submenu.id_pressed.connect(subMenu)
	menu_button.get_popup().add_child(submenu)
	menu_button.get_popup().add_submenu_item("Game", "submenu")
	menu_button.get_popup().connect(&"id_pressed", func(id: int):
		print(id)
		match id:
			Progs.ABOUT:
				window[Progs.ABOUT].show()
			Progs.AI:
				window[Progs.AI].show()
			Progs.TXT_ED:
				window[Progs.TXT_ED].show()
			Progs.CUBE:
				window[Progs.CUBE].show()
			#Progs.PRGS:
	)
	
func subMenu(id):
	match id:
		0:	
			window[5].show()
			
		
