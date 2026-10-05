extends Area2D
class_name Arista

signal mouse_enter_custom(arista: Arista)
signal mouse_exit_custom(arista: Arista)

@onready var line: Line2D = $Line2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var peso_label: Label = $peso

var COLOR_NORMAL := Color.BLACK
const COLOR_HOVER := Color.RED

var id_arista: String = ""
var peso_valor: int = 0

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func create_line(pos1: Vector2, pos2: Vector2, id: String, peso: int, color: Color) -> void:
	id_arista = id
	peso_valor = peso
	peso_label.text = str(peso)
	
	line.add_point(pos1)
	line.add_point(pos2)
	
	if color != Color(0,0,0,0):
		change_normal_color(color)
	else:
		change_normal_color(Color.BLACK)
		
	var formaCollision = RectangleShape2D.new()
	formaCollision.set_size(Vector2(pos1.distance_to(pos2), line.width))
	collision.shape = formaCollision
	collision.position = (pos1 + pos2) / 2
	peso_label.position = (pos1 + pos2) / 2.0
	collision.rotation = pos1.angle_to_point(pos2)

func change_normal_color(color: Color) -> void:
	COLOR_NORMAL = color
	# ¡AQUÍ ESTÁ LA CLAVE! Tienes que aplicar el color al Line2D visualmente
	if line: 
		line.default_color = COLOR_NORMAL

func _on_mouse_entered() -> void:
	mouse_enter_custom.emit(self)
	line.default_color = COLOR_HOVER

func _on_mouse_exited() -> void:
	mouse_exit_custom.emit(self)
	line.default_color = COLOR_NORMAL
