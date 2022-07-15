extends Spatial

export var width := 10
export var height := 10


func _ready() -> void:
	var new_tiles := []
	var tile: CSGBox = $Tile

	var side_size := tile.width

	for i in range(-width/2, width/2):
		for j in range(-height/2, height/2):
			var new_tile: CSGBox = tile.duplicate()
			new_tile.visible = true
			new_tiles.push_back(new_tile)
			yield(get_tree(), "idle_frame")
			new_tile.translation = (Vector3(i * side_size, new_tile.translation.y, j * side_size))
			get_parent().add_child(new_tile)
