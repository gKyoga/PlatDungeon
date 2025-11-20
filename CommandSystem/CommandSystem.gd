extends Node

@onready var commands = $Commands

@onready var chat = $CanvasLayer/LineEdit
@onready var returnText = $CanvasLayer/RichTextLabel

var closed = true
var lastCommand1 = ""
var lastCommand2 = ""
var lastCommand3 = ""
var command = ""



var commandList : Dictionary = {}

func _ready():
	chat.hide()
	returnText.hide()
	pass 



func _process(_delta):
	start()
	pass


func start():
	
	if closed:
		if Input.is_action_just_pressed("ui_text_completion_accept"):
			chat.show()
			returnText.show()
			chat.grab_focus()
			closed = false
	else:
		if Input.is_action_just_pressed("ui_up") and chat.text == lastCommand2:
				chat.text = lastCommand3
		elif Input.is_action_just_pressed("ui_up") and chat.text == lastCommand1:
				chat.text = lastCommand2
		elif Input.is_action_just_pressed("ui_up"):
				chat.text = lastCommand1
		
		if Input.is_action_just_pressed("ui_text_completion_accept") and chat.has_focus():
			EnterCommand()
		elif Input.is_action_just_pressed("ui_text_completion_accept"):
			chat.grab_focus()
		
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			chat.release_focus()
			closed = true
			chat.hide()
			returnText.hide()
			
			pass
	
	pass

func EnterCommand():
	
	chat.release_focus()
	command = chat.text
	SaveLastCommand()
	chat.text = ""
	if command != "":
		commands.ExecuteCommand(command)
	
	pass

func SaveLastCommand():
	
	lastCommand3 = lastCommand2
	lastCommand2 = lastCommand1
	lastCommand1 = chat.text
	
	pass


func Error(error_msg : String):
	
	
	returnText.text += "\n" + error_msg
	#await get_tree().create_timer(2.0).timeout
	#returnText.text = ""
	
	
	pass
