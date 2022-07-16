extends Spatial

export var width := 6
export var height := 6
export var tile_size = 2

var positions := {}
var player_grid_position := Vector2.ZERO

var tile = preload("res://src/Tile/Tile.tscn")

onready var player_mesh := $"../Player/Pivot/Rotator/Mesh"
onready var player = $"../Player"

func _init() -> void:
	for i in range(0, width):
		for j in range(0, height):
			positions[Vector2(i, j)] = {}

func _ready() -> void:
	pass


func load_level(level: Level = null):
	if(level):
		for tile in level.Tiles:
			instantiate_tile(tile.x, tile.y, tile.z)
		player_grid_position = level.StartPosition
		player.translation = Vector3(level.StartPosition.x* tile_size,1,level.StartPosition.y* tile_size) 
	for i in range(0, width):
		for j in range(0, height):
			if(!positions[Vector2(i, j)]):
				instantiate_tile(i, j, rand_range(1,7))
			else:
				print('already tile at ',i,j)

func instantiate_tile(x: int, y: int, value: int):
	var new_tile = tile.instance()
	new_tile.value = value
	get_parent().call_deferred("add_child", new_tile)
	new_tile.translation = (Vector3(x, 0, y) * tile_size)
	positions[Vector2(x, y)] = new_tile

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


