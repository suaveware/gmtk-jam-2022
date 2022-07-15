extends Spatial

export var width := 6
export var height := 6
export var tile_size = 2

var tile = preload("res://src/Tile/Tile.tscn")

func _ready() -> void:
	var new_tiles := []

	for i in range(0, width):
		for j in range(0, height):
			var new_tile = tile.instance()
			new_tile.value = rand_range(0,6)
			new_tiles.push_back(new_tile)
			yield(get_tree(), "idle_frame")
			new_tile.translation = (Vector3(i * tile_size, 0, j * tile_size))
			get_parent().add_child(new_tile)
