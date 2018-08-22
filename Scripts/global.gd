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