extends Node

var playerLife = 100
var playerBall = 6

func saveOption():
	var dict_save = {
		"language" : TranslationServer.get_locale()
	}
	
	var saveFile = File.new()
	saveFile.open("user://options.save", File.WRITE)
	saveFile.store_line(to_json(dict_save))
	saveFile.close()

func loadOption():
	var saveFile = File.new()
	if not saveFile.file_exists("user://options.save"):
		return
	
	saveFile.open("user://options.save", File.READ)
	var current_line = parse_json(saveFile.get_line())
	TranslationServer.set_locale(current_line["language"])
	saveFile.close()

func saveGame(level):
	var dict_save = {
		"level" : str(level)
	}
	var saveFile = File.new()
	saveFile.open("user://level.save", File.WRITE)
	saveFile.store_line(to_json(dict_save))
	saveFile.close()

func loadGame():
	var saveFile = File.new()
	if not saveFile.file_exists("user://level.save"):
		get_tree().change_scene("res://Scènes/Niveaux/L1.tscn")
		return
	
	saveFile.open("user://level.save", File.READ)
	var current_line = parse_json(saveFile.get_line())
	get_tree().change_scene("res://Scènes/Niveaux/L"+current_line["level"]+".tscn")
	saveFile.close()