class_name GraphSystem
extends Node
# @export var init: Init
@onready var vertice: Vertice = $"../Vertice"
@onready var fondo: Sprite2D = $"../Sprite2D"
@onready var arista: Arista = $"../Arista"
@onready var label_id: Label = $"../VBoxContainer/IdArista"
@onready var label_peso: Label = $"../VBoxContainer/Peso_f"
#@onready var vertice: PackedScene
@onready var btn_prim: Button = $"../VBoxContainer/Button"

func _ready() -> void:
	arista.mouse_enter_custom.connect(_on_arista_mouse_enter_custom)
	arista.mouse_exit_custom.connect(_on_arista_mouse_exit_custom)
	label_id.text = "-"
	label_peso.text = "-"
	if btn_prim:
		btn_prim.pressed.connect(_on_btn_prim_pressed)

var adjacency_list: Dictionary = {}
var visual_vertices: Dictionary = {}
var drawn_edges: Dictionary = {}

func add_vertex(id: int) -> void:
	if not adjacency_list.has(id):
		adjacency_list[id] = []

func add_edge(v1: int, v2: int) -> void:
	add_vertex(v1)
	add_vertex(v2)
	
	if not v2 in adjacency_list[v1]:
		adjacency_list[v1].append(v2)
		
	if not v1 in adjacency_list[v2]:
		adjacency_list[v2].append(v1)
		

func generate_linear_graph(num_vertices: int) -> void:
	adjacency_list.clear()
	
	for i in range(num_vertices):
		var ver_id = i + 1
		add_vertex(ver_id)
		
	for i in range(num_vertices - 1):
		var ver_id = i + 1
		add_edge(ver_id, ver_id + 1)

func generate_complete_graph(num_vertices: int) -> void:
	adjacency_list.clear()
	
	for i in range(num_vertices):
		var ver_id = i + 1
		add_vertex(ver_id)
		
	for i in range(num_vertices):
		var ver_id_i = i + 1
		for j in range(i + 1, num_vertices):
			var ver_id_j = j + 1
			add_edge(ver_id_i, ver_id_j)

func print_graph() -> void:
	print("--- Estado actual del Grafo ---")
	for vertex in adjacency_list:
		print("Vértice ", vertex, " está conectado con: ", adjacency_list[vertex])
	impl_graph()


func impl_graph() -> void:
	var init := get_parent()
	var spriteSize = fondo.texture.get_size() * fondo.scale
	for iterador in adjacency_list.size():
		var vertex_id = iterador + 1
		
		var instancia := vertice.duplicate() as Node2D
		init.add_child(instancia)
		instancia.position = Vector2(
			randf_range(0.0, spriteSize.x),
			randf_range(0.0, spriteSize.y)
		)
		var laberlVertice = instancia.get_node("Label") as Label
		laberlVertice.set_text(str(vertex_id))
		visual_vertices[vertex_id] = instancia
	
	for v1 in adjacency_list.keys():
		for v2 in adjacency_list[v1]:
			var min_v = min(v1, v2)
			var max_v = max(v1, v2)
			var edge_id = str(min_v) + "_" + str(max_v)
			
			if not edge_id in drawn_edges.keys():
				# Obtenemos la nueva arista y la guardamos en el diccionario
				var nueva_arista = _dibujar_linea(visual_vertices[v1].position, visual_vertices[v2].position, edge_id)
				drawn_edges[edge_id] = {"min_v": min_v, "max_v": max_v, "arista": nueva_arista}
	# print(visual_vertices)

func _dibujar_linea(pos1: Vector2, pos2: Vector2, edge_id: String) -> Arista:
	var init := get_parent()
	var nueva_arista = arista.duplicate() as Arista
	init.add_child(nueva_arista)
	var color = Color.BLACK
	var peso = 0

	var edge_split = edge_id.split("_")
	var vector_edge_1 = int(edge_split[0]) 
	var vector_edge_2 = int(edge_split[1])

	if vector_edge_1 % 5 == 0 and vector_edge_2 % 5 == 0:
		peso = vector_edge_1 + vector_edge_2
		color = Color.CHOCOLATE
		
	if vector_edge_1 == 3 and vector_edge_2 % 2 == 0 and vector_edge_2 > 4:
		peso = -2
		color = Color.DARK_ORCHID
		
	if vector_edge_1 == 7 and vector_edge_2  == 14 :
		peso = -4
		color = Color.DEEP_PINK
		
	if comprobarAbsoluto(vector_edge_1, vector_edge_2) == 1:
		peso = 1
		color = Color.CORNFLOWER_BLUE

	# Nota: Esta línea sobrescribe todos los pesos calculados arriba.
	peso = comprobarAbsoluto(vector_edge_1,vector_edge_2) * 2

	var line = nueva_arista.get_node("Line2D") as Line2D
	line.clear_points()

	nueva_arista.create_line(pos1, pos2, edge_id, peso, color)
	nueva_arista.mouse_enter_custom.connect(_on_arista_mouse_enter_custom)
	nueva_arista.mouse_exit_custom.connect(_on_arista_mouse_exit_custom)

	# IMPORTANTE: Retornar la arista generada
	return nueva_arista

func comprobarAbsoluto(num1:int, num2:int):
	var resta = num1 - num2
	var valorAbsoluto = 0
	if resta < 0:
		valorAbsoluto = resta * -1
	return valorAbsoluto

func run_prim() -> void:
	if adjacency_list.is_empty():
		print("El grafo está vacío.")
		return

	var visited = []
	var mst_edges = []

	# 1. Empezamos con el primer vértice disponible
	var start_vertex = adjacency_list.keys()[0]
	visited.append(start_vertex)

	var total_vertices = adjacency_list.size()

	# 2. Bucle principal: repetir hasta visitar todos los nodos
	while visited.size() < total_vertices:
		var min_weight = INF
		var best_edge_id = ""
		var next_vertex = -1
		# Revisamos todos los vértices ya visitados
		for u in visited:
			# ---> FALTABA ESTA LÍNEA: <---
			for v in adjacency_list[u]: 
				if not v in visited: # Si el vecino NO ha sido visitado
					# Generamos el ID de la arista tal como lo hiciste antes
					var min_v = min(u, v)
					var max_v = max(u, v)
					var edge_id = str(min_v) + "_" + str(max_v)

					# Verificamos que la arista exista visualmente
					if drawn_edges.has(edge_id):
						var arista_node = drawn_edges[edge_id]["arista"] as Arista
						var peso = arista_node.peso_valor
						# Buscamos la arista con el peso más bajo (Identación corregida)
						if peso < min_weight:
							min_weight = peso
							best_edge_id = edge_id
							next_vertex = v
		# Si encontramos un vértice válido, lo añadimos al Árbol (MST)
		if next_vertex != -1:
			visited.append(next_vertex)
			mst_edges.append(best_edge_id)
		else:
			# Si next_vertex es -1, significa que el grafo es disconexo (partido en pedazos)
			print("El grafo no es conexo. Prim se detuvo.")
			break
			
	print("Aristas del Árbol de Expansión Mínima (Prim): ", mst_edges)
	_highlight_mst(mst_edges)

func _highlight_mst(mst_edges: Array) -> void:
	for edge_id in drawn_edges.keys():
		var a = drawn_edges[edge_id]["arista"] as Arista
		#a.change_normal_color(Color(0.5, 0.5, 0.5, 0.3)) # Gris transparente
		a.change_normal_color(Color(0.5, 0.5, 0.5, 0.3)) # Gris transparente
		a.line.width = 2.0 
	for edge_id in mst_edges:
		if drawn_edges.has(edge_id):
			var a = drawn_edges[edge_id]["arista"] as Arista
			a.change_normal_color(Color.GOLD)
			a.line.width = 6.0 # Hacer la línea más gruesa

func _on_arista_mouse_enter_custom(a: Arista) -> void:
	label_id.text = "Arista: " + a.id_arista
	label_peso.text = "Peso: " + str(a.peso_valor)


func _on_arista_mouse_exit_custom(_a: Arista) -> void:
	label_id.text = "-"
	label_peso.text = "-"




func _on_btn_prim_pressed() -> void:
	if drawn_edges.size() > 0:
		print("Ejecutando Algoritmo de Prim...")
		run_prim()
	else:
		print("Primero debes generar el grafo antes de ejecutar Prim.")
