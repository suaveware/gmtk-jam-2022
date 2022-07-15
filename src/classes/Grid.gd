extends Spatial

export var width := 6
export var height := 6
export var tile_size = 2

var positions := {}
var player_grid_position := Vector2.ZERO

var tile = preload("res://src/Tile/Tile.tscn")

onready var player_mesh := $"../Player/Pivot/Rotator/Mesh"

func _init() -> void:
	for i in range(0, width):
		for j in range(0, height):
			positions[Vector2(i, j)] = {}

func _ready() -> void:
	generate()


func generate() -> void:
	var new_tiles := []

	for i in range(0, width):
		for j in range(0, height):
			var new_tile = tile.instance()
			new_tile.value = rand_range(0,6)
			new_tiles.push_back(new_tile)
			yield(get_tree(), "idle_frame")
			new_tile.translation = (Vector3(i * tile_size, 0, j * tile_size))
			get_parent().add_child(new_tile)

			positions[Vector2(i, j)] = new_tile


func _on_Player_moved(direction: Vector3) -> void:
	match direction:
		Vector3.FORWARD:
			player_grid_position.y -= 1

		Vector3.BACK:
			player_grid_position.y += 1

		Vector3.RIGHT:
			player_grid_position.x += 1

		Vector3.LEFT:
			player_grid_position.x -= 1

	var tile = positions[player_grid_position]
	for child in tile.get_children():
		var g = child.global_transform
		tile.remove_child(child)
		player_mesh.add_child(child)

		child.global_transform = g


