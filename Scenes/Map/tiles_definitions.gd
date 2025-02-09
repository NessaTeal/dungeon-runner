class_name TilesDefinitions

static var ALL_TILES = [
	{
		"top": "bb",
		"right": "bG",
		"bottom": "Gb",
		"left": "bb",
		"atlas_position": Vector2i(0, 0)
	},
	{
		"top": "bb",
		"right": "bG",
		"bottom": "GG",
		"left": "Gb",
		"atlas_position": Vector2i(1, 0)
	},
	{
		"top": "bb",
		"right": "bb",
		"bottom": "bG",
		"left": "Gb",
		"atlas_position": Vector2i(2, 0)
	},
	{
		"top": "bG",
		"right": "GG",
		"bottom": "Gb",
		"left": "bb",
		"atlas_position": Vector2i(0, 1)
	},
	{
		"top": "GG",
		"right": "GG",
		"bottom": "GG",
		"left": "GG",
		"atlas_position": Vector2i(1, 1)
	},
	{
		"top": "Gb",
		"right": "bb",
		"bottom": "bG",
		"left": "GG",
		"atlas_position": Vector2i(2, 1)
	},
	{
		"top": "bG",
		"right": "Gb",
		"bottom": "bb",
		"left": "bb",
		"atlas_position": Vector2i(0, 2)
	},
	{
		"top": "GG",
		"right": "Gb",
		"bottom": "bb",
		"left": "bG",
		"atlas_position": Vector2i(1, 2)
	},
	{
		"top": "Gb",
		"right": "bb",
		"bottom": "bb",
		"left": "bG",
		"atlas_position": Vector2i(2, 2)
	},
	{
		"top": "bb",
		"right": "bb",
		"bottom": "bb",
		"left": "bb",
		"atlas_position": Vector2i(4, 2)
	},
	{
		"top": "GG",
		"right": "Gb",
		"bottom": "bG",
		"left": "GG",
		"atlas_position": Vector2i(3, 0)
	},
	{
		"top": "GG",
		"right": "GG",
		"bottom": "Gb",
		"left": "bG",
		"atlas_position": Vector2i(4, 0)
	},
	{
		"top": "Gb",
		"right": "bG",
		"bottom": "GG",
		"left": "GG",
		"atlas_position": Vector2i(3, 1)
	},
	{
		"top": "bG",
		"right": "GG",
		"bottom": "GG",
		"left": "Gb",
		"atlas_position": Vector2i(4, 1)
	},
	{
		"top": "bb",
		"right": "bS",
		"bottom": "Sb",
		"left": "bb",
		"atlas_position": Vector2i(5, 0)
	},
	{
		"top": "bb",
		"right": "bS",
		"bottom": "SS",
		"left": "Sb",
		"atlas_position": Vector2i(6, 0)
	},
	{
		"top": "bb",
		"right": "bb",
		"bottom": "bS",
		"left": "Sb",
		"atlas_position": Vector2i(7, 0)
	},
	{
		"top": "bS",
		"right": "SS",
		"bottom": "Sb",
		"left": "bb",
		"atlas_position": Vector2i(5, 1)
	},
	{
		"top": "SS",
		"right": "SS",
		"bottom": "SS",
		"left": "SS",
		"atlas_position": Vector2i(6, 1)
	},
	{
		"top": "Sb",
		"right": "bb",
		"bottom": "bS",
		"left": "SS",
		"atlas_position": Vector2i(7, 1)
	},
	{
		"top": "bS",
		"right": "Sb",
		"bottom": "bb",
		"left": "bb",
		"atlas_position": Vector2i(5, 2)
	},
	{
		"top": "SS",
		"right": "Sb",
		"bottom": "bb",
		"left": "bS",
		"atlas_position": Vector2i(6, 2)
	},
	{
		"top": "Sb",
		"right": "bb",
		"bottom": "bb",
		"left": "bS",
		"atlas_position": Vector2i(7, 2)
	},
	{
		"top": "SS",
		"right": "Sb",
		"bottom": "bS",
		"left": "SS",
		"atlas_position": Vector2i(8, 0)
	},
	{
		"top": "SS",
		"right": "SS",
		"bottom": "Sb",
		"left": "bS",
		"atlas_position": Vector2i(9, 0)
	},
	{
		"top": "Sb",
		"right": "bS",
		"bottom": "SS",
		"left": "SS",
		"atlas_position": Vector2i(8, 1)
	},
	{
		"top": "bS",
		"right": "SS",
		"bottom": "SS",
		"left": "Sb",
		"atlas_position": Vector2i(9, 1)
	}
]

static func getAllVariants():
	var arr = Array()
	for i in ALL_TILES:
		arr.push_back(i)
	return arr
