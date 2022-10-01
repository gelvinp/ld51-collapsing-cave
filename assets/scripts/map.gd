tool
class_name Map
extends Node2D
# Contains common information about a map sequence

enum MapType { STANDARD, CRAFTING, COMBAT }
enum TileType { BEDROCK = 0, STONE = 1, GREEN = 2, YELLOW = 3, RED = 4 }

export(MapType) var map_type = MapType.STANDARD
export(float, 0, 1, 0.05) var green_chance = 0.0
export(float, 0, 1, 0.05) var yellow_chance = 0.0
export(float, 0, 1, 0.05) var red_chance = 0.0

var _tilemap: TileMap = null
var top_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	if not Engine.editor_hint:
		_tilemap = get_node("TileMap")
		top_node = get_node("Top")
		
		if map_type == MapType.STANDARD:
			spawn_resources()


func spawn_resources():
	for tile in _tilemap.get_used_cells_by_id(TileType.STONE):
		var choices := []
		
		if green_chance > 0.0:
			choices.append(TileType.GREEN)
		if yellow_chance > 0.0:
			choices.append(TileType.YELLOW)
		if red_chance > 0.0:
			choices.append(TileType.RED)
		
		if choices.size() == 0:
			return
		
		# TODO: Make sure GDScript.randomize() is called on game start
		choices.shuffle()
		
		var chance: float = randf()
		
		match choices[0]:
			TileType.GREEN:
				if chance <= green_chance:
					_tilemap.set_cellv(tile, TileType.GREEN)
			TileType.YELLOW:
				if chance <= yellow_chance:
					_tilemap.set_cellv(tile, TileType.YELLOW)
			TileType.RED:
				if chance <= red_chance:
					_tilemap.set_cellv(tile, TileType.RED)


func _get_configuration_warning():
	var tilemap = find_node("TileMap")
	var top = find_node("Top")
	
	if (not tilemap) or (not tilemap is TileMap):
		return "Missing TileMap child named TileMap!"
	elif (not top) or (not top is Node2D):
		return "Missing Node2D child named Top!"
	
	return ""
