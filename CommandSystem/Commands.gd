extends Node

class_name Commands 

var mob_found = false
#cuasa asda

func ExecuteCommand(command):
	
	command.strip_edges()
	
	if command.begins_with("/spawn"):
		var parametros = command.split(" ")
		if parametros.size() >= 2:
			spawn_mob_by_name(parametros[1])  
		else:
			get_parent().Error("This command needs a enemy name: /spawn Slime")
	elif command.begins_with("/help"):
		get_parent().Error("Commands list: /help , /spawn")
	else:
		get_parent().Error("Unknow Command: " + command)
	#match command:
		#"/spawn enemy":
			#SpawnEnemy()
		#"funcao2":
			#funcao2()
		#"funcao3":
			#funcao3()
		#_:
			#Erro()


func spawn_mob_by_name(mob_name):
	var folder_path = "res://prefabs/"
	var scene_name = mob_name + ".tscn"
	#var scene_path = (str(folder_path) + str(scene_name))
	
	SearchInFolders(folder_path , scene_name)
	
	#---------------
	#Tentar fazer dar a mensg de erro ("mob not found")
	#----------------
	#if mob_found == false:
		#get_parent().Error("mob not found")

func SearchInFolders(folder : String , mob_name : String):
	var dir = DirAccess.open(folder)
	var file = null
	if dir:
		dir.list_dir_begin() # true indica que listará os arquivos e também as pastas

		while true:
			file = dir.get_next()
			if file == "":
				break # Sai do loop quando não houver mais arquivos

			if dir.current_is_dir():
				# Se o item atual for um diretório, chama a função recursivamente
				SearchInFolders(folder + "/" + file , mob_name)
			else:
				# Se o item atual for um arquivo, faça o que precisar com ele
				#print("Arquivo encontrado:", folder + "/" + file)
				if mob_name == file:
					var mob_path = folder + "/" + file
					spawn_enemy(mob_path)
					mob_found = true
					break
		dir.list_dir_end() # Fecha o diretório após terminar
	else:
		print("Erro ao abrir o diretório:", folder)



func spawn_enemy(mob_path):
	var scene_resource = load(mob_path)
	if scene_resource != null:
		var scene_instance = scene_resource.instantiate()
		get_owner().add_child(scene_instance)
		scene_instance.global_position = get_tree().get_first_node_in_group("Player").global_position + Vector2(100, 100)
	else:
		get_parent().Error("mob not found")
