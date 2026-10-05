class_name GraphSystem
extends Node
# @export var init: Init
@onready var vertice: Vertice = $"../Vertice"
@onready var fondo: Sprite2D = $"../Sprite2D"
@onready var arista: Arista = $"../Arista"
@onready var label_id: Label = $"../VBoxContainer/IdArista"
@onready var label_peso: Label = $"../VBoxContainer/Peso_f"
#@onready var vertice: PackedScene

func _ready() -> void:
	arista.mouse_enter_custom.connect(_on_arista_mouse_enter_custom)
	arista.mouse_exit_custom.connect(_on_arista_mouse_exit_custom)
	label_id.text = "-"
	label_peso.text = "-"

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
				#drawn_edges.append(edge_id)
				drawn_edges[edge_id] = {min_v:{}, max_v:{}, arista: {}}
				_dibujar_linea(visual_vertices[v1].position, visual_vertices[v2].position, edge_id)
	# print(visual_vertices)

func _dibujar_linea(pos1: Vector2, pos2: Vector2, edge_id: String) -> void:
	var init := get_parent()
	var nueva_arista = arista.duplicate() as Arista
	init.add_child(nueva_arista)

	var line = nueva_arista.get_node("Line2D") as Line2D
	line.clear_points()

	var peso = 0

	var edge_split = edge_id.split("_")
	var vector_edge_1 = int(edge_split[0]) 
	var vector_edge_2 = int(edge_split[1])
	
	#if vector_edge_1 % 5 == 0 and vector_edge_2 % 5 == 0:
	if vector_edge_1 % 5 == 0:
		peso = vector_edge_1 + vector_edge_2
		#nueva_arista.change_normal_color("BLUE")
		nueva_arista.COLOR_NORMAL = Color.GREEN
	

	nueva_arista.create_line(pos1, pos2, edge_id, peso)

	nueva_arista.mouse_enter_custom.connect(_on_arista_mouse_enter_custom)
	nueva_arista.mouse_exit_custom.connect(_on_arista_mouse_exit_custom)


func _on_arista_mouse_enter_custom(a: Arista) -> void:
	label_id.text = "Arista: " + a.id_arista
	label_peso.text = "Peso: " + str(a.peso_valor)


func _on_arista_mouse_exit_custom(_a: Arista) -> void:
	label_id.text = "-"
	label_peso.text = "-"
